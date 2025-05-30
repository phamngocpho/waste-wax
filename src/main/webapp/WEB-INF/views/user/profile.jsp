<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - CandleShop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#B8472A',
                        secondary: '#534C45',
                        'primary-light': '#f8f1ee',
                        'primary-dark': '#a03e25',
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50 text-gray-800">
<jsp:include page="layouts/nav.jsp" />

<div class="container mx-auto px-4 py-8 max-w-7xl mt-32 mb-12">
    <h1 class="text-3xl font-bold text-secondary mb-8">Thông tin cá nhân</h1>

    <div class="flex flex-col md:flex-row gap-8">
        <!-- Sidebar -->
        <div class="w-full md:w-1/4 lg:w-1/5">
            <div class="bg-white rounded-xl shadow-sm p-6">
                <!-- User info -->
                <div class="flex items-center space-x-4 pb-6 border-b border-gray-100 mb-6">
                    <div class="w-16 h-16 rounded-full bg-primary flex items-center justify-center text-white text-2xl font-bold">
                        ${fn:substring(user.username, 0, 1).toUpperCase()}
                    </div>
                    <div>
                        <h3 class="font-semibold text-lg">${user.fullName}</h3>
                        <p class="text-gray-500 text-sm">${user.email}</p>
                        <div class="mt-1 inline-flex items-center bg-gray-100 px-3 py-1 rounded-full text-sm">
                            <i class="fas fa-star text-yellow-500 mr-1"></i> ${user.points} điểm
                        </div>
                    </div>
                </div>

                <!-- Navigation -->
                <nav>
                    <ul class="space-y-1">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile"
                               class="flex items-center px-4 py-3 rounded-lg bg-primary-light text-primary font-medium">
                                <i class="fas fa-user w-5 mr-3"></i> Thông tin cá nhân
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/user/orders"
                               class="flex items-center px-4 py-3 rounded-lg hover:bg-gray-50 text-secondary font-medium transition">
                                <i class="fas fa-shopping-bag w-5 mr-3"></i> Đơn hàng của tôi
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/wishlist"
                               class="flex items-center px-4 py-3 rounded-lg hover:bg-gray-50 text-secondary font-medium transition">
                                <i class="fas fa-heart w-5 mr-3"></i> Danh sách yêu thích
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/logout"
                               class="flex items-center px-4 py-3 rounded-lg hover:bg-red-50 text-red-600 font-medium transition">
                                <i class="fas fa-sign-out-alt w-5 mr-3"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- Main content -->
        <div class="w-full md:w-3/4 lg:w-4/5">
            <div class="bg-white rounded-xl shadow-sm p-8">
                <!-- Alerts -->
                <c:if test="${not empty success}">
                    <div class="mb-6 bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded-lg">
                        <div class="flex items-center">
                            <i class="fas fa-check-circle mr-2"></i>
                            <span>${success}</span>
                        </div>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="mb-6 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-lg">
                        <div class="flex items-center">
                            <i class="fas fa-exclamation-circle mr-2"></i>
                            <span>${error}</span>
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/profile/update" method="post">
                    <!-- Basic Information -->
                    <h2 class="text-xl font-semibold text-secondary pb-2 border-b border-gray-200 mb-6">Thông tin cơ bản</h2>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label for="username" class="block text-sm font-medium text-gray-700 mb-2">Tên đăng nhập</label>
                            <input type="text" id="username" name="username"
                                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition"
                                   value="${user.username}" required>
                        </div>

                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                            <input type="email" id="email" name="email"
                                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition"
                                   value="${user.email}" required>
                        </div>
                    </div>

                    <div class="mb-6">
                        <label for="fullName" class="block text-sm font-medium text-gray-700 mb-2">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName"
                               class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition"
                               value="${user.fullName}" required>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                        <div>
                            <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">Số điện thoại</label>
                            <input type="tel" id="phone" name="phone"
                                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition"
                                   value="${user.phone}">
                        </div>

                        <div>
                            <label for="address" class="block text-sm font-medium text-gray-700 mb-2">Địa chỉ</label>
                            <input type="text" id="address" name="address"
                                   class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition"
                                   value="${user.address}">
                        </div>
                    </div>

                    <!-- Password Change -->
                    <h2 class="text-xl font-semibold text-secondary pb-2 border-b border-gray-200 mb-6">Đổi mật khẩu</h2>

                    <div class="mb-6">
                        <label class="inline-flex items-center cursor-pointer">
                            <input type="checkbox" id="changePassword" name="changePassword" value="true"
                                   class="w-5 h-5 text-primary border-gray-300 rounded focus:ring-primary"
                                   onchange="togglePasswordFields()">
                            <span class="ml-2 text-gray-700">Tôi muốn đổi mật khẩu</span>
                        </label>
                    </div>

                    <div id="passwordFields" class="hidden space-y-6 mb-8">
                        <div>
                            <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-2">Mật khẩu mới</label>
                            <div class="relative">
                                <input type="password" id="newPassword" name="newPassword"
                                       class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition">
                                <button type="button" onclick="togglePasswordVisibility('newPassword')"
                                        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                                    <i id="newPasswordIcon" class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div>
                            <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-2">Xác nhận mật khẩu mới</label>
                            <div class="relative">
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       class="w-full px-4 py-3 rounded-lg border border-gray-300 focus:ring-2 focus:ring-primary focus:border-primary transition">
                                <button type="button" onclick="togglePasswordVisibility('confirmPassword')"
                                        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700">
                                    <i id="confirmPasswordIcon" class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="mt-8">
                        <button type="submit"
                                class="px-6 py-3 bg-primary text-white font-medium rounded-lg hover:bg-primary-dark transition">
                            Cập nhật thông tin
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    function togglePasswordFields() {
        const passwordFields = document.getElementById('passwordFields');
        const changePasswordCheckbox = document.getElementById('changePassword');

        if (changePasswordCheckbox.checked) {
            passwordFields.classList.remove('hidden');
        } else {
            passwordFields.classList.add('hidden');
            document.getElementById('newPassword').value = '';
            document.getElementById('confirmPassword').value = '';
        }
    }

    function togglePasswordVisibility(inputId) {
        const passwordInput = document.getElementById(inputId);
        const icon = document.getElementById(inputId + 'Icon');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
</script>
<jsp:include page="layouts/footer.jsp" />
</body>
</html>
