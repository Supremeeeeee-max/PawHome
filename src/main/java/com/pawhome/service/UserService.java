package com.pawhome.service;

import com.pawhome.dao.UserDAO;
import com.pawhome.model.User;
import com.pawhome.util.PasswordEncryptor;

import java.util.List;

/**
 * Service class encapsulating business logic for User operations.
 */
public class UserService {

    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    /**
     * Registers a new user with encrypted password.
     * Returns error message or null on success.
     */
    public String register(User user) {
        // Check if email already exists
        if (userDAO.findByEmail(user.getEmail()) != null) {
            return "An account with this email already exists.";
        }
        // Check if phone already exists
        if (userDAO.findByPhone(user.getPhone()) != null) {
            return "An account with this phone number already exists.";
        }
        // Encrypt password
        user.setPassword(PasswordEncryptor.encrypt(user.getPassword()));
        user.setRole("user");
        user.setStatus("pending");

        boolean success = userDAO.insert(user);
        return success ? null : "Registration failed. Please try again.";
    }

    /**
     * Authenticates a user by email and password.
     * Returns the User object or null if authentication fails.
     */
    public User authenticate(String email, String password) {
        User user = userDAO.findByEmail(email);
        if (user != null && PasswordEncryptor.verify(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    /**
     * Approves a pending user account.
     */
    public boolean approveUser(int userId) {
        return userDAO.updateStatus(userId, "approved");
    }

    /**
     * Rejects a pending user account.
     */
    public boolean rejectUser(int userId) {
        return userDAO.updateStatus(userId, "rejected");
    }

    /**
     * Updates a user's profile.
     */
    public boolean updateProfile(User user) {
        return userDAO.update(user);
    }

    /**
     * Changes a user's password.
     */
    public boolean changePassword(int userId, String oldPassword, String newPassword) {
        User user = userDAO.findById(userId);
        if (user != null && PasswordEncryptor.verify(oldPassword, user.getPassword())) {
            return userDAO.updatePassword(userId, PasswordEncryptor.encrypt(newPassword));
        }
        return false;
    }

    public User findById(int userId) {
        return userDAO.findById(userId);
    }

    public List<User> findAll() {
        return userDAO.findAll();
    }

    public List<User> findPending() {
        return userDAO.findPending();
    }

    public List<User> findApprovedUsers() {
        return userDAO.findApprovedUsers();
    }

    public boolean deleteUser(int userId) {
        return userDAO.delete(userId);
    }

    public int countPending() {
        return userDAO.countPending();
    }
}
