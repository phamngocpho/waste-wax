package com.example.CandleShop.controller.admin;


import com.example.CandleShop.entity.OilExchange;
import com.example.CandleShop.service.OilExchangeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/admin/oil_exchanges")
public class AdminOilExchangeController {

    @Autowired
    private OilExchangeService oilExchangeService;

    // Hiển thị danh sách tất cả các yêu cầu trao đổi dầu
    @GetMapping
    public String listAllExchanges(Model model) {
        List<OilExchange> pendingExchanges = oilExchangeService.getPendingExchanges();
        List<OilExchange> approvedExchanges = oilExchangeService.getApprovedExchanges();
        List<OilExchange> completedExchanges = oilExchangeService.getCompletedExchanges();

        model.addAttribute("pendingExchanges", pendingExchanges);
        model.addAttribute("approvedExchanges", approvedExchanges);
        model.addAttribute("completedExchanges", completedExchanges);

        return "admin/oil_exchanges/list_exchanges";
    }

    // Xem chi tiết yêu cầu trao đổi dầu
    @GetMapping("/{id}")
    public String viewExchangeDetails(@PathVariable Long id, Model model) {
        try {
            OilExchange exchange = oilExchangeService.getExchangeById(id);
            model.addAttribute("exchange", exchange);
            return "admin/oil_exchanges/detail_exchange";
        } catch (Exception e) {
            return "redirect:/admin/oil_exchanges";
        }
    }

    // Phê duyệt yêu cầu trao đổi dầu
    @PostMapping("/{id}/approve")
    public String approveExchange(
            @PathVariable Long id,
            @RequestParam("pickupDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime pickupDate,
            RedirectAttributes redirectAttributes) {

        try {
            oilExchangeService.approveExchange(id, pickupDate);
            redirectAttributes.addFlashAttribute("successMessage", "Đã phê duyệt yêu cầu trao đổi dầu thành công");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/admin/oil_exchanges";
    }

    // Từ chối yêu cầu trao đổi dầu
    @PostMapping("/{id}/reject")
    public String rejectExchange(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {

        try {
            oilExchangeService.rejectExchange(id);
            redirectAttributes.addFlashAttribute("successMessage", "Đã từ chối yêu cầu trao đổi dầu");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/admin/oil_exchanges";
    }

    // Hoàn thành yêu cầu trao đổi dầu và cộng điểm
    @PostMapping("/{id}/complete")
    public String completeExchange(
            @PathVariable Long id,
            RedirectAttributes redirectAttributes) {

        try {
            oilExchangeService.completeExchange(id);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Đã hoàn thành yêu cầu trao đổi dầu và cộng điểm cho người dùng");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/admin/oil_exchanges";
    }
}

