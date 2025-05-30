<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết người dùng</title>
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
                <h1 class="h2">Chi tiết người dùng</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-2">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="/admin/users/edit/${user.id}" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </a>
                </div>
            </div>

            <!-- Thông tin người dùng -->
            <div class="row">
                <!-- Thông tin cơ bản -->
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin cơ bản</h5>
                        </div>
                        <div class="card-body">
                            <table class="table">
                                <tr>
                                    <th style="width: 35%">ID:</th>
                                    <td>${user.id}</td>
                                </tr>
                                <tr>
                                    <th>Tên đăng nhập:</th>
                                    <td>${user.username}</td>
                                </tr>
                                <tr>
                                    <th>Họ và tên:</th>
                                    <td>${user.fullName != null ? user.fullName : 'Chưa cập nhật'}</td>
                                </tr>
                                <tr>
                                    <th>Email:</th>
                                    <td>${user.email}</td>
                                </tr>
                                <tr>
                                    <th>Số điện thoại:</th>
                                    <td>${user.phone != null ? user.phone : 'Chưa cập nhật'}</td>
                                </tr>
                                <tr>
                                    <th>Địa chỉ:</th>
                                    <td>${user.address != null ? user.address : 'Chưa cập nhật'}</td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Thông tin tài khoản -->
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0"><i class="fas fa-info-circle me-2"></i>Thông tin tài khoản</h5>
                        </div>
                        <div class="card-body">
                            <table class="table">
                                <tr>
                                    <th style="width: 35%">Vai trò:</th>
                                    <td>
                                        <span class="badge ${user.role == 'ADMIN' ? 'bg-danger' : 'bg-primary'}">
                                            ${user.role}
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Trạng thái:</th>
                                    <td>
                                        <span class="badge ${user.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">
                                            ${user.status == 'ACTIVE' ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Điểm tích lũy:</th>
                                    <td>${user.points}</td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo:</th>
                                    <td>
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>Cập nhật lần cuối:</th>
                                    <td>
                                        <c:if test="${user.updatedAt != null}">
                                            <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                        </c:if>
                                        <c:if test="${user.updatedAt == null}">
                                            Chưa cập nhật
                                        </c:if>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lịch sử đơn hàng (nếu có) -->
            <div class="card mb-4">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-shopping-cart me-2"></i>Lịch sử đơn hàng</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty user.orders}">
                        <p class="text-center text-muted">Người dùng chưa có đơn hàng nào.</p>
                    </c:if>
                    <c:if test="${not empty user.orders}">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                <tr>
                                    <th>Mã đơn hàng</th>
                                    <th>Ngày đặt</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${user.orders}" var="order">
                                    <tr>
                                        <td>${order.id}</td>
                                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" /></td>
                                        <td>
                                            <span class="badge bg-${order.status == 'COMPLETED' ? 'success' : (order.status == 'PENDING' ? 'warning' : 'danger')}">
                                                    ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <a href="/admin/orders/detail/${order.id}" class="btn btn-sm btn-info">
                                                <i class="fas fa-eye"></i> Xem
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


