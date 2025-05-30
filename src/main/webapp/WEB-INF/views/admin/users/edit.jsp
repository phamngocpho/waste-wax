<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chỉnh sửa người dùng</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/users" class="btn btn-secondary">
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

            <!-- Form chỉnh sửa người dùng -->
            <div class="card">
                <div class="card-body">
                    <form action="/admin/users/edit/${user.id}" method="post">
                        <!-- Thông tin đăng nhập -->
                        <div class="mb-4">
                            <h4>Thông tin đăng nhập</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" value="${user.username}" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" value="${user.email}" required>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="changePassword" name="changePassword" value="true">
                                        <label class="form-check-label" for="changePassword">
                                            Đổi mật khẩu
                                        </label>
                                    </div>
                                    <div id="passwordField" style="display: none;">
                                        <label for="newPassword" class="form-label">Mật khẩu mới</label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword">
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="role" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                    <select class="form-select" id="role" name="role" required>
                                        <c:forEach items="${roles}" var="role">
                                            <option value="${role}" ${user.role == role ? 'selected' : ''}>${role}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin cá nhân -->
                        <div class="mb-4">
                            <h4>Thông tin cá nhân</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullName}">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Thông tin khác -->
                        <div class="mb-4">
                            <h4>Thông tin khác</h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="points" class="form-label">Điểm tích lũy</label>
                                    <input type="number" class="form-control" id="points" name="points" value="${user.points}" min="0">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="ACTIVE" ${user.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="INACTIVE" ${user.status == 'INACTIVE' ? 'selected' : ''}>Bị khóa</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="text-end">
                            <button type="reset" class="btn btn-secondary">Làm mới</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Hiển thị trường mật khẩu mới khi checkbox được chọn
    document.getElementById('changePassword').addEventListener('change', function() {
        var passwordField = document.getElementById('passwordField');
        if (this.checked) {
            passwordField.style.display = 'block';
        } else {
            passwordField.style.display = 'none';
        }
    });
</script>
</body>
</html>
