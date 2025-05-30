package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.OilExchange;
import com.example.CandleShop.entity.User;
import com.example.CandleShop.service.OilExchangeService;
import com.example.CandleShop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/oil_exchange")
public class OilExchangeController {

    @Autowired
    private OilExchangeService oilExchangeService;

    @Autowired
    private UserService userService;

    // Hiển thị trang chính của chức năng trao đổi dầu
    @GetMapping
    public String showOilExchangePage(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            User user = userService.getUserById(userId);

            List<OilExchange> userExchanges = oilExchangeService.getUserExchanges(user);

            model.addAttribute("user", user);
            model.addAttribute("exchanges", userExchanges);
            model.addAttribute("newExchange", new OilExchange());

            return "user/oil_exchange";
        } catch (Exception e) {
            return "redirect:/login";
        }
    }

    // Xử lý gửi yêu cầu trao đổi dầu mới
    @PostMapping("/create")
    public String submitExchangeRequest(
            @ModelAttribute("newExchange") OilExchange exchange,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            oilExchangeService.createExchange(exchange, userId);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Yêu cầu trao đổi dầu của bạn đã được gửi thành công! Chúng tôi sẽ liên hệ với bạn sớm.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/oil_exchange";
    }

    // Hủy yêu cầu trao đổi dầu
    @PostMapping("/cancel/{id}")
    public String cancelExchange(
            @PathVariable Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        try {
            OilExchange exchange = oilExchangeService.getExchangeById(id);

            // Kiểm tra quyền truy cập
            if (!exchange.getUser().getId().equals(userId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền hủy yêu cầu này");
                return "redirect:/oil_exchange";
            }

            oilExchangeService.cancelExchange(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã hủy yêu cầu trao đổi dầu thành công");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/oil_exchange";
    }

    // Xem chi tiết yêu cầu
    @GetMapping("/{id}")
    public String viewExchangeDetails(
            @PathVariable Long id,
            Model model,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        try {
            OilExchange exchange = oilExchangeService.getExchangeById(id);

            // Kiểm tra quyền truy cập
            if (!exchange.getUser().getId().equals(userId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Bạn không có quyền xem yêu cầu này");
                return "redirect:/oil_exchange";
            }
            model.addAttribute("exchange", exchange);
            return "user/oil_exchange_detail";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/oil_exchange";
        }
    }
}
