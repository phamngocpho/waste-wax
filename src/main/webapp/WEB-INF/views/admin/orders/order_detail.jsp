<!-- order-detail.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../layouts/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../layouts/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid">
        <div class="container-fluid">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h3 class="mb-0">Chi tiết đơn hàng #${order.orderNumber}</h3>
                    <a href="/admin/orders" class="btn btn-secondary">Quay lại</a>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5>Thông tin khách hàng</h5>
                            <table class="table table-borderless">
                                <tr>
                                    <td>Họ tên:</td>
                                    <td>${order.user.username}</td>
                                </tr>
                                <tr>
                                    <td>Số điện thoại:</td>
                                    <td>${order.shippingPhone}</td>
                                </tr>
                                <tr>
                                    <td>Địa chỉ:</td>
                                    <td>${order.shippingAddress}</td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h5>Thông tin đơn hàng</h5>
                            <table class="table table-borderless">
                                <tr>
                                    <td>Ngày đặt:</td>
                                    <td>
                                        <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Tổng tiền hàng:</td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                </tr>
                                <tr>
                                    <td>Phí vận chuyển:</td>
                                    <td><fmt:formatNumber value="${order.shippingFee}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                </tr>
                                <tr>
                                    <td>Tổng thanh toán:</td>
                                    <td><strong><fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong></td>
                                </tr>
                                <tr>
                                    <td>Trạng thái thanh toán:</td>
                                    <td>
                                        <span class="badge bg-${order.paymentStatus == 'PAID' ? 'success' : 'warning'}">
                                            ${order.paymentStatus == 'PAID' ? 'Chưa thanh toán' : 'Đã thanh toán'}
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <form action="/admin/orders/${order.id}/update-status" method="post" class="mb-4">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="orderStatus">Trạng thái đơn hàng:</label>
                                    <select name="orderStatus" id="orderStatus" class="form-control">
                                        <c:forEach items="${orderStatuses}" var="status">
                                            <option value="${status}" ${order.orderStatus == status ? 'selected' : ''}>${status.vietnameseName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="paymentStatus">Trạng thái thanh toán:</label>
                                    <select name="paymentStatus" id="paymentStatus" class="form-control">
                                        <c:forEach items="${paymentStatuses}" var="status">
                                            <option value="${status}" ${order.paymentStatus == status ? 'selected' : ''}>${status.name()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary">Cập nhật trạng thái</button>
                            </div>
                        </div>
                    </form>

                    <div class="row">
                        <div class="col-12">
                            <h5>Chi tiết đơn hàng</h5>
                            <div class="table-responsive">
                                <!-- Phần hiển thị danh sách sản phẩm trong đơn hàng -->
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th>Sản phẩm</th>
                                        <th>Hình ảnh</th>
                                        <th>Kích thước</th>
                                        <th>Giá</th>
                                        <th>Số lượng</th>
                                        <th>Thành tiền</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${order.orderItems}" var="item">
                                        <tr>
                                            <td>${item.product.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty item.product.images && item.product.images.size() > 0}">
                                                        <c:set var="primaryImage" value="${item.product.images[0].imageUrl}" />
                                                        <c:forEach items="${item.product.images}" var="image">
                                                            <c:if test="${image.primary}">  <!-- Sửa từ image.isPrimary thành image.primary -->
                                                                <c:set var="primaryImage" value="${image.imageUrl}" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <img src="${primaryImage}" alt="${item.product.name}" width="50">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="/images/default-product.jpg" alt="${item.product.name}" width="50">
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${item.productSize.sizeValue}</td>
                                            <!-- Thay đổi từ price thành unitPrice -->
                                            <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            <td>${item.quantity}</td>
                                            <!-- Sử dụng subtotal hoặc tính toán unitPrice * quantity -->
                                            <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function updateOrderStatus(orderId, status) {
        document.getElementById('updateStatusBtn').addEventListener('click', function() {
            fetch(`/admin/orders/${order.id}/update-status`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ status: status })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Cập nhật trạng thái thành công!');
                        location.reload();
                    } else {
                        alert('Cập nhật trạng thái thất bại!');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Đã xảy ra lỗi khi cập nhật trạng thái!');
                });
        });
    }
</script>

<%@ include file="../layouts/footer.jsp" %>
