package org.example.graphql.controller;

import org.example.graphql.entity.Product;
import org.example.graphql.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;

@Controller
public class ProductController {
    
    @Autowired
    private ProductService productService;
    
    // Query Mappings
    @QueryMapping
    public List<Product> products() {
        return productService.getAllProducts();
    }
    
    @QueryMapping
    public Product product(@Argument Long id) {
        Optional<Product> product = productService.getProductById(id);
        return product.orElse(null);
    }
    
    @QueryMapping
    public Product productByName(@Argument String name) {
        Optional<Product> product = productService.getProductByName(name);
        return product.orElse(null);
    }
    
    // YÊU CẦU CHÍNH: Products ordered by price (low to high)
    @QueryMapping
    public List<Product> productsOrderByPrice() {
        return productService.getAllProductsOrderByPriceAsc();
    }
    
    // YÊU CẦU CHÍNH: Products by category
    @QueryMapping
    public List<Product> productsByCategory(@Argument Long categoryId) {
        return productService.getProductsByCategoryId(categoryId);
    }
    
    @QueryMapping
    public List<Product> productsByUser(@Argument Long userId) {
        return productService.getProductsByUserId(userId);
    }
    
    @QueryMapping
    public List<Product> searchProductsByName(@Argument String name) {
        return productService.searchProductsByName(name);
    }
    
    @QueryMapping
    public List<Product> productsByPriceRange(@Argument Float minPrice, @Argument Float maxPrice) {
        return productService.getProductsByPriceRange(minPrice, maxPrice);
    }
    
    @QueryMapping
    public List<Product> productsWithDiscount() {
        return productService.getProductsWithDiscount();
    }
    
    @QueryMapping
    public List<Product> featuredProducts() {
        return productService.getFeaturedProducts();
    }
    
    @QueryMapping
    public List<Product> newestProducts() {
        return productService.getNewestProducts();
    }
    
    @QueryMapping
    public List<Product> lowStockProducts(@Argument Integer threshold) {
        return productService.getLowStockProducts(threshold);
    }
    
    @QueryMapping
    public List<Product> searchProducts(@Argument(name = "name") String name, 
                                       @Argument(name = "categoryId") Long categoryId,
                                       @Argument(name = "minPrice") Float minPrice, 
                                       @Argument(name = "maxPrice") Float maxPrice) {
        return productService.searchProducts(name, categoryId, minPrice, maxPrice);
    }
    
    // Schema Mappings for computed fields
    @SchemaMapping
    public Float finalPrice(Product product) {
        return product.getFinalPrice();
    }
    
    // Mutation Mappings
    @MutationMapping
    public Product createProduct(@Argument ProductInput input) {
        Product product = new Product();
        product.setProductName(input.getProductName());
        product.setDescription(input.getDescription());
        product.setUnitPrice(input.getUnitPrice());
        product.setQuantity(input.getQuantity());
        product.setDiscount(input.getDiscount());
        product.setImages(input.getImages());
        product.setCategoryId(input.getCategoryId());
        product.setUserId(input.getUserId());
        
        return productService.createProduct(product);
    }
    
    @MutationMapping
    public Product updateProduct(@Argument Long id, @Argument ProductUpdateInput input) {
        Product productDetails = new Product();
        
        if (input.getProductName() != null) productDetails.setProductName(input.getProductName());
        if (input.getDescription() != null) productDetails.setDescription(input.getDescription());
        if (input.getUnitPrice() != null) productDetails.setUnitPrice(input.getUnitPrice());
        if (input.getQuantity() != null) productDetails.setQuantity(input.getQuantity());
        if (input.getDiscount() != null) productDetails.setDiscount(input.getDiscount());
        if (input.getImages() != null) productDetails.setImages(input.getImages());
        if (input.getStatus() != null) productDetails.setStatus(input.getStatus());
        if (input.getCategoryId() != null) productDetails.setCategoryId(input.getCategoryId());
        
        return productService.updateProduct(id, productDetails);
    }
    
    @MutationMapping
    public Boolean deleteProduct(@Argument Long id) {
        return productService.deleteProduct(id);
    }
    
    @MutationMapping
    public Product updateProductStock(@Argument Long id, @Argument Integer quantity) {
        return productService.updateProductStock(id, quantity);
    }
    
    @MutationMapping
    public Product applyDiscount(@Argument Long id, @Argument Float discountPercent) {
        return productService.applyDiscount(id, discountPercent);
    }
    
    @MutationMapping
    public Product toggleProductStatus(@Argument Long id) {
        return productService.toggleProductStatus(id);
    }
    
    // Input Classes
    public static class ProductInput {
        private String productName;
        private String description;
        private Float unitPrice;
        private Integer quantity;
        private Float discount;
        private String images;
        private Long categoryId;
        private Long userId;
        
        // Getters and Setters
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Float getUnitPrice() { return unitPrice; }
        public void setUnitPrice(Float unitPrice) { this.unitPrice = unitPrice; }
        
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
        
        public Float getDiscount() { return discount; }
        public void setDiscount(Float discount) { this.discount = discount; }
        
        public String getImages() { return images; }
        public void setImages(String images) { this.images = images; }
        
        public Long getCategoryId() { return categoryId; }
        public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
        
        public Long getUserId() { return userId; }
        public void setUserId(Long userId) { this.userId = userId; }
    }
    
    public static class ProductUpdateInput {
        private String productName;
        private String description;
        private Float unitPrice;
        private Integer quantity;
        private Float discount;
        private String images;
        private Boolean status;
        private Long categoryId;
        
        // Getters and Setters
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        
        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }
        
        public Float getUnitPrice() { return unitPrice; }
        public void setUnitPrice(Float unitPrice) { this.unitPrice = unitPrice; }
        
        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
        
        public Float getDiscount() { return discount; }
        public void setDiscount(Float discount) { this.discount = discount; }
        
        public String getImages() { return images; }
        public void setImages(String images) { this.images = images; }
        
        public Boolean getStatus() { return status; }
        public void setStatus(Boolean status) { this.status = status; }
        
        public Long getCategoryId() { return categoryId; }
        public void setCategoryId(Long categoryId) { this.categoryId = categoryId; }
    }
}