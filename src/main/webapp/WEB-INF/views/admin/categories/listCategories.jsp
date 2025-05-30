<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="../layouts/header.jsp" %>
<%@ include file="../layouts/sidebar.jsp" %>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/category.css">

<div class="main-content">
    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="header-title">
                <h4>Quản lý danh mục</h4>
            </div>
            <div class="header-action">
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal" style="background: #D2691E">
                    <i class="bx bx-plus"></i> Thêm danh mục
                </button>
            </div>
        </div>
    </div>

    <!-- Content Area -->
    <div class="content-area">
        <!-- Thông báo -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Danh sách danh mục -->
        <div class="card">
            <div class="card-body">
                <div class="category-list">
                    <!-- Danh sách danh mục phẳng -->
                    <c:forEach items="${categories}" var="category">
                        <div class="category-item d-flex justify-content-between align-items-center">
                            <span>${category.name}</span>
                            <div class="category-actions">
                                <button class="btn btn-sm btn-outline-primary"
                                        onclick="editCategory(${category.id}, '${category.name}')">
                                    <i class="bx bx-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger"
                                        onclick="confirmDelete(${category.id}, '${category.name}')">
                                    <i class="bx bx-trash"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>

                    <!-- Hiển thị khi không có danh mục nào -->
                    <c:if test="${empty categories}">
                        <div class="text-center py-4">
                            <p class="text-muted">Chưa có danh mục nào. Hãy thêm danh mục mới.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal thêm danh mục -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addCategoryModalLabel">Thêm danh mục mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories/add" method="post">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="categoryName" class="form-label">Tên danh mục</label>
                        <input type="text" class="form-control" id="categoryName" name="name" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Thêm danh mục</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal chỉnh sửa danh mục -->
<div class="modal fade" id="editCategoryModal" tabindex="-1" aria-labelledby="editCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editCategoryModalLabel">Sửa danh mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/categories/update" method="post">
                <div class="modal-body">
                    <input type="hidden" id="editCategoryId" name="id">
                    <div class="mb-3">
                        <label for="editCategoryName" class="form-label">Tên danh mục</label>
                        <input type="text" class="form-control" id="editCategoryName" name="name" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal xác nhận xóa -->
<div class="modal fade" id="deleteCategoryModal" tabindex="-1" aria-labelledby="deleteCategoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteCategoryModalLabel">Xác nhận xóa</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Bạn có chắc chắn muốn xóa danh mục <span id="deleteCategoryName" class="fw-bold"></span>?</p>
                <p class="text-danger">Lưu ý: Việc này có thể ảnh hưởng đến các sản phẩm thuộc danh mục này.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <form action="${pageContext.request.contextPath}/admin/categories/delete" method="post">
                    <input type="hidden" id="deleteCategoryId" name="id">
                    <button type="submit" class="btn btn-danger">Xóa</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Hàm mở modal sửa danh mục
    function editCategory(id, name) {
        document.getElementById('editCategoryId').value = id;
        document.getElementById('editCategoryName').value = name;

        const editModal = new bootstrap.Modal(document.getElementById('editCategoryModal'));
        editModal.show();
    }

    // Hàm mở modal xác nhận xóa
    function confirmDelete(id, name) {
        document.getElementById('deleteCategoryId').value = id;
        document.getElementById('deleteCategoryName').textContent = name;

        const deleteModal = new bootstrap.Modal(document.getElementById('deleteCategoryModal'));
        deleteModal.show();
    }

    // Tự động ẩn thông báo sau 5 giây
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>

<%@ include file="../layouts/footer.jsp" %>
