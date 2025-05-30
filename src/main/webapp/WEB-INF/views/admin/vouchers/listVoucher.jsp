<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../layouts/header.jsp" />
<jsp:include page="../layouts/sidebar.jsp" />
<div class="main-content">
<div class="content-wrapper">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Quản lý Voucher</h1>
                </div>
            </div>
        </div>
    </div>

    <section class="content">
        <div class="container-fluid">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <div class="float-right">
                        <a href="/admin/vouchers/create" class="btn btn-primary">Thêm Voucher</a>
                    </div>
                </div>
                <div class="card-body">
                    <table class="table table-bordered">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Mã</th>
                            <th>Giảm giá (%)</th>
                            <th>Điểm</th>
                            <th>Giá trị tối thiểu</th>
                            <th>Giảm tối đa</th>
                            <th>Trạng thái</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="voucher" items="${vouchers}">
                            <tr>
                                <td>${voucher.id}</td>
                                <td>${voucher.code}</td>
                                <td>${voucher.discountPercent}%</td>
                                <td>${voucher.pointsRequired}</td>
                                <td><fmt:formatNumber value="${voucher.minOrderValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</td>
                                <td><fmt:formatNumber value="${voucher.maxDiscountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</td>
                                <td>
                                    <c:if test="${voucher.isActive}">
                                        <span class="badge badge-success">Hoạt động</span>
                                    </c:if>
                                    <c:if test="${!voucher.isActive}">
                                        <span class="badge badge-danger">Không hoạt động</span>
                                    </c:if>
                                </td>
                                <td>
                                    <a href="/admin/vouchers/edit/${voucher.id}" class="btn btn-sm btn-info">Sửa</a>
                                    <a href="/admin/vouchers/delete/${voucher.id}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn xóa voucher này?')">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </section>
</div>
</div>

<jsp:include page="../layouts/footer.jsp" />
