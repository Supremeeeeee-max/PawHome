package com.pawhome.controller;

import com.pawhome.dao.InquiryDAO;
import com.pawhome.model.Inquiry;
import com.pawhome.util.InputValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Servlet handling contact form submissions (public page).
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private InquiryDAO inquiryDAO;

    @Override
    public void init() throws ServletException {
        inquiryDAO = new InquiryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Validation
        StringBuilder errors = new StringBuilder();
        if (!InputValidator.isNotEmpty(name)) errors.append("Name is required.<br>");
        if (!InputValidator.isValidEmail(email)) errors.append("Please enter a valid email.<br>");
        if (!InputValidator.isNotEmpty(subject)) errors.append("Subject is required.<br>");
        if (!InputValidator.isNotEmpty(message)) errors.append("Message is required.<br>");

        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("subject", subject);
            request.setAttribute("message", message);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        Inquiry inquiry = new Inquiry(name.trim(), email.trim(), subject.trim(), message.trim());
        if (inquiryDAO.insert(inquiry)) {
            request.setAttribute("success", "Your inquiry has been submitted successfully. We will get back to you soon!");
        } else {
            request.setAttribute("error", "Failed to submit inquiry. Please try again.");
        }
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
}
