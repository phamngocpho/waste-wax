package com.example.CandleShop.dto;

import java.io.Serial;
import java.io.Serializable;

public class OrderDTO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private String shippingName;
    private String shippingAddress;
    private String shippingPhone;
    private Long paymentMethodId;

    public OrderDTO() {
    }

    public OrderDTO(String shippingName, String shippingAddress, String shippingPhone, Long paymentMethodId) {
        this.shippingName = shippingName;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.paymentMethodId = paymentMethodId;
    }

    public String getShippingName() {
        return shippingName;
    }

    public void setShippingName(String shippingName) {
        this.shippingName = shippingName;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getShippingPhone() {
        return shippingPhone;
    }

    public void setShippingPhone(String shippingPhone) {
        this.shippingPhone = shippingPhone;
    }

    public Long getPaymentMethodId() {
        return paymentMethodId;
    }

    public void setPaymentMethodId(Long paymentMethodId) {
        this.paymentMethodId = paymentMethodId;
    }
}
