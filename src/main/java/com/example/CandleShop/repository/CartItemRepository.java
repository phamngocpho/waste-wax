package com.example.CandleShop.repository;

import com.example.CandleShop.entity.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Long> {
    List<CartItem> findByCartId(Long cartId);
    CartItem findByCartIdAndProductIdAndProductSizeId(Long cartId, Long productId, Long sizeId);
    @Query("SELECT ci FROM CartItem ci " +
            "LEFT JOIN FETCH ci.product p " +
            "LEFT JOIN FETCH p.images " +
            "WHERE ci.id IN :ids")
    List<CartItem> findCartItemsWithProductAndImages(@Param("ids") List<Long> ids);
}

