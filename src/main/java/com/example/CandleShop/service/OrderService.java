package com.example.CandleShop.service;

import com.example.CandleShop.dto.CheckoutDTO;
import com.example.CandleShop.entity.Order;
import com.example.CandleShop.entity.OrderItem;
import com.example.CandleShop.enums.OrderStatus;
import com.example.CandleShop.enums.PaymentStatus;
import com.example.CandleShop.repository.OrderItemRepository;
import com.example.CandleShop.repository.OrderRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;

    public OrderService(OrderRepository orderRepository, OrderItemRepository orderItemRepository) {
        this.orderRepository = orderRepository;
        this.orderItemRepository = orderItemRepository;
    }

    public List<Order> getOrdersByUserId(Long userId) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public Page<Order> getOrdersByFilters(
            OrderStatus status, LocalDateTime fromDate, LocalDateTime toDate,
            int page, int size) {
        return orderRepository.findByFilters(
                status, fromDate, toDate, PageRequest.of(page, size));
    }

    public Order getOrderById(Long id) {
        return orderRepository.findById(id).orElse(null);
    }

    @Transactional
    public void deleteOrder(Long id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy đơn hàng"));

        orderItemRepository.deleteByOrderId(id);
        orderRepository.delete(order);
    }

    public Order save(Order order) {
        return orderRepository.save(order);
    }

    @Transactional
    public Order createOrder(Order order, List<CheckoutDTO> checkoutItems) {
        if (order.getShippingName() == null && order.getUser() != null) {
            // Lấy thông tin từ người dùng
            order.setShippingName(order.getUser().getFullName());
        }

        if (order.getShippingPhone() == null && order.getUser() != null) {
            order.setShippingPhone(order.getUser().getPhone());
        }

        // Kiểm tra từng trường một cách chi tiết
        if (order.getShippingName() == null || order.getShippingName().trim().isEmpty()) {
            throw new IllegalArgumentException("Tên người nhận không được để trống");
        }

        if (order.getShippingPhone() == null || order.getShippingPhone().trim().isEmpty()) {
            throw new IllegalArgumentException("Số điện thoại người nhận không được để trống");
        }

        if (order.getShippingAddress() == null || order.getShippingAddress().trim().isEmpty()) {
            throw new IllegalArgumentException("Địa chỉ giao hàng không được để trống");
        }

        // Tạo mã đơn hàng
        String orderNumber = generateOrderNumber();
        order.setOrderNumber(orderNumber);

        // Lưu đơn hàng
        Order savedOrder = orderRepository.save(order);

        // Tạo các mục đơn hàng
        for (CheckoutDTO checkoutDTO : checkoutItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(savedOrder);
            orderItem.setProduct(checkoutDTO.getProduct());
            orderItem.setProductSize(checkoutDTO.getProductSize());
            orderItem.setQuantity(checkoutDTO.getQuantity());
            orderItem.setUnitPrice(checkoutDTO.getPrice());
            orderItem.setSubtotal(checkoutDTO.getTotal());

            orderItemRepository.save(orderItem);
        }

        return savedOrder;
    }


    private String generateOrderNumber() {
        String dateStr = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomStr = String.format("%05d", new java.util.Random().nextInt(100000));
        return "ORD-" + dateStr + "-" + randomStr;
    }

    // Hủy đơn hàng
    @Transactional
    public boolean cancelOrder(Long orderId, Long userId) {
        Order order = orderRepository.findById(orderId).orElse(null);
        if (order != null && order.getUser().getId().equals(userId) && order.getOrderStatus() == OrderStatus.PENDING) {
            order.setOrderStatus(OrderStatus.CANCELLED);
            orderRepository.save(order);
            return true;
        }
        return false;
    }


}
