package org.example.graphql.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "dbo.Products")
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "productId")
    private Long productId;
    
    @Column(name = "createDate")
    private LocalDateTime createDate;
    
    @Column(name = "description", length = 500)
    private String description;
    
    @Column(name = "discount")
    private Float discount;
    
    @Column(name = "images", length = 200)
    private String images;
    
    @Column(name = "productName", length = 500, nullable = false)
    private String productName;
    
    @Column(name = "quantity", nullable = false)
    private Integer quantity;
    
    @Column(name = "status")
    private Boolean status;
    
    @Column(name = "unitPrice", nullable = false)
    private Float unitPrice;
    
    @Column(name = "categoryId", nullable = false)
    private Long categoryId;
    
    // Note: Relationships will be resolved via GraphQL resolvers to avoid lazy loading issues
    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "categoryId", referencedColumnName = "id", insertable = false, updatable = false)
    // private Category category;
    // 
    // @ManyToOne(fetch = FetchType.LAZY)
    // @JoinColumn(name = "userId", referencedColumnName = "id", insertable = false, updatable = false)
    // private User user;
    
    @Column(name = "userId")
    private Long userId;
    
    // Constructors
    public Product() {
        this.createDate = LocalDateTime.now();
        this.status = true;
    }
    
    public Product(String productName, String description, Float unitPrice, Integer quantity, Long categoryId, Long userId) {
        this();
        this.productName = productName;
        this.description = description;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.categoryId = categoryId;
        this.userId = userId;
    }
    
    // Getters and Setters
    public Long getProductId() {
        return productId;
    }
    
    public void setProductId(Long productId) {
        this.productId = productId;
    }
    
    public LocalDateTime getCreateDate() {
        return createDate;
    }
    
    public void setCreateDate(LocalDateTime createDate) {
        this.createDate = createDate;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Float getDiscount() {
        return discount;
    }
    
    public void setDiscount(Float discount) {
        this.discount = discount;
    }
    
    public String getImages() {
        return images;
    }
    
    public void setImages(String images) {
        this.images = images;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public Integer getQuantity() {
        return quantity;
    }
    
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
    
    public Boolean getStatus() {
        return status;
    }
    
    public void setStatus(Boolean status) {
        this.status = status;
    }
    
    public Float getUnitPrice() {
        return unitPrice;
    }
    
    public void setUnitPrice(Float unitPrice) {
        this.unitPrice = unitPrice;
    }
    
    public Long getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }
    
    // Category and User relationships handled by GraphQL resolvers
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    // Calculated field for final price after discount
    public Float getFinalPrice() {
        if (discount != null && discount > 0) {
            return unitPrice * (1 - discount / 100);
        }
        return unitPrice;
    }
}