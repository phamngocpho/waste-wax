package com.example.CandleShop.repository;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.enums.OrderStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByUserIdOrderByCreatedAtDesc(Long userId);

    @Query("SELECT o FROM Order o WHERE " +
            "(:status IS NULL OR o.orderStatus = :status) AND " +
            "(:fromDate IS NULL OR o.createdAt >= :fromDate) AND " +
            "(:toDate IS NULL OR o.createdAt <= :toDate) " +
            "ORDER BY o.createdAt DESC")
    Page<Order> findByFilters(
            @Param("status") OrderStatus status,
            @Param("fromDate") LocalDateTime fromDate,
            @Param("toDate") LocalDateTime toDate,
            Pageable pageable);

}
