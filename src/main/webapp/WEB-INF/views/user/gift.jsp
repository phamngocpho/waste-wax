<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gift Exchange</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Playball:wght@400&display=swap" />
    <style>
        .title-decoration {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 20px;
            margin: 2rem 0;
        }

        .title-decoration::before,
        .title-decoration::after {
            content: "";
            height: 1px;
            background-color: #000;
            flex: 1;
        }
    </style>
    <script>
        function exchangePoints(voucherId, pointsRequired) {
            // Kiểm tra người dùng đã đăng nhập chưa
            if (${empty sessionScope.user}) {
                alert("Vui lòng đăng nhập để đổi điểm!");
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }

            // Kiểm tra người dùng có đủ điểm không
            const userPoints = ${sessionScope.user.points};
            if (userPoints < pointsRequired) {
                showToast("Bạn không đủ điểm để đổi voucher này!", "error");
                return;
            }

            // Xác nhận đổi điểm
            if (!confirm(`Bạn có chắc chắn muốn dùng ${pointsRequired} điểm để đổi voucher này không?`)) {
                return;
            }

            // Gửi yêu cầu AJAX để đổi điểm
            fetch('${pageContext.request.contextPath}/redeem', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `voucherId=${voucherId}&userId=${sessionScope.user.id}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast(data.message, "success");
                        // Cập nhật số điểm hiển thị
                        document.getElementById('userPoints').textContent = userPoints - pointsRequired;
                        // Reload trang sau 1.5 giây
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        showToast(data.message || "Có lỗi xảy ra khi đổi voucher!", "error");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast("Có lỗi xảy ra khi đổi voucher!", "error");
                });
        }
        function exchangePoints(voucherId, pointsRequired) {
            // Kiểm tra người dùng đã đăng nhập chưa
            if (${empty sessionScope.user}) {
                alert("Vui lòng đăng nhập để đổi điểm!");
                window.location.href = "${pageContext.request.contextPath}/login";
                return;
            }

            // Kiểm tra người dùng có đủ điểm không
            const userPoints = ${sessionScope.user.points};
            if (userPoints < pointsRequired) {
                showToast("Bạn không đủ điểm để đổi voucher này!", "error");
                return;
            }

            // Xác nhận đổi điểm
            if (!confirm(`Bạn có chắc chắn muốn dùng ${pointsRequired} điểm để đổi voucher này không?`)) {
                return;
            }

            // Gửi yêu cầu AJAX để đổi điểm
            const formData = new URLSearchParams();
            formData.append('voucherId', voucherId);

            fetch('${pageContext.request.contextPath}/redeem', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showToast(data.message, "success");
                        // Cập nhật số điểm hiển thị
                        document.getElementById('userPoints').textContent = data.userPoints;
                        // Reload trang sau 1.5 giây
                        setTimeout(() => {
                            window.location.reload();
                        }, 1500);
                    } else {
                        showToast(data.message || "Có lỗi xảy ra khi đổi voucher!", "error");
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast("Có lỗi xảy ra khi đổi voucher!", "error");
                });
        }


        function showToast(message, type) {
            const toast = document.getElementById('toast');
            const toastMessage = document.getElementById('toastMessage');

            // Set message and style based on type
            toastMessage.textContent = message;

            if (type === "success") {
                toast.className = "fixed bottom-4 right-4 bg-green-50 text-green-600 shadow-lg rounded-lg p-4 flex items-center";
            } else if (type === "error") {
                toast.className = "fixed bottom-4 right-4 bg-red-50 text-red-600 shadow-lg rounded-lg p-4 flex items-center";
            } else {
                toast.className = "fixed bottom-4 right-4 bg-white shadow-lg rounded-lg p-4 flex items-center";
            }

            // Show toast
            toast.classList.remove("hidden");

            // Hide after 3 seconds
            setTimeout(() => {
                toast.classList.add("hidden");
            }, 3000);
        }
    </script>
</head>
<body>
<!-- Include Navigation -->
<jsp:include page="layouts/nav.jsp" />

<!-- Hero Section -->
<div class="relative w-full h-[550px]">
    <img src="${pageContext.request.contextPath}/images/gift-hero.jpg" alt="Oil recycling banner" class="w-full h-full object-cover">
    <div class="absolute top-1/3 left-1/2 -translate-x-1/2 -translate-y-1/2 text-left w-full px-4">
        <h1 class="font-['Playball'] text-4xl md:text-5xl text-[#B8860B] ml-32">
            Exchange used oil for scented candles
        </h1>
        <p class="font-['Playball'] text-2xl md:text-3xl text-[#DAA520] mt-2 ml-48">
            Care for the earth, light up your life!
        </p>
    </div>
</div>

<!-- Point Display Section -->
<!-- Point Display Section -->
<div class="max-w-6xl mx-auto px-4 py-4 mt-8">
    <c:if test="${not empty sessionScope.user}">
        <div class="bg-white bg-opacity-80 backdrop-blur-sm p-6 rounded-lg flex justify-between items-center shadow-md mx-auto max-w-md">
            <div class="text-left">
                <p class="text-[#8B4513] font-medium text-2xl">TOTAL</p>
                <p class="text-[#8B4513] font-medium text-2xl">POINTS</p>
            </div>
            <div class="text-right">
                <span id="userPoints" class="font-bold text-[#8B4513] text-6xl">${sessionScope.user.points}</span>
            </div>
        </div>
    </c:if>
</div>


<!-- Trade Section -->
<div class="max-w-4xl mx-auto px-4 py-4 mt-16">
    <h2 class="font-['Playball'] text-4xl text-[#654321] text-center mb-4">
        Trade used oil for candles
    </h2>

    <div class="relative">
        <img src="${pageContext.request.contextPath}/images/trade.jpg" alt="Oil and candle exchange" class="w-full rounded-lg" />
    </div>
</div>

<!-- Gift Section -->
<div class="max-w-6xl mx-auto px-4 py-8">
    <div class="title-decoration">
        <h2 class="text-3xl font-playfair px-4">Gift for you</h2>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
        <!-- Red Candle -->
        <div class="text-center">
            <div class="relative mb-4">
                <img src="${pageContext.request.contextPath}/images/red-candle.png" alt="Red Candle" class="w-full rounded-lg">
            </div>
            <h3 class="text-lg font-medium mb-2">Red Candle</h3>
            <button onclick="exchangeCandle('red', 100)" class="bg-pink-100 text-pink-500 px-4 py-1 rounded-full text-sm">
                Exchange 100 point
            </button>
        </div>

        <!-- Pink Candle -->
        <div class="text-center">
            <div class="relative mb-4">
                <img src="${pageContext.request.contextPath}/images/pink-candle.png" alt="Pink Candle" class="w-full rounded-lg">
            </div>
            <h3 class="text-lg font-medium mb-2">Pink Candle</h3>
            <button onclick="exchangeCandle('pink', 100)" class="bg-pink-100 text-pink-500 px-4 py-1 rounded-full text-sm">
                Exchange 100 point
            </button>
        </div>

        <!-- Purple Candle -->
        <div class="text-center">
            <div class="relative mb-4">
                <img src="${pageContext.request.contextPath}/images/purple-candle.png" alt="Purple Candle" class="w-full rounded-lg">
            </div>
            <h3 class="text-lg font-medium mb-2">Purple Candle</h3>
            <button onclick="exchangeCandle('purple', 100)" class="bg-pink-100 text-pink-500 px-4 py-1 rounded-full text-sm">
                Exchange 100 point
            </button>
        </div>

        <!-- Green Candle -->
        <div class="text-center">
            <div class="relative mb-4">
                <img src="${pageContext.request.contextPath}/images/green-candle.png" alt="Green Candle" class="w-full rounded-lg">
            </div>
            <h3 class="text-lg font-medium mb-2">Green Candle</h3>
            <button onclick="exchangeCandle('green', 100)" class="bg-pink-100 text-pink-500 px-4 py-1 rounded-full text-sm">
                Exchange 100 point
            </button>
        </div>
    </div>

    <!-- Voucher Section -->
    <!-- Voucher Section -->
    <div class="title-decoration">
        <h2 class="text-3xl font-playfair px-4">Voucher</h2>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
        <c:forEach items="${availableVouchers}" var="voucher">
            <div class="bg-pink-50 p-6 rounded-lg text-center">
                <h3 class="text-5xl font-bold text-pink-300 mb-4">${voucher.discountPercent}%</h3>
                <p class="text-lg text-gray-700 mb-2">${voucher.description}</p>
                <c:if test="${not empty voucher.minOrderValue}">
                    <p class="text-sm text-gray-500 mb-2">Đơn hàng tối thiểu: <fmt:formatNumber value="${voucher.minOrderValue}" type="currency" currencySymbol="₫" /></p>
                </c:if>
                <c:if test="${not empty voucher.maxDiscountAmount}">
                    <p class="text-sm text-gray-500 mb-2">Giảm tối đa: <fmt:formatNumber value="${voucher.maxDiscountAmount}" type="currency" currencySymbol="₫" /></p>
                </c:if>
                <button onclick="exchangePoints(${voucher.id}, ${voucher.pointsRequired})" class="bg-pink-100 text-pink-500 px-4 py-1 rounded-full text-sm">
                    Exchange ${voucher.pointsRequired} point
                </button>
            </div>
        </c:forEach>
    </div>
</div>

<!-- My Vouchers Section (only visible to logged-in users) -->
<c:if test="${not empty sessionScope.user}">
    <div class="max-w-6xl mx-auto px-4 py-8">
        <div class="title-decoration">
            <h2 class="text-3xl font-playfair px-4">My Vouchers</h2>
        </div>

        <c:if test="${empty userVouchers}">
            <p class="text-center text-gray-500 py-8">Bạn chưa có voucher nào</p>
        </c:if>

        <c:if test="${not empty userVouchers}">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <c:forEach items="${userVouchers}" var="userVoucher">
                    <div class="bg-white border border-gray-200 p-4 rounded-lg">
                        <div class="flex justify-between items-center mb-2">
                            <h3 class="text-xl font-bold">${userVoucher.voucher.discountPercent}% OFF</h3>
                            <span class="px-2 py-1 text-xs rounded ${userVoucher.isUsed ? 'bg-gray-100 text-gray-500' : 'bg-green-100 text-green-600'}">
                                    ${userVoucher.isUsed ? 'Đã sử dụng' : 'Chưa sử dụng'}
                            </span>
                        </div>
                        <p class="text-sm text-gray-600 mb-1">Mã: ${userVoucher.voucher.code}</p>
                        <p class="text-sm text-gray-600 mb-1">Hạn sử dụng: ${userVoucher.formattedExpiryDate}</p>
                        <c:if test="${not empty userVoucher.voucher.minOrderValue}">
                            <p class="text-xs text-gray-500">Đơn hàng tối thiểu: <fmt:formatNumber value="${userVoucher.voucher.minOrderValue}" type="currency" currencySymbol="₫" /></p>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</c:if>

<!-- Toast Message -->
<div id="toast" class="fixed bottom-4 right-4 bg-white shadow-lg rounded-lg p-4 hidden">
    <p id="toastMessage" class="text-gray-800"></p>
</div>

<!-- Include Footer -->
<jsp:include page="layouts/footer.jsp" />
</body>
</html>
