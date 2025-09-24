package org.example.graphql.service;

import org.example.graphql.entity.Category;
import org.example.graphql.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CategoryService {
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    // Create category
    public Category createCategory(Category category) {
        // Validate unique category name for the user
        if (categoryRepository.existsByNameAndUserId(category.getName(), category.getUserId())) {
            throw new RuntimeException("Category name already exists for this user: " + category.getName());
        }
        return categoryRepository.save(category);
    }
    
    // Get all categories
    @Transactional(readOnly = true)
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }
    
    // Get category by ID
    @Transactional(readOnly = true)
    public Optional<Category> getCategoryById(Long id) {
        return categoryRepository.findById(id);
    }
    
    // Get category by name
    @Transactional(readOnly = true)
    public Optional<Category> getCategoryByName(String name) {
        return categoryRepository.findByName(name);
    }
    
    // Get categories by user ID
    @Transactional(readOnly = true)
    public List<Category> getCategoriesByUserId(Long userId) {
        return categoryRepository.findByUserId(userId);
    }
    
    // Update category
    public Category updateCategory(Long id, Category categoryDetails) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found with id: " + id));
        
        // Check if name is being changed and if new name exists for the user
        if (!category.getName().equals(categoryDetails.getName()) && 
            categoryRepository.existsByNameAndUserId(categoryDetails.getName(), category.getUserId())) {
            throw new RuntimeException("Category name already exists for this user: " + categoryDetails.getName());
        }
        
        category.setName(categoryDetails.getName());
        category.setDescription(categoryDetails.getDescription());
        category.setIcon(categoryDetails.getIcon());
        
        return categoryRepository.save(category);
    }
    
    // Delete category
    public boolean deleteCategory(Long id) {
        Optional<Category> category = categoryRepository.findById(id);
        if (category.isPresent()) {
            // Check if category has active products
            long productCount = categoryRepository.countActiveProductsInCategory(id);
            if (productCount > 0) {
                throw new RuntimeException("Cannot delete category. It has " + productCount + " active products.");
            }
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    // Search categories by name
    @Transactional(readOnly = true)
    public List<Category> searchCategoriesByName(String name) {
        return categoryRepository.findByNameContaining(name);
    }
    
    // Search categories by description
    @Transactional(readOnly = true)
    public List<Category> searchCategoriesByDescription(String description) {
        return categoryRepository.findByDescriptionContaining(description);
    }
    
    // Get categories with active products
    @Transactional(readOnly = true)
    public List<Category> getCategoriesWithActiveProducts() {
        return categoryRepository.findCategoriesWithActiveProducts();
    }
    
    // Get all categories ordered by name
    @Transactional(readOnly = true)
    public List<Category> getAllCategoriesOrderedByName() {
        return categoryRepository.findAllByOrderByNameAsc();
    }
    
    // Count active products in category
    @Transactional(readOnly = true)
    public long countActiveProductsInCategory(Long categoryId) {
        return categoryRepository.countActiveProductsInCategory(categoryId);
    }
    
    // Force delete category (delete with all products)
    public boolean forceDeleteCategory(Long id) {
        if (categoryRepository.existsById(id)) {
            categoryRepository.deleteById(id);
            return true;
        }
        return false;
    }
}