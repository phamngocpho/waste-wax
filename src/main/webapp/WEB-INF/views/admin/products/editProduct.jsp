<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="/css/admin.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->


            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Chỉnh sửa sản phẩm</h1>
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

                <!-- Form chỉnh sửa sản phẩm -->
                <div class="card">
                    <div class="card-body">
                        <form action="/admin/products/edit/${product.id}" method="post" enctype="multipart/form-data">
                            <!-- Thông tin cơ bản -->
                            <div class="mb-4">
                                <h4>Thông tin cơ bản</h4>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="name" name="name" value="${product.name}" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="categoryId" class="form-label">Danh mục <span class="text-danger">*</span></label>
                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                            <option value="">-- Chọn danh mục --</option>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}" ${product.category.id == category.id ? 'selected' : ''}>${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label for="description" class="form-label">Mô tả</label>
                                        <textarea class="form-control" id="description" name="description" rows="4">${product.description}</textarea>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin giá và kho -->
                            <div class="mb-4">
                                <h4>Thông tin giá và kho</h4>
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label for="basePrice" class="form-label">Giá cơ bản (VNĐ) <span class="text-danger">*</span></label>
                                        <input type="number" class="form-control" id="basePrice" name="basePrice" value="${product.basePrice}" required>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="discountPercentage" class="form-label">Giảm giá (%)</label>
                                        <input type="number" class="form-control" id="discountPercentage" name="discountPercentage" value="${product.discountPercentage}" min="0" max="100">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label for="stockQuantity" class="form-label">Số lượng kho</label>
                                        <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" value="${product.stockQuantity}" min="0">
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin bổ sung -->
                            <div class="mb-4">
                                <h4>Thông tin bổ sung</h4>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="scentType" class="form-label">Loại hương</label>
                                        <input type="text" class="form-control" id="scentType" name="scentType" value="${product.scentType}">
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label for="status" class="form-label">Trạng thái</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="ACTIVE" ${product.status == 'ACTIVE' ? 'selected' : ''}>Đang bán</option>
                                            <option value="INACTIVE" ${product.status == 'INACTIVE' ? 'selected' : ''}>Ngừng bán</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <div class="form-check mt-4">
                                            <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured" value="true" ${product.featured ? 'checked' : ''}>
                                            <label class="form-check-label" for="isFeatured">
                                                Sản phẩm nổi bật
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Hình ảnh sản phẩm hiện tại -->
                            <div class="mb-4">
                                <h4>Hình ảnh sản phẩm hiện tại</h4>
                                <div class="row">
                                    <c:forEach items="${productImages}" var="image" varStatus="status">
                                        <div class="col-md-3 mb-3">
                                            <div class="card">
                                                <img src="/uploads/${image.imageUrl}" class="card-img-top" alt="Product Image" style="height: 150px; object-fit: cover;">
                                                <div class="card-body">
                                                    <div class="form-check mb-2">
                                                        <input class="form-check-input" type="radio" name="primaryImageId" id="primaryImage${status.index}"
                                                               value="${image.id}" ${image.primary ? 'checked' : ''}>
                                                        <label class="form-check-label" for="primaryImage${status.index}">
                                                            Ảnh chính
                                                        </label>
                                                    </div>
                                                    <div class="form-check">
                                                        <input class="form-check-input" type="checkbox" name="deleteImageIds" id="deleteImage${status.index}"
                                                               value="${image.id}">
                                                        <label class="form-check-label" for="deleteImage${status.index}">
                                                            Xóa ảnh
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Thêm hình ảnh mới -->
                            <div class="mb-4">
                                <h4>Thêm hình ảnh mới</h4>
                                <div class="image-upload-container mb-3">
                                    <div class="image-preview-container" id="imagePreviewContainer">
                                        <!-- Các ảnh preview sẽ được thêm vào đây bằng JavaScript -->
                                    </div>
                                    <div class="mb-3">
                                        <label for="newImages" class="form-label">Chọn hình ảnh mới (có thể chọn nhiều)</label>
                                        <input type="file" class="form-control" id="newImages" name="newImages" multiple accept="image/*" onchange="previewImages(this)">
                                    </div>
                                </div>
                            </div>

                            <!-- Kích thước sản phẩm hiện tại -->
                            <div class="mb-4">
                                <h4>Kích thước sản phẩm hiện tại</h4>
                                <div id="existingSizeContainer">
                                    <c:forEach items="${productSizes}" var="size" varStatus="status">
                                        <div class="row size-row mb-2">
                                            <input type="hidden" name="existingSizeIds" value="${size.id}">
                                            <div class="col-md-3">
                                                <label class="form-label">Kích thước (ml)</label>
                                                <input type="number" class="form-control" name="existingSizeValues" value="${size.sizeValue}" required>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Giá (VNĐ)</label>
                                                <input type="number" class="form-control" name="existingSizePrices" value="${size.price}" required>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label">Số lượng kho</label>
                                                <input type="number" class="form-control" name="existingSizeStocks" value="${size.stockQuantity}" min="0">
                                            </div>
                                            <div class="col-md-3 d-flex align-items-end">
                                                <div class="form-check mb-3 me-3">
                                                    <input class="form-check-input" type="checkbox" name="deleteSizeIds" id="deleteSize${status.index}"
                                                           value="${size.id}">
                                                    <label class="form-check-label" for="deleteSize${status.index}">
                                                        Xóa kích thước
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- Thêm kích thước mới -->
                            <div class="mb-4">
                                <h4>Thêm kích thước mới</h4>
                                <div id="newSizeContainer">
                                    <!-- Các kích thước mới sẽ được thêm vào đây bằng JavaScript -->
                                </div>
                                <button type="button" class="btn btn-success mt-2" onclick="addNewSize()">
                                    <i class="fas fa-plus"></i> Thêm kích thước mới
                                </button>
                            </div>

                            <!-- Nút submit -->
                            <div class="text-end mt-4">
                                <a href="/admin/products" class="btn btn-secondary">Hủy</a>
                                <button type="submit" class="btn btn-primary">Cập nhật sản phẩm</button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý preview hình ảnh mới
        function previewImages(input) {
            const previewContainer = document.getElementById('imagePreviewContainer');

            // Xóa các preview cũ
            previewContainer.innerHTML = '';

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
                    }

                    reader.readAsDataURL(input.files[i]);
                }
            }
        }

        // Thêm kích thước mới
        function addNewSize() {
            const sizeContainer = document.getElementById('newSizeContainer');
            const newRow = document.createElement('div');
            newRow.className = 'row size-row mb-2';
            newRow.innerHTML = `
                <div class="col-md-3">
                    <label class="form-label">Kích thước (ml)</label>
                    <input type="number" class="form-control" name="newSizeValues" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Giá (VNĐ)</label>
                    <input type="number" class="form-control" name="newSizePrices" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Số lượng kho</label>
                    <input type="number" class="form-control" name="newSizeStocks" value="0" min="0">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="button" class="btn btn-danger mb-3" onclick="removeNewSize(this)">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            `;
            sizeContainer.appendChild(newRow);
        }

        // Xóa kích thước mới
        function removeNewSize(button) {
            const row = button.closest('.size-row');
            row.remove();
        }
    </script>
</body>
</html>
