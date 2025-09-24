package org.example.graphql.resolver;

import org.example.graphql.entity.Category;
import org.example.graphql.entity.Product;
import org.example.graphql.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class CategoryResolver {
    
    @Autowired
    private ProductService productService;
    
    @SchemaMapping
    public List<Product> products(Category category) {
        return productService.getProductsByCategoryId(category.getId());
    }
}