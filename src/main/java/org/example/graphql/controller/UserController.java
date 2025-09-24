package org.example.graphql.controller;

import org.example.graphql.entity.User;
import org.example.graphql.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;

@Controller
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // Query Mappings
    @QueryMapping
    public List<User> users() {
        return userService.getAllUsers();
    }
    
    @QueryMapping
    public User user(@Argument Long id) {
        Optional<User> user = userService.getUserById(id);
        return user.orElse(null);
    }
    
    @QueryMapping
    public User userByUsername(@Argument String username) {
        Optional<User> user = userService.getUserByUsername(username);
        return user.orElse(null);
    }
    
    @QueryMapping
    public List<User> usersByRole(@Argument Integer roleId) {
        return userService.getUsersByRole(roleId);
    }
    
    @QueryMapping
    public List<User> searchUsersByName(@Argument String name) {
        return userService.searchUsersByName(name);
    }
    
    // Mutation Mappings
    @MutationMapping
    public User createUser(@Argument UserInput input) {
        User user = new User();
        user.setUsername(input.getUsername());
        user.setPassword(input.getPassword());
        user.setEmail(input.getEmail());
        user.setFullName(input.getFullName());
        user.setPhone(input.getPhone());
        user.setAvatar(input.getAvatar());
        user.setRoleId(input.getRoleId());
        
        return userService.createUser(user);
    }
    
    @MutationMapping
    public User updateUser(@Argument Long id, @Argument UserUpdateInput input) {
        User userDetails = new User();
        
        if (input.getUsername() != null) userDetails.setUsername(input.getUsername());
        if (input.getPassword() != null) userDetails.setPassword(input.getPassword());
        if (input.getEmail() != null) userDetails.setEmail(input.getEmail());
        if (input.getFullName() != null) userDetails.setFullName(input.getFullName());
        if (input.getPhone() != null) userDetails.setPhone(input.getPhone());
        if (input.getAvatar() != null) userDetails.setAvatar(input.getAvatar());
        if (input.getRoleId() != null) userDetails.setRoleId(input.getRoleId());
        
        return userService.updateUser(id, userDetails);
    }
    
    @MutationMapping
    public Boolean deleteUser(@Argument Long id) {
        return userService.deleteUser(id);
    }
    
    // Input Classes
    public static class UserInput {
        private String username;
        private String password;
        private String email;
        private String fullName;
        private String phone;
        private String avatar;
        private Integer roleId;
        
        // Getters and Setters
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public String getAvatar() { return avatar; }
        public void setAvatar(String avatar) { this.avatar = avatar; }
        
        public Integer getRoleId() { return roleId; }
        public void setRoleId(Integer roleId) { this.roleId = roleId; }
    }
    
    public static class UserUpdateInput {
        private String username;
        private String password;
        private String email;
        private String fullName;
        private String phone;
        private String avatar;
        private Integer roleId;
        
        // Getters and Setters
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public String getAvatar() { return avatar; }
        public void setAvatar(String avatar) { this.avatar = avatar; }
        
        public Integer getRoleId() { return roleId; }
        public void setRoleId(Integer roleId) { this.roleId = roleId; }
    }
}