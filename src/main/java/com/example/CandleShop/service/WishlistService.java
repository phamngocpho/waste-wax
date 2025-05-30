package com.example.CandleShop.service;

import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.User;
import com.example.CandleShop.entity.WishlistItem;
import com.example.CandleShop.repository.ProductRepository;
import com.example.CandleShop.repository.UserRepository;
import com.example.CandleShop.repository.WishlistRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class WishlistService {

    private final WishlistRepository wishlistRepository;

    private final ProductRepository productRepository;

    private final UserRepository userRepository;

    public WishlistService(WishlistRepository wishlistRepository, ProductRepository productRepository, UserRepository userRepository) {
        this.wishlistRepository = wishlistRepository;
        this.productRepository = productRepository;
        this.userRepository = userRepository;
    }

    public List<WishlistItem> getWishlistByUserId(Long userId) {
        return wishlistRepository.findByUserId(userId);
    }

    @Transactional
    public void addToWishlist(Long userId, Long productId) {
        // Kiểm tra xem sản phẩm đã có trong wishlist chưa
        if (wishlistRepository.existsByUserIdAndProductId(userId, productId)) {
            return; // Đã tồn tại trong wishlist
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng với ID: " + userId));

        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + productId));

        WishlistItem wishlistItem = new WishlistItem(user, product);
        wishlistRepository.save(wishlistItem);
    }

    @Transactional
    public void removeFromWishlist(Long userId, Long productId) {
        wishlistRepository.deleteByUserIdAndProductId(userId, productId);
    }
}