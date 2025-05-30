package com.example.CandleShop.controller.admin;

import com.example.CandleShop.entity.Category;
import com.example.CandleShop.service.CategoryService;
import com.example.CandleShop.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
@Controller
@RequestMapping("/admin/categories")
public class CategoryController {
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private ProductService productService;

    @GetMapping
    public String listCategory(Model model) {
        // Lấy tất cả danh mục
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        return "admin/categories/listCategories";
    }

    @PostMapping("/add")
    public String addCategory(@RequestParam String name,
                              RedirectAttributes redirectAttributes) {
        if(categoryService.isCategoryNameExists(name)){
            redirectAttributes.addFlashAttribute("errorMessage", "Tên danh mục đã tồn tại");
            return "redirect:/admin/categories";
        }

        Category category = new Category();
        category.setName(name);

        categoryService.saveCategory(category);
        redirectAttributes.addFlashAttribute("successMessage", "Thêm danh mục thành công");
        return "redirect:/admin/categories";
    }

    @PostMapping("/update")
    public String updateCategory(@RequestParam Long id,
                                 @RequestParam String name,
                                 RedirectAttributes redirectAttributes) {
        // Tìm danh mục cần cập nhật
        Category category = categoryService.getCategoryById(id)
                .orElse(null);

        if (category == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không tìm thấy danh mục");
            return "redirect:/admin/categories";
        }
        category.setName(name);

        categoryService.saveCategory(category);
        redirectAttributes.addFlashAttribute("successMessage", "Cập nhật danh mục thành công");
        return "redirect:/admin/categories";
    }

    @PostMapping("/delete")
    public String deleteCategory(@RequestParam Long id, RedirectAttributes redirectAttributes) {
        try {
            boolean hasProducts = productService.existsByCategoryId(id);

            if (hasProducts) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Không thể xóa danh mục vì còn chứa sản phẩm. Vui lòng xóa sản phẩm trước.");
                return "redirect:/admin/categories";
            }

            categoryService.deleteCategory(id);
            redirectAttributes.addFlashAttribute("successMessage", "Xóa danh mục thành công");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể xóa danh mục: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

}

