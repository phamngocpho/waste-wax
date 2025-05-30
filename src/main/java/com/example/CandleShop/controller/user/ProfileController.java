package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.User;
import com.example.CandleShop.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class ProfileController {

    @Autowired
    private UserService userService;

    @GetMapping("/profile")
    public String showProfilePage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // Lấy thông tin user từ database để đảm bảo dữ liệu mới nhất
        User currentUser = userService.getUserById(user.getId());
        model.addAttribute("user", currentUser);
        return "user/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(
            @ModelAttribute User updatedUser,
            @RequestParam(required = false) Boolean changePassword,
            @RequestParam(required = false) String newPassword,
            @RequestParam(required = false) String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Kiểm tra mật khẩu mới nếu người dùng muốn thay đổi
            if (Boolean.TRUE.equals(changePassword)) {
                if (newPassword == null || newPassword.isEmpty()) {
                    redirectAttributes.addFlashAttribute("error", "Mật khẩu mới không được để trống");
                    return "redirect:/profile";
                }

                if (!newPassword.equals(confirmPassword)) {
                    redirectAttributes.addFlashAttribute("error", "Mật khẩu xác nhận không khớp");
                    return "redirect:/profile";
                }
            }

            // Giữ nguyên role và points từ user hiện tại
            updatedUser.setId(currentUser.getId());
            updatedUser.setRole(currentUser.getRole());
            updatedUser.setPoints(currentUser.getPoints());
            updatedUser.setStatus(currentUser.getStatus());

            // Cập nhật thông tin người dùng
            userService.updateUser(currentUser.getId(), updatedUser, changePassword, newPassword);

            // Cập nhật session với thông tin mới
            User refreshedUser = userService.getUserById(currentUser.getId());
            session.setAttribute("user", refreshedUser);

            redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin thành công");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile";
    }
}
