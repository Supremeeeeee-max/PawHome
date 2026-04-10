package com.pawhome.dao;

import com.pawhome.model.Inquiry;
import com.pawhome.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Inquiry (contact form) operations.
 */
public class InquiryDAO {

    public boolean insert(Inquiry inquiry) {
        String sql = "INSERT INTO inquiries (name, email, subject, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, inquiry.getName());
            ps.setString(2, inquiry.getEmail());
            ps.setString(3, inquiry.getSubject());
            ps.setString(4, inquiry.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Inquiry> findAll() {
        List<Inquiry> inquiries = new ArrayList<>();
        String sql = "SELECT * FROM inquiries ORDER BY submitted_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Inquiry inq = new Inquiry();
                inq.setInquiryId(rs.getInt("inquiry_id"));
                inq.setName(rs.getString("name"));
                inq.setEmail(rs.getString("email"));
                inq.setSubject(rs.getString("subject"));
                inq.setMessage(rs.getString("message"));
                inq.setSubmittedAt(rs.getTimestamp("submitted_at"));
                inquiries.add(inq);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return inquiries;
    }

    public boolean delete(int inquiryId) {
        String sql = "DELETE FROM inquiries WHERE inquiry_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inquiryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
