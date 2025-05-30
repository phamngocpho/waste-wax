package com.example.CandleShop.service;

import com.example.CandleShop.entity.UserVoucher;
import com.example.CandleShop.repository.UserVoucherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class UserVoucherService {

    @Autowired
    private UserVoucherRepository userVoucherRepository;

    public List<UserVoucher> getAvailableVouchersByUserId(Long userId) {
        return userVoucherRepository.findByUserIdOrderByIsUsedAscExpiryDateDesc(
                userId, java.time.LocalDate.now());
    }

    public void saveUserVoucher(UserVoucher userVoucher) {
        userVoucherRepository.save(userVoucher);
    }
    public List<UserVoucher> getUsableVouchers(Long userId) {
        return userVoucherRepository.findByUserIdAndIsUsedFalseAndExpiryDateAfter(userId, LocalDate.now());
    }
    public UserVoucher findById(Long id) {
        Optional<UserVoucher> userVoucher = userVoucherRepository.findById(id);
        return userVoucher.orElse(null);
    }
}
