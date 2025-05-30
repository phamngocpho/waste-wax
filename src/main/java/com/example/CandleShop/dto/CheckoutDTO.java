package com.example.CandleShop.dto;

import com.example.CandleShop.entity.CartItem;
import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.ProductSize;
import java.math.BigDecimal;

public class CheckoutDTO {
    private Long id;
    private Product product;
    private ProductSize productSize;  // Thêm trường này
    private Long productId;
    private Long productSizeId;
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal total;

    private BigDecimal subTotal; // Tổng tiền trước khi áp voucher
    private BigDecimal discount; // Số tiền giảm giá
    private BigDecimal finalTotal; // Tổng tiền sau khi áp voucher
    private String voucherCode; // Mã voucher đã áp dụng

    // Constructor
    public CheckoutDTO() {}

    public CheckoutDTO(CartItem cartItem) {
        this.id = cartItem.getId();
        this.product = cartItem.getProduct();
        this.productSize = cartItem.getProductSize();
        this.quantity = cartItem.getQuantity();
        this.price = cartItem.getProductSize() != null ?
                cartItem.getProductSize().getPrice() : BigDecimal.ZERO;
        this.total = this.price.multiply(new BigDecimal(this.quantity));
    }
    // Trong CheckoutDTO.java
    public void setVoucherInfo(BigDecimal subTotal, BigDecimal discount, String voucherCode) {
        this.subTotal = subTotal;
        this.discount = discount;
        this.voucherCode = voucherCode;
        this.finalTotal = subTotal.subtract(discount);
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }
    public Long getProductSizeId() {
        return productSizeId;
    }

    public void setProductSizeId(Long productSizeId) {
        this.productSizeId = productSizeId;
    }
    public void setId(Long id) {
        this.id = id;
    }
    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public ProductSize getProductSize() {
        return productSize;
    }

    public void setProductSize(ProductSize productSize) {
        this.productSize = productSize;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getTotal() {
        return total;
    }

    public void setTotal(BigDecimal total) {
        this.total = total;
    }
    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }

    public BigDecimal getDiscount() {
        return discount != null ? discount : BigDecimal.ZERO;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public BigDecimal getFinalTotal() {
        return finalTotal;
    }

    public void setFinalTotal(BigDecimal finalTotal) {
        this.finalTotal = finalTotal;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }
}
