package com.pawhome.service;

import com.pawhome.dao.AnimalDAO;
import com.pawhome.model.Animal;

import java.util.List;

/**
 * Service class encapsulating business logic for Animal operations.
 */
public class AnimalService {

    private AnimalDAO animalDAO;

    public AnimalService() {
        this.animalDAO = new AnimalDAO();
    }

    public boolean addAnimal(Animal animal) {
        return animalDAO.insert(animal);
    }

    public boolean updateAnimal(Animal animal) {
        return animalDAO.update(animal);
    }

    public boolean deleteAnimal(int animalId) {
        return animalDAO.delete(animalId);
    }

    public Animal getAnimalById(int animalId) {
        return animalDAO.findById(animalId);
    }

    public List<Animal> getAllAnimals() {
        return animalDAO.findAll();
    }

    public List<Animal> getAvailableAnimals() {
        return animalDAO.findAvailable();
    }

    public List<Animal> searchAnimals(String keyword) {
        return animalDAO.search(keyword);
    }

    public List<Animal> getAnimalsByCategory(int categoryId) {
        return animalDAO.findByCategory(categoryId);
    }

    public int countAll() {
        return animalDAO.countAll();
    }

    public int countByStatus(String status) {
        return animalDAO.countByStatus(status);
    }

    public List<Object[]> getAdoptionStatsBySpecies() {
        return animalDAO.getAdoptionStatsBySpecies();
    }

    public List<Object[]> getAvailabilityReport() {
        return animalDAO.getAvailabilityReport();
    }
}
