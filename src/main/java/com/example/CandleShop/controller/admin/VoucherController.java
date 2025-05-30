package com.example.CandleShop.controller.admin;

import com.example.CandleShop.entity.Voucher;
import com.example.CandleShop.service.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/vouchers")
public class VoucherController {

    @Autowired
    private VoucherService voucherService;

    @GetMapping
    public String listVouchers(Model model) {
        List<Voucher> vouchers = voucherService.getAllVouchers();
        model.addAttribute("vouchers", vouchers);
        return "admin/vouchers/listVoucher";
    }

    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("voucher", new Voucher());
        return "admin/vouchers/createVoucher";
    }

    @PostMapping("/create")
    public String createVoucher(@ModelAttribute Voucher voucher, RedirectAttributes redirectAttributes) {
        try {
            voucherService.saveVoucher(voucher);
            redirectAttributes.addFlashAttribute("successMessage", "Voucher created successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error creating voucher: " + e.getMessage());
        }
        return "redirect:/admin/vouchers";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Voucher voucher = voucherService.getVoucherById(id)
                    .orElseThrow(() -> new RuntimeException("Voucher not found"));
            model.addAttribute("voucher", voucher);
            return "admin/vouchers/editVoucher";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
            return "redirect:/admin/vouchers";
        }
    }

    @PostMapping("/edit/{id}")
    public String updateVoucher(@PathVariable Long id, @ModelAttribute Voucher voucher,
                                RedirectAttributes redirectAttributes) {
        try {
            voucher.setId(id);
            voucherService.saveVoucher(voucher);
            redirectAttributes.addFlashAttribute("successMessage", "Voucher updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating voucher: " + e.getMessage());
        }
        return "redirect:/admin/vouchers";
    }

    @GetMapping("/delete/{id}")
    public String deleteVoucher(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            voucherService.deleteVoucher(id);
            redirectAttributes.addFlashAttribute("successMessage", "Voucher deleted successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error deleting voucher: " + e.getMessage());
        }
        return "redirect:/admin/vouchers";
    }
}
