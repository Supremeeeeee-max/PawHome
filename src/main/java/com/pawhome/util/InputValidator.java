package com.pawhome.util;

import java.util.regex.Pattern;

/**
 * Utility class for validating user inputs.
 */
public class InputValidator {

    private static final Pattern EMAIL_PATTERN =
        Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
        Pattern.compile("^[0-9]{10,15}$");

    private static final Pattern NAME_PATTERN =
        Pattern.compile("^[A-Za-z\\s]{2,150}$");

    /**
     * Checks if a string is not null and not empty after trimming.
     * @param value the string to check
     * @return true if the string is not empty
     */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /**
     * Validates email format.
     * @param email the email to validate
     * @return true if the email is valid
     */
    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /**
     * Validates phone number (10-15 digits only).
     * @param phone the phone number to validate
     * @return true if the phone number is valid
     */
    public static boolean isValidPhone(String phone) {
        return phone != null && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /**
     * Validates full name (letters and spaces only, 2-150 chars).
     * @param name the name to validate
     * @return true if the name is valid
     */
    public static boolean isValidName(String name) {
        return name != null && NAME_PATTERN.matcher(name.trim()).matches();
    }

    /**
     * Validates password strength (minimum 6 characters).
     * @param password the password to validate
     * @return true if the password meets requirements
     */
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    /**
     * Validates that a string represents a positive integer.
     * @param value the string to check
     * @return true if it is a positive integer
     */
    public static boolean isPositiveInteger(String value) {
        if (value == null || value.trim().isEmpty()) return false;
        try {
            int num = Integer.parseInt(value.trim());
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}
