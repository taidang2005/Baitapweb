package org.example.graphql.repository;

import org.example.graphql.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    // Find all products ordered by price (low to high) - YÊU CẦU CHÍNH
    @Query("SELECT p FROM Product p WHERE p.status = true ORDER BY p.unitPrice ASC")
    List<Product> findAllActiveProductsOrderByPriceAsc();
    
    // Find products by category ID - YÊU CẦU CHÍNH
    @Query("SELECT p FROM Product p WHERE p.categoryId = :categoryId AND p.status = true ORDER BY p.productName ASC")
    List<Product> findActiveProductsByCategoryId(@Param("categoryId") Long categoryId);
    
    // Find product by name
    Optional<Product> findByProductName(String productName);
    
    // Find products by user ID
    List<Product> findByUserId(Long userId);
    
    // Find products by name containing (case-insensitive)
    @Query("SELECT p FROM Product p WHERE LOWER(p.productName) LIKE LOWER(CONCAT('%', :name, '%')) AND p.status = true")
    List<Product> findByProductNameContaining(@Param("name") String name);
    
    // Find products by price range
    @Query("SELECT p FROM Product p WHERE p.unitPrice BETWEEN :minPrice AND :maxPrice AND p.status = true ORDER BY p.unitPrice ASC")
    List<Product> findByPriceRange(@Param("minPrice") Float minPrice, @Param("maxPrice") Float maxPrice);
    
    // Find products with discount
    @Query("SELECT p FROM Product p WHERE p.discount > 0 AND p.status = true ORDER BY p.discount DESC")
    List<Product> findProductsWithDiscount();
    
    // Find out of stock products
    List<Product> findByQuantityAndStatus(Integer quantity, Boolean status);
    
    // Find low stock products (quantity <= threshold)
    @Query("SELECT p FROM Product p WHERE p.quantity <= :threshold AND p.status = true ORDER BY p.quantity ASC")
    List<Product> findLowStockProducts(@Param("threshold") Integer threshold);
    
    // Find products ordered by creation date (newest first)
    @Query("SELECT p FROM Product p WHERE p.status = true ORDER BY p.createDate DESC")
    List<Product> findAllActiveProductsOrderByCreateDateDesc();
    
    // Search products by multiple criteria
    @Query("SELECT p FROM Product p WHERE " +
           "(:name IS NULL OR LOWER(p.productName) LIKE LOWER(CONCAT('%', :name, '%'))) AND " +
           "(:categoryId IS NULL OR p.categoryId = :categoryId) AND " +
           "(:minPrice IS NULL OR p.unitPrice >= :minPrice) AND " +
           "(:maxPrice IS NULL OR p.unitPrice <= :maxPrice) AND " +
           "p.status = true " +
           "ORDER BY p.unitPrice ASC")
    List<Product> searchProducts(@Param("name") String name, 
                                @Param("categoryId") Long categoryId,
                                @Param("minPrice") Float minPrice, 
                                @Param("maxPrice") Float maxPrice);
    
    // Count active products
    long countByStatus(Boolean status);
    
    // Find featured products (high rating or with discount)
    @Query("SELECT p FROM Product p WHERE (p.discount > 10 OR p.quantity > 50) AND p.status = true ORDER BY p.discount DESC, p.quantity DESC")
    List<Product> findFeaturedProducts();
}