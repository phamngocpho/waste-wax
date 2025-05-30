package com.example.CandleShop.service;

import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.User;
import com.example.CandleShop.entity.WishlistItem;
import com.example.CandleShop.repository.ProductRepository;
import com.example.CandleShop.repository.UserRepository;
import com.example.CandleShop.repository.WishlistRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class WishlistService {

    @Autowired
    private WishlistRepository wishlistRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private UserRepository userRepository;

    public List<WishlistItem> getWishlistByUserId(Long userId) {
        return wishlistRepository.findByUserId(userId);
    }

    @Transactional
    public WishlistItem addToWishlist(Long userId, Long productId) {
        // Kiểm tra xem sản phẩm đã có trong wishlist chưa
        if (wishlistRepository.existsByUserIdAndProductId(userId, productId)) {
            return null; // Đã tồn tại trong wishlist
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + userId));

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + productId));

        WishlistItem wishlistItem = new WishlistItem(user, product);
        return wishlistRepository.save(wishlistItem);
    }

    @Transactional
    public void removeFromWishlist(Long userId, Long productId) {
        wishlistRepository.deleteByUserIdAndProductId(userId, productId);
    }
}