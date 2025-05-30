package com.example.CandleShop.controller.admin;


import com.example.CandleShop.entity.Category;
import com.example.CandleShop.entity.Product;
import com.example.CandleShop.entity.ProductImage;
import com.example.CandleShop.entity.ProductSize;
import com.example.CandleShop.service.CategoryService;
import com.example.CandleShop.service.ProductImageService;
import com.example.CandleShop.service.ProductService;
import com.example.CandleShop.service.ProductSizeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private ProductImageService productImageService;

    @Autowired
    private ProductSizeService productSizeService;

    @GetMapping
    public String listProducts(Model model) {
        List<Product> products = productService.getAllProductActives();
        model.addAttribute("products", products);
        return "admin/products/listProduct";
    }

    // Hiển thị form thêm sản phẩm mới
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "admin/products/addProduct";
    }

    // Xử lý thêm sản phẩm mới
    @PostMapping("/create")
    public String createProduct(@RequestParam("name") String name,
                                @RequestParam("description") String description,
                                @RequestParam("categoryId") Long categoryId,
                                @RequestParam("basePrice") BigDecimal basePrice,
                                @RequestParam("stockQuantity") Integer stockQuantity,
                                @RequestParam(value = "status", defaultValue = "ACTIVE") String status,
                                @RequestParam(value = "sizeValues", required = false) List<String> sizeValues,
                                @RequestParam(value = "isFeatured", required = false) Boolean isFeatured,
                                @RequestParam(value = "sizePrices", required = false) List<BigDecimal> sizePrices,
                                @RequestParam(value = "sizeStockQuantities", required = false) List<Integer> sizeStockQuantities,
                                @RequestParam(value = "images", required = false) List<MultipartFile> images,
                                @RequestParam(value = "primaryImageIndex", required = false, defaultValue = "0") Integer primaryImageIndex,
                                RedirectAttributes redirectAttributes) {
        try {
            // Tạo đối tượng sản phẩm
            Product product = new Product();
            product.setName(name);
            product.setDescription(description);
            product.setFeatured(isFeatured != null);
            // Lấy category
            Optional<Category> category = categoryService.getCategoryById(categoryId);
            product.setCategory(category.orElse(null));

            product.setBasePrice(basePrice);
            product.setStockQuantity(stockQuantity);
            product.setStatus(status);
            product.setCreatedAt(new Date());

            // Lưu sản phẩm trước để có ID
            product = productService.saveProduct(product);

            // Kiểm tra xem sản phẩm đã được lưu thành công chưa
            if (product.getId() == null) {
                throw new RuntimeException("Không thể lưu sản phẩm. Vui lòng thử lại.");
            }

            // Thêm log để kiểm tra ID sản phẩm
            System.out.println("Đã lưu sản phẩm với ID: " + product.getId());

            // Xử lý kích thước và giá (nếu có)
            if (sizeValues != null && !sizeValues.isEmpty()) {
                for (int i = 0; i < sizeValues.size(); i++) {
                    if (sizeValues.get(i) != null && !sizeValues.get(i).isEmpty()) {
                        ProductSize size = new ProductSize();

                        // Thiết lập product_id
                        size.setProduct(product);

                        // Thiết lập size_value
                        size.setSizeValue(sizeValues.get(i));

                        // Thiết lập price
                        if (sizePrices != null && i < sizePrices.size()) {
                            size.setPrice(sizePrices.get(i));
                        } else {
                            size.setPrice(basePrice);
                        }

                        // Thiết lập stockQuantity
                        if (sizeStockQuantities != null && i < sizeStockQuantities.size()) {
                            size.setStockQuantity(sizeStockQuantities.get(i));
                        } else {
                            size.setStockQuantity(stockQuantity / Math.max(1, sizeValues.size()));
                        }

                        // Thêm log để kiểm tra dữ liệu
                        System.out.println("Thêm kích thước: " + size.getSizeValue() +
                                ", Giá: " + size.getPrice() +
                                ", Số lượng: " + size.getStockQuantity() +
                                ", Product ID: " + product.getId());

                        productSizeService.saveProductSize(size);
                    }
                }
            }

            // Xử lý hình ảnh (nếu có)
            if (images != null && !images.isEmpty()) {
                int index = 0;
                for (MultipartFile image : images) {
                    if (!image.isEmpty()) {
                        // Lưu file và lấy tên file
                        String fileName = productImageService.saveImage(image);

                        // Tạo đối tượng ProductImage
                        ProductImage productImage = new ProductImage();
                        productImage.setProduct(product);
                        productImage.setImageUrl(fileName);
                        productImage.setPrimary(index == primaryImageIndex);

                        // Lưu vào database
                        productImageService.saveProductImage(productImage);
                        index++;
                    }
                }
            }

            redirectAttributes.addFlashAttribute("success", "Thêm sản phẩm thành công!");
            return "redirect:/admin/products";
        } catch (Exception e) {
            e.printStackTrace(); // In stack trace để debug
            redirectAttributes.addFlashAttribute("error", "Lỗi khi thêm sản phẩm: " + e.getMessage());
            return "redirect:/admin/products/create";
        }
    }


    // Hiển thị form chỉnh sửa sản phẩm
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id);
        List<Category> categories = categoryService.getAllCategories();
        List<ProductImage> images = productImageService.getImagesByProductId(id);
        List<ProductSize> sizes = productSizeService.getSizesByProductId(id);

        model.addAttribute("product", product);
        model.addAttribute("categories", categories);
        model.addAttribute("productImages", images);
        model.addAttribute("productSizes", sizes);

        return "admin/products/editProduct";
    }

    // Xử lý cập nhật sản phẩm
    @PostMapping("/edit/{id}")
    public String updateProduct(
            @PathVariable Long id,
            @RequestParam String name,
            @RequestParam String description,
            @RequestParam Long categoryId,
            @RequestParam BigDecimal basePrice,
            @RequestParam(required = false, defaultValue = "0") BigDecimal discountPercentage,
            @RequestParam(required = false, defaultValue = "0") Integer stockQuantity,
            @RequestParam(required = false) String scentType,
            @RequestParam(required = false, defaultValue = "false") Boolean isFeatured,
            @RequestParam(required = false, defaultValue = "ACTIVE") String status,
            @RequestParam(required = false) List<MultipartFile> newImages,
            @RequestParam(required = false) List<Long> deleteImageIds,
            @RequestParam(required = false) Long primaryImageId,
            @RequestParam(required = false) List<Long> existingSizeIds,
            @RequestParam(required = false) List<String> existingSizeValues,
            @RequestParam(required = false) List<BigDecimal> existingSizePrices,
            @RequestParam(required = false) List<Integer> existingSizeStocks,
            @RequestParam(required = false) List<String> newSizeValues,
            @RequestParam(required = false) List<BigDecimal> newSizePrices,
            @RequestParam(required = false) List<Integer> newSizeStocks,
            @RequestParam(required = false) List<Long> deleteSizeIds,
            RedirectAttributes redirectAttributes) {

        try {
            // Cập nhật thông tin cơ bản của sản phẩm
            Product existingProduct = productService.getProductById(id);
            existingProduct.setName(name);
            existingProduct.setDescription(description);
            existingProduct.setBasePrice(basePrice);
            existingProduct.setDiscountPercentage(discountPercentage);
            existingProduct.setStockQuantity(stockQuantity);
            existingProduct.setScentType(scentType);
            existingProduct.setFeatured(isFeatured);
            existingProduct.setStatus(status);

            // Cập nhật danh mục
            Optional<Category> category = categoryService.getCategoryById(categoryId);
            existingProduct.setCategory(category.orElse(null));

            // Lưu sản phẩm đã cập nhật
            productService.saveProduct(existingProduct);

            // Xử lý cập nhật ảnh chính
            if (primaryImageId != null) {
                // Đặt tất cả ảnh về không phải ảnh chính
                List<ProductImage> allImages = productImageService.getImagesByProductId(id);
                for (ProductImage img : allImages) {
                    img.setPrimary(false);
                    productImageService.saveProductImage(img);
                }

                // Đặt ảnh được chọn làm ảnh chính
                ProductImage primaryImage = productImageService.getProductImageById(primaryImageId);
                primaryImage.setPrimary(true);
                productImageService.saveProductImage(primaryImage);
            }

            // Xóa hình ảnh nếu có
            if (deleteImageIds != null && !deleteImageIds.isEmpty()) {
                for (Long imageId : deleteImageIds) {
                    productImageService.deleteProductImage(imageId);
                }
            }

            // Thêm hình ảnh mới nếu có
            if (newImages != null && !newImages.isEmpty()) {
                for (MultipartFile imageFile : newImages) {
                    if (!imageFile.isEmpty()) {
                        ProductImage productImage = new ProductImage();
                        productImage.setProduct(existingProduct);
                        productImage.setImageUrl(productImageService.saveImage(imageFile));
                        productImage.setPrimary(false); // Mặc định không phải ảnh chính
                        productImageService.saveProductImage(productImage);
                    }
                }
            }

            // Cập nhật kích thước sản phẩm hiện có
            if (existingSizeIds != null && !existingSizeIds.isEmpty()) {
                for (int i = 0; i < existingSizeIds.size(); i++) {
                    // Bỏ qua nếu kích thước này được đánh dấu xóa
                    if (deleteSizeIds != null && deleteSizeIds.contains(existingSizeIds.get(i))) {
                        continue;
                    }

                    ProductSize size = productSizeService.getProductSizeById(existingSizeIds.get(i));
                    if (existingSizeValues != null && i < existingSizeValues.size()) {
                        size.setSizeValue(existingSizeValues.get(i));
                    }
                    if (existingSizePrices != null && i < existingSizePrices.size()) {
                        size.setPrice(existingSizePrices.get(i));
                    }
                    if (existingSizeStocks != null && i < existingSizeStocks.size()) {
                        size.setStockQuantity(existingSizeStocks.get(i));
                    }
                    productSizeService.saveProductSize(size);
                }
            }

            // Thêm kích thước mới nếu có
            if (newSizeValues != null && !newSizeValues.isEmpty()) {
                for (int i = 0; i < newSizeValues.size(); i++) {
                    if (newSizeValues.get(i) != null && !newSizeValues.get(i).isEmpty()) {
                        ProductSize newSize = new ProductSize();
                        newSize.setProduct(existingProduct);
                        newSize.setSizeValue(newSizeValues.get(i));

                        if (newSizePrices != null && i < newSizePrices.size()) {
                            newSize.setPrice(newSizePrices.get(i));
                        } else {
                            newSize.setPrice(basePrice);
                        }

                        if (newSizeStocks != null && i < newSizeStocks.size()) {
                            newSize.setStockQuantity(newSizeStocks.get(i));
                        } else {
                            newSize.setStockQuantity(0);
                        }

                        productSizeService.saveProductSize(newSize);
                    }
                }
            }

            // Xóa kích thước nếu có
            if (deleteSizeIds != null && !deleteSizeIds.isEmpty()) {
                for (Long sizeId : deleteSizeIds) {
                    productSizeService.deleteProductSize(sizeId);
                }
            }

            redirectAttributes.addFlashAttribute("success", "Cập nhật sản phẩm thành công!");
            return "redirect:/admin/products";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Lỗi khi cập nhật sản phẩm: " + e.getMessage());
            return "redirect:/admin/products/edit/" + id;
        }
    }

    // Xem chi tiết sản phẩm
    @GetMapping("/view/{id}")
    public String viewProduct(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id);
        List<ProductImage> images = productImageService.getImagesByProductId(id);
        List<ProductSize> sizes = productSizeService.getSizesByProductId(id);

        model.addAttribute("product", product);
        model.addAttribute("productImages", images);
        model.addAttribute("productSizes", sizes);

        return "admin/products/view";
    }
    // Thay thế phương thức xóa sản phẩm hiện tại bằng phương thức xóa mềm
    @PostMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            productService.softDeleteProduct(id);
            redirectAttributes.addFlashAttribute("success", "Xóa sản phẩm thành công");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Lỗi khi xóa sản phẩm: " + e.getMessage());
        }
        return "redirect:/admin/products";
    }
}

