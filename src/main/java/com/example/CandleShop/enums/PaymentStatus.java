package com.example.CandleShop.enums;

public enum PaymentStatus {
    PENDING("Chờ thanh toán"),
    PAID("Đã thanh toán"),
    FAILED("Thanh toán thất bại"),
    REFUNDED("Đã hoàn tiền");

    private final String displayValue;

    PaymentStatus(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getDisplayValue() {
        return displayValue;
    }
}
