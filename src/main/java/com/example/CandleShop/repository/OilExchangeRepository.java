package com.example.CandleShop.repository;

import com.example.CandleShop.entity.OilExchange;
import com.example.CandleShop.entity.User;
import com.example.CandleShop.enums.ExchangeStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OilExchangeRepository extends JpaRepository<OilExchange, Long> {
    List<OilExchange> findByUserOrderByCreatedAtDesc(User user);
    List<OilExchange> findByStatusOrderByCreatedAtAsc(ExchangeStatus status);
    List<OilExchange> findByStatus(ExchangeStatus status);
    List<OilExchange> findByExchangeNumber(String exchangeNumber);
}

