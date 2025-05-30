<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
    <style>
        :root {
            --primary-color: #6366f1;
            --secondary-color: #f8fafc;
            --border-color: #e2e8f0;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --success-color: #10b981;
            --danger-color: #ef4444;
        }

        body {
            background-color: #f8fafc;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        .main-container {
            padding: 2rem;
        }

        .page-header {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0;
        }

        .form-card {
            background: white;
            border-radius: 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-section {
            padding: 2rem;
            border-bottom: 1px solid var(--border-color);
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label {
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .btn {
            border-radius: 8px;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #5855eb;
            border-color: #5855eb;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #6b7280;
            border-color: #6b7280;
        }

        .btn-outline-secondary {
            border-color: var(--border-color);
            color: var(--text-secondary);
        }

        .btn-outline-secondary:hover {
            background-color: var(--secondary-color);
            border-color: var(--border-color);
        }

        .image-upload-area {
            border: 2px dashed var(--border-color);
            border-radius: 12px;
            padding: 2rem;
            text-align: center;
            transition: all 0.2s ease;
            background-color: #fafbfc;
        }

        .image-upload-area:hover {
            border-color: var(--primary-color);
            background-color: rgba(99, 102, 241, 0.05);
        }

        .image-preview-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .image-preview {
            position: relative;
            border-radius: 8px;
            overflow: hidden;
            aspect-ratio: 1;
        }

        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .size-row {
            background-color: #f8fafc;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid var(--border-color);
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 1rem 1.5rem;
        }

        .alert-danger {
            background-color: #fef2f2;
            color: #dc2626;
        }

        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .text-danger {
            color: var(--danger-color) !important;
        }

        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            color: var(--text-secondary);
            font-weight: 500;
            transition: color 0.2s ease;
        }

        .back-button:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <main class="col-md-9 ms-sm-auto col-lg-10 main-container">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="page-title">Thêm sản phẩm mới</h1>
                    <a href="/admin/products" class="back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại
                    </a>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                        ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Main Form -->
            <div class="form-card">
                <form action="/admin/products/create" method="post" enctype="multipart/form-data">

                    <!-- Basic Information -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-info-circle text-primary"></i>
                            Thông tin cơ bản
                        </h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="name" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="name" name="name" required placeholder="Nhập tên sản phẩm">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="categoryId" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                <select class="form-select" id="categoryId" name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <c:forEach items="${categories}" var="category">
                                        <option value="${category.id}">${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả sản phẩm</label>
                            <textarea class="form-control" id="description" name="description" rows="4" placeholder="Nhập mô tả chi tiết về sản phẩm"></textarea>
                        </div>
                    </div>

                    <!-- Pricing & Inventory -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-dollar-sign text-success"></i>
                            Thông tin giá và kho
                        </h4>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label for="basePrice" class="form-label">Giá cơ bản (VNĐ) <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" id="basePrice" name="basePrice" required placeholder="0">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="discountPercentage" class="form-label">Giảm giá (%)</label>
                                <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" value="0" min="0" max="100" placeholder="0">
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="stockQuantity" class="form-label">Số lượng kho</label>
                                <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="0" min="0" placeholder="0">
                            </div>
                        </div>
                    </div>

                    <!-- Additional Information -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-cog text-info"></i>
                            Thông tin bổ sung
                        </h4>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="scentType" class="form-label">Loại hương</label>
                                <input type="text" class="form-control" id="scentType" name="scentType" placeholder="Ví dụ: Hương hoa, Hương trái cây...">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="status" class="form-label">Trạng thái</label>
                                <select class="form-select" id="status" name="status">
                                    <option value="ACTIVE" selected>Đang bán</option>
                                    <option value="INACTIVE">Ngừng bán</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label class="form-label">&nbsp;</label>
                                <div class="form-check mt-2">
                                    <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured">
                                    <label class="form-check-label" for="isFeatured">
                                        Sản phẩm nổi bật
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Product Images -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-images text-warning"></i>
                            Hình ảnh sản phẩm
                        </h4>
                        <div class="image-upload-area">
                            <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Tải lên hình ảnh sản phẩm</h5>
                            <p class="text-muted mb-3">Chọn nhiều ảnh để hiển thị sản phẩm một cách tốt nhất</p>
                            <input type="file" class="form-control" id="images" name="images" multiple accept="image/*" onchange="previewImages(this)">
                        </div>

                        <div class="image-preview-container" id="imagePreviewContainer"></div>

                        <div class="mt-3">
                            <label for="primaryImageIndex" class="form-label">Chọn ảnh chính</label>
                            <select class="form-select" id="primaryImageIndex" name="primaryImageIndex">
                                <option value="">-- Chọn ảnh chính --</option>
                            </select>
                        </div>
                    </div>

                    <!-- Product Sizes -->
                    <div class="form-section">
                        <h4 class="section-title">
                            <i class="fas fa-ruler text-purple"></i>
                            Kích thước và giá
                        </h4>
                        <div id="sizeContainer">
                            <div class="size-row">
                                <div class="row">
                                    <div class="col-md-4 mb-2">
                                        <label class="form-label">Kích thước</label>
                                        <input type="text" name="sizeValues" class="form-control" placeholder="VD: S, M, L hoặc 50ml, 100ml" required>
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <label class="form-label">Giá (VNĐ)</label>
                                        <input type="number" name="sizePrices" class="form-control" placeholder="0" min="0" required>
                                    </div>
                                    <div class="col-md-3 mb-2">
                                        <label class="form-label">Số lượng</label>
                                        <input type="number" name="sizeStockQuantities" class="form-control" placeholder="0" min="0" required>
                                    </div>
                                    <div class="col-md-2 mb-2">
                                        <label class="form-label">&nbsp;</label>
                                        <button type="button" class="btn btn-outline-danger d-block remove-size">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button type="button" id="addSizeBtn" class="btn btn-outline-secondary">
                            <i class="fas fa-plus me-2"></i>
                            Thêm kích thước
                        </button>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-section">
                        <div class="d-flex justify-content-end gap-3">
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-undo me-2"></i>
                                Làm mới
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-2"></i>
                                Lưu sản phẩm
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Image preview functionality
    function previewImages(input) {
        const previewContainer = document.getElementById('imagePreviewContainer');
        const primaryImageSelect = document.getElementById('primaryImageIndex');

        previewContainer.innerHTML = '';
        primaryImageSelect.innerHTML = '<option value="">-- Chọn ảnh chính --</option>';

        if (input.files && input.files.length > 0) {
            for (let i = 0; i < input.files.length; i++) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    const imageContainer = document.createElement('div');
                    imageContainer.className = 'image-preview';

                    const img = document.createElement('img');
                    img.src = e.target.result;

                    imageContainer.appendChild(img);
                    previewContainer.appendChild(imageContainer);

                    const option = document.createElement('option');
                    option.value = i;
                    option.textContent = `Ảnh ${i + 1}`;
                    primaryImageSelect.appendChild(option);

                    if (i === 0) {
                        primaryImageSelect.value = 0;
                    }
                }

                reader.readAsDataURL(input.files[i]);
            }
        }
    }

    // Size management
    document.addEventListener('DOMContentLoaded', function() {
        document.getElementById('addSizeBtn').addEventListener('click', function() {
            const sizeContainer = document.getElementById('sizeContainer');
            const newRow = document.createElement('div');
            newRow.className = 'size-row';
            newRow.innerHTML = `
                <div class="row">
                    <div class="col-md-4 mb-2">
                        <label class="form-label">Kích thước</label>
                        <input type="text" name="sizeValues" class="form-control" placeholder="VD: S, M, L hoặc 50ml, 100ml" required>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Giá (VNĐ)</label>
                        <input type="number" name="sizePrices" class="form-control" placeholder="0" min="0" required>
                    </div>
                    <div class="col-md-3 mb-2">
                        <label class="form-label">Số lượng</label>
                        <input type="number" name="sizeStockQuantities" class="form-control" placeholder="0" min="0" required>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label class="form-label">&nbsp;</label>
                        <button type="button" class="btn btn-outline-danger d-block remove-size">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `;
            sizeContainer.appendChild(newRow);

            newRow.querySelector('.remove-size').addEventListener('click', function() {
                newRow.remove();
            });
        });

        document.querySelectorAll('.remove-size').forEach(button => {
            button.addEventListener('click', function() {
                this.closest('.size-row').remove();
            });
        });

        // Form submit handling
        document.querySelector('form').addEventListener('submit', function(e) {
            const sizeValues = document.querySelectorAll('input[name="sizeValues"]');

            if (sizeValues.length === 0) {
                const hiddenSizeValue = document.createElement('input');
                hiddenSizeValue.type = 'hidden';
                hiddenSizeValue.name = 'sizeValues';
                hiddenSizeValue.value = 'Default';
                this.appendChild(hiddenSizeValue);

                const hiddenSizePrice = document.createElement('input');
                hiddenSizePrice.type = 'hidden';
                hiddenSizePrice.name = 'sizePrices';
                hiddenSizePrice.value = document.querySelector('input[name="basePrice"]').value || '0';
                this.appendChild(hiddenSizePrice);

                const hiddenSizeStock = document.createElement('input');
                hiddenSizeStock.type = 'hidden';
                hiddenSizeStock.name = 'sizeStockQuantities';
                hiddenSizeStock.value = document.querySelector('input[name="stockQuantity"]').value || '0';
                this.appendChild(hiddenSizeStock);
            }
        });
    });
</script>
</body>
</html>
