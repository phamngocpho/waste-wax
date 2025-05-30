package com.example.CandleShop.enums;

public enum Role {
    ADMIN("Quản trị viên"),
    USER("Người dùng");

    private final String displayValue;

    Role(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getDisplayValue() {
        return displayValue;
    }
}
