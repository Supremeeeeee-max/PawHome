package com.pawhome.model;

import java.util.Date;

/**
 * Model class representing an Animal in the shelter.
 */
public class Animal {
    private int animalId;
    private String name;
    private String species;
    private String breed;
    private int age;
    private String gender;
    private String healthStatus;
    private String description;
    private String imagePath;
    private String shelterLocation;
    private Date intakeDate;
    private String availabilityStatus; // "Available", "Reserved", "Adopted"
    private int categoryId;
    private int addedBy;
    private Date createdAt;

    // Extra field for display (category name)
    private String categoryName;

    // Default constructor
    public Animal() {}

    // Getters and Setters
    public int getAnimalId() { return animalId; }
    public void setAnimalId(int animalId) { this.animalId = animalId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecies() { return species; }
    public void setSpecies(String species) { this.species = species; }

    public String getBreed() { return breed; }
    public void setBreed(String breed) { this.breed = breed; }

    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getHealthStatus() { return healthStatus; }
    public void setHealthStatus(String healthStatus) { this.healthStatus = healthStatus; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getShelterLocation() { return shelterLocation; }
    public void setShelterLocation(String shelterLocation) { this.shelterLocation = shelterLocation; }

    public Date getIntakeDate() { return intakeDate; }
    public void setIntakeDate(Date intakeDate) { this.intakeDate = intakeDate; }

    public String getAvailabilityStatus() { return availabilityStatus; }
    public void setAvailabilityStatus(String availabilityStatus) { this.availabilityStatus = availabilityStatus; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getAddedBy() { return addedBy; }
    public void setAddedBy(int addedBy) { this.addedBy = addedBy; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
}
