package com.example.CandleShop.service;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.entity.Payment;
import com.example.CandleShop.entity.PaymentMethod;
import com.example.CandleShop.enums.PaymentStatus;
import com.example.CandleShop.repository.PaymentMethodRepository;
import com.example.CandleShop.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
@Service
public class PaymentService {

    private final PaymentRepository paymentRepository;

    private final OrderService orderService;
    private final PaymentMethodRepository paymentMethodRepository;

    public PaymentService(PaymentRepository paymentRepository, OrderService orderService, PaymentMethodRepository paymentMethodRepository) {
        this.paymentRepository = paymentRepository;
        this.orderService = orderService;
        this.paymentMethodRepository = paymentMethodRepository;
    }

    public Payment save(Payment payment) {
        return paymentRepository.save(payment);
    }

}
