package org.example.graphql.resolver;

import org.example.graphql.entity.Product;
import org.example.graphql.entity.Category;
import org.example.graphql.entity.User;
import org.example.graphql.service.CategoryService;
import org.example.graphql.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.Optional;

@Controller
public class ProductResolver {
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private UserService userService;
    
    @SchemaMapping
    public Category category(Product product) {
        if (product.getCategoryId() != null) {
            Optional<Category> category = categoryService.getCategoryById(product.getCategoryId());
            return category.orElse(null);
        }
        return null;
    }
    
    @SchemaMapping
    public User user(Product product) {
        if (product.getUserId() != null) {
            Optional<User> user = userService.getUserById(product.getUserId());
            return user.orElse(null);
        }
        return null;
    }
}