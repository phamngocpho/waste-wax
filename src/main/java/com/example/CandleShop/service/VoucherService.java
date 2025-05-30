package com.example.CandleShop.service;

import com.example.CandleShop.entity.User;
import com.example.CandleShop.entity.UserVoucher;
import com.example.CandleShop.entity.Voucher;
import com.example.CandleShop.repository.UserRepository;
import com.example.CandleShop.repository.UserVoucherRepository;
import com.example.CandleShop.repository.VoucherRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class VoucherService {

    @Autowired
    private VoucherRepository voucherRepository;

    @Autowired
    private UserVoucherRepository userVoucherRepository;

    @Autowired
    private UserRepository userRepository;

    // ADMIN: Lấy tất cả voucher
    public List<Voucher> getAllVouchers() {
        return voucherRepository.findAll();
    }

    // ADMIN: Lưu voucher
    public Voucher saveVoucher(Voucher voucher) {
        if (voucher.getCreatedAt() == null) {
            voucher.setCreatedAt(LocalDateTime.now());
        }
        return voucherRepository.save(voucher);
    }

    // ADMIN: Lấy voucher theo ID
    public Optional<Voucher> getVoucherById(Long id) {
        return voucherRepository.findById(id);
    }

    // ADMIN: Xóa voucher
    public void deleteVoucher(Long id) {
        userVoucherRepository.deleteByVoucherId(id);
        voucherRepository.deleteById(id);
    }

    // USER: Lấy danh sách voucher có thể đổi
    public List<Voucher> getAvailableVouchersForUser() {
        return voucherRepository.findByIsActiveTrue();
    }
    // USER: Áp dụng voucher vào đơn hàng
    public BigDecimal calculateDiscountAmount(UserVoucher userVoucher, BigDecimal orderTotal) {
        Voucher voucher = userVoucher.getVoucher();

        // Kiểm tra giá trị đơn hàng tối thiểu
        if (orderTotal.compareTo(voucher.getMinOrderValue()) < 0) {
            return BigDecimal.ZERO;
        }

        // Tính số tiền giảm giá
        BigDecimal discountAmount = orderTotal.multiply(
                BigDecimal.valueOf(voucher.getDiscountPercent()).divide(BigDecimal.valueOf(100))
        );

        // Kiểm tra giới hạn giảm giá tối đa
        if (voucher.getMaxDiscountAmount() != null &&
                discountAmount.compareTo(voucher.getMaxDiscountAmount()) > 0) {
            discountAmount = voucher.getMaxDiscountAmount();
        }

        return discountAmount;
    }

    // USER: Áp dụng voucher vào đơn hàng
    @Transactional
    public Map<String, Object> applyVoucherToOrder(Long userVoucherId, Long userId, BigDecimal orderTotal) {
        Map<String, Object> result = new HashMap<>();

        try {
            Optional<UserVoucher> userVoucherOpt = userVoucherRepository.findByIdAndUserIdAndIsUsedFalse(userVoucherId, userId);

            if (userVoucherOpt.isEmpty()) {
                result.put("success", false);
                result.put("message", "Voucher không hợp lệ hoặc đã được sử dụng");
                return result;
            }

            UserVoucher userVoucher = userVoucherOpt.get();

            // Kiểm tra hạn sử dụng
            if (userVoucher.getExpiryDate().isBefore(LocalDate.now())) {
                result.put("success", false);
                result.put("message", "Voucher đã hết hạn");
                return result;
            }

            BigDecimal discountAmount = calculateDiscountAmount(userVoucher, orderTotal);

            if (discountAmount.compareTo(BigDecimal.ZERO) <= 0) {
                result.put("success", false);
                result.put("message", "Đơn hàng không đủ điều kiện áp dụng voucher này");
                return result;
            }

            result.put("success", true);
            result.put("discountAmount", discountAmount);
            result.put("userVoucher", userVoucher);

            return result;
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi áp dụng voucher: " + e.getMessage());
            return result;
        }
    }
    @Transactional
    public Map<String, Object> redeemVoucher(Long userId, Long voucherId) {
        Map<String, Object> result = new HashMap<>();
        try {
            // Kiểm tra user và voucher có tồn tại không
            Optional<User> userOptional = userRepository.findById(userId);
            Optional<Voucher> voucherOptional = voucherRepository.findById(voucherId);

            if (userOptional.isEmpty()) {
                result.put("success", false);
                result.put("message", "Không tìm thấy thông tin người dùng");
                return result;
            }

            if (voucherOptional.isEmpty()) {
                result.put("success", false);
                result.put("message", "Không tìm thấy voucher");
                return result;
            }

            User user = userOptional.get();
            Voucher voucher = voucherOptional.get();

            // Kiểm tra voucher có còn active không
            if (!voucher.getIsActive()) {
                result.put("success", false);
                result.put("message", "Voucher này không còn hiệu lực");
                return result;
            }

            // Kiểm tra điểm của user có đủ không
            int pointsRequired = voucher.getPointsRequired();

            if (user.getPoints() < pointsRequired) {
                result.put("success", false);
                result.put("message", "Bạn không đủ điểm để đổi voucher này");
                return result;
            }

            // Tạo UserVoucher mới
            UserVoucher userVoucher = new UserVoucher();
            userVoucher.setUser(user);
            userVoucher.setVoucher(voucher);
            userVoucher.setIsUsed(false);
            userVoucher.setCreatedAt(LocalDateTime.now());

            // Tính ngày hết hạn dựa trên expiryDays của voucher
            LocalDate expiryDate = LocalDate.now().plusDays(voucher.getExpiryDays());
            userVoucher.setExpiryDate(expiryDate);

            // Lưu UserVoucher
            userVoucherRepository.save(userVoucher);

            // Trừ điểm của user
            user.setPoints(user.getPoints() - pointsRequired);
            userRepository.save(user);

            result.put("success", true);
            result.put("message", "Đổi voucher thành công!");
            return result;

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
            return result;
        }
    }

}
