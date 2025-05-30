<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng - Candle Shop</title>
    <link rel="stylesheet" href="/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-detail {
            max-width: 900px;
            margin: 0 auto;
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .order-items {
            margin-bottom: 30px;
        }
        .order-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        .order-summary {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
        }
        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
        }
    </style>
</head>
<body>
<jsp:include page="layouts/nav.jsp" />

<div class="container my-5">
    <div class="order-detail">
        <h2 class="text-center mb-4">Chi tiết đơn hàng</h2>

        <div class="order-header">
            <div class="row">
                <div class="col-md-6">
                    <h5>Thông tin đơn hàng</h5>
                    <p>Mã đơn hàng: <strong>${order.orderNumber}</strong></p>
                    <p>Ngày đặt: <strong><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></strong></p>
                    <p>Trạng thái:
                        <span class="badge bg-${order.orderStatus == 'DELIVERED' ? 'success' :
                                              order.orderStatus == 'CANCELLED' ? 'danger' :
                                              order.orderStatus == 'PROCESSING' ? 'primary' :
                                              'warning'}">
                            ${order.orderStatus}
                        </span>
                    </p>
                    <p>Trạng thái thanh toán:
                        <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' :
                                              order.paymentStatus == 'FAILED' ? 'danger' :
                                              'warning'}">
                            ${order.paymentStatus}
                        </span>
                    </p>
                    <p>Phương thức thanh toán: <strong>${order.paymentMethod.name}</strong></p>
                </div>
                <div class="col-md-6">
                    <h5>Thông tin giao hàng</h5>
                    <p>Người nhận: <strong>${order.shippingName}</strong></p>
                    <p>Số điện thoại: <strong>${order.shippingPhone}</strong></p>
                    <p>Địa chỉ: <strong>${order.shippingAddress}</strong></p>
                </div>
            </div>
        </div>

        <h5>Sản phẩm đã đặt</h5>
        <div class="order-items">
            <c:forEach items="${order.orderItems}" var="item">
                <div class="order-item">
                    <div class="row align-items-center">
                        <div class="col-md-2">
                            <c:if test="${not empty item.product.productImages}">
                                <img src="${item.product.productImages[0].imageUrl}" alt="${item.product.name}" class="product-image">
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <h6>${item.product.name}</h6>
                            <p class="text-muted mb-0">Kích thước: ${item.productSize.size}</p>
                            <p class="text-muted mb-0">Số lượng: ${item.quantity}</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <p class="mb-0"><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/> x ${item.quantity}</p>
                            <p class="fw-bold mb-0"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></p>
                            <jsp:useBean id="order" scope="request" type="com.example.CandleShop.entity.Order"/>
                            <c:if test="${order.orderStatus == 'DELIVERED' && !item.isReviewed}">
                                <a href="/user/review/add?orderItemId=${item.id}" class="btn btn-sm btn-outline-primary mt-2">Đánh giá</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="order-summary">
            <div class="row mb-2">
                <div class="col-6">Tạm tính:</div>
                <div class="col-6 text-end"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
            </div>
            <div class="row mb-2">
                <div class="col-6">Phí vận chuyển:</div>
                <div class="col-6 text-end"><fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
            </div>
            <c:if test="${order.discountAmount > 0}">
                <div class="row mb-2">
                    <div class="col-6">Giảm giá:</div>
                    <div class="col-6 text-end">-<fmt:formatNumber value="${order.discountAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                </div>
            </c:if>
            <hr>
            <div class="row fw-bold">
                <div class="col-6">Tổng cộng:</div>
                <div class="col-6 text-end"><fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
            </div>
        </div>

        <div class="text-center mt-4">
            <a href="/user/orders" class="btn btn-outline-secondary">Quay lại danh sách đơn hàng</a>
            <c:if test="${order.orderStatus == 'PENDING' && order.paymentStatus != 'PAID'}">
                <a href="/checkout/payment?orderId=${order.id}" class="btn btn-primary ms-2">Thanh toán</a>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="layouts/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
