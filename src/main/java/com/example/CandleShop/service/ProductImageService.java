package com.example.CandleShop.service;

import com.example.CandleShop.entity.ProductImage;
import com.example.CandleShop.repository.ProductImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

@Service
public class ProductImageService {

    private final ProductImageRepository productImageRepository;

    @Value("${upload.path}")
    private String uploadPath;

    public ProductImageService(ProductImageRepository productImageRepository) {
        this.productImageRepository = productImageRepository;
    }

    public List<ProductImage> getImagesByProductId(Long productId) {
        return productImageRepository.findByProductId(productId);
    }

    public ProductImage getProductImageById(Long id) {
        return productImageRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy hình ảnh với ID: " + id));
    }

    public void saveProductImage(ProductImage productImage) {
        productImageRepository.save(productImage);
    }

    public String saveImage(MultipartFile file) throws IOException {
        // Tạo thư mục uploads nếu chưa tồn tại
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Tạo tên file duy nhất
        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();

        // Lưu file
        Path filePath = Paths.get(uploadPath, fileName);
        Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return fileName;
    }
    public void deleteProductImage(Long id) {
        ProductImage image = getProductImageById(id);

        // Nếu đây là ảnh chính và còn ảnh khác, đặt ảnh khác làm ảnh chính
        if (image.isPrimary()) {
            List<ProductImage> otherImages = productImageRepository.findByProductIdAndIdNot(image.getProduct().getId(), id);
            if (!otherImages.isEmpty()) {
                ProductImage newPrimaryImage = otherImages.get(0);
                newPrimaryImage.setPrimary(true);
                productImageRepository.save(newPrimaryImage);
            }
        }

        // Xóa file ảnh nếu cần
        try {
            Path filePath = Paths.get(uploadPath, image.getImageUrl());
            Files.deleteIfExists(filePath);
        } catch (IOException e) {
            // Log lỗi nhưng vẫn tiếp tục xóa record trong database
            System.err.println("Không thể xóa file ảnh: " + e.getMessage());
        }

        // Xóa record trong database
        productImageRepository.deleteById(id);
    }

}


