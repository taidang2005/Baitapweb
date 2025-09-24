package org.example.graphql.repository;

import org.example.graphql.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    
    // Find category by name
    Optional<Category> findByName(String name);
    
    // Find categories by user ID
    List<Category> findByUserId(Long userId);
    
    // Find categories by name containing (case-insensitive)
    @Query("SELECT c FROM Category c WHERE LOWER(c.name) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<Category> findByNameContaining(@Param("name") String name);
    
    // Find categories with products
    @Query("SELECT DISTINCT c FROM Category c WHERE c.id IN (SELECT p.categoryId FROM Product p WHERE p.status = true)")
    List<Category> findCategoriesWithActiveProducts();
    
    // Count products in category
    @Query("SELECT COUNT(p) FROM Product p WHERE p.categoryId = :categoryId AND p.status = true")
    long countActiveProductsInCategory(@Param("categoryId") Long categoryId);
    
    // Find categories ordered by name
    List<Category> findAllByOrderByNameAsc();
    
    // Find categories by description containing
    @Query("SELECT c FROM Category c WHERE LOWER(c.description) LIKE LOWER(CONCAT('%', :description, '%'))")
    List<Category> findByDescriptionContaining(@Param("description") String description);
    
    // Check if category name exists for user
    boolean existsByNameAndUserId(String name, Long userId);
}