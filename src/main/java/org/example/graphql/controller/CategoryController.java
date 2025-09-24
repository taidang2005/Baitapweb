package org.example.graphql.controller;

import org.example.graphql.entity.Category;
import org.example.graphql.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;

@Controller
public class CategoryController {
    
    @Autowired
    private CategoryService categoryService;
    
    // Query Mappings
    @QueryMapping
    public List<Category> categories() {
        return categoryService.getAllCategories();
    }
    
    @QueryMapping
    public Category category(@Argument Long id) {
        Optional<Category> category = categoryService.getCategoryById(id);
        return category.orElse(null);
    }
    
    @QueryMapping
    public Category categoryByName(@Argument String name) {
        Optional<Category> category = categoryService.getCategoryByName(name);
        return category.orElse(null);
    }
    
    @QueryMapping
    public List<Category> categoriesByUser(@Argument Long userId) {
        return categoryService.getCategoriesByUserId(userId);
    }
    
    @QueryMapping
    public List<Category> categoriesWithProducts() {
        return categoryService.getCategoriesWithActiveProducts();
    }
    
    @QueryMapping
    public List<Category> searchCategoriesByName(@Argument String name) {
        return categoryService.searchCategoriesByName(name);
    }
    
    // Schema Mappings for computed fields
    @SchemaMapping
    public Integer productCount(Category category) {
        return (int) categoryService.countActiveProductsInCategory(category.getId());
    }
    
    // Mutation Mappings
    @MutationMapping
    public Category createCategory(@Argument CategoryInput input) {
        Category category = new Category();
        category.setName(input.getName());
        category.setDescription(input.getDescription());
        category.setUserId(input.getUserId());
        category.setIcon(input.getIcon());
        
        return categoryService.createCategory(category);
    }
    
    @MutationMapping
    public Category updateCategory(@Argument Long id, @Argument CategoryUpdateInput input) {
        Category categoryDetails = new Category();
        
        if (input.getName() != null) categoryDetails.setName(input.getName());
        if (input.getDescription() != null) categoryDetails.setDescription(input.getDescription());
        if (input.getIcon() != null) categoryDetails.setIcon(input.getIcon());
        
        return categoryService.updateCategory(id, categoryDetails);
    }
    
    @MutationMapping
    public Boolean deleteCategory(@Argument Long id) {
        return categoryService.deleteCategory(id);
    }
    
    // Input Classes
    public static class CategoryInput {
        private String name;
        private String description;
        private Long userId;
        private String icon;
        
        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Long getUserId() { return userId; }
        public void setUserId(Long userId) { this.userId = userId; }
        
        public String getIcon() { return icon; }
        public void setIcon(String icon) { this.icon = icon; }
    }
    
    public static class CategoryUpdateInput {
        private String name;
        private String description;
        private String icon;
        
        // Getters and Setters
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public String getIcon() { return icon; }
        public void setIcon(String icon) { this.icon = icon; }
    }
}