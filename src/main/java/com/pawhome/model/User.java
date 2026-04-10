package com.pawhome.model;

import java.util.Date;

/**
 * Model class representing a User in the system.
 */
public class User {
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private Date dob;
    private String address;
    private String role;       // "admin" or "user"
    private String profileImage;
    private String status;     // "pending", "approved", "rejected"
    private Date createdAt;

    // Default constructor
    public User() {}

    // Parameterized constructor for registration
    public User(String fullName, String email, String phone, String password,
                Date dob, String address) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.dob = dob;
        this.address = address;
        this.role = "user";
        this.status = "pending";
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
