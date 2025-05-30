package com.example.CandleShop.entity;

import com.example.CandleShop.enums.ExchangeStatus;
import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "oil_exchanges")
public class OilExchange {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String exchangeNumber;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private Double oilAmount;
    private Integer pointsEarned;
    private String pickupAddress;
    private String pickupPhone;
    private String pickupName;

    @Enumerated(EnumType.STRING)
    private ExchangeStatus status;

    private LocalDateTime scheduledPickupDate;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    // Constructors
    public OilExchange() {
    }
    // Getters and Setters
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
    }

    public String getExchangeNumber() {
        return exchangeNumber;
    }

    public void setExchangeNumber(String exchangeNumber) {
        this.exchangeNumber = exchangeNumber;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Double getOilAmount() {
        return oilAmount;
    }

    public void setOilAmount(Double oilAmount) {
        this.oilAmount = oilAmount;
    }

    public Integer getPointsEarned() {
        return pointsEarned;
    }

    public void setPointsEarned(Integer pointsEarned) {
        this.pointsEarned = pointsEarned;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getPickupPhone() {
        return pickupPhone;
    }

    public void setPickupPhone(String pickupPhone) {
        this.pickupPhone = pickupPhone;
    }

    public String getPickupName() {
        return pickupName;
    }

    public void setPickupName(String pickupName) {
        this.pickupName = pickupName;
    }

    public ExchangeStatus getStatus() {
        return status;
    }

    public void setStatus(ExchangeStatus status) {
        this.status = status;
    }

    public LocalDateTime getScheduledPickupDate() {
        return scheduledPickupDate;
    }

    public void setScheduledPickupDate(LocalDateTime scheduledPickupDate) {
        this.scheduledPickupDate = scheduledPickupDate;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }
}
