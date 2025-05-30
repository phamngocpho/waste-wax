package com.example.CandleShop.repository;

import com.example.CandleShop.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByIsFeaturedTrue();
    List<Product> findTop5ByIsFeaturedIsTrue();
    List<Product> findByStatus(String status);
}
