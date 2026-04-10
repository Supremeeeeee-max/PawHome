package com.pawhome.model;

import java.util.Date;

/**
 * Model class representing an Adoption Application.
 */
public class AdoptionApplication {
    private int applicationId;
    private int userId;
    private int animalId;
    private Date applyDate;
    private String reason;
    private String status; // "Pending", "Approved", "Rejected"
    private int reviewedBy;
    private Date reviewDate;

    // Extra fields for display purposes
    private String userName;
    private String animalName;
    private String reviewerName;

    public AdoptionApplication() {}

    // Getters and Setters
    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAnimalId() { return animalId; }
    public void setAnimalId(int animalId) { this.animalId = animalId; }

    public Date getApplyDate() { return applyDate; }
    public void setApplyDate(Date applyDate) { this.applyDate = applyDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(int reviewedBy) { this.reviewedBy = reviewedBy; }

    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getAnimalName() { return animalName; }
    public void setAnimalName(String animalName) { this.animalName = animalName; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
}
