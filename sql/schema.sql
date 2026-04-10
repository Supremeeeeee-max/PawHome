-- PawHome: Animal Shelter & Adoption System
-- Database Schema

DROP DATABASE IF EXISTS pawhome;
CREATE DATABASE pawhome;
USE pawhome;

-- Categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    dob DATE,
    address VARCHAR(300),
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    profile_image VARCHAR(500),
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Animals table
CREATE TABLE animals (
    animal_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    species VARCHAR(100) NOT NULL,
    breed VARCHAR(150),
    age INT,
    gender ENUM('Male', 'Female', 'Unknown') NOT NULL DEFAULT 'Unknown',
    health_status VARCHAR(200),
    description TEXT,
    image_path VARCHAR(500),
    shelter_location VARCHAR(300),
    intake_date DATE,
    availability_status ENUM('Available', 'Reserved', 'Adopted') NOT NULL DEFAULT 'Available',
    category_id INT,
    added_by INT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (added_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_species (species),
    INDEX idx_availability (availability_status)
) ENGINE=InnoDB;

-- Adoption applications table
CREATE TABLE adoption_applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    animal_id INT NOT NULL,
    apply_date DATE NOT NULL,
    reason TEXT,
    status ENUM('Pending', 'Approved', 'Rejected') NOT NULL DEFAULT 'Pending',
    reviewed_by INT,
    review_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_user (user_id)
) ENGINE=InnoDB;

-- Wishlists table
CREATE TABLE wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    animal_id INT NOT NULL,
    added_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (animal_id) REFERENCES animals(animal_id) ON DELETE CASCADE,
    UNIQUE KEY unique_wishlist (user_id, animal_id)
) ENGINE=InnoDB;

-- Inquiries table (contact form)
CREATE TABLE inquiries (
    inquiry_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(200) NOT NULL,
    subject VARCHAR(300) NOT NULL,
    message TEXT NOT NULL,
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Insert default admin account (password: admin123 - SHA-256 hashed)
INSERT INTO users (full_name, email, phone, password, role, status) VALUES
('System Admin', 'admin@pawhome.com', '9800000000',
 '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
 'admin', 'approved');

-- Insert default categories
INSERT INTO categories (category_name, description) VALUES
('Dog', 'Domestic dogs of all breeds'),
('Cat', 'Domestic cats of all breeds'),
('Bird', 'Pet birds including parrots, finches, etc.'),
('Rabbit', 'Domestic rabbits'),
('Fish', 'Aquarium and pet fish'),
('Other', 'Other animals not in listed categories');

-- Insert sample animals
INSERT INTO animals (name, species, breed, age, gender, health_status, description, shelter_location, intake_date, availability_status, category_id, added_by) VALUES
('Buddy', 'Dog', 'Golden Retriever', 3, 'Male', 'Healthy', 'Friendly and playful golden retriever. Great with children and other pets.', 'Main Shelter', '2026-01-15', 'Available', 1, 1),
('Whiskers', 'Cat', 'Persian', 2, 'Female', 'Healthy', 'Calm and affectionate Persian cat. Loves to cuddle.', 'Main Shelter', '2026-02-10', 'Available', 2, 1),
('Coco', 'Rabbit', 'Holland Lop', 1, 'Female', 'Healthy', 'Adorable Holland Lop rabbit. Very gentle and easy to handle.', 'East Branch', '2026-03-01', 'Available', 4, 1),
('Rocky', 'Dog', 'German Shepherd', 4, 'Male', 'Vaccinated', 'Loyal and protective German Shepherd. Well trained.', 'Main Shelter', '2025-12-20', 'Available', 1, 1),
('Mittens', 'Cat', 'Siamese', 1, 'Female', 'Healthy', 'Playful Siamese kitten. Very vocal and curious.', 'East Branch', '2026-03-10', 'Available', 2, 1);
