<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../layouts/header.jsp" />
<jsp:include page="../layouts/sidebar.jsp" />

<div class="main-content">
    <div class="container py-4">
        <h2 class="mb-4">Chỉnh sửa Voucher</h2>
        <div class="card">
            <div class="card-body">
                <form action="/admin/vouchers/edit/${voucher.id}" method="post">
                    <input type="hidden" name="id" value="${voucher.id}">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Mã Voucher</label>
                            <input type="text" name="code" class="form-control" value="${voucher.code}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Phần trăm giảm giá</label>
                            <input type="number" name="discountPercent" class="form-control" min="1" max="100" value="${voucher.discountPercent}" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Điểm cần đổi</label>
                            <input type="number" name="pointsRequired" class="form-control" min="1" value="${voucher.pointsRequired}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Đơn tối thiểu</label>
                            <input type="number" name="minOrderValue" class="form-control" min="0" step="1000" value="${voucher.minOrderValue}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giảm tối đa</label>
                            <input type="number" name="maxDiscountAmount" class="form-control" min="0" step="1000" value="${voucher.maxDiscountAmount}">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Ngày hiệu lực</label>
                            <input type="number" name="expiryDays" class="form-control" min="1" value="${voucher.expiryDays}">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Mô tả</label>
                            <textarea name="description" class="form-control" rows="2">${voucher.description}</textarea>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="isActive" class="form-select">
                                <option value="true" <c:if test="${voucher.isActive}">selected</c:if>>Hoạt động</option>
                                <option value="false" <c:if test="${!voucher.isActive}">selected</c:if>>Ẩn</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Lưu</button>
                            <a href="/admin/vouchers" class="btn btn-secondary ms-2">Hủy</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp" />
