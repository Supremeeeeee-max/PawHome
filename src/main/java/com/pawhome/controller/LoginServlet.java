package com.pawhome.controller;

import com.pawhome.model.User;
import com.pawhome.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet handling user login and logout operations.
 */
@WebServlet(urlPatterns = {"/login", "/logout"})
public class LoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        // Handle logout
        if (uri.endsWith("/logout")) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            // Delete remember-me cookie
            Cookie cookie = new Cookie("rememberEmail", "");
            cookie.setMaxAge(0);
            cookie.setPath("/");
            response.addCookie(cookie);

            response.sendRedirect(request.getContextPath() + "/login?message=You+have+been+logged+out+successfully");
            return;
        }

        // Show login page - check for remember-me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberEmail".equals(cookie.getName())) {
                    request.setAttribute("rememberedEmail", cookie.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // Validate inputs
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = userService.authenticate(email.trim(), password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Check if account is approved
        if ("pending".equals(user.getStatus())) {
            request.setAttribute("error", "Your account is pending approval. Please wait for admin verification.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if ("rejected".equals(user.getStatus())) {
            request.setAttribute("error", "Your account has been rejected. Please contact the administrator.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create session
        HttpSession session = request.getSession();
        session.setAttribute("loggedInUser", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getFullName());
        session.setAttribute("userRole", user.getRole());
        session.setAttribute("userStatus", user.getStatus());
        session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout

        // Handle remember-me cookie
        if ("on".equals(remember)) {
            Cookie cookie = new Cookie("rememberEmail", email.trim());
            cookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
            cookie.setPath("/");
            response.addCookie(cookie);
        }

        // Redirect based on role
        if ("admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/home");
        }
    }
}
