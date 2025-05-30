<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý trao đổi dầu - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%
    // Định nghĩa các formatter để sử dụng trong trang
    pageContext.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    pageContext.setAttribute("dateTimeFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>
<jsp:include page="../layouts/header.jsp" />
<jsp:include page="../layouts/sidebar.jsp" />

<div class="container-fluid mt-4">
    <div class="row">


        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Quản lý trao đổi dầu</h1>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <ul class="nav nav-tabs mb-4" id="exchangeTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab">
                        Đang chờ xử lý <span class="badge bg-warning">${pendingExchanges.size()}</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved" type="button" role="tab">
                        Đã duyệt, chờ lấy dầu <span class="badge bg-info">${approvedExchanges.size()}</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button" role="tab">
                        Đã hoàn thành <span class="badge bg-success">${completedExchanges.size()}</span>
                    </button>
                </li>
            </ul>

            <div class="tab-content" id="exchangeTabsContent">
                <!-- Tab đang chờ xử lý -->
                <div class="tab-pane fade show active" id="pending" role="tabpanel">
                    <c:choose>
                        <c:when test="${empty pendingExchanges}">
                            <p class="text-center py-4">Không có yêu cầu trao đổi dầu nào đang chờ xử lý.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                    <tr>
                                        <th>Mã yêu cầu</th>
                                        <th>Người dùng</th>
                                        <th>Ngày tạo</th>
                                        <th>Số lượng dầu</th>
                                        <th>Điểm</th>
                                        <th>Địa chỉ</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${pendingExchanges}" var="exchange">
                                        <tr>
                                            <td>${exchange.exchangeNumber}</td>
                                            <td>${exchange.user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exchange.createdAt != null}">
                                                        ${exchange.createdAt.format(pageContext.getAttribute("dateTimeFormatter"))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${exchange.oilAmount} lít</td>
                                            <td>${exchange.pointsEarned}</td>
                                            <td>${exchange.pickupAddress}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}" class="btn btn-sm btn-info">Chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- Tab đã duyệt, chờ lấy dầu -->
                <div class="tab-pane fade" id="approved" role="tabpanel">
                    <c:choose>
                        <c:when test="${empty approvedExchanges}">
                            <p class="text-center py-4">Không có yêu cầu trao đổi dầu nào đã được duyệt và đang chờ lấy dầu.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                    <tr>
                                        <th>Mã yêu cầu</th>
                                        <th>Người dùng</th>
                                        <th>Ngày tạo</th>
                                        <th>Ngày lấy dầu</th>
                                        <th>Số lượng dầu</th>
                                        <th>Điểm</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${approvedExchanges}" var="exchange">
                                        <tr>
                                            <td>${exchange.exchangeNumber}</td>
                                            <td>${exchange.user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exchange.createdAt != null}">
                                                        ${exchange.createdAt.format(pageContext.getAttribute("dateTimeFormatter"))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exchange.scheduledPickupDate != null}">
                                                        ${exchange.scheduledPickupDate.format(pageContext.getAttribute("dateFormatter"))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${exchange.oilAmount} lít</td>
                                            <td>${exchange.pointsEarned}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}" class="btn btn-sm btn-info">Chi tiết</a>
                                                <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal" data-bs-target="#completeModal${exchange.id}">Hoàn thành</button>
                                            </td>
                                        </tr>

                                        <div class="modal fade" id="completeModal${exchange.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Hoàn thành yêu cầu trao đổi dầu</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}/complete" method="post">
                                                        <div class="modal-body">
                                                            <p>Xác nhận đã nhận được dầu từ yêu cầu <strong>${exchange.exchangeNumber}</strong>?</p>
                                                            <p class="text-success">Người dùng sẽ nhận được <strong>${exchange.pointsEarned}</strong> điểm.</p>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                                            <button type="submit" class="btn btn-success">Xác nhận hoàn thành</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- Tab đã hoàn thành -->
                <div class="tab-pane fade" id="completed" role="tabpanel">
                    <c:choose>
                        <c:when test="${empty completedExchanges}">
                            <p class="text-center py-4">Không có yêu cầu trao đổi dầu nào đã hoàn thành.</p>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                    <tr>
                                        <th>Mã yêu cầu</th>
                                        <th>Người dùng</th>
                                        <th>Ngày tạo</th>
                                        <th>Ngày hoàn thành</th>
                                        <th>Số lượng dầu</th>
                                        <th>Điểm</th>
                                        <th>Thao tác</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${completedExchanges}" var="exchange">
                                        <tr>
                                            <td>${exchange.exchangeNumber}</td>
                                            <td>${exchange.user.fullName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exchange.createdAt != null}">
                                                        ${exchange.createdAt.format(pageContext.getAttribute("dateTimeFormatter"))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${exchange.completedAt != null}">
                                                        ${exchange.completedAt.format(pageContext.getAttribute("dateTimeFormatter"))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${exchange.oilAmount} lít</td>
                                            <td>${exchange.pointsEarned}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}" class="btn btn-sm btn-info">Chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
