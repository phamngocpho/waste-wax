<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="layouts/nav.jsp" />

<div class="container my-5">
    <h2 class="text-center mb-4">Voucher của tôi</h2>

    <div class="row">
        <div class="col-md-4">
            <div class="card">
                <div class="card-header">
                    <h5>Thông tin điểm</h5>
                </div>
                <div class="card-body">
                    <p>Số điểm hiện tại: <strong>${user.points}</strong></p>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <ul class="nav nav-tabs" id="myTab" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="available-tab" data-toggle="tab" href="#available" role="tab" aria-controls="available" aria-selected="true">Voucher của tôi</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="redeem-tab" data-toggle="tab" href="#redeem" role="tab" aria-controls="redeem" aria-selected="false">Đổi voucher</a>
                </li>
            </ul>

            <div class="tab-content" id="myTabContent">
                <!-- Voucher của tôi -->
                <div class="tab-pane fade show active" id="available" role="tabpanel" aria-labelledby="available-tab">
                    <div class="row mt-3">
                        <c:forEach var="userVoucher" items="${userVouchers}">
                            <div class="col-md-6 mb-3">
                                <div class="card ${userVoucher.isUsed || userVoucher.expiryDate.isBefore(java.time.LocalDate.now()) ? 'bg-light' : ''}">
                                    <div class="card-body">
                                        <h5 class="card-title">${userVoucher.voucher.code}</h5>
                                        <h6 class="card-subtitle mb-2 text-muted">Giảm ${userVoucher.voucher.discountPercent}%</h6>
                                        <p class="card-text">${userVoucher.voucher.description}</p>
                                        <p class="card-text">
                                            <small>
                                                <c:if test="${userVoucher.voucher.minOrderValue > 0}">
                                                    Áp dụng cho đơn hàng từ <fmt:formatNumber value="${userVoucher.voucher.minOrderValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </c:if>
                                            </small>
                                        </p>
                                        <p class="card-text">
                                            <small>
                                                <c:if test="${userVoucher.voucher.maxDiscountAmount != null}">
                                                    Giảm tối đa <fmt:formatNumber value="${userVoucher.voucher.maxDiscountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </c:if>
                                            </small>
                                        </p>
                                        <p class="card-text">
                                            <small>Hạn sử dụng: <fmt:formatDate value="${userVoucher.expiryDate}" pattern="dd/MM/yyyy"/></small>
                                        </p>

                                        <c:choose>
                                            <c:when test="${userVoucher.isUsed}">
                                                <div class="badge badge-secondary">Đã sử dụng</div>
                                            </c:when>
                                            <c:when test="${userVoucher.expiryDate.isBefore(java.time.LocalDate.now())}">
                                                <div class="badge badge-danger">Hết hạn</div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="badge badge-success">Có thể sử dụng</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <c:if test="${empty userVouchers}">
                            <div class="col-12 text-center py-5">
                                <p>Bạn chưa có voucher nào. Hãy đổi điểm để nhận voucher!</p>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Đổi voucher -->
                <div class="tab-pane fade" id="redeem" role="tabpanel" aria-labelledby="redeem-tab">
                    <div class="row mt-3">
                        <c:forEach var="voucher" items="${availableVouchers}">
                            <div class="col-md-6 mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">${voucher.code}</h5>
                                        <h6 class="card-subtitle mb-2 text-muted">Giảm ${voucher.discountPercent}%</h6>
                                        <p class="card-text">${voucher.description}</p>
                                        <p class="card-text">
                                            <small>
                                                <c:if test="${voucher.minOrderValue > 0}">
                                                    Áp dụng cho đơn hàng từ <fmt:formatNumber value="${voucher.minOrderValue}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </c:if>
                                            </small>
                                        </p>
                                        <p class="card-text">
                                            <small>
                                                <c:if test="${voucher.maxDiscountAmount != null}">
                                                    Giảm tối đa <fmt:formatNumber value="${voucher.maxDiscountAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                                </c:if>
                                            </small>
                                        </p>
                                        <p class="card-text">
                                            <small>Hiệu lực: ${voucher.expiryDays} ngày sau khi đổi</small>
                                        </p>
                                        <p class="card-text">
                                            <strong>Điểm cần để đổi: ${voucher.pointsRequired}</strong>
                                        </p>

                                        <button class="btn ${user.points >= voucher.pointsRequired ? 'btn-primary' : 'btn-secondary'} redeem-btn"
                                                data-id="${voucher.id}"
                                            ${user.points >= voucher.pointsRequired ? '' : 'disabled'}>
                                            Đổi voucher
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $('.redeem-btn').click(function() {
            var voucherId = $(this).data('id');

            $.ajax({
                url: '/vouchers/redeem/' + voucherId,
                type: 'POST',
                success: function(response) {
                    if (response.success) {
                        alert(response.message);
                        window.location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function(xhr) {
                    var response = JSON.parse(xhr.responseText);
                    alert(response.message);
                }
            });
        });
    });
</script>

<jsp:include page="layouts/footer.jsp" />
