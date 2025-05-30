<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Giỏ hàng - Candle Shop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brown: {
                            600: '#4A3427',
                            700: '#5D4435',
                        }
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-gray-50">
<jsp:include page="layouts/nav.jsp" />

<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 pt-10">
    <h1 class="text-2xl font-semibold text-gray-900 mb-8">Giỏ hàng của bạn</h1>
    <c:if test="${empty cartItems}">
        <div class="text-center py-16">
            <p class="text-gray-500 mb-4">Giỏ hàng của bạn đang trống</p>
            <a href="${pageContext.request.contextPath}/shop"
               class="inline-block bg-brown-600 text-white px-6 py-3 rounded-md
                          hover:bg-brown-700 transition-colors">
                Tiếp tục mua sắm
            </a>
        </div>
    </c:if>
    <c:if test="${not empty cartItems}">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Cart Items -->
            <div class="lg:col-span-2 space-y-4">
                <c:forEach items="${cartItems}" var="item">
                    <div class="bg-white rounded-lg shadow-sm p-6 flex items-center space-x-4">
                        <!-- Thêm checkbox để chọn sản phẩm -->
                        <div class="flex items-center">
                            <input type="checkbox" id="select-item-${item.id}"
                                   class="select-item w-5 h-5 text-brown-600 rounded border-gray-300 focus:ring-brown-500"
                                   data-id="${item.id}"
                                   data-price="${item.productSize.price * item.quantity}">
                        </div>
                        <img src="${pageContext.request.contextPath}/uploads/${not empty item.product.images ? item.product.images[0].imageUrl : 'default.jpg'}"
                             alt="${item.product.name}"
                             class="w-24 h-24 object-cover rounded-md">

                        <div class="flex-1">
                            <h3 class="font-medium text-gray-900">${item.product.name}</h3>
                            <p class="text-gray-500">Size: ${item.productSize.sizeValue}ml</p>
                            <p class="text-gray-700">
                                <fmt:formatNumber value="${item.productSize.price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                            </p>
                        </div>
                            <div class="flex items-center border rounded-md">
                                <label for="quantity-${item.id}">
                                </label><input type="number" value="${item.quantity}"
                                                                                min="1"
                                                                                class="w-12 text-center border-x py-1"
                                                                                onchange="updateQuantity(${item.id}, this.value, true)"
                                                                                id="quantity-${item.id}">
                            </div>
                        <div class="text-right">
                            <p class="font-medium text-gray-900">
                                <fmt:formatNumber value="${item.productSize.price * item.quantity}" type="number" groupingUsed="true" maxFractionDigits="0"/>
                            </p>

                            <button>
                            <a href="${pageContext.request.contextPath}/cart/remove/${item.id}"
                               class="text-red-500 hover:text-red-700 mt-2"
                               onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')">
                                <i class="fas fa-trash"></i>
                            </a>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Order Summary -->
            <div class="bg-white rounded-lg shadow-sm p-6 h-fit">
                <h2 class="text-lg font-medium text-gray-900 mb-4">Tổng quan đơn hàng</h2>

                <!-- Hiển thị các sản phẩm đã chọn -->
                <div id="selected-items" class="mb-4 space-y-2">
                </div>

                <div class="border-t border-gray-200 pt-4 space-y-2">
                    <div class="flex justify-between">
                        <span class="text-gray-600">Tổng tiền hàng</span>
                        <span id="subtotal" class="font-medium">0 VND</span>
                    </div>
                </div>
                <div class="border-t border-gray-200 mt-4 pt-4 flex justify-between">
                    <span class="text-gray-800 font-medium">Tổng thanh toán</span>
                    <span id="total" class="text-xl font-semibold text-brown-600">0 VND</span>
                </div>
                <button id="checkout-btn"
                        class="w-full bg-brown-600 text-white py-3 px-4 rounded-md mt-6
                               hover:bg-brown-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                    Thanh toán
                </button>
            </div>
        </div>
    </c:if>
</div>

