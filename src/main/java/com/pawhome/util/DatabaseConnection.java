package com.pawhome.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for managing database connections.
 * Uses JDBC to connect to MySQL database.
 */
public class DatabaseConnection {

    // CHANGE THESE VALUES TO MATCH YOUR SETUP
    // If using XAMPP MySQL: port is usually 3306, password is usually empty ""
    // If using MySQL Workbench standalone: port is usually 3306, password is what you set during install
    private static final String URL = "jdbc:mysql://localhost:3306/pawhome?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";  // PUT YOUR MYSQL ROOT PASSWORD HERE

    private static boolean driverLoaded = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            driverLoaded = true;
            System.out.println("[PawHome DB] MySQL JDBC Driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("[PawHome DB] ERROR: MySQL JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    /**
     * Returns a new database connection.
     * @return Connection object or null if connection fails
     */
    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            throw new SQLException("MySQL JDBC Driver not loaded.");
        }
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            return conn;
        } catch (SQLException e) {
            System.err.println("[PawHome DB] CONNECTION FAILED: " + e.getMessage());
            System.err.println("[PawHome DB] URL: " + URL);
            System.err.println("[PawHome DB] Make sure MySQL is running and the pawhome database exists.");
            throw e;
        }
    }

    /**
     * Closes the database connection safely.
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Tests if the database connection is working.
     * Call this to verify your setup.
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("[PawHome DB] Connection test SUCCESSFUL!");
            return true;
        } catch (Exception e) {
            System.err.println("[PawHome DB] Connection test FAILED: " + e.getMessage());
            return false;
        }
    }
}