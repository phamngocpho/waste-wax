<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sản phẩm mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="/css/addProduct.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Thêm sản phẩm mới</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/products" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            </c:if>

            <!-- Form thêm sản phẩm -->
            <div class="card">
                <div class="card-body">
                    <form action="/admin/products/create" method="post" enctype="multipart/form-data">
                        <!-- Thông tin cơ bản -->
                        <div class="mb-4">
                            <h4>Thông tin cơ bản</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="name" name="name" required>
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
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control" id="description" name="description" rows="4"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin giá và kho -->
                        <div class="mb-4">
                            <h4>Thông tin giá và kho</h4>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="basePrice" class="form-label">Giá cơ bản (VNĐ) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="basePrice" name="basePrice" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="discountPercentage" class="form-label">Giảm giá (%)</label>
                                    <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" value="0" min="0" max="100">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="stockQuantity" class="form-label">Số lượng kho</label>
                                    <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="0" min="0">
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin bổ sung -->
                        <div class="mb-4">
                            <h4>Thông tin bổ sung</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="scentType" class="form-label">Loại hương</label>
                                    <input type="text" class="form-control" id="scentType" name="scentType">
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="ACTIVE" selected>Đang bán</option>
                                        <option value="INACTIVE">Ngừng bán</option>
                                    </select>
                                </div>
                                <div class="form-check mt-4">
                                    <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured">
                                    <label class="form-check-label" for="isFeatured">
                                        Sản phẩm nổi bật
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Hình ảnh sản phẩm -->
                        <div class="mb-4">
                            <h4>Hình ảnh sản phẩm</h4>
                            <div class="image-upload-container mb-3">
                                <div class="image-preview-container" id="imagePreviewContainer">
                                    <!-- Các ảnh preview sẽ được thêm vào đây bằng JavaScript -->
                                </div>
                                <div class="mb-3">
                                    <label for="images" class="form-label">Chọn hình ảnh (có thể chọn nhiều)</label>
                                    <input type="file" class="form-control" id="images" name="images" multiple accept="image/*" onchange="previewImages(this)">
                                </div>
                                <div class="mb-3">
                                    <label for="primaryImageIndex" class="form-label">Chọn ảnh chính</label>
                                    <select class="form-select" id="primaryImageIndex" name="primaryImageIndex">
                                        <option value="">-- Chọn ảnh chính --</option>
                                        <!-- Options sẽ được thêm vào đây bằng JavaScript -->
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Kích thước sản phẩm -->
                        <!-- Phần form thêm kích thước sản phẩm -->
                        <div class="mb-4">
                            <h4>Kích thước và giá</h4>
                            <div id="sizeContainer">
                                <div class="size-row row mb-2">
                                    <div class="col-md-4">
                                        <input type="text" name="sizeValues" class="form-control" placeholder="Kích thước (VD: S, M, L)" required>
                                    </div>
                                    <div class="col-md-3">
                                        <input type="number" name="sizePrices" class="form-control" placeholder="Giá" min="0" required>
                                    </div>
                                    <div class="col-md-3">
                                        <input type="number" name="sizeStockQuantities" class="form-control" placeholder="Số lượng" min="0" required>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="button" class="btn btn-danger remove-size"><i class="fas fa-trash"></i></button>
                                    </div>
                                </div>
                            </div>
                            <button type="button" id="addSizeBtn" class="btn btn-sm btn-outline-secondary mt-2">
                                <i class="fas fa-plus"></i> Thêm kích thước
                            </button>
                        </div>

                        <!-- Nút submit -->
                        <div class="text-end mt-4">
                            <button type="reset" class="btn btn-secondary">Làm mới</button>
                            <button type="submit" class="btn btn-primary">Lưu sản phẩm</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Xử lý preview hình ảnh
    function previewImages(input) {
        const previewContainer = document.getElementById('imagePreviewContainer');
        const primaryImageSelect = document.getElementById('primaryImageIndex');

        // Xóa các preview cũ
        previewContainer.innerHTML = '';
        primaryImageSelect.innerHTML = '<option value="">-- Chọn ảnh chính --</option>';

        if (input.files && input.files.length > 0) {
            for (let i = 0; i < input.files.length; i++) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    // Tạo container cho mỗi ảnh
                    const imageContainer = document.createElement('div');
                    imageContainer.className = 'image-preview';

                    // Tạo thẻ img
                    const img = document.createElement('img');
                    img.src = e.target.result;
                    img.className = 'img-thumbnail';
                    img.style.width = '100px';
                    img.style.height = '100px';

                    // Thêm vào container
                    imageContainer.appendChild(img);
                    previewContainer.appendChild(imageContainer);

                    // Thêm option vào select
                    const option = document.createElement('option');
                    option.value = i;
                    option.textContent = `Ảnh ${i + 1}`;
                    primaryImageSelect.appendChild(option);

                    // Đặt ảnh đầu tiên làm ảnh chính
                    if (i === 0) {
                        primaryImageSelect.value = 0;
                    }
                }

                reader.readAsDataURL(input.files[i]);
            }
        }
    }

    // Thêm kích thước mới
    function addSize() {
        const sizeContainer = document.getElementById('sizeContainer');
        const newRow = document.createElement('div');
        newRow.className = 'row size-row mb-2';
        newRow.innerHTML = `
                <div class="col-md-3">
                    <label class="form-label">Kích thước (ml)</label>
                    <input type="number" class="form-control" name="sizeValues[]" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Giá (VNĐ)</label>
                    <input type="number" class="form-control" name="sizePrices[]" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Số lượng kho</label>
                    <input type="number" class="form-control" name="sizeStocks[]" value="0" min="0">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="button" class="btn btn-danger mb-3" onclick="removeSize(this)">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            `;
        sizeContainer.appendChild(newRow);
    }

    // Xóa kích thước
    function removeSize(button) {
        const row = button.closest('.size-row');
        row.remove();
    }
</script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Xử lý thêm kích thước
        document.getElementById('addSizeBtn').addEventListener('click', function() {
            const sizeContainer = document.getElementById('sizeContainer');
            const newRow = document.createElement('div');
            newRow.className = 'size-row row mb-2';
            newRow.innerHTML = `
                <div class="col-md-4">
                    <input type="text" name="sizeValues" class="form-control" placeholder="Kích thước (VD: S, M, L)" required>
                </div>
                <div class="col-md-3">
                    <input type="number" name="sizePrices" class="form-control" placeholder="Giá" min="0" required>
                </div>
                <div class="col-md-3">
                    <input type="number" name="sizeStockQuantities" class="form-control" placeholder="Số lượng" min="0" required>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn btn-danger remove-size"><i class="fas fa-trash"></i></button>
                </div>
            `;
            sizeContainer.appendChild(newRow);

            // Thêm sự kiện cho nút xóa
            newRow.querySelector('.remove-size').addEventListener('click', function() {
                newRow.remove();
            });
        });

        // Xử lý xóa kích thước
        document.querySelectorAll('.remove-size').forEach(button => {
            button.addEventListener('click', function() {
                this.closest('.size-row').remove();
            });
        });

        // Xử lý form submit
        document.querySelector('form').addEventListener('submit', function(e) {
            // Kiểm tra xem có ít nhất một kích thước
            const sizeValues = document.querySelectorAll('input[name="sizeValues"]');

            // Nếu không có kích thước nào, thêm các input ẩn để đảm bảo mảng không null
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
