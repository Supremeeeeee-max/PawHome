package com.pawhome.dao;

import com.pawhome.model.Wishlist;
import com.pawhome.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Wishlist operations.
 */
public class WishlistDAO {

    public boolean add(int userId, int animalId) {
        String sql = "INSERT INTO wishlists (user_id, animal_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, animalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            // Duplicate entry means already in wishlist
            return false;
        }
    }

    public boolean remove(int userId, int animalId) {
        String sql = "DELETE FROM wishlists WHERE user_id = ? AND animal_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, animalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Wishlist> findByUser(int userId) {
        List<Wishlist> list = new ArrayList<>();
        String sql = "SELECT w.*, a.name as animal_name, a.species, a.breed, a.availability_status, a.image_path " +
                     "FROM wishlists w JOIN animals a ON w.animal_id = a.animal_id " +
                     "WHERE w.user_id = ? ORDER BY w.added_date DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setWishlistId(rs.getInt("wishlist_id"));
                w.setUserId(rs.getInt("user_id"));
                w.setAnimalId(rs.getInt("animal_id"));
                w.setAddedDate(rs.getTimestamp("added_date"));
                w.setAnimalName(rs.getString("animal_name"));
                w.setSpecies(rs.getString("species"));
                w.setBreed(rs.getString("breed"));
                w.setAvailabilityStatus(rs.getString("availability_status"));
                w.setImagePath(rs.getString("image_path"));
                list.add(w);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isInWishlist(int userId, int animalId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ? AND animal_id = ?";
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

    public int countByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
