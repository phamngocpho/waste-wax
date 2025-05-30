package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.*;
import com.example.CandleShop.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping("/add")
    public String addToCart(
            @RequestParam Long productId,
            @RequestParam Long sizeId,
            @RequestParam Integer quantity,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            // Lấy userId từ session
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập để thêm vào giỏ hàng");
                return "redirect:/login";
            }

            cartService.addToCart(userId, productId, sizeId, quantity);
            redirectAttributes.addFlashAttribute("success", "Đã thêm sản phẩm vào giỏ hàng");
            return "redirect:/cart";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/product/" + productId;
        }
    }

    @GetMapping
    public String viewCart(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        List<CartItem> cartItems = cartService.getCartItems(user.getId());
        model.addAttribute("cartItems", cartItems);
        return "user/cart";
    }

    @PostMapping("/cart/update")
    @ResponseBody
    public Map<String, Object> updateCartItem(@RequestParam Long itemId,
                                              @RequestParam int quantity,
                                              HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            cartService.updateCartItemQuantity(itemId, quantity);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }
    @GetMapping("/remove/{itemId}")
    public String removeFromCart(@PathVariable Long itemId,
                                 RedirectAttributes redirectAttributes) {
        try {
            cartService.removeCartItems(Collections.singletonList(itemId));
            redirectAttributes.addFlashAttribute("success", "Đã xóa sản phẩm khỏi giỏ hàng");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa sản phẩm");
        }
        return "redirect:/cart";
    }

}
