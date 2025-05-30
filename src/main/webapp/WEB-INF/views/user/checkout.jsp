<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Thanh toán - Candle Shop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
<jsp:include page="layouts/nav.jsp"/>

<div class="max-w-7xl mx-auto px-4 py-8">
    <h1 class="text-2xl font-semibold mb-6">Thanh toán</h1>

    <!-- Hiển thị các bước thanh toán -->
    <div class="flex items-center justify-center mb-8">
        <div class="flex items-center">
            <div class="bg-brown-600 text-white rounded-full w-8 h-8 flex items-center justify-center">1</div>
            <span class="ml-2 text-brown-600 font-medium">Giỏ hàng</span>
        </div>
        <div class="h-1 w-16 bg-brown-600 mx-2"></div>
        <div class="flex items-center">
            <div class="bg-brown-600 text-white rounded-full w-8 h-8 flex items-center justify-center">2</div>
            <span class="ml-2 text-brown-600 font-medium">Thanh toán</span>
        </div>
        <div class="h-1 w-16 bg-gray-300 mx-2"></div>
        <div class="flex items-center">
            <div class="bg-gray-300 text-gray-600 rounded-full w-8 h-8 flex items-center justify-center">3</div>
            <span class="ml-2 text-gray-600">Hoàn tất</span>
        </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Cột bên trái - Review đơn hàng -->
        <div class="space-y-6">
            <div class="bg-white rounded-lg shadow p-6">
                <h2 class="text-lg font-medium mb-4">Xem lại đơn hàng</h2>

                <!-- Danh sách sản phẩm -->
                <div class="space-y-4">
                    <c:forEach items="${checkoutItems}" var="item">
                        <div class="flex items-center space-x-4 border-b pb-4">
                            <img src="${pageContext.request.contextPath}/uploads/${empty item.product.images ? 'default.jpg' : item.product.images[0].imageUrl}"
                                 alt="${item.product.name}"
                                 class="w-20 h-20 object-cover rounded">
                            <div class="flex-1">
                                <h3 class="font-medium">${item.product.name}</h3>
                                <p class="text-sm text-gray-500">Size: ${item.productSize.sizeValue}ml</p>
                                <p class="text-sm">Số lượng: ${item.quantity}</p>

                                <!-- Bảng giá chi tiết cho từng sản phẩm -->
                                <div class="mt-2 space-y-1">
                                    <div class="flex justify-between text-sm">
                                        <span>Đơn giá:</span>
                                        <span><fmt:formatNumber value="${item.price}" type="currency"
                                                                currencySymbol="₫"/></span>
                                    </div>
                                    <div class="flex justify-between text-sm">
                                        <span>Thành tiền:</span>
                                        <span><fmt:formatNumber value="${item.total}" type="currency"
                                                                currencySymbol="₫"/></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Bảng tổng kết -->
                <div class="mt-6 border-t pt-4">
                    <h3 class="text-lg font-medium mb-4">Tổng đơn hàng</h3>

                    <!-- Tổng tiền và giảm giá -->
                    <div class="space-y-2 border-t pt-2">
                        <div class="flex justify-between">
                            <span class="text-gray-600">Tổng tiền hàng:</span>
                            <span id="subtotal">
                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="₫"/>
                            </span>
                        </div>

                        <!-- Phần hiển thị voucher đã áp dụng -->
                        <div id="discount-section" class="flex justify-between text-green-600" style="display: none;">
                            <span>Giảm giá:</span>
                            <span id="discount-amount">-₫0</span>
                        </div>

                        <!-- Phí vận chuyển -->
                        <div class="flex justify-between text-gray-600">
                            <span>Phí vận chuyển:</span>
                            <span>
                                <fmt:formatNumber value="${shippingFee}" type="currency" currencySymbol="₫"/>
                            </span>
                        </div>

                        <!-- Tổng thanh toán -->
                        <div class="flex justify-between font-bold text-lg border-t pt-2">
                            <span>Tổng thanh toán:</span>
                            <span id="final-total" class="text-brown-600">
                                <fmt:formatNumber value="${totalAmount + shippingFee}" type="currency"
                                                  currencySymbol="₫"/>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Phần voucher -->
            <div class="bg-white rounded-lg shadow p-6">
                <h2 class="text-lg font-medium mb-4">Mã giảm giá</h2>

                <c:choose>
                    <c:when test="${not empty availableVouchers}">
                        <div class="space-y-3">
                            <c:forEach items="${availableVouchers}" var="userVoucher">
                                <div class="border rounded-lg p-3 hover:border-brown-600 cursor-pointer voucher-item"
                                     data-id="${userVoucher.id}" data-code="${userVoucher.voucher.code}">
                                    <div class="flex justify-between items-center">
                                        <div>
                                            <div class="font-medium">${userVoucher.voucher.code}</div>
                                            <div class="text-sm text-gray-600">
                                                Giảm ${userVoucher.voucher.discountPercent}%
                                                <c:if test="${userVoucher.voucher.maxDiscountAmount != null}">
                                                    (tối đa <fmt:formatNumber
                                                        value="${userVoucher.voucher.maxDiscountAmount}" type="currency"
                                                        currencySymbol="₫"/>)
                                                </c:if>
                                            </div>
                                            <div class="text-xs text-gray-500">
                                                Hết hạn: ${userVoucher.expiryDate}
                                            </div>
                                        </div>
                                        <button class="apply-voucher bg-brown-600 text-white px-3 py-1 rounded hover:bg-brown-700"
                                                data-id="${userVoucher.id}">
                                            Áp dụng
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-500">Bạn không có mã giảm giá nào khả dụng.</p>
                    </c:otherwise>
                </c:choose>

                <!-- Hiển thị voucher đã áp dụng -->
                <div id="applied-voucher" class="mt-4 p-3 bg-green-50 rounded-lg border border-green-200"
                     style="display: none;">
                    <div class="flex justify-between items-center">
                        <div>
                            <div class="text-green-700 font-medium">Đã áp dụng mã: <span
                                    id="applied-voucher-code"></span></div>
                            <div id="applied-voucher-discount" class="text-sm text-green-600"></div>
                        </div>
                        <button id="remove-voucher" class="text-red-600 hover:text-red-800">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24"
                                 stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M6 18L18 6M6 6l12 12"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cột bên phải - Thông tin thanh toán -->
        <div class="space-y-6">
            <div class="bg-white rounded-lg shadow p-6">
                <h2 class="text-lg font-medium mb-4">Thông tin giao hàng</h2>

                <form id="checkout-form" method="post" action="${pageContext.request.contextPath}/place-order">
                    <div class="space-y-4">
                        Copy
                        <div>
                            <label for="shippingName" class="block text-sm font-medium text-gray-700 mb-1">Full name of
                                recipient</label>
                            <input type="text" name="shippingName" id="shippingName" value="${fullName}" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-brown-600 focus:border-brown-600">
                        </div>

                        <div>
                            <label for="shippingPhone" class="block text-sm font-medium text-gray-700 mb-1">Phone
                                number</label>
                            <input type="tel" name="shippingPhone" id="shippingPhone" value="${phone}" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-brown-600 focus:border-brown-600">
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Your Email</label>
                            <input type="email" name="customerEmail" id="email" value="${email}" required
                                   class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-brown-600 focus:border-brown-600">
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Địa chỉ giao hàng</label>
                            <textarea name="shippingAddress" required rows="3"
                                      class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-brown-600 focus:border-brown-600"></textarea>
                        </div>

                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Phương thức thanh toán</label>
                            <div class="space-y-2">
                                <div class="flex items-center">
                                    <input id="payment-cod" type="radio" name="paymentMethodId" value="1" checked
                                           class="h-4 w-4 text-brown-600 focus:ring-brown-600">
                                    <label for="payment-cod" class="ml-2 text-sm text-gray-700">
                                        Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div class="flex items-center">
                                    <input id="payment-bank" type="radio" name="paymentMethodId" value="2"
                                           class="h-4 w-4 text-brown-600 focus:ring-brown-600">
                                    <label for="payment-bank" class="ml-2 text-sm text-gray-700">
                                        Chuyển khoản ngân hàng
                                    </label>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden fields for checkout data -->
                        <input type="hidden" id="applied-voucher-id" name="userVoucherId">
                        <input type="hidden" id="discount-value" name="discountAmount" value="0">
                        <input type="hidden" id="final-total-value" name="finalAmount"
                               value="${totalAmount + shippingFee}">

                        <div class="pt-4">
                            <button type="submit"
                                    class="w-full bg-brown-600 text-white py-2 px-4 rounded-md hover:bg-brown-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-brown-600">
                                Đặt hàng
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Áp dụng voucher
        $('.apply-voucher').click(function () {
            const userVoucherId = $(this).data('id');

            $.ajax({
                url: '${pageContext.request.contextPath}/checkout/apply-voucher',
                type: 'POST',
                data: {
                    userVoucherId: userVoucherId
                },
                success: function (response) {
                    if (response.success) {
                        // Hiển thị thông tin giảm giá
                        $('#discount-section').show();
                        $('#discount-amount').text('-₫' + response.discount.toLocaleString('vi-VN'));

                        // Cập nhật tổng tiền
                        $('#final-total').text('₫' + response.finalTotal.toLocaleString('vi-VN'));

                        // Hiển thị voucher đã áp dụng
                        $('#applied-voucher').show();
                        $('#applied-voucher-code').text(response.voucherCode);
                        $('#applied-voucher-discount').text('Giảm: ₫' + response.discount.toLocaleString('vi-VN'));

                        // Cập nhật hidden fields
                        $('#applied-voucher-id').val(userVoucherId);
                        $('#discount-value').val(response.discount);
                        $('#final-total-value').val(response.finalTotal);

                        // Thông báo thành công
                        alert(response.message);
                    } else {
                        // Thông báo lỗi
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('Có lỗi xảy ra khi áp dụng voucher');
                }
            });
        });

        // Xóa voucher đã áp dụng
        $('#remove-voucher').click(function () {
            // Ẩn thông tin giảm giá
            $('#discount-section').hide();
            $('#applied-voucher').hide();

            // Khôi phục tổng tiền ban đầu
            const subtotal = parseFloat('${totalAmount}');
            const shipping = parseFloat('${shippingFee}');
            const total = subtotal + shipping;

            $('#final-total').text('₫' + total.toLocaleString('vi-VN'));

            // Xóa dữ liệu voucher
            $('#applied-voucher-id').val('');
            $('#discount-value').val(0);
            $('#final-total-value').val(total);
        });
    });
</script>

</body>
</html>
