package com.pawhome.model;

import java.util.Date;

/**
 * Model class representing a Wishlist entry.
 */
public class Wishlist {
    private int wishlistId;
    private int userId;
    private int animalId;
    private Date addedDate;

    // Extra fields for display
    private String animalName;
    private String species;
    private String breed;
    private String availabilityStatus;
    private String imagePath;

    public Wishlist() {}

    public int getWishlistId() { return wishlistId; }
    public void setWishlistId(int wishlistId) { this.wishlistId = wishlistId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAnimalId() { return animalId; }
    public void setAnimalId(int animalId) { this.animalId = animalId; }

    public Date getAddedDate() { return addedDate; }
    public void setAddedDate(Date addedDate) { this.addedDate = addedDate; }

    public String getAnimalName() { return animalName; }
    public void setAnimalName(String animalName) { this.animalName = animalName; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}
