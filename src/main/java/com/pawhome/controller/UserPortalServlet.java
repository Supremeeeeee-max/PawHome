package com.pawhome.controller;

import com.pawhome.dao.CategoryDAO;
import com.pawhome.dao.WishlistDAO;
import com.pawhome.model.Animal;
import com.pawhome.model.User;
import com.pawhome.service.AdoptionService;
import com.pawhome.service.AnimalService;
import com.pawhome.service.UserService;
import com.pawhome.util.InputValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
 * Servlet handling all user portal operations:
 * home/browse, animal details, adoption application,
 * wishlist, profile management, and password change.
 */
@WebServlet("/user/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class UserPortalServlet extends HttpServlet {

    private AnimalService animalService;
    private AdoptionService adoptionService;
    private UserService userService;
    private WishlistDAO wishlistDAO;
    private CategoryDAO categoryDAO;
    private static final String UPLOAD_DIR = "uploads" + File.separator + "profiles";

    @Override
    public void init() throws ServletException {
        animalService = new AnimalService();
        adoptionService = new AdoptionService();
        userService = new UserService();
        wishlistDAO = new WishlistDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/home";
        }

        try {
            switch (pathInfo) {
                case "/home":
                    showHome(request, response);
                    break;
                case "/animal":
                    showAnimalDetail(request, response);
                    break;
                case "/applications":
                    showMyApplications(request, response);
                    break;
                case "/wishlist":
                    showWishlist(request, response);
                    break;
                case "/wishlist/add":
                    addToWishlist(request, response);
                    break;
                case "/wishlist/remove":
                    removeFromWishlist(request, response);
                    break;
                case "/profile":
                    showProfile(request, response);
                    break;
                default:
                    showHome(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/user/home.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        try {
            switch (pathInfo) {
                case "/apply":
                    submitApplication(request, response);
                    break;
                case "/profile/update":
                    updateProfile(request, response);
                    break;
                case "/profile/password":
                    changePassword(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user/home");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/user/home?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    // ============= HOME / BROWSE =============

    private void showHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            String categoryFilter = request.getParameter("category");

            if (search != null && !search.trim().isEmpty()) {
                request.setAttribute("animals", animalService.searchAnimals(search));
                request.setAttribute("searchTerm", search);
            } else if (categoryFilter != null && !categoryFilter.isEmpty()) {
                request.setAttribute("animals", animalService.getAnimalsByCategory(Integer.parseInt(categoryFilter)));
                request.setAttribute("selectedCategory", categoryFilter);
            } else {
                request.setAttribute("animals", animalService.getAvailableAnimals());
            }

            request.setAttribute("categories", categoryDAO.findAll());

            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("userId");
            request.setAttribute("wishlistCount", wishlistDAO.countByUser(userId));
        } catch (Exception e) {
            request.setAttribute("animals", new ArrayList<>());
            request.setAttribute("categories", new ArrayList<>());
            request.setAttribute("wishlistCount", 0);
            e.printStackTrace();
        }

        request.getRequestDispatcher("/user/home.jsp").forward(request, response);
    }

    // ============= ANIMAL DETAIL =============

    private void showAnimalDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        try {
            int animalId = Integer.parseInt(idStr);
            Animal animal = animalService.getAnimalById(animalId);

            if (animal == null) {
                response.sendRedirect(request.getContextPath() + "/user/home?error=Animal+not+found");
                return;
            }

            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("userId");

            request.setAttribute("animal", animal);
            request.setAttribute("inWishlist", wishlistDAO.isInWishlist(userId, animalId));
            request.setAttribute("hasApplied", new com.pawhome.dao.AdoptionDAO().hasUserApplied(userId, animalId));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user/home?error=Error+loading+animal+details");
            return;
        }

        request.getRequestDispatcher("/user/animal-detail.jsp").forward(request, response);
    }

    // ============= ADOPTION APPLICATION =============

    private void submitApplication(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        int animalId = Integer.parseInt(request.getParameter("animalId"));
        String reason = request.getParameter("reason");

        if (!InputValidator.isNotEmpty(reason)) {
            response.sendRedirect(request.getContextPath() + "/user/animal?id=" + animalId + "&error=Please+provide+a+reason+for+adoption");
            return;
        }

        String error = adoptionService.applyForAdoption(userId, animalId, reason);
        if (error != null) {
            response.sendRedirect(request.getContextPath() + "/user/animal?id=" + animalId + "&error=" + java.net.URLEncoder.encode(error, "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/user/animal?id=" + animalId + "&success=Application+submitted+successfully");
        }
    }

    // ============= MY APPLICATIONS =============

    private void showMyApplications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("userId");
            request.setAttribute("applications", adoptionService.getUserApplications(userId));
        } catch (Exception e) {
            request.setAttribute("applications", new ArrayList<>());
            e.printStackTrace();
        }
        request.getRequestDispatcher("/user/applications.jsp").forward(request, response);
    }

    // ============= WISHLIST =============

    private void showWishlist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("userId");
            request.setAttribute("wishlistItems", wishlistDAO.findByUser(userId));
        } catch (Exception e) {
            request.setAttribute("wishlistItems", new ArrayList<>());
            e.printStackTrace();
        }
        request.getRequestDispatcher("/user/wishlist.jsp").forward(request, response);
    }

    private void addToWishlist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        int animalId = Integer.parseInt(request.getParameter("id"));
        wishlistDAO.add(userId, animalId);
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/user/home");
    }

    private void removeFromWishlist(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        int animalId = Integer.parseInt(request.getParameter("id"));
        wishlistDAO.remove(userId, animalId);
        String referer = request.getHeader("Referer");
        response.sendRedirect(referer != null ? referer : request.getContextPath() + "/user/wishlist");
    }

    // ============= PROFILE =============

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            int userId = (int) session.getAttribute("userId");
            User user = userService.findById(userId);
            request.setAttribute("user", user);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load profile: " + e.getMessage());
            e.printStackTrace();
        }
        request.getRequestDispatcher("/user/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        User user = userService.findById(userId);
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));

        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                user.setDob(new SimpleDateFormat("yyyy-MM-dd").parse(dobStr));
            } catch (Exception e) {
                // Keep existing dob
            }
        }

        // Handle profile image upload
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + fileName);
            user.setProfileImage(UPLOAD_DIR + File.separator + fileName);
        }

        if (userService.updateProfile(user)) {
            session.setAttribute("userName", user.getFullName());
            response.sendRedirect(request.getContextPath() + "/user/profile?success=Profile+updated+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/profile?error=Failed+to+update+profile");
        }
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/profile?error=New+passwords+do+not+match");
            return;
        }

        if (!InputValidator.isValidPassword(newPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/profile?error=Password+must+be+at+least+6+characters");
            return;
        }

        if (userService.changePassword(userId, currentPassword, newPassword)) {
            response.sendRedirect(request.getContextPath() + "/user/profile?success=Password+changed+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/profile?error=Current+password+is+incorrect");
        }
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf('=') + 2, token.length() - 1);
                int dotIndex = fileName.lastIndexOf('.');
                return dotIndex > 0 ? fileName.substring(dotIndex) : ".jpg";
            }
        }
        return ".jpg";
    }
}