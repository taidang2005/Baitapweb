package org.example.graphql.service;

import org.example.graphql.entity.Product;
import org.example.graphql.repository.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class ProductService {
    
    @Autowired
    private ProductRepository productRepository;
    
    // Create product
    public Product createProduct(Product product) {
        // Validate product data
        if (product.getUnitPrice() <= 0) {
            throw new RuntimeException("Product price must be greater than 0");
        }
        if (product.getQuantity() < 0) {
            throw new RuntimeException("Product quantity cannot be negative");
        }
        
        return productRepository.save(product);
    }
    
    // Get all products
    @Transactional(readOnly = true)
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }
    
    // Get product by ID
    @Transactional(readOnly = true)
    public Optional<Product> getProductById(Long id) {
        return productRepository.findById(id);
    }
    
    // Get product by name
    @Transactional(readOnly = true)
    public Optional<Product> getProductByName(String name) {
        return productRepository.findByProductName(name);
    }
    
    // YÊU CẦU CHÍNH: Get all products ordered by price (low to high)
    @Transactional(readOnly = true)
    public List<Product> getAllProductsOrderByPriceAsc() {
        return productRepository.findAllActiveProductsOrderByPriceAsc();
    }
    
    // YÊU CẦU CHÍNH: Get products by category ID
    @Transactional(readOnly = true)
    public List<Product> getProductsByCategoryId(Long categoryId) {
        return productRepository.findActiveProductsByCategoryId(categoryId);
    }
    
    // Update product
    public Product updateProduct(Long id, Product productDetails) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        
        // Validate updated data
        if (productDetails.getUnitPrice() <= 0) {
            throw new RuntimeException("Product price must be greater than 0");
        }
        if (productDetails.getQuantity() < 0) {
            throw new RuntimeException("Product quantity cannot be negative");
        }
        
        product.setProductName(productDetails.getProductName());
        product.setDescription(productDetails.getDescription());
        product.setUnitPrice(productDetails.getUnitPrice());
        product.setQuantity(productDetails.getQuantity());
        product.setDiscount(productDetails.getDiscount());
        product.setImages(productDetails.getImages());
        product.setStatus(productDetails.getStatus());
        product.setCategoryId(productDetails.getCategoryId());
        
        return productRepository.save(product);
    }
    
    // Delete product (soft delete by setting status to false)
    public boolean deleteProduct(Long id) {
        Optional<Product> productOpt = productRepository.findById(id);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            product.setStatus(false);
            productRepository.save(product);
            return true;
        }
        return false;
    }
    
    // Hard delete product
    public boolean hardDeleteProduct(Long id) {
        if (productRepository.existsById(id)) {
            productRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    // Get products by user ID
    @Transactional(readOnly = true)
    public List<Product> getProductsByUserId(Long userId) {
        return productRepository.findByUserId(userId);
    }
    
    // Search products by name
    @Transactional(readOnly = true)
    public List<Product> searchProductsByName(String name) {
        return productRepository.findByProductNameContaining(name);
    }
    
    // Get products by price range
    @Transactional(readOnly = true)
    public List<Product> getProductsByPriceRange(Float minPrice, Float maxPrice) {
        return productRepository.findByPriceRange(minPrice, maxPrice);
    }
    
    // Get products with discount
    @Transactional(readOnly = true)
    public List<Product> getProductsWithDiscount() {
        return productRepository.findProductsWithDiscount();
    }
    
    // Get low stock products
    @Transactional(readOnly = true)
    public List<Product> getLowStockProducts(Integer threshold) {
        return productRepository.findLowStockProducts(threshold);
    }
    
    // Get newest products
    @Transactional(readOnly = true)
    public List<Product> getNewestProducts() {
        return productRepository.findAllActiveProductsOrderByCreateDateDesc();
    }
    
    // Search products with multiple criteria
    @Transactional(readOnly = true)
    public List<Product> searchProducts(String name, Long categoryId, Float minPrice, Float maxPrice) {
        return productRepository.searchProducts(name, categoryId, minPrice, maxPrice);
    }
    
    // Count active products
    @Transactional(readOnly = true)
    public long countActiveProducts() {
        return productRepository.countByStatus(true);
    }
    
    // Get featured products
    @Transactional(readOnly = true)
    public List<Product> getFeaturedProducts() {
        return productRepository.findFeaturedProducts();
    }
    
    // Update product stock
    public Product updateProductStock(Long id, Integer newQuantity) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        
        if (newQuantity < 0) {
            throw new RuntimeException("Product quantity cannot be negative");
        }
        
        product.setQuantity(newQuantity);
        return productRepository.save(product);
    }
    
    // Apply discount to product
    public Product applyDiscount(Long id, Float discountPercent) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        
        if (discountPercent < 0 || discountPercent > 100) {
            throw new RuntimeException("Discount must be between 0 and 100 percent");
        }
        
        product.setDiscount(discountPercent);
        return productRepository.save(product);
    }
    
    // Toggle product status
    public Product toggleProductStatus(Long id) {
        Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found with id: " + id));
        
        product.setStatus(!product.getStatus());
        return productRepository.save(product);
    }
}