package org.example.graphql.repository;

import org.example.graphql.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    // Find user by username
    Optional<User> findByUsername(String username);
    
    // Find user by email
    Optional<User> findByEmail(String email);
    
    // Find users by role
    List<User> findByRoleId(Integer roleId);
    
    // Find users by full name containing (case-insensitive)
    @Query("SELECT u FROM User u WHERE LOWER(u.fullName) LIKE LOWER(CONCAT('%', :name, '%'))")
    List<User> findByFullNameContaining(@Param("name") String name);
    
    // Check if username exists
    boolean existsByUsername(String username);
    
    // Check if email exists
    boolean existsByEmail(String email);
    
    // Find users with products
    @Query("SELECT DISTINCT u FROM User u WHERE u.id IN (SELECT p.userId FROM Product p WHERE p.status = true)")
    List<User> findUsersWithActiveProducts();
    
    // Count users by role
    long countByRoleId(Integer roleId);
}