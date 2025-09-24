package org.example.graphql.resolver;

import org.example.graphql.entity.User;
import org.example.graphql.entity.Product;
import org.example.graphql.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class UserResolver {
    
    @Autowired
    private ProductService productService;
    
    @SchemaMapping
    public List<Product> products(User user) {
        return productService.getProductsByUserId(user.getId());
    }
}