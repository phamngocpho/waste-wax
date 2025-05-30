<!-- list-orders.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../layouts/header.jsp" %>

<div class="admin-wrapper">
    <%@ include file="../layouts/sidebar.jsp" %>

    <div class="main-content">
        <div class="container-fluid">
            <h2 class="mb-4">Quản lý đơn hàng</h2>

            <!-- Filter Form -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="get" action="/admin/orders" class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="">Tất cả</option>
                                <c:forEach items="${orderStatuses}" var="status">
                                    <option value="${status}"
                                        ${status == selectedStatus ? 'selected' : ''}>
                                            ${status.getVietnameseName()}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Từ ngày</label>
                            <input type="date" name="fromDate" class="form-control"
                                   value="${fromDate}">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Đến ngày</label>
                            <input type="date" name="toDate" class="form-control"
                                   value="${toDate}">
                        </div>
                        <div class="col-md-3 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary">Lọc</button>
                            <a href="/admin/orders" class="btn btn-secondary ms-2">Đặt lại</a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                            <tr>
                                <th>Mã đơn hàng</th>
                                <th>Ngày đặt</th>
                                <th>Khách hàng</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${orders.content}" var="order">
                                <tr>
                                    <td>${order.orderNumber}</td>
                                    <td>
                                        <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>${order.user.fullName}</td>
                                    <td>
                                        <fmt:formatNumber value="${order.finalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </td>
                                    <td>
                                            <span class="badge bg-${order.orderStatus == 'DELIVERED' ? 'success' :
                                                                  order.orderStatus == 'CANCELLED' ? 'danger' :
                                                                  order.orderStatus == 'SHIPPING' ? 'info' : 'warning'}">
                                                    ${order.orderStatus.getVietnameseName()}
                                            </span>
                                    </td>
                                    <td>
                                        <a href="/admin/orders/${order.id}" class="btn btn-sm btn-primary">
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${orders.totalPages > 1}">
                        <nav aria-label="Page navigation">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${orders.number == 0 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=0&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">
                                        Đầu
                                    </a>
                                </li>
                                <li class="page-item ${orders.number == 0 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${orders.number - 1}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">
                                        Trước
                                    </a>
                                </li>

                                <c:forEach begin="${Math.max(0, orders.number - 2)}"
                                           end="${Math.min(orders.totalPages - 1, orders.number + 2)}"
                                           var="i">
                                    <li class="page-item ${orders.number == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">
                                                ${i + 1}
                                        </a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${orders.number == orders.totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${orders.number + 1}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">
                                        Tiếp
                                    </a>
                                </li>
                                <li class="page-item ${orders.number == orders.totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${orders.totalPages - 1}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}">
                                        Cuối
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="../layouts/footer.jsp" %>
