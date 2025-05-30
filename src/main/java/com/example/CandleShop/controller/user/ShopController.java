package com.example.CandleShop.controller.user;


import com.example.CandleShop.entity.Product;
import com.example.CandleShop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class ShopController {

    @Autowired
    private ProductService productService;

    @GetMapping("/shop")
    public String showShopPage(Model model) {
        List<Product> allProducts = productService.getAllProductsWithImages();
        List<Product> featuredProducts = productService.getFeaturedProducts(3);
        model.addAttribute("allProducts", allProducts);
        model.addAttribute("featuredProducts", featuredProducts);
        return "user/shop";
    }
}
