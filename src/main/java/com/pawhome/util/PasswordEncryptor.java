package com.pawhome.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * Utility class for password encryption using SHA-256.
 */
public class PasswordEncryptor {

    /**
     * Encrypts a plain text password using SHA-256 hashing.
     * @param password the plain text password
     * @return the hashed password as a hex string
     */
    public static String encrypt(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available.", e);
        }
    }

    /**
     * Verifies a plain text password against a hashed password.
     * @param plainPassword the plain text password
     * @param hashedPassword the hashed password to compare against
     * @return true if the passwords match
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        String encrypted = encrypt(plainPassword);
        return encrypted.equals(hashedPassword);
    }
}
