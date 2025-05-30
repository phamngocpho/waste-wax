<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm người dùng mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
    <style>
        :root {
            --background: #ffffff;
            --foreground: #0f172a;
            --muted: #f8fafc;
            --muted-foreground: #64748b;
            --border: #e2e8f0;
            --input: #ffffff;
            --primary: #0f172a;
            --primary-foreground: #f8fafc;
            --secondary: #f1f5f9;
            --secondary-foreground: #0f172a;
            --accent: #f1f5f9;
            --accent-foreground: #0f172a;
            --destructive: #ef4444;
            --destructive-foreground: #fef2f2;
            --ring: #94a3b8;
            --radius: 0.5rem;
        }

        body {
            background-color: var(--muted);
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            color: var(--foreground);
        }

        .main-container {
            margin: 2rem 0 2rem 0;
        }

        .page-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--border);
        }

        .page-title {
            font-size: 1.875rem;
            font-weight: 600;
            color: var(--foreground);
            margin: 0;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin-bottom: 1rem;
        }

        .breadcrumb-item {
            color: var(--muted-foreground);
            font-size: 0.875rem;
        }

        .breadcrumb-item.active {
            color: var(--foreground);
        }

        .breadcrumb-item + .breadcrumb-item::before {
            content: "/";
            color: var(--muted-foreground);
        }

        .card {
            background: var(--background);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }

        .card-header {
            background: var(--muted);
            border-bottom: 1px solid var(--border);
            padding: 1.5rem;
            border-radius: var(--radius) var(--radius) 0 0;
        }

        .card-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--foreground);
            margin: 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--foreground);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-icon {
            width: 1rem;
            height: 1rem;
            color: var(--muted-foreground);
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--foreground);
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1px solid var(--border);
            border-radius: calc(var(--radius) - 2px);
            background-color: var(--input);
            color: var(--foreground);
            font-size: 0.875rem;
            padding: 0.75rem 1rem;
            transition: all 0.2s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--ring);
            box-shadow: 0 0 0 2px rgba(148, 163, 184, 0.2);
            outline: none;
        }

        .form-control::placeholder {
            color: var(--muted-foreground);
        }

        .required {
            color: var(--destructive);
        }

        .btn {
            border-radius: calc(var(--radius) - 2px);
            font-size: 0.875rem;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .btn-primary {
            background-color: var(--primary);
            color: var(--primary-foreground);
            border-color: var(--primary);
        }

        .btn-primary:hover {
            background-color: rgba(15, 23, 42, 0.9);
            border-color: rgba(15, 23, 42, 0.9);
        }

        .btn-secondary {
            background-color: var(--secondary);
            color: var(--secondary-foreground);
            border-color: var(--border);
        }

        .btn-secondary:hover {
            background-color: var(--accent);
            color: var(--accent-foreground);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--foreground);
            border-color: var(--border);
        }

        .btn-outline:hover {
            background-color: var(--accent);
            color: var(--accent-foreground);
        }

        .alert {
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 1rem;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
        }

        .alert-danger {
            background-color: var(--destructive-foreground);
            color: var(--destructive);
            border-color: var(--destructive);
        }

        .alert-success {
            background-color: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }

        .btn-close {
            background: none;
            border: none;
            font-size: 1rem;
            opacity: 0.5;
        }

        .btn-close:hover {
            opacity: 1;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 0.75rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--border);
            margin-top: 1.5rem;
        }

        .input-group {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted-foreground);
            z-index: 2;
        }

        .input-with-icon {
            padding-left: 2.5rem;
        }

        .form-text {
            font-size: 0.75rem;
            color: var(--muted-foreground);
            margin-top: 0.25rem;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.5rem;
            border-radius: calc(var(--radius) - 4px);
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-active {
            background-color: #f0fdf4;
            color: #166534;
        }

        .status-inactive {
            background-color: #fef2f2;
            color: #dc2626;
        }

        .field-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }

            .field-group {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
            }
        }

        .loading {
            opacity: 0.6;
            pointer-events: none;
        }

        .spinner {
            display: inline-block;
            width: 1rem;
            height: 1rem;
            border: 2px solid transparent;
            border-top: 2px solid currentColor;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row">
        <main class="col-md-9 ms-sm-auto col-lg-10 main-container">
            <!-- Breadcrumb -->
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="/admin" class="text-decoration-none">Dashboard</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="/admin/users" class="text-decoration-none">Người dùng</a>
                    </li>
                    <li class="breadcrumb-item active">Thêm mới</li>
                </ol>
            </nav>

            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h1 class="page-title">Thêm người dùng mới</h1>
                    <a href="/admin/users" class="btn btn-outline">
                        <i class="fas fa-arrow-left me-2"></i>
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

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                        ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Main Form -->
            <div class="card">
                <div class="card-body">
                    <form id="userForm" action="/admin/users/create" method="post" novalidate>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <!-- Authentication Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="fas fa-key section-icon"></i>
                                Thông tin đăng nhập
                            </h3>
                            <div class="field-group">
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        Tên đăng nhập <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <i class="fas fa-user input-icon"></i>
                                        <input type="text"
                                               class="form-control input-with-icon"
                                               id="username"
                                               name="username"
                                               placeholder="Nhập tên đăng nhập"
                                               value="${param.username}"
                                               required>
                                    </div>
                                    <div class="form-text">Tên đăng nhập phải có ít nhất 3 ký tự</div>
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <i class="fas fa-envelope input-icon"></i>
                                        <input type="email"
                                               class="form-control input-with-icon"
                                               id="email"
                                               name="email"
                                               placeholder="Nhập địa chỉ email"
                                               value="${param.email}"
                                               required>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        Mật khẩu <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <i class="fas fa-lock input-icon"></i>
                                        <input type="password"
                                               class="form-control input-with-icon"
                                               id="password"
                                               name="password"
                                               placeholder="Nhập mật khẩu"
                                               required>
                                    </div>
                                    <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                                </div>

                                <div class="mb-3">
                                    <label for="role" class="form-label">
                                        Vai trò <span class="required">*</span>
                                    </label>
                                    <select class="form-select" id="role" name="role" required>
                                        <option value="">Chọn vai trò</option>
                                        <c:forEach items="${roles}" var="role">
                                            <option value="${role}" ${param.role == role ? 'selected' : ''}>
                                                <c:choose>
                                                    <c:when test="${role == 'ADMIN'}">Quản trị viên</c:when>
                                                    <c:when test="${role == 'USER'}">Người dùng</c:when>
                                                    <c:otherwise>${role}</c:otherwise>
                                                </c:choose>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Personal Information Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="fas fa-user-circle section-icon"></i>
                                Thông tin cá nhân
                            </h3>
                            <div class="field-group">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <div class="input-group">
                                        <i class="fas fa-id-card input-icon"></i>
                                        <input type="text"
                                               class="form-control input-with-icon"
                                               id="fullName"
                                               name="fullName"
                                               placeholder="Nhập họ và tên"
                                               value="${param.fullName}">
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <div class="input-group">
                                        <i class="fas fa-phone input-icon"></i>
                                        <input type="tel"
                                               class="form-control input-with-icon"
                                               id="phone"
                                               name="phone"
                                               placeholder="Nhập số điện thoại"
                                               value="${param.phone}">
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="address" class="form-label">Địa chỉ</label>
                                <div class="input-group">
                                    <i class="fas fa-map-marker-alt input-icon"></i>
                                    <textarea class="form-control input-with-icon"
                                              id="address"
                                              name="address"
                                              rows="3"
                                              placeholder="Nhập địa chỉ">${param.address}</textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Additional Information Section -->
                        <div class="form-section">
                            <h3 class="section-title">
                                <i class="fas fa-cog section-icon"></i>
                                Cài đặt tài khoản
                            </h3>
                            <div class="field-group">
                                <div class="mb-3">
                                    <label for="points" class="form-label">Điểm tích lũy</label>
                                    <div class="input-group">
                                        <i class="fas fa-star input-icon"></i>
                                        <input type="number"
                                               class="form-control input-with-icon"
                                               id="points"
                                               name="points"
                                               value="${param.points != null ? param.points : '0'}"
                                               min="0"
                                               placeholder="0">
                                    </div>
                                    <div class="form-text">Điểm tích lũy ban đầu của người dùng</div>
                                </div>

                                <div class="mb-3">
                                    <label for="status" class="form-label">Trạng thái tài khoản</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="ACTIVE" ${param.status == 'ACTIVE' || param.status == null ? 'selected' : ''}>
                                            Hoạt động
                                        </option>
                                        <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>
                                            Bị khóa
                                        </option>
                                    </select>
                                    <div class="form-text">
                                        <span class="status-badge status-active">
                                            <i class="fas fa-circle"></i>
                                            Hoạt động: Người dùng có thể đăng nhập và sử dụng hệ thống
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                <i class="fas fa-undo me-2"></i>
                                Làm mới
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-plus me-2"></i>
                                Tạo người dùng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Form validation and submission
    document.getElementById('userForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const submitBtn = document.getElementById('submitBtn');
        const originalText = submitBtn.innerHTML;

        // Show loading state
        submitBtn.innerHTML = '<span class="spinner me-2"></span>Đang tạo...';
        submitBtn.disabled = true;
        document.body.classList.add('loading');

        // Validate form
        if (validateForm()) {
            // Submit form
            this.submit();
        } else {
            // Reset button state
            submitBtn.innerHTML = originalText;
            submitBtn.disabled = false;
            document.body.classList.remove('loading');
        }
    });

    function validateForm() {
        let isValid = true;
        const requiredFields = ['username', 'email', 'password', 'role'];

        requiredFields.forEach(fieldName => {
            const field = document.getElementById(fieldName);
            const value = field.value.trim();

            // Remove existing error styling
            field.classList.remove('is-invalid');

            if (!value) {
                field.classList.add('is-invalid');
                isValid = false;
            }
        });

        // Validate email format
        const email = document.getElementById('email');
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email.value && !emailPattern.test(email.value)) {
            email.classList.add('is-invalid');
            isValid = false;
        }

        // Validate password length
        const password = document.getElementById('password');
        if (password.value && password.value.length < 6) {
            password.classList.add('is-invalid');
            isValid = false;
        }

        // Validate username length
        const username = document.getElementById('username');
        if (username.value && username.value.length < 3) {
            username.classList.add('is-invalid');
            isValid = false;
        }

        return isValid;
    }

    function resetForm() {
        document.getElementById('userForm').reset();
        // Remove all validation classes
        document.querySelectorAll('.is-invalid').forEach(el => {
            el.classList.remove('is-invalid');
        });
    }

    // Real-time validation
    document.querySelectorAll('input, select, textarea').forEach(field => {
        field.addEventListener('blur', function() {
            if (this.hasAttribute('required') && !this.value.trim()) {
                this.classList.add('is-invalid');
            } else {
                this.classList.remove('is-invalid');
            }
        });

        field.addEventListener('input', function() {
            if (this.classList.contains('is-invalid') && this.value.trim()) {
                this.classList.remove('is-invalid');
            }
        });
    });

    // Auto-hide alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        });
    });

    // Phone number formatting
    document.getElementById('phone').addEventListener('input', function(e) {
        let value = e.target.value.replace(/\D/g, '');
        if (value.length > 10) {
            value = value.substring(0, 10);
        }
        e.target.value = value;
    });

    // Username validation (no spaces, special characters)
    document.getElementById('username').addEventListener('input', function(e) {
        let value = e.target.value.toLowerCase().replace(/[^a-z0-9_]/g, '');
        e.target.value = value;
    });
</script>

<style>
    .is-invalid {
        border-color: var(--destructive) !important;
        box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.2) !important;
    }
</style>
</body>
</html>