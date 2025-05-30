package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.User;
import com.example.CandleShop.entity.UserVoucher;
import com.example.CandleShop.entity.Voucher;
import com.example.CandleShop.service.UserService;
import com.example.CandleShop.service.UserVoucherService;
import com.example.CandleShop.service.VoucherService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class VoucherUserController {

    @Autowired
    private VoucherService voucherService;

    @Autowired
    private UserVoucherService userVoucherService;

    @Autowired
    private UserService userService;

    @GetMapping("/gifts")
    public String showGiftPage(Model model, HttpSession session) {
        // Lấy danh sách voucher có sẵn
        List<Voucher> availableVouchers = voucherService.getAvailableVouchersForUser();
        model.addAttribute("availableVouchers", availableVouchers);

        // Nếu người dùng đã đăng nhập, lấy danh sách voucher của họ
        User user = (User) session.getAttribute("user");
        if (user != null) {
            List<UserVoucher> userVouchers = userVoucherService.getAvailableVouchersByUserId(user.getId());
            model.addAttribute("userVouchers", userVouchers);
        }

        return "user/gift";
    }

    @PostMapping("/redeem")
    @ResponseBody
    public Map<String, Object> redeemVoucher(@RequestParam(required=true) Long voucherId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        System.out.println("Received voucherId: " + voucherId); // Thêm log để debug

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("message", "Vui lòng đăng nhập để đổi voucher");
            return response;
        }
        try {
            // Gọi service để đổi voucher
            Map<String, Object> result = voucherService.redeemVoucher(user.getId(), voucherId);

            if ((boolean) result.get("success")) {
                // Cập nhật lại user trong session với số điểm mới
                User updatedUser = userService.getUserById(user.getId());
                session.setAttribute("user", updatedUser);

                response.put("success", true);
                response.put("message", result.get("message"));
                response.put("userPoints", updatedUser.getPoints());
            } else {
                response.put("success", false);
                response.put("message", result.get("message"));
            }
            return response;
        } catch (Exception e) {
            e.printStackTrace(); // Thêm log để debug
            response.put("success", false);
            response.put("message", e.getMessage());
            return response;
        }
    }
}
