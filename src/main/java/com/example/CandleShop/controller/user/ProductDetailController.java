package com.example.CandleShop.controller.user;

import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.ProductImage;
import com.example.CandleShop.entity.ProductSize;
import com.example.CandleShop.service.ProductImageService;
import com.example.CandleShop.service.ProductService;
import com.example.CandleShop.service.ProductSizeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import java.util.List;
import java.util.Optional;

@Controller
public class ProductDetailController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductImageService productImageService;

    @Autowired
    private ProductSizeService productSizeService;

    @GetMapping("/product/{id}")
    public String showProductDetail(@PathVariable("id") Long id, Model model) {
        Optional<Product> productOptional = Optional.ofNullable(productService.getProductById(id));

        if (productOptional.isPresent()) {
            Product product = productOptional.get();
            List<ProductImage> images = productImageService.getImagesByProductId(id);
            List<ProductSize> sizes = productSizeService.getSizesByProductId(id);
            List<Product> favoriteProducts = productService.getFavoriteProducts();

            model.addAttribute("product", product);
            model.addAttribute("images", images);
            model.addAttribute("sizes", sizes);
            model.addAttribute("favoriteProducts", favoriteProducts);
            model.addAttribute("productImageService", productImageService);

            return "user/detailProduct";
        } else {
            return "redirect:/shop";
        }
    }
    @PostMapping("/{id}/buy-now")
    public String buyNow(@PathVariable Long id) {
        return "redirect:/checkout";
    }
}
