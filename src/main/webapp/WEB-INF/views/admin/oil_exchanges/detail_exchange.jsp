<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết trao đổi dầu - Admin</title>
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

<div class="container-fluid mt-4">
    <div class="row">
        <jsp:include page="../layouts/sidebar.jsp" />

        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chi tiết trao đổi dầu</h1>
                <a href="${pageContext.request.contextPath}/admin/oil_exchanges" class="btn btn-secondary">Quay lại</a>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Mã yêu cầu: ${exchange.exchangeNumber}</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin cơ bản</h6>
                            <table class="table table-bordered">
                                <tr>
                                    <th style="width: 40%">Trạng thái</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${exchange.status == 'PENDING'}">
                                                <span class="badge bg-warning">Đang chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'APPROVED'}">
                                                <span class="badge bg-info">Đã duyệt, chờ lấy dầu</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'COMPLETED'}">
                                                <span class="badge bg-success">Đã hoàn thành</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'CANCELLED'}">
                                                <span class="badge bg-secondary">Đã hủy</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'REJECTED'}">
                                                <span class="badge bg-danger">Đã từ chối</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo yêu cầu</th>
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
                                </tr>
                                <tr>
                                    <th>Số lượng dầu</th>
                                    <td>${exchange.oilAmount} lít</td>
                                </tr>
                                <tr>
                                    <th>Điểm nhận được</th>
                                    <td>${exchange.pointsEarned} điểm</td>
                                </tr>
                                <c:if test="${exchange.status == 'APPROVED' || exchange.status == 'COMPLETED'}">
                                    <tr>
                                        <th>Ngày lấy dầu dự kiến</th>
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
                                    </tr>
                                </c:if>
                                <c:if test="${exchange.status == 'COMPLETED'}">
                                    <tr>
                                        <th>Ngày hoàn thành</th>
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
                                    </tr>
                                </c:if>
                            </table>
                        </div>

                        <div class="col-md-6">
                            <h6 class="fw-bold">Thông tin người dùng & liên hệ</h6>
                            <table class="table table-bordered">
                                <tr>
                                    <th style="width: 40%">Người dùng</th>
                                    <td>${exchange.user.fullName}</td>
                                </tr>
                                <tr>
                                    <th>Email</th>
                                    <td>${exchange.user.email}</td>
                                </tr>
                                <tr>
                                    <th>Người liên hệ</th>
                                    <td>${exchange.pickupName}</td>
                                </tr>
                                <tr>
                                    <th>Số điện thoại</th>
                                    <td>${exchange.pickupPhone}</td>
                                </tr>
                                <tr>
                                    <th>Địa chỉ lấy dầu</th>
                                    <td>${exchange.pickupAddress}</td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="mt-4">
                        <c:choose>
                            <c:when test="${exchange.status == 'PENDING'}">
                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#approveModal">
                                    Phê duyệt
                                </button>
                                <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                    Từ chối
                                </button>
                            </c:when>
                            <c:when test="${exchange.status == 'APPROVED'}">
                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#completeModal">
                                    Hoàn thành
                                </button>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Modal phê duyệt -->
            <div class="modal fade" id="approveModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Phê duyệt yêu cầu trao đổi dầu</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}/approve" method="post">
                            <div class="modal-body">
                                <p>Bạn đang phê duyệt yêu cầu trao đổi dầu <strong>${exchange.exchangeNumber}</strong>.</p>
                                <div class="mb-3">
                                    <label for="pickupDate" class="form-label">Ngày hẹn lấy dầu</label>
                                    <input type="datetime-local" id="pickupDate" name="pickupDate" class="form-control" required>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-success">Phê duyệt</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal từ chối -->
            <div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Từ chối yêu cầu trao đổi dầu</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/oil_exchanges/${exchange.id}/reject" method="post">
                            <div class="modal-body">
                                <p>Bạn có chắc muốn từ chối yêu cầu trao đổi dầu <strong>${exchange.exchangeNumber}</strong>?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-danger">Từ chối</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal hoàn thành -->
            <div class="modal fade" id="completeModal" tabindex="-1" aria-hidden="true">
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
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
