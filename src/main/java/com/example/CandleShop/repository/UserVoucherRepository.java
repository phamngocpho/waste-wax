package com.example.CandleShop.repository;

import com.example.CandleShop.entity.UserVoucher;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserVoucherRepository extends JpaRepository<UserVoucher, Long> {

    @Query("SELECT uv FROM UserVoucher uv " +
            "WHERE uv.user.id = :userId " +
            "ORDER BY uv.isUsed ASC, uv.expiryDate DESC")
    List<UserVoucher> findByUserIdOrderByIsUsedAscExpiryDateDesc(@Param("userId") Long userId, LocalDate now);
    // Tìm các voucher chưa sử dụng và còn hạn của user
    List<UserVoucher> findByUserIdAndIsUsedFalseAndExpiryDateAfter(Long userId, LocalDate date);

    // Tìm voucher cụ thể của user chưa sử dụng
    Optional<UserVoucher> findByIdAndUserIdAndIsUsedFalse(Long id, Long userId);
    @Modifying
    @Query("DELETE FROM UserVoucher uv WHERE uv.voucher.id = :voucherId")
    @Transactional
    void deleteByVoucherId(@Param("voucherId") Long voucherId);
}
