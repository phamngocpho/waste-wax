package com.example.CandleShop.service;

import com.example.CandleShop.entity.ProductSize;
import com.example.CandleShop.repository.ProductSizeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProductSizeService {

    private final ProductSizeRepository productSizeRepository;

    public ProductSizeService(ProductSizeRepository productSizeRepository) {
        this.productSizeRepository = productSizeRepository;
    }

    public List<ProductSize> getSizesByProductId(Long productId) {
        return productSizeRepository.findByProductId(productId);
    }

    public ProductSize getProductSizeById(Long id) {
        return productSizeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy kích thước sản phẩm với ID: " + id));
    }

    public ProductSize saveProductSize(ProductSize productSize) {
        return productSizeRepository.save(productSize);
    }
    public List<ProductSize> getProductSizesByProductId(Long productId) {
        return productSizeRepository.findByProductIdAndDeletedFalse(productId);
    }
    public void deleteProductSize(Long id) {
        productSizeRepository.deleteById(id);
    }
    public Optional<ProductSize> getById(Long id) {
        return productSizeRepository.findById(id);
    }
    public void softDeleteProductSize(Long id) {
        ProductSize size = productSizeRepository.findById(id).orElse(null);
        if (size != null) {
            size.setDeleted(true);
            productSizeRepository.save(size);
        }
    }
}
