package com.pawhome.dao;

import com.pawhome.model.Animal;
import com.pawhome.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Animal operations.
 */
public class AnimalDAO {

    /**
     * Inserts a new animal into the database.
     */
    public boolean insert(Animal animal) {
        String sql = "INSERT INTO animals (name, species, breed, age, gender, health_status, description, image_path, shelter_location, intake_date, availability_status, category_id, added_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, animal.getName());
            ps.setString(2, animal.getSpecies());
            ps.setString(3, animal.getBreed());
            ps.setInt(4, animal.getAge());
            ps.setString(5, animal.getGender());
            ps.setString(6, animal.getHealthStatus());
            ps.setString(7, animal.getDescription());
            ps.setString(8, animal.getImagePath());
            ps.setString(9, animal.getShelterLocation());
            if (animal.getIntakeDate() != null) {
                ps.setDate(10, new java.sql.Date(animal.getIntakeDate().getTime()));
            } else {
                ps.setNull(10, Types.DATE);
            }
            ps.setString(11, animal.getAvailabilityStatus());
            ps.setInt(12, animal.getCategoryId());
            ps.setInt(13, animal.getAddedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Finds an animal by ID with category name.
     */
    public Animal findById(int animalId) {
        String sql = "SELECT a.*, c.category_name FROM animals a LEFT JOIN categories c ON a.category_id = c.category_id WHERE a.animal_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, animalId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapAnimal(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns all animals with category names.
     */
    public List<Animal> findAll() {
        List<Animal> animals = new ArrayList<>();
        String sql = "SELECT a.*, c.category_name FROM animals a LEFT JOIN categories c ON a.category_id = c.category_id ORDER BY a.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                animals.add(mapAnimal(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return animals;
    }

    /**
     * Returns all available animals.
     */
    public List<Animal> findAvailable() {
        List<Animal> animals = new ArrayList<>();
        String sql = "SELECT a.*, c.category_name FROM animals a LEFT JOIN categories c ON a.category_id = c.category_id WHERE a.availability_status = 'Available' ORDER BY a.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                animals.add(mapAnimal(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return animals;
    }

    /**
     * Searches animals by name, species, breed, or shelter location.
     */
    public List<Animal> search(String keyword) {
        List<Animal> animals = new ArrayList<>();
        String sql = "SELECT a.*, c.category_name FROM animals a LEFT JOIN categories c ON a.category_id = c.category_id WHERE (a.name LIKE ? OR a.species LIKE ? OR a.breed LIKE ? OR a.shelter_location LIKE ?) ORDER BY a.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + keyword + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setString(3, searchTerm);
            ps.setString(4, searchTerm);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                animals.add(mapAnimal(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return animals;
    }

    /**
     * Finds animals by category.
     */
    public List<Animal> findByCategory(int categoryId) {
        List<Animal> animals = new ArrayList<>();
        String sql = "SELECT a.*, c.category_name FROM animals a LEFT JOIN categories c ON a.category_id = c.category_id WHERE a.category_id = ? ORDER BY a.name";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                animals.add(mapAnimal(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return animals;
    }

    /**
     * Updates an animal record.
     */
    public boolean update(Animal animal) {
        String sql = "UPDATE animals SET name=?, species=?, breed=?, age=?, gender=?, health_status=?, description=?, image_path=?, shelter_location=?, intake_date=?, availability_status=?, category_id=? WHERE animal_id=?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, animal.getName());
            ps.setString(2, animal.getSpecies());
            ps.setString(3, animal.getBreed());
            ps.setInt(4, animal.getAge());
            ps.setString(5, animal.getGender());
            ps.setString(6, animal.getHealthStatus());
            ps.setString(7, animal.getDescription());
            ps.setString(8, animal.getImagePath());
            ps.setString(9, animal.getShelterLocation());
            if (animal.getIntakeDate() != null) {
                ps.setDate(10, new java.sql.Date(animal.getIntakeDate().getTime()));
            } else {
                ps.setNull(10, Types.DATE);
            }
            ps.setString(11, animal.getAvailabilityStatus());
            ps.setInt(12, animal.getCategoryId());
            ps.setInt(13, animal.getAnimalId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes an animal by ID.
     */
    public boolean delete(int animalId) {
        String sql = "DELETE FROM animals WHERE animal_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, animalId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Counts total animals.
     */
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM animals";
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
     * Counts animals by availability status.
     */
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM animals WHERE availability_status = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Returns top adopted species for reports.
     */
    public List<Object[]> getAdoptionStatsBySpecies() {
        List<Object[]> stats = new ArrayList<>();
        String sql = "SELECT a.species, COUNT(*) as count FROM animals a WHERE a.availability_status = 'Adopted' GROUP BY a.species ORDER BY count DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.add(new Object[]{rs.getString("species"), rs.getInt("count")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Returns availability vs adopted statistics.
     */
    public List<Object[]> getAvailabilityReport() {
        List<Object[]> stats = new ArrayList<>();
        String sql = "SELECT availability_status, COUNT(*) as count FROM animals GROUP BY availability_status";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.add(new Object[]{rs.getString("availability_status"), rs.getInt("count")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Maps a ResultSet row to an Animal object.
     */
    private Animal mapAnimal(ResultSet rs) throws SQLException {
        Animal animal = new Animal();
        animal.setAnimalId(rs.getInt("animal_id"));
        animal.setName(rs.getString("name"));
        animal.setSpecies(rs.getString("species"));
        animal.setBreed(rs.getString("breed"));
        animal.setAge(rs.getInt("age"));
        animal.setGender(rs.getString("gender"));
        animal.setHealthStatus(rs.getString("health_status"));
        animal.setDescription(rs.getString("description"));
        animal.setImagePath(rs.getString("image_path"));
        animal.setShelterLocation(rs.getString("shelter_location"));
        animal.setIntakeDate(rs.getDate("intake_date"));
        animal.setAvailabilityStatus(rs.getString("availability_status"));
        animal.setCategoryId(rs.getInt("category_id"));
        animal.setAddedBy(rs.getInt("added_by"));
        animal.setCreatedAt(rs.getTimestamp("created_at"));
        try {
            animal.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // category_name not in result set
        }
        return animal;
    }
}
