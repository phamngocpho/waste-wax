package com.example.CandleShop.repository;

import com.example.CandleShop.entity.ProductImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductImageRepository extends JpaRepository<ProductImage, Long> {
    List<ProductImage> findByProductId(Long productId);
    List<ProductImage> findByProductIdAndDeletedFalse(Long productId);
    List<ProductImage> findByProductIdAndIdNot(Long productId, Long id);
}
