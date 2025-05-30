package com.example.CandleShop.dto;

import java.io.Serial;
import java.io.Serializable;

public class OrderDTO implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    private String shippingName;
    private String shippingAddress;
    private String shippingPhone;
    private String customerEmail;
    private Long paymentMethodId;

    public OrderDTO() {
    }

    public OrderDTO(String shippingName, String shippingAddress, String shippingPhone, String customerEmail, Long paymentMethodId) {
        this.shippingName = shippingName;
        this.shippingAddress = shippingAddress;
        this.shippingPhone = shippingPhone;
        this.customerEmail = customerEmail;
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

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public Long getPaymentMethodId() {
        return paymentMethodId;
    }

    public void setPaymentMethodId(Long paymentMethodId) {
        this.paymentMethodId = paymentMethodId;
    }
}
