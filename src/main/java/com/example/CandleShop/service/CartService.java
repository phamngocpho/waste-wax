package com.example.CandleShop.service;

import com.example.CandleShop.entity.*;
import com.example.CandleShop.repository.CartItemRepository;
import com.example.CandleShop.repository.CartRepository;
import com.example.CandleShop.repository.ProductImageRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class CartService {

    @Autowired
    private CartRepository cartRepository;

    @Autowired
    private CartItemRepository cartItemRepository;

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProductSizeService productSizeService;

    @Autowired
    private ProductImageRepository productImageRepository;

    @Transactional
    public void addToCart(Long userId, Long productId, Long sizeId, Integer quantity) {
        // Tìm hoặc tạo giỏ hàng cho user
        Cart cart = cartRepository.findByUserId(userId);
        if (cart == null) {
            cart = new Cart();
            cart.setUser(userService.findById(userId));
            cart.setCreatedAt(new Date());
            cart = cartRepository.save(cart);
        }

        // Kiểm tra sản phẩm và size tồn tại
        Product product = productService.getProductById(productId);
        Optional<ProductSize> size = productSizeService.getById(sizeId);

        // Kiểm tra số lượng tồn kho
        if (size.get().getStockQuantity() < quantity) {
            throw new RuntimeException("Số lượng sản phẩm trong kho không đủ");
        }

        // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
        CartItem existingItem = cartItemRepository.findByCartIdAndProductIdAndProductSizeId(
                cart.getId(), productId, sizeId);

        if (existingItem != null) {
            // Nếu đã có, cập nhật số lượng
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
            cartItemRepository.save(existingItem);
        } else {
            // Nếu chưa có, tạo mới cart item
            CartItem cartItem = new CartItem();
            cartItem.setCart(cart);
            cartItem.setProduct(product);
            cartItem.setProductSize(size.orElse(null));
            cartItem.setQuantity(quantity);
            cartItemRepository.save(cartItem);
        }
        // Cập nhật thời gian cập nhật giỏ hàng
        cart.setUpdatedAt(new Date());
        cartRepository.save(cart);
    }

    // Thêm dependency injection cho ProductImageRepository


    public List<CartItem> getCartItems(Long userId) {
        Cart cart = cartRepository.findByUserId(userId);
        if (cart == null) {
            return new ArrayList<>();
        }

        List<CartItem> cartItems = cartItemRepository.findByCartId(cart.getId());

        // Đảm bảo images được load cho mỗi sản phẩm
        for (CartItem item : cartItems) {
            Product product = item.getProduct();
            List<ProductImage> images = productImageRepository.findByProductId(product.getId());
            product.setImages(images);
        }

        return cartItems;
    }
    public void removeCartItems(List<Long> cartItemIds) {
        cartItemIds.forEach(id -> cartItemRepository.deleteById(id));
    }
    public List<CartItem> getCartItemsByIds(List<Long> ids) {
        // Sử dụng join fetch để lấy images cùng với product
        return cartItemRepository.findCartItemsWithProductAndImages(ids);
    }

    @Transactional
    public void updateCartItemQuantity(Long itemId, Integer quantity) {
        if (quantity < 1) {
            // Nếu số lượng < 1, xóa item khỏi giỏ hàng
            cartItemRepository.deleteById(itemId);
        } else {
            // Cập nhật số lượng
            CartItem cartItem = cartItemRepository.findById(itemId).orElse(null);
            if (cartItem != null) {
                cartItem.setQuantity(quantity);
                cartItemRepository.save(cartItem);
            }
        }
    }
}

