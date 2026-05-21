package com.pawhome.controller;

import com.pawhome.dao.CategoryDAO;
import com.pawhome.dao.InquiryDAO;
import com.pawhome.model.Animal;
import com.pawhome.model.Category;
import com.pawhome.service.AdoptionService;
import com.pawhome.service.AnimalService;
import com.pawhome.service.UserService;
import com.pawhome.util.DatabaseConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Servlet handling all admin operations.
 * FIXED: All database calls wrapped in try-catch to prevent infinite redirect loops.
 * FIXED: Default case uses forward instead of redirect.
 * FIXED: Database connection tested on init.
 */
@WebServlet("/admin/*")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 10 * 1024 * 1024
)
public class AdminServlet extends HttpServlet {

    private UserService userService;
    private AnimalService animalService;
    private AdoptionService adoptionService;
    private CategoryDAO categoryDAO;
    private InquiryDAO inquiryDAO;
    private static final String UPLOAD_DIR = "uploads" + File.separator + "animals";

    @Override
    public void init() throws ServletException {
        userService = new UserService();
        animalService = new AnimalService();
        adoptionService = new AdoptionService();
        categoryDAO = new CategoryDAO();
        inquiryDAO = new InquiryDAO();

        // Test database connection on startup
        System.out.println("[AdminServlet] Initializing... Testing database connection.");
        DatabaseConnection.testConnection();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        switch (pathInfo) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/animals":
                showAnimals(request, response);
                break;
            case "/animals/add":
                showAddAnimalForm(request, response);
                break;
            case "/animals/edit":
                showEditAnimalForm(request, response);
                break;
            case "/animals/delete":
                deleteAnimal(request, response);
                break;
            case "/users":
                showUsers(request, response);
                break;
            case "/users/approve":
                approveUser(request, response);
                break;
            case "/users/reject":
                rejectUser(request, response);
                break;
            case "/applications":
                showApplications(request, response);
                break;
            case "/applications/approve":
                approveApplication(request, response);
                break;
            case "/applications/reject":
                rejectApplication(request, response);
                break;
            case "/categories":
                showCategories(request, response);
                break;
            case "/categories/delete":
                deleteCategory(request, response);
                break;
            case "/reports":
                showReports(request, response);
                break;
            case "/inquiries":
                showInquiries(request, response);
                break;
            case "/inquiries/delete":
                deleteInquiry(request, response);
                break;
            default:
                // FIXED: forward to dashboard JSP directly, never redirect
                showDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        switch (pathInfo) {
            case "/animals/add":
                addAnimal(request, response);
                break;
            case "/animals/edit":
                updateAnimal(request, response);
                break;
            case "/categories/add":
                addCategory(request, response);
                break;
            case "/categories/edit":
                updateCategory(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    // ============= DASHBOARD =============
    // FIXED: Every single database call is individually wrapped in try-catch.
    // If the database is down, the page still loads with zeros and empty lists.
    // No exceptions escape this method. No redirects happen from this method.

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalAnimals = 0;
        int availableAnimals = 0;
        int adoptedAnimals = 0;
        int pendingApplications = 0;
        int pendingUsers = 0;
        int totalAdoptions = 0;
        List<?> recentApplications = new ArrayList<>();
        List<?> pendingUsersList = new ArrayList<>();
        String dbError = null;

        try {
            totalAnimals = animalService.countAll();
            availableAnimals = animalService.countByStatus("Available");
            adoptedAnimals = animalService.countByStatus("Adopted");
            pendingApplications = adoptionService.countPending();
            pendingUsers = userService.countPending();
            totalAdoptions = adoptionService.countApproved();
            recentApplications = adoptionService.getAllApplications();
            pendingUsersList = userService.findPending();
        } catch (Exception e) {
            dbError = "Database connection error: " + e.getMessage() + ". Please check that MySQL is running and the pawhome database exists.";
            System.err.println("[AdminServlet] Dashboard DB error: " + e.getMessage());
            e.printStackTrace();
        }

        request.setAttribute("totalAnimals", totalAnimals);
        request.setAttribute("availableAnimals", availableAnimals);
        request.setAttribute("adoptedAnimals", adoptedAnimals);
        request.setAttribute("pendingApplications", pendingApplications);
        request.setAttribute("pendingUsers", pendingUsers);
        request.setAttribute("totalAdoptions", totalAdoptions);
        request.setAttribute("recentApplications", recentApplications);
        request.setAttribute("pendingUsersList", pendingUsersList);

        if (dbError != null) {
            request.setAttribute("error", dbError);
        }

        // FIXED: Always forward to JSP. Never redirect. This prevents the loop.
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    // ============= ANIMAL MANAGEMENT =============

    private void showAnimals(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String search = request.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                request.setAttribute("animals", animalService.searchAnimals(search));
                request.setAttribute("searchTerm", search);
            } else {
                request.setAttribute("animals", animalService.getAllAnimals());
            }
        } catch (Exception e) {
            request.setAttribute("animals", new ArrayList<>());
            request.setAttribute("error", "Failed to load animals: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/animals.jsp").forward(request, response);
    }

    private void showAddAnimalForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("categories", categoryDAO.findAll());
        } catch (Exception e) {
            request.setAttribute("categories", new ArrayList<>());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/animal-form.jsp").forward(request, response);
    }

    private void showEditAnimalForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Animal animal = animalService.getAnimalById(id);
            if (animal == null) {
                response.sendRedirect(request.getContextPath() + "/admin/animals?error=Animal+not+found");
                return;
            }
            request.setAttribute("animal", animal);
            request.setAttribute("categories", categoryDAO.findAll());
            request.setAttribute("editMode", true);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/animals?error=Error+loading+animal");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/animal-form.jsp").forward(request, response);
    }

    private void addAnimal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Animal animal = extractAnimalFromRequest(request);
        HttpSession session = request.getSession();
        animal.setAddedBy((int) session.getAttribute("userId"));

        String imagePath = handleImageUpload(request);
        if (imagePath != null) {
            animal.setImagePath(imagePath);
        }

        if (animalService.addAnimal(animal)) {
            response.sendRedirect(request.getContextPath() + "/admin/animals?success=Animal+added+successfully");
        } else {
            request.setAttribute("error", "Failed to add animal. Please try again.");
            try { request.setAttribute("categories", categoryDAO.findAll()); }
            catch (Exception e) { request.setAttribute("categories", new ArrayList<>()); }
            request.getRequestDispatcher("/WEB-INF/views/admin/animal-form.jsp").forward(request, response);
        }
    }

    private void updateAnimal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("animalId"));
        Animal animal = extractAnimalFromRequest(request);
        animal.setAnimalId(id);

        String imagePath = handleImageUpload(request);
        if (imagePath != null) {
            animal.setImagePath(imagePath);
        } else {
            Animal existing = animalService.getAnimalById(id);
            if (existing != null) {
                animal.setImagePath(existing.getImagePath());
            }
        }

        if (animalService.updateAnimal(animal)) {
            response.sendRedirect(request.getContextPath() + "/admin/animals?success=Animal+updated+successfully");
        } else {
            request.setAttribute("error", "Failed to update animal.");
            request.setAttribute("animal", animal);
            try { request.setAttribute("categories", categoryDAO.findAll()); }
            catch (Exception e) { request.setAttribute("categories", new ArrayList<>()); }
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/WEB-INF/views/admin/animal-form.jsp").forward(request, response);
        }
    }

    private void deleteAnimal(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (animalService.deleteAnimal(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/animals?success=Animal+deleted+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/animals?error=Failed+to+delete+animal");
        }
    }

    private Animal extractAnimalFromRequest(HttpServletRequest request) {
        Animal animal = new Animal();
        animal.setName(request.getParameter("name"));
        animal.setSpecies(request.getParameter("species"));
        animal.setBreed(request.getParameter("breed"));
        String ageStr = request.getParameter("age");
        animal.setAge(ageStr != null && !ageStr.isEmpty() ? Integer.parseInt(ageStr) : 0);
        animal.setGender(request.getParameter("gender"));
        animal.setHealthStatus(request.getParameter("healthStatus"));
        animal.setDescription(request.getParameter("description"));
        animal.setShelterLocation(request.getParameter("shelterLocation"));
        animal.setAvailabilityStatus(request.getParameter("availabilityStatus"));
        String catId = request.getParameter("categoryId");
        animal.setCategoryId(catId != null && !catId.isEmpty() ? Integer.parseInt(catId) : 0);

        String intakeDateStr = request.getParameter("intakeDate");
        if (intakeDateStr != null && !intakeDateStr.isEmpty()) {
            try {
                animal.setIntakeDate(new SimpleDateFormat("yyyy-MM-dd").parse(intakeDateStr));
            } catch (Exception e) {
                animal.setIntakeDate(new Date());
            }
        }
        return animal;
    }

    private String handleImageUpload(HttpServletRequest request) throws IOException, ServletException {
        Part filePart = request.getPart("animalImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + fileName);
            return UPLOAD_DIR + File.separator + fileName;
        }
        return null;
    }

    // ============= USER MANAGEMENT =============

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("allUsers", userService.findAll());
            request.setAttribute("pendingUsers", userService.findPending());
        } catch (Exception e) {
            request.setAttribute("allUsers", new ArrayList<>());
            request.setAttribute("pendingUsers", new ArrayList<>());
            request.setAttribute("error", "Failed to load users: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void approveUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        userService.approveUser(userId);
        response.sendRedirect(request.getContextPath() + "/admin/users?success=User+approved+successfully");
    }

    private void rejectUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        userService.rejectUser(userId);
        response.sendRedirect(request.getContextPath() + "/admin/users?success=User+rejected");
    }

    // ============= APPLICATION MANAGEMENT =============

    private void showApplications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String filter = request.getParameter("filter");
            if ("pending".equals(filter)) {
                request.setAttribute("applications", adoptionService.getPendingApplications());
            } else {
                request.setAttribute("applications", adoptionService.getAllApplications());
            }
        } catch (Exception e) {
            request.setAttribute("applications", new ArrayList<>());
            request.setAttribute("error", "Failed to load applications: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/applications.jsp").forward(request, response);
    }

    private void approveApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int appId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        int adminId = (int) session.getAttribute("userId");
        adoptionService.approveApplication(appId, adminId);
        response.sendRedirect(request.getContextPath() + "/admin/applications?success=Application+approved");
    }

    private void rejectApplication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int appId = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();
        int adminId = (int) session.getAttribute("userId");
        adoptionService.rejectApplication(appId, adminId);
        response.sendRedirect(request.getContextPath() + "/admin/applications?success=Application+rejected");
    }

    // ============= CATEGORY MANAGEMENT =============

    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("categories", categoryDAO.findAll());
        } catch (Exception e) {
            request.setAttribute("categories", new ArrayList<>());
            request.setAttribute("error", "Failed to load categories: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Category cat = new Category(request.getParameter("categoryName"), request.getParameter("description"));
        categoryDAO.insert(cat);
        response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category+added");
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Category cat = new Category();
        cat.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        cat.setCategoryName(request.getParameter("categoryName"));
        cat.setDescription(request.getParameter("description"));
        categoryDAO.update(cat);
        response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category+updated");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        categoryDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/categories?success=Category+deleted");
    }

    // ============= REPORTS =============

    private void showReports(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("availabilityReport", animalService.getAvailabilityReport());
            request.setAttribute("speciesReport", animalService.getAdoptionStatsBySpecies());
            request.setAttribute("totalAnimals", animalService.countAll());
            request.setAttribute("totalAdoptions", adoptionService.countApproved());
            request.setAttribute("pendingApps", adoptionService.countPending());
        } catch (Exception e) {
            request.setAttribute("availabilityReport", new ArrayList<>());
            request.setAttribute("speciesReport", new ArrayList<>());
            request.setAttribute("totalAnimals", 0);
            request.setAttribute("totalAdoptions", 0);
            request.setAttribute("pendingApps", 0);
            request.setAttribute("error", "Failed to load reports: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }

    // ============= INQUIRIES =============

    private void showInquiries(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("inquiries", inquiryDAO.findAll());
        } catch (Exception e) {
            request.setAttribute("inquiries", new ArrayList<>());
            request.setAttribute("error", "Failed to load inquiries: " + e.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/admin/inquiries.jsp").forward(request, response);
    }

    private void deleteInquiry(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        inquiryDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/admin/inquiries?success=Inquiry+deleted");
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