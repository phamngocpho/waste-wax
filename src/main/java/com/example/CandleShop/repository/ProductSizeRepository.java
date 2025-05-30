package com.example.CandleShop.repository;

import com.example.CandleShop.entity.ProductSize;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductSizeRepository extends JpaRepository<ProductSize, Long> {
    List<ProductSize> findByProductId(Long productId);
    List<ProductSize> findByProductIdAndDeletedFalse(Long productId);
}

