package com.pawhome.service;

import com.pawhome.dao.AdoptionDAO;
import com.pawhome.dao.AnimalDAO;
import com.pawhome.model.AdoptionApplication;

import java.util.Date;
import java.util.List;

/**
 * Service class encapsulating business logic for Adoption operations.
 * Service layer update for Chunk 2
 */
public class AdoptionService {

    private AdoptionDAO adoptionDAO;
    private AnimalDAO animalDAO;

    public AdoptionService() {
        this.adoptionDAO = new AdoptionDAO();
        this.animalDAO = new AnimalDAO();
    }

    /**
     * Submits a new adoption application.
     * Returns error message or null on success.
     */
    public String applyForAdoption(int userId, int animalId, String reason) {
        // Check if user already applied for this animal
        if (adoptionDAO.hasUserApplied(userId, animalId)) {
            return "You have already applied to adopt this animal.";
        }

        AdoptionApplication app = new AdoptionApplication();
        app.setUserId(userId);
        app.setAnimalId(animalId);
        app.setApplyDate(new Date());
        app.setReason(reason);
        app.setStatus("Pending");

        boolean success = adoptionDAO.insert(app);
        return success ? null : "Failed to submit application. Please try again.";
    }

    /**
     * Approves an adoption application and marks the animal as Adopted.
     */
    public boolean approveApplication(int applicationId, int adminId) {
        AdoptionApplication app = adoptionDAO.findById(applicationId);
        if (app == null) return false;

        boolean updated = adoptionDAO.updateStatus(applicationId, "Approved", adminId);
        if (updated) {
            // Mark animal as Adopted
            var animal = animalDAO.findById(app.getAnimalId());
            if (animal != null) {
                animal.setAvailabilityStatus("Adopted");
                animalDAO.update(animal);
            }
        }
        return updated;
    }

    /**
     * Rejects an adoption application.
     */
    public boolean rejectApplication(int applicationId, int adminId) {
        return adoptionDAO.updateStatus(applicationId, "Rejected", adminId);
    }

    public List<AdoptionApplication> getUserApplications(int userId) {
        return adoptionDAO.findByUser(userId);
    }

    public List<AdoptionApplication> getAllApplications() {
        return adoptionDAO.findAll();
    }

    public List<AdoptionApplication> getPendingApplications() {
        return adoptionDAO.findPending();
    }

    public int countPending() {
        return adoptionDAO.countPending();
    }

    public int countApproved() {
        return adoptionDAO.countApproved();
    }
}
