<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: Arial, sans-serif;
    }

    .navbar-wrapper {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        padding: 0 20px;
        z-index: 1000;
        transition: transform 0.3s ease-in-out;
        background-color: white;
    }

    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 25px 80px;
        background-color: white;
        height: 120px;

        border-radius: 0 0 30px 30px;
        border: 1px solid #e0e0e0;

        /* Thêm shadow nhẹ để tạo độ nổi */
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .nav-group {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }

    .logo-container {
        display: flex;
        align-items: center;
        position: absolute;
        left: 50%;
        transform: translateX(-50%);
    }

    .logo {
        width: 80px;
        height: 80px;
        background-size: contain;
        background-repeat: no-repeat;
        background-image: url('static/images/logo2.svg');
    }

    .nav-link {
        text-decoration: none;
        color: #333;
        font-size: 1.1rem; /* Tăng kích thước chữ */
        font-weight: 500; /* Làm đậm chữ hơn */
        transition: color 0.3s ease;
        position: relative;
    }

    .nav-link:hover, .nav-link.active {
        color: #ff6b6b;
    }

    .icon-group {
        display: flex;
        align-items: center;
        gap: 2rem; /* Tăng khoảng cách giữa các icon */
    }

    .icon-link {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        position: relative;
    }

    .icon-link svg {
        width: 26px; /* Tăng kích thước icon */
        height: 26px; /* Tăng kích thước icon */
        color: #534C45;
        transition: color 0.3s;
    }

    .icon-link span {
        font-size: 1rem; /* Tăng kích thước chữ */
    }

    .icon-link:hover svg {
        color: #ff6b6b;
    }

    .icon-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background-color: #ff6b6b;
        color: white;
        font-size: 11px; /* Tăng kích thước chữ */
        width: 18px; /* Tăng kích thước badge */
        height: 18px; /* Tăng kích thước badge */
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .hamburger {
        display: none;
        cursor: pointer;
        background: none;
        border: none;
        padding: 0.5rem;
    }

    .hamburger-icon {
        width: 28px; /* Tăng kích thước icon hamburger */
        height: 3px;
        background-color: #333;
        position: relative;
        transition: all 0.3s ease;
    }

    .hamburger-icon::before,
    .hamburger-icon::after {
        content: '';
        position: absolute;
        width: 28px; /* Tăng kích thước icon hamburger */
        height: 3px;
        background-color: #333;
        transition: all 0.3s ease;
    }

    .hamburger-icon::before {
        transform: translateY(-9px); /* Tăng khoảng cách */
    }

    .hamburger-icon::after {
        transform: translateY(9px); /* Tăng khoảng cách */
    }
    .relative {
        position: relative;
    }

    .group:hover .group-hover\:block {
        display: block;
    }

    .hidden {
        display: none;
    }

    .absolute {
        position: absolute;
    }

    .right-0 {
        right: 0;
    }

    .mt-2 {
        margin-top: 0.5rem;
    }

    .rounded-lg {
        border-radius: 0.5rem;
    }

    .shadow-lg {
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    }


    @media (max-width: 1100px) {
        .nav-group {
            gap: 2rem;
        }

        .icon-group {
            gap: 1.5rem;
        }
    }

    @media (max-width: 968px) {
        .hamburger {
            display: block;
        }

        .nav-group {
            position: fixed;
            top: 90px; /* Điều chỉnh theo chiều cao mới của navbar */
            left: -100%;
            width: 100%;
            height: calc(100vh - 90px); /* Điều chỉnh theo chiều cao mới của navbar */
            background-color: white;
            flex-direction: column;
            padding: 2rem;
            transition: left 0.3s ease;
            z-index: 1000;
        }

        .nav-group.active {
            left: 0;
        }

        .navbar {
            padding: 1.2rem; /* Tăng padding cho mobile */
        }

        .icon-group {
            gap: 1.2rem;
        }

        .icon-link span {
            display: none;
        }
    }

    /* Hamburger animation classes */
    .hamburger.active .hamburger-icon {
        background-color: transparent;
    }

    .hamburger.active .hamburger-icon::before {
        transform: rotate(45deg) translate(0, 0);
    }

    .hamburger.active .hamburger-icon::after {
        transform: rotate(-45deg) translate(0, 0);
    }

    @media (max-width: 480px) {
        .navbar {
            height: 80px; /* Giảm chiều cao cho màn hình nhỏ */
            padding: 15px 20px;
        }

        .logo {
            width: 50px;
            height: 50px;
        }

        .icon-group {
            gap: 1rem;
        }
    }
    /* Style cho phần auth buttons */
    .auth-buttons {
        display: flex;
        align-items: center;
        gap: 1rem;
    }

    .auth-button {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0.5rem 1rem;
        border-radius: 0.5rem;
        font-size: 0.875rem;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
    }

    .login-button {
        color: #534C45;
        display: flex;
        align-items: center;
    }

    .login-button:hover {
        color: #ff6b6b;
    }

    .register-button {
        background-color: #534C45;
        color: white;
        border: 1px solid #534C45;
    }

    .register-button:hover {
        background-color: #ff6b6b;
        border-color: #ff6b6b;
    }

    /* Style cho icon trong login button */
    .login-button svg {
        width: 20px;
        height: 20px;
    }

    /* Thêm styles cho dropdown */
    .group:hover .group-hover\:block {
        display: block;
    }

    .text-blue-600 {
        color: #2563EB;
    }

    /* Hover effect cho menu items */
    .hover\:bg-gray-50:hover {
        background-color: #F9FAFB;
    }

    /* Border styles */
    .border-gray-100 {
        border-color: #F3F4F6;
    }

    .border-b {
        border-bottom-width: 1px;
    }

    .border-t {
        border-top-width: 1px;
    }

    /* Text sizes */
    .text-xs {
        font-size: 0.75rem;
    }

    /* Spacing */
    .gap-2 {
        gap: 0.5rem;
    }
    /* Enhanced dropdown menu styles */
    .relative {
        position: relative;
    }

    .group:hover .group-hover\:block {
        display: block;
    }

    .hidden {
        display: none;
    }

    .absolute {
        position: absolute;
    }

    .right-0 {
        right: 0;
    }

    .mt-2 {
        margin-top: 0.5rem;
    }

    /* Avatar styles */
    .rounded-full {
        border-radius: 9999px;
    }

    .w-10 {
        width: 2.5rem;
    }

    .h-10 {
        height: 2.5rem;
    }

    .w-12 {
        width: 3rem;
    }

    .h-12 {
        height: 3rem;
    }

    .bg-\[\#B8472A\] {
        background-color: #B8472A;
    }

    .text-white {
        color: white;
    }

    .font-bold {
        font-weight: 700;
    }

    .font-medium {
        font-weight: 500;
    }

    .flex {
        display: flex;
    }

    .items-center {
        align-items: center;
    }

    .justify-center {
        justify-content: center;
    }

    .mr-2 {
        margin-right: 0.5rem;
    }

    .gap-3 {
        gap: 0.75rem;
    }

    /* Enhanced dropdown menu styling */
    .user-dropdown {
        position: absolute;
        right: 0;
        top: 100%;
        width: 280px;
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        margin-top: 10px;
        z-index: 1000;
        overflow: hidden;
        border: 1px solid rgba(0, 0, 0, 0.08);
        display: none;
        animation: fadeIn 0.2s ease-in-out;
    }

    .group:hover .user-dropdown {
        display: block;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .user-header {
        padding: 20px;
        border-bottom: 1px solid #f0f0f0;
        background-color: #f9f9f9;
    }

    .user-info {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .user-avatar {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background-color: #B8472A;
        color: white;
        font-weight: bold;
        font-size: 20px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .user-details {
        flex: 1;
    }

    .user-name {
        font-weight: 600;
        font-size: 16px;
        color: #333;
        margin-bottom: 3px;
    }

    .user-email {
        font-size: 14px;
        color: #666;
        word-break: break-all;
    }

    .menu-items {
        padding: 10px 0;
    }

    .menu-item {
        display: block;
        padding: 12px 20px;
        color: #333;
        text-decoration: none;
        font-size: 15px;
        transition: all 0.2s ease;
        position: relative;
    }

    .menu-item:hover {
        background-color: #f5f5f5;
        color: #B8472A;
    }

    .menu-item.danger {
        color: #e53935;
    }

    .menu-item.danger:hover {
        background-color: #ffebee;
    }

    .menu-divider {
        height: 1px;
        background-color: #f0f0f0;
        margin: 8px 0;
    }

    /* User avatar button */
    .user-avatar-button {
        display: flex;
        align-items: center;
        cursor: pointer;
        padding: 5px;
        border-radius: 30px;
        transition: all 0.2s ease;
    }

    .user-avatar-button:hover {
        background-color: rgba(0, 0, 0, 0.05);
    }

    .dropdown-arrow {
        margin-left: 5px;
        transition: transform 0.2s ease;
    }

    .group:hover .dropdown-arrow {
        transform: rotate(180deg);
    }
</style>
<div class="navbar-wrapper">
    <nav class="navbar">
        <button class="hamburger" onclick="toggleMenu()">
            <div class="hamburger-icon"></div>
        </button>

        <div class="nav-group">
            <a href="${pageContext.request.contextPath}/home" class="nav-link ${pageContext.request.servletPath == '/home' ? 'active' : ''}" data-page="home">Home</a>
            <a href="${pageContext.request.contextPath}/shop" class="nav-link ${pageContext.request.servletPath.contains('/shop') ? 'active' : ''}" data-page="shop">Shop</a>
            <a href="${pageContext.request.contextPath}/gifts" class="nav-link ${pageContext.request.servletPath.contains('/gifts') ? 'active' : ''}" data-page="gift">Gifts</a>
            <a href="${pageContext.request.contextPath}/about" class="nav-link ${pageContext.request.servletPath.contains('/about') ? 'active' : ''}" data-page="about">About</a>
            <a href="${pageContext.request.contextPath}/oil_exchange" class="nav-link ${pageContext.request.servletPath.contains('/oil_exchange') ? 'active' : ''}" data-page="contact">Oil exchange</a>
            <a href="${pageContext.request.contextPath}/contact" class="nav-link ${pageContext.request.servletPath.contains('/contact') ? 'active' : ''}" data-page="contact">Contact</a>
        </div>

        <div class="logo-container">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/logo.svg" alt="Candle Logo" class="logo">
            </a>
        </div>

        <div class="icon-group">
            <a href="${pageContext.request.contextPath}/wishlist" class="nav-link icon-link">
                <svg width="25" height="24" viewBox="0 0 25 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <g clip-path="url(#clip0_292_534)">
                        <g clip-path="url(#clip1_292_534)">
                            <mask id="mask0_292_534" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="0" y="1" width="25" height="25">
                                <path d="M24.7764 1.04639H0.776367V25.0464H24.7764V1.04639Z" fill="white"/>
                            </mask>
                            <g mask="url(#mask0_292_534)">
                                <path d="M18.2763 1.96338C17.1503 1.98089 16.0488 2.29523 15.0831 2.87465C14.1174 3.45407 13.3217 4.27805 12.7763 5.26338C12.231 4.27805 11.4353 3.45407 10.4696 2.87465C9.50387 2.29523 8.40238 1.98089 7.27633 1.96338C5.48127 2.04137 3.79003 2.82663 2.57211 4.14761C1.35419 5.46859 0.708575 7.2179 0.776326 9.01338C0.776326 15.7884 11.7323 23.6134 12.1983 23.9454L12.7763 24.3544L13.3543 23.9454C13.8203 23.6154 24.7763 15.7884 24.7763 9.01338C24.8441 7.2179 24.1985 5.46859 22.9806 4.14761C21.7626 2.82663 20.0714 2.04137 18.2763 1.96338ZM12.7763 21.8924C9.52333 19.4624 2.77633 13.4924 2.77633 9.01338C2.70797 7.74809 3.1427 6.50711 3.98569 5.56108C4.82869 4.61505 6.01156 4.04073 7.27633 3.96338C8.5411 4.04073 9.72397 4.61505 10.567 5.56108C11.41 6.50711 11.8447 7.74809 11.7763 9.01338H13.7763C13.708 7.74809 14.1427 6.50711 14.9857 5.56108C15.8287 4.61505 17.0116 4.04073 18.2763 3.96338C19.5411 4.04073 20.724 4.61505 21.567 5.56108C22.41 6.50711 22.8447 7.74809 22.7763 9.01338C22.7763 13.4944 16.0293 19.4624 12.7763 21.8924Z" fill="#534C45"/>
                            </g>
                        </g>
                    </g>
                    <defs>
                        <clipPath id="clip0_292_534">
                            <rect width="25" height="25" fill="white" transform="translate(0.000976562 0.679688)"/>
                        </clipPath>
                        <clipPath id="clip1_292_534">
                            <rect width="25" height="25" fill="white" transform="translate(0.000976562 0.679688)"/>
                        </clipPath>
                    </defs>
                </svg>
                <span>Wishlist</span>
                <c:if test="${not empty wishlistCount && wishlistCount > 0}">
                    <span class="icon-badge">${wishlistCount}</span>
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/cart" class="nav-link icon-link">
                <svg width="26" height="26" viewBox="0 0 26 26" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <g clip-path="url(#clip0_255_486)">
                        <g clip-path="url(#clip1_255_486)">
                            <g clip-path="url(#clip2_255_486)">
                                <mask id="mask0_255_486" style="mask-type:luminance" maskUnits="userSpaceOnUse" x="0" y="0" width="25" height="25">
                                    <path d="M24.8445 0.931641H0.844482V24.9316H24.8445V0.931641Z" fill="white"/>
                                </mask>
                                <g mask="url(#mask0_255_486)">
                                    <path d="M24.8444 3.93164H5.08648L5.04448 3.58064C4.95853 2.85105 4.60787 2.17837 4.05897 1.69011C3.51008 1.20186 2.80111 0.931983 2.06648 0.931641H0.844482V2.93164H2.06648C2.31141 2.93167 2.54782 3.02159 2.73085 3.18435C2.91389 3.34711 3.03082 3.57138 3.05948 3.81464L4.64448 17.2826C4.73043 18.0122 5.0811 18.6849 5.62999 19.1731C6.17889 19.6614 6.88785 19.9313 7.62248 19.9316H20.8444V17.9316H7.62248C7.37739 17.9316 7.14086 17.8415 6.95781 17.6785C6.77475 17.5156 6.65791 17.291 6.62948 17.0476L6.49848 15.9316H22.6804L24.8444 3.93164ZM21.0084 13.9316H6.26348L5.32248 5.93164H22.4514L21.0084 13.9316Z" fill="#534C45"/>
                                    <path d="M7.84448 24.9316C8.94905 24.9316 9.84448 24.0362 9.84448 22.9316C9.84448 21.827 8.94905 20.9316 7.84448 20.9316C6.73991 20.9316 5.84448 21.827 5.84448 22.9316C5.84448 24.0362 6.73991 24.9316 7.84448 24.9316Z" fill="#534C45"/>
                                    <path d="M17.8445 24.9316C18.9491 24.9316 19.8445 24.0362 19.8445 22.9316C19.8445 21.827 18.9491 20.9316 17.8445 20.9316C16.74 20.9316 15.8445 21.827 15.8445 22.9316C15.8445 24.0362 16.74 24.9316 17.8445 24.9316Z" fill="#534C45"/>
                                </g>
                            </g>
                        </g>
                    </g>
                    <defs>
                        <clipPath id="clip0_255_486">
                            <rect width="25" height="24.724" fill="white" transform="translate(0.350342 0.564941)"/>
                        </clipPath>
                        <clipPath id="clip1_255_486">
                            <rect width="25" height="25" fill="white" transform="translate(0.350342 0.564941)"/>
                        </clipPath>
                        <clipPath id="clip2_255_486">
                            <rect width="25" height="25" fill="white" transform="translate(0.350342 0.564941)"/>
                        </clipPath>
                    </defs>
                </svg>
                <span>Cart</span>
                <c:if test="${not empty cartCount && cartCount > 0}">
                    <span class="icon-badge">${cartCount}</span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <div class="relative group">
                        <!-- User avatar button -->
                        <div class="user-avatar-button">
                            <!-- Trong phần avatar button -->
                            <div class="user-avatar">
                                    ${fn:substring(sessionScope.user.username, 0, 1).toUpperCase()}
                            </div>
                            <svg xmlns="http://www.w3.org/2000/svg" class="dropdown-arrow" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 12 15 18 9"></polyline>
                            </svg>
                        </div>

                        <!-- Enhanced dropdown menu -->
                        <div class="user-dropdown">
                            <div class="user-header">
                                <div class="user-info">
                                    <div class="user-avatar">
                                            ${fn:substring(sessionScope.user.username, 0, 1).toUpperCase()}
                                    </div>
                                    <div class="user-details">
                                        <div class="user-name">${sessionScope.user.fullName}</div>
                                        <div class="user-email">${sessionScope.user.email}</div>
                                    </div>
                            </div>

                            <div class="menu-items">
                                <a href="${pageContext.request.contextPath}/profile" class="menu-item">
                                    <i class="fas fa-user-circle"></i> Profile
                                </a>
                                <a href="${pageContext.request.contextPath}/user/orders" class="menu-item">
                                    <i class="fas fa-shopping-bag"></i> My order
                                </a>
                                <div class="menu-divider"></div>
                                <a href="${pageContext.request.contextPath}/logout" class="menu-item danger">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- Phần hiển thị khi chưa đăng nhập -->
                    <div class="auth-buttons">
                        <a href="${pageContext.request.contextPath}/login" class="auth-button login-button">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M12 12C14.7614 12 17 9.76142 17 7C17 4.23858 14.7614 2 12 2C9.23858 2 7 4.23858 7 7C7 9.76142 9.23858 12 12 12Z" stroke="currentColor" stroke-width="1.5"/>
                                <path d="M20 21C20 18.2386 16.4183 16 12 16C7.58172 16 4 18.2386 4 21" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
                            </svg>
                            <span>Login</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="auth-button register-button">
                            <span>Register</span>
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>



        </div>
    </nav>
</div>

<script>
    function toggleMenu() {
        const navGroup = document.querySelector('.nav-group');
        const hamburger = document.querySelector('.hamburger');
        navGroup.classList.toggle('active');
        hamburger.classList.toggle('active');
    }
    let lastScrollTop = 0;
    const navbar = document.querySelector('.navbar-wrapper');

    window.addEventListener('scroll', () => {
        const scrollTop = window.pageYOffset || document.documentElement.scrollTop;

        if (scrollTop > lastScrollTop) {
            // Cuộn xuống
            navbar.style.transform = 'translateY(-100%)';
        } else {
            // Cuộn lên
            navbar.style.transform = 'translateY(0)';
        }

        lastScrollTop = scrollTop;
    });

</script>
