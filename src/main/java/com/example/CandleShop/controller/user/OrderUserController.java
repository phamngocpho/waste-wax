package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/user/orders")
public class OrderUserController {

    @Autowired
    private OrderService orderService;
    // Hiển thị danh sách đơn hàng
    @GetMapping
    public String showUserOrders(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        List<Order> orders = orderService.getOrdersByUserId(userId);
        model.addAttribute("orders", orders);

        return "user/orders"; // Tên file JSP
    }

    // Hủy đơn hàng
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelOrder(@RequestParam("orderId") Long orderId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập.");
            return response;
        }

        boolean success = orderService.cancelOrder(orderId, userId);
        if (success) {
            response.put("success", true);
            response.put("message", "Đơn hàng đã được hủy thành công.");
        } else {
            response.put("success", false);
            response.put("message", "Không thể hủy đơn hàng.");
        }

        return response;
    }
}
