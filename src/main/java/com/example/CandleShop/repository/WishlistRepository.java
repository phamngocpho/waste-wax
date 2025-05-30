package com.example.CandleShop.repository;

import com.example.CandleShop.entity.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistRepository extends JpaRepository<WishlistItem, Long> {
    List<WishlistItem> findByUserId(Long userId);
    Optional<WishlistItem> findByUserIdAndProductId(Long userId, Long productId);
    boolean existsByUserIdAndProductId(Long userId, Long productId);

    @Modifying
    @Transactional
    @Query("DELETE FROM WishlistItem w WHERE w.user.id = :userId AND w.product.id = :productId")
    void deleteByUserIdAndProductId(Long userId, Long productId);
}
