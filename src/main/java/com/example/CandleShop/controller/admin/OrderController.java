package com.example.CandleShop.controller.admin;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.enums.OrderStatus;
import com.example.CandleShop.enums.PaymentStatus;
import com.example.CandleShop.service.EmailService;
import com.example.CandleShop.service.OrderService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/admin/orders")
public class OrderController {
    @Autowired
    private OrderService orderService;
    private static final Logger logger = LoggerFactory.getLogger(OrderController.class);
    @Autowired
    private EmailService emailService;

    @GetMapping
    public String listOrders(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) OrderStatus status,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,
            Model model) {

        LocalDateTime fromDateTime = fromDate != null ? fromDate.atStartOfDay() : null;
        LocalDateTime toDateTime = toDate != null ? toDate.atTime(23, 59, 59) : null;

        Page<Order> orderPage = orderService.getOrdersByFilters(
                status, fromDateTime, toDateTime, page, size
        );

        model.addAttribute("orders", orderPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", orderPage.getTotalPages());
        model.addAttribute("orderStatuses", OrderStatus.values());
        model.addAttribute("selectedStatus", status);
        assert fromDate != null;
        model.addAttribute("fromDate", fromDate);
        assert toDate != null;
        model.addAttribute("toDate", toDate);

        return "admin/orders/list_orders";
    }

    @GetMapping("/{id}")
    public String viewOrderDetail(@PathVariable Long id, Model model) {
        Order order = orderService.getOrderById(id);
        if (order == null) {
            return "redirect:/admin/orders";
        }

        model.addAttribute("order", order);
        model.addAttribute("orderStatuses", OrderStatus.values());
        model.addAttribute("paymentStatuses", PaymentStatus.values());

        return "admin/orders/order_detail";
    }


    @PostMapping("/{id}/update-status")
    public String updateOrderStatus(@PathVariable Long id,
                                    @RequestParam OrderStatus orderStatus,
                                    @RequestParam PaymentStatus paymentStatus,
                                    RedirectAttributes redirectAttributes) {
        logger.info("Cập nhật trạng thái đơn hàng #{}: orderStatus={}, paymentStatus={}",
                id, orderStatus, paymentStatus);
        Order order = orderService.getOrderById(id);

        if (order != null) {
            // Lưu trạng thái cũ để so sánh
            OrderStatus oldStatus = order.getOrderStatus();

            // Cập nhật trạng thái
            order.setOrderStatus(orderStatus);
            order.setPaymentStatus(paymentStatus);
            orderService.save(order);

            logger.info("Đã cập nhật trạng thái đơn hàng #{} từ {} thành {}",
                    id, oldStatus, orderStatus);

            // Gửi email khi trạng thái là CONFIRMED
            if (orderStatus == OrderStatus.CONFIRMED) {
                logger.info("Đơn hàng #{} đã được xác nhận, chuẩn bị gửi email", id);
                emailService.sendOrderConfirmedEmail(order);
            }

            // Gửi email khi trạng thái là COMPLETED
            if (orderStatus == OrderStatus.DELIVERED) {
                logger.info("Đơn hàng #{} đã hoàn thành, chuẩn bị gửi email", id);
                emailService.sendOrderCompletedEmail(order);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
        } else {
            logger.error("Không tìm thấy đơn hàng với ID: {}", id);
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy đơn hàng!");
        }
        return "redirect:/admin/orders/" + id;
    }
}