<script>
    // Lưu trữ các sản phẩm đã chọn
    let selectedItems = [];
    let totalAmount = 0;

    function formatCurrency(amount) {
        // Định dạng số với dấu phân cách hàng nghìn
        const formattedNumber = new Intl.NumberFormat('vi-VN', {
            maximumFractionDigits: 0
        }).format(amount);

        // Thêm "VND" vào sau số đã định dạng
        return formattedNumber + " VND";
    }


    // Xử lý khi checkbox thay đổi
    document.addEventListener('DOMContentLoaded', function() {
        const checkboxes = document.querySelectorAll('.select-item');
        const checkoutBtn = document.getElementById('checkout-btn');

        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateSelectedItems);
        });

        // Vô hiệu hóa nút thanh toán ban đầu
        checkoutBtn.disabled = true;

        // Xử lý nút thanh toán
        checkoutBtn.addEventListener('click', function() {
            if (selectedItems.length > 0) {
                // Tạo form ẩn để gửi dữ liệu
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/checkout';

                // Thêm các sản phẩm đã chọn vào form
                const itemsInput = document.createElement('input');
                itemsInput.type = 'hidden';
                itemsInput.name = 'selectedItems';
                itemsInput.value = JSON.stringify(selectedItems);
                form.appendChild(itemsInput);

                document.body.appendChild(form);
                form.submit();
            }
        });
    });

    function updateSelectedItems() {
        const checkboxes = document.querySelectorAll('.select-item:checked');
        const selectedItemsContainer = document.getElementById('selected-items');
        const subtotalElement = document.getElementById('subtotal');
        const totalElement = document.getElementById('total');
        const checkoutBtn = document.getElementById('checkout-btn');

        selectedItems = [];
        totalAmount = 0;

        // Xóa nội dung cũ
        selectedItemsContainer.innerHTML = '';

        // Thêm các sản phẩm đã chọn
        checkboxes.forEach(checkbox => {
            const itemId = checkbox.getAttribute('data-id');
            const itemPrice = parseFloat(checkbox.getAttribute('data-price'));

            selectedItems.push({
                id: itemId,
                price: itemPrice
            });

            totalAmount += itemPrice;

            // Tìm thẻ div cha chứa thông tin sản phẩm
            const productContainer = checkbox.closest('.bg-white');

            // Hiển thị sản phẩm đã chọn
            const itemElement = document.createElement('div');
            itemElement.className = 'flex justify-between text-sm';
            // Sử dụng hàm JavaScript formatCurrency thay vì EL
            const formattedPrice = formatCurrency(itemPrice);
            itemElement.innerHTML = `
            <span class="text-gray-600">${productName}</span>
            <span class="font-medium">${formattedPrice}</span>
        `;

            selectedItemsContainer.appendChild(itemElement);
        });

        // Cập nhật tổng tiền
        subtotalElement.textContent = formatCurrency(totalAmount);
        totalElement.textContent = formatCurrency(totalAmount);

        // Kích hoạt/vô hiệu hóa nút thanh toán
        checkoutBtn.disabled = selectedItems.length === 0;
    }

    function updateQuantity(itemId, change, isDirectInput = false) {
        let quantityInput = document.getElementById(`quantity-${itemId}`);
        let currentQuantity = parseInt(quantityInput.value);
        let newQuantity;

        if (isDirectInput) {
            newQuantity = parseInt(change);
        } else {
            newQuantity = currentQuantity + parseInt(change);
        }

        if (newQuantity < 1) {
            newQuantity = 1;
        }

        // Gửi request cập nhật số lượng
        fetch(`${pageContext.request.contextPath}/cart/update`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `itemId=${itemId}&quantity=${newQuantity}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    quantityInput.value = newQuantity;
                    // Cập nhật tổng giá
                    updateTotalPrice();
                } else {
                    alert('Có lỗi xảy ra khi cập nhật số lượng');
                }
            });
    }

    function updateTotalPrice() {
        location.reload();
    }
</script>

<jsp:include page="layouts/footer.jsp" />
</body>
</html>
