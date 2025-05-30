package com.example.CandleShop.enums;

public enum OrderStatus {
    PENDING("Chờ xác nhận"),
    CONFIRMED("Đã xác nhận"),
    SHIPPING("Đang giao hàng"),
    DELIVERED("Đã giao hàng"),
    CANCELLED("Đã hủy"),
    RETURNED("Đã hoàn trả");
    private final String vietnameseName;

    OrderStatus(String displayName) {
        this.vietnameseName = displayName;
    }

    public String getVietnameseName() {
        return vietnameseName;
    }
}
