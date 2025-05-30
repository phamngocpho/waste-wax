package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.WishlistItem;
import com.example.CandleShop.service.WishlistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    @GetMapping
    public String wishlistPage(Model model, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        List<WishlistItem> wishlistItems = wishlistService.getWishlistByUserId(userId);
        model.addAttribute("wishlistItems", wishlistItems);

        return "user/wishlist";
    }

    @GetMapping("/add/{productId}")
    public String addToWishlist(@PathVariable Long productId, HttpSession session,
                                @RequestParam(required = false) String redirect) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        wishlistService.addToWishlist(userId, productId);

        // Nếu redirect=wishlist, chuyển đến trang wishlist
        if ("wishlist".equals(redirect)) {
            return "redirect:/wishlist";
        }

        // Mặc định trở về trang trước đó
        return "redirect:/shop";
    }

    @GetMapping("/remove/{productId}")
    public String removeFromWishlist(@PathVariable Long productId, HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        wishlistService.removeFromWishlist(userId, productId);
        return "redirect:/wishlist";
    }
}

