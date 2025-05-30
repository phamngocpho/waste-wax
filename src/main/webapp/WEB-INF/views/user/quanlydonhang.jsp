<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - Candle Shop</title>
    <link rel="stylesheet" href="/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<jsp:include page="layouts/nav.jsp" />

<div class="container my-5">
    <h2 class="text-center mb-4">Đơn hàng của tôi</h2>

    <c:if test="${empty orders}">
        <div class="text-center py-5">
            <h5>Bạn chưa có đơn hàng nào</h5>
            <a href="/shop" class="btn btn-primary mt-3">Mua sắm ngay</a>
        </div>
    </c:if>

    <c:if test="${not empty orders}">
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                <tr>
                    <th>Mã đơn hàng</th>
                    <th>Ngày đặt</th>
                    <th>Tổng tiền</th>
                    <th>Trạng thái đơn hàng</th>
                    <th>Trạng thái thanh toán</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>${order.orderNumber}</td>
                        <td><fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                        <td><fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        <td>
                                    <span class="badge bg-${order.orderStatus == 'DELIVERED' ? 'success' :
                                                          order.orderStatus == 'CANCELLED' ? 'danger' :
                                                          order.orderStatus == 'PROCESSING' ? 'primary' :
                                                          'warning'}">
                                            ${order.orderStatus}
                                    </span>
                        </td>
                        <td>
                                    <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' :
                                                          order.paymentStatus == 'FAILED' ? 'danger' :
                                                          'warning'}">
                                            ${order.paymentStatus}
                                    </span>
                        </td>
                        <td>
                            <a href="/user/orders/${order.id}" class="btn btn-sm btn-outline-primary">Chi tiết</a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
</div>

<jsp:include page="layouts/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
