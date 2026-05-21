package com.pawhome.controller;

import com.pawhome.model.User;
import com.pawhome.service.UserService;
import com.pawhome.util.InputValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

/**
 * Servlet handling user registration with file upload for profile image.
 */
@WebServlet("/register")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 5 * 1024 * 1024,        // 5 MB
    maxRequestSize = 10 * 1024 * 1024     // 10 MB
)
public class RegisterServlet extends HttpServlet {

    private UserService userService;
    private static final String UPLOAD_DIR = "uploads" + File.separator + "profiles";

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (!InputValidator.isValidName(fullName)) {
            errors.append("Full name must contain only letters and spaces (2-150 characters).<br>");
        }
        if (!InputValidator.isValidEmail(email)) {
            errors.append("Please enter a valid email address.<br>");
        }
        if (!InputValidator.isValidPhone(phone)) {
            errors.append("Phone number must be 10-15 digits only.<br>");
        }
        if (!InputValidator.isValidPassword(password)) {
            errors.append("Password must be at least 6 characters long.<br>");
        }
        if (!password.equals(confirmPassword)) {
            errors.append("Passwords do not match.<br>");
        }
        if (!InputValidator.isNotEmpty(address)) {
            errors.append("Address is required.<br>");
        }

        // If validation errors exist, return to form
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Parse date of birth
        Date dob = null;
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
            } catch (ParseException e) {
                request.setAttribute("error", "Invalid date format for date of birth.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }
        }

        // Handle profile image upload
        String imagePath = null;
        Part filePart = request.getPart("profileImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            filePart.write(uploadPath + File.separator + fileName);
            imagePath = UPLOAD_DIR + File.separator + fileName;
        }

        // Create user object
        User user = new User(fullName.trim(), email.trim(), phone.trim(), password, dob, address.trim());
        user.setProfileImage(imagePath);

        // Register user
        String errorMsg = userService.register(user);

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("address", address);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } else {
            request.setAttribute("success", "Registration successful! Your account is pending admin approval. You will be able to login once approved.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Extracts file extension from uploaded Part.
     */
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
