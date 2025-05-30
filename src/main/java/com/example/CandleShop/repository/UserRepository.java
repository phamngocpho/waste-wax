package com.example.CandleShop.repository;

import com.example.CandleShop.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
    User findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    User findByUsernameOrEmail(String username, String email);
    List<User> findByRole(User.Role role);
    List<User> findByStatus(String status);
}
