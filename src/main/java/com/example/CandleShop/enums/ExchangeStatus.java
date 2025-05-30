package com.example.CandleShop.enums;

public enum ExchangeStatus {
    PENDING("Waiting for confirmation"),
    APPROVED("Approved"),
    COLLECTED("Collected"),
    COMPLETED("Completed"),
    CANCELLED("Cancelled"),
    REJECTED("Rejected");

    private final String displayValue;

    ExchangeStatus(String displayValue) {
        this.displayValue = displayValue;
    }

    public String getDisplayValue() {
        return displayValue;
    }
}
