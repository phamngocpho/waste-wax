package com.example.CandleShop.service;

import com.example.CandleShop.entity.PaymentMethod;
import com.example.CandleShop.repository.PaymentMethodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;


@Service
public class PaymentMethodService {
    @Autowired
    private PaymentMethodRepository paymentMethodRepository;

    public PaymentMethod findById(Long id) {
        Optional<PaymentMethod> paymentMethod = paymentMethodRepository.findById(id);
        return paymentMethod.orElse(null);
    }
}
