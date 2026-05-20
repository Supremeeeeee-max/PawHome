package com.pawhome.dao;

import com.pawhome.model.AdoptionApplication;
import com.pawhome.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Adoption Application operations.
 * DAO layer update for Chunk 1
 */
public class AdoptionDAO {

    public boolean insert(AdoptionApplication app) {
        String sql = "INSERT INTO adoption_applications (user_id, animal_id, apply_date, reason, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, app.getUserId());
            ps.setInt(2, app.getAnimalId());
            ps.setDate(3, new java.sql.Date(app.getApplyDate().getTime()));
            ps.setString(4, app.getReason());
            ps.setString(5, "Pending");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Finds all applications by a specific user with animal names.
     */
    public List<AdoptionApplication> findByUser(int userId) {
        List<AdoptionApplication> apps = new ArrayList<>();
        String sql = "SELECT aa.*, u.full_name as user_name, a.name as animal_name, r.full_name as reviewer_name " +
                     "FROM adoption_applications aa " +
                     "JOIN users u ON aa.user_id = u.user_id " +
                     "JOIN animals a ON aa.animal_id = a.animal_id " +
                     "LEFT JOIN users r ON aa.reviewed_by = r.user_id " +
                     "WHERE aa.user_id = ? ORDER BY aa.apply_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                apps.add(mapApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    /**
     * Finds all applications (for admin).
     */
    public List<AdoptionApplication> findAll() {
        List<AdoptionApplication> apps = new ArrayList<>();
        String sql = "SELECT aa.*, u.full_name as user_name, a.name as animal_name, r.full_name as reviewer_name " +
                     "FROM adoption_applications aa " +
                     "JOIN users u ON aa.user_id = u.user_id " +
                     "JOIN animals a ON aa.animal_id = a.animal_id " +
                     "LEFT JOIN users r ON aa.reviewed_by = r.user_id " +
                     "ORDER BY aa.apply_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                apps.add(mapApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    /**
     * Finds pending applications (for admin).
     */
    public List<AdoptionApplication> findPending() {
        List<AdoptionApplication> apps = new ArrayList<>();
        String sql = "SELECT aa.*, u.full_name as user_name, a.name as animal_name, r.full_name as reviewer_name " +
                     "FROM adoption_applications aa " +
                     "JOIN users u ON aa.user_id = u.user_id " +
                     "JOIN animals a ON aa.animal_id = a.animal_id " +
                     "LEFT JOIN users r ON aa.reviewed_by = r.user_id " +
                     "WHERE aa.status = 'Pending' ORDER BY aa.apply_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                apps.add(mapApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return apps;
    }

    /**
     * Updates application status (approve/reject).
     */
    public boolean updateStatus(int applicationId, String status, int reviewedBy) {
        String sql = "UPDATE adoption_applications SET status=?, reviewed_by=?, review_date=CURDATE() WHERE application_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reviewedBy);
            ps.setInt(3, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Finds a specific application by ID.
     */
    public AdoptionApplication findById(int applicationId) {
        String sql = "SELECT aa.*, u.full_name as user_name, a.name as animal_name, r.full_name as reviewer_name " +
                     "FROM adoption_applications aa " +
                     "JOIN users u ON aa.user_id = u.user_id " +
                     "JOIN animals a ON aa.animal_id = a.animal_id " +
                     "LEFT JOIN users r ON aa.reviewed_by = r.user_id " +
                     "WHERE aa.application_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapApplication(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Checks if user already applied for a specific animal.
     */
    public boolean hasUserApplied(int userId, int animalId) {
        String sql = "SELECT COUNT(*) FROM adoption_applications WHERE user_id = ? AND animal_id = ? AND status != 'Rejected'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, animalId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Counts pending applications.
     */
    public int countPending() {
        String sql = "SELECT COUNT(*) FROM adoption_applications WHERE status = 'Pending'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Counts total adoptions completed.
     */
    public int countApproved() {
        String sql = "SELECT COUNT(*) FROM adoption_applications WHERE status = 'Approved'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private AdoptionApplication mapApplication(ResultSet rs) throws SQLException {
        AdoptionApplication app = new AdoptionApplication();
        app.setApplicationId(rs.getInt("application_id"));
        app.setUserId(rs.getInt("user_id"));
        app.setAnimalId(rs.getInt("animal_id"));
        app.setApplyDate(rs.getDate("apply_date"));
        app.setReason(rs.getString("reason"));
        app.setStatus(rs.getString("status"));
        app.setReviewedBy(rs.getInt("reviewed_by"));
        app.setReviewDate(rs.getDate("review_date"));
        app.setUserName(rs.getString("user_name"));
        app.setAnimalName(rs.getString("animal_name"));
        try {
            app.setReviewerName(rs.getString("reviewer_name"));
        } catch (SQLException e) {
            // reviewer might be null
        }
        return app;
    }
}
