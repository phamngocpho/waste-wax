package com.example.CandleShop.service;

import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.ProductImage;
import com.example.CandleShop.entity.ProductSize;
import com.example.CandleShop.repository.ProductImageRepository;
import com.example.CandleShop.repository.ProductRepository;
import com.example.CandleShop.repository.ProductSizeRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ProductService {

    @Autowired
    private ProductRepository productRepository;
    @Autowired
    private ProductSizeRepository productSizeRepository;
    @Autowired
    private ProductImageRepository productImageRepository;

    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy sản phẩm với ID: " + id));
    }
    public Product saveProduct(Product product) {
        return productRepository.save(product);
    }

    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
    public List<Product> getAllActiveProducts() {
        return productRepository.findByStatus("ACTIVE");
    }

    public List<Product> getAllProductsWithImages() {
        List<Product> products = getAllActiveProducts();
        products.sort((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()));
        for (Product product : products) {
            if (product.getImages() != null) {
                product.getImages().size(); // Force initialization
            }
            if (product.getCategory() != null) {
                product.getCategory().getName(); // Force initialization
            }
        }
        return products;
    }
    public List<Product> getAllProductActives() {
        List<Product> products = productRepository.findAll();
        products.sort((p1, p2) -> p2.getCreatedAt().compareTo(p1.getCreatedAt()));
        for (Product product : products) {
            if (product.getImages() != null) {
                product.getImages().size(); // Force initialization
            }
            if (product.getCategory() != null) {
                product.getCategory().getName(); // Force initialization
            }
        }
        return products;
    }

    public List<Product> getFeaturedProducts() {
        return productRepository.findByIsFeaturedTrue();
    }
    public List<Product> getFeaturedProducts(int limit) {
        Pageable pageable = PageRequest.of(0, limit);
        return productRepository.findAll(pageable).getContent();
    }
    public List<Product> getFavoriteProducts() {
        return productRepository.findTop5ByIsFeaturedIsTrue();
    }
    public boolean existsByCategoryId(Long categoryId) {
        return productRepository.existsById(categoryId);
    }
    @Transactional
    public void softDeleteProduct(Long id) {
        Product product = getProductById(id);
        if (product != null) {
            // Đánh dấu sản phẩm là đã xóa
            product.setDeleted(true);
            product.setStatus("DELETED");
            productRepository.save(product);

            // Đánh dấu tất cả các kích thước sản phẩm là đã xóa
            List<ProductSize> sizes = productSizeRepository.findByProductId(id);
            for (ProductSize size : sizes) {
                size.setDeleted(true);
                productSizeRepository.save(size);
            }

            // Đánh dấu tất cả các hình ảnh sản phẩm là đã xóa
            List<ProductImage> images = productImageRepository.findByProductId(id);
            for (ProductImage image : images) {
                image.setDeleted(true);
                productImageRepository.save(image);
            }
        }
    }
}
