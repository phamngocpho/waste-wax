<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng #${order.orderNumber}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp"/>
    <jsp:include page="../layouts/sidebar.jsp"/>
</head>

<body class="bg-gray-50/40">
<div class="ml-[250px] min-h-screen">
    <main class="flex-1 p-6 space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold tracking-tight">
                    Chi tiết đơn hàng <span class="text-blue-600 font-mono">#${order.orderNumber}</span>
                </h1>
                <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both"/>
                <p class="text-muted-foreground">
                    Đặt hàng lúc <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                </p>
            </div>
            <a href="/admin/orders"
               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                <i class="fas fa-arrow-left w-4 h-4 mr-2"></i>
                Quay lại
            </a>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="rounded-lg border border-green-200 bg-green-50 p-4 text-green-800">
                <div class="flex items-center">
                    <i class="fas fa-check-circle w-4 h-4 mr-2"></i>
                        ${success}
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="rounded-lg border border-red-200 bg-red-50 p-4 text-red-800">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle w-4 h-4 mr-2"></i>
                        ${error}
                </div>
            </div>
        </c:if>

        <!-- Order Info Grid -->
        <div class="grid gap-6 md:grid-cols-2">
            <!-- Customer Info -->
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                <div class="flex flex-col space-y-1.5 p-6 pb-4">
                    <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                        <i class="fas fa-user w-4 h-4 mr-2 text-blue-600"></i>
                        Thông tin khách hàng
                    </h3>
                </div>
                <div class="p-6 pt-0 space-y-4">
                    <div class="flex items-center gap-3">
                        <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground font-medium">
                            ${order.user.username.substring(0, 1).toUpperCase()}
                        </div>
                        <div>
                            <div class="font-medium">${order.user.username}</div>
                            <div class="text-sm text-muted-foreground">Khách hàng</div>
                        </div>
                    </div>
                    <div class="space-y-2">
                        <div class="flex items-center text-sm">
                            <i class="fas fa-phone w-4 h-4 mr-2 text-green-600"></i>
                            ${order.shippingPhone}
                        </div>
                        <div class="flex items-start text-sm">
                            <i class="fas fa-map-marker-alt w-4 h-4 mr-2 mt-0.5 text-red-600"></i>
                            <span>${order.shippingAddress}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Info -->
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                <div class="flex flex-col space-y-1.5 p-6 pb-4">
                    <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                        <i class="fas fa-shopping-cart w-4 h-4 mr-2 text-green-600"></i>
                        Thông tin đơn hàng
                    </h3>
                </div>
                <div class="p-6 pt-0 space-y-3">
                    <div class="flex justify-between text-sm">
                        <span class="text-muted-foreground">Tổng tiền hàng:</span>
                        <span class="font-medium text-green-600">
                                <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"
                                                  maxFractionDigits="0"/> VNĐ
                            </span>
                    </div>
                    <div class="flex justify-between text-sm">
                        <span class="text-muted-foreground">Phí vận chuyển:</span>
                        <span class="font-medium">
                                <fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"
                                                  maxFractionDigits="0"/> VNĐ
                            </span>
                    </div>
                    <div class="flex justify-between text-base font-semibold pt-2 border-t">
                        <span>Tổng thanh toán:</span>
                        <span class="text-green-600">
                                <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"
                                                  maxFractionDigits="0"/> VNĐ
                            </span>
                    </div>
                    <div class="flex justify-between items-center text-sm pt-2">
                        <span class="text-muted-foreground">Trạng thái thanh toán:</span>
                        <c:choose>
                            <c:when test="${order.paymentStatus == 'PAID'}">
                                    <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800">
                                        Đã thanh toán
                                    </span>
                            </c:when>
                            <c:otherwise>
                                    <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                                        Chưa thanh toán
                                    </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Status Update -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="flex flex-col space-y-1.5 p-6 pb-4">
                <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                    <i class="fas fa-edit w-4 h-4 mr-2 text-orange-600"></i>
                    Cập nhật trạng thái
                </h3>
            </div>
            <div class="p-6 pt-0">
                <form action="/admin/orders/${order.id}/update-status" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <div class="flex flex-col md:flex-row gap-4">
                        <div class="flex-1">
                            <label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 mb-2 block">
                                Trạng thái đơn hàng
                            </label>
                            <select name="orderStatus"
                                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                                <c:forEach items="${orderStatuses}" var="status">
                                    <option value="${status}" ${order.orderStatus == status ? 'selected' : ''}>
                                            ${status.vietnameseName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="flex-1">
                            <label class="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 mb-2 block">
                                Trạng thái thanh toán
                            </label>
                            <select name="paymentStatus"
                                    class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                                <c:forEach items="${paymentStatuses}" var="status">
                                    <option value="${status}" ${order.paymentStatus == status ? 'selected' : ''}>
                                        <c:choose>
                                            <c:when test="${status == 'PAID'}">Đã thanh toán</c:when>
                                            <c:otherwise>Chưa thanh toán</c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="flex items-end">
                            <button type="submit"
                                    class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                                <i class="fas fa-save w-4 h-4 mr-2"></i>
                                Cập nhật
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Order Items -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="flex flex-col space-y-1.5 p-6 pb-4">
                <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                    <i class="fas fa-list w-4 h-4 mr-2 text-purple-600"></i>
                    Chi tiết sản phẩm
                </h3>
            </div>
            <div class="relative w-full overflow-auto">
                <table class="w-full caption-bottom text-sm">
                    <thead class="[&_tr]:border-b">
                    <tr class="border-b transition-colors hover:bg-muted/50">
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Sản phẩm</th>
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Hình ảnh</th>
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Size</th>
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Đơn giá</th>
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">SL</th>
                        <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody class="[&_tr:last-child]:border-0">
                    <c:forEach items="${order.orderItems}" var="item">
                        <tr class="border-b transition-colors hover:bg-muted/50">
                            <td class="p-4 align-middle">
                                <div>
                                    <div class="font-medium text-sm">${item.product.name}</div>
                                    <div class="text-xs text-muted-foreground">Mã: #${item.product.id}</div>
                                </div>
                            </td>
                            <td class="p-4 align-middle">
                                <c:choose>
                                    <c:when test="${not empty item.product.images && item.product.images.size() > 0}">
                                        <c:set var="primaryImage" value="${item.product.images[0].imageUrl}"/>
                                        <c:forEach items="${item.product.images}" var="image">
                                            <c:if test="${image.primary}">
                                                <c:set var="primaryImage" value="${image.imageUrl}"/>
                                            </c:if>
                                        </c:forEach>
                                        <img src="/uploads/${primaryImage}" alt="${item.product.name}"
                                             class="h-12 w-12 rounded-md object-cover border">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="h-12 w-12 rounded-md bg-muted flex items-center justify-center">
                                            <i class="fas fa-image text-muted-foreground"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="p-4 align-middle">
                                        <span class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-600 ring-1 ring-inset ring-gray-500/10">
                                                ${item.productSize.sizeValue}
                                        </span>
                            </td>
                            <td class="p-4 align-middle">
                                <div class="font-medium text-green-600">
                                    <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true"
                                                      maxFractionDigits="0"/> VNĐ
                                </div>
                            </td>
                            <td class="p-4 align-middle">
                                        <span class="inline-flex items-center justify-center rounded-full bg-primary text-primary-foreground text-xs font-medium h-6 w-6">
                                                ${item.quantity}
                                        </span>
                            </td>
                            <td class="p-4 align-middle">
                                <div class="font-semibold">
                                    <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"
                                                      maxFractionDigits="0"/> VNĐ
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Order Summary -->
            <div class="p-6 bg-muted/30 border-t space-y-2">
                <div class="flex justify-between text-sm">
                    <span>Tổng tiền hàng:</span>
                    <span class="font-medium">
                            <fmt:formatNumber value="${order.totalAmount}" type="number" groupingUsed="true"
                                              maxFractionDigits="0"/> VNĐ
                        </span>
                </div>
                <div class="flex justify-between text-sm">
                    <span>Phí vận chuyển:</span>
                    <span class="font-medium">
                            <fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true"
                                              maxFractionDigits="0"/> VNĐ
                        </span>
                </div>
                <div class="flex justify-between text-base font-bold pt-2 border-t text-green-600">
                    <span>Tổng thanh toán:</span>
                    <span>
                            <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true"
                                              maxFractionDigits="0"/> VNĐ
                        </span>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // Auto-hide alerts
    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('[role="alert"]');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });

    // Form loading state
    document.querySelector('form').addEventListener('submit', function (e) {
        const btn = this.querySelector('button[type="submit"]');
        const originalText = btn.innerHTML;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin w-4 h-4 mr-2"></i>Đang cập nhật...';
        btn.disabled = true;
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            window.location.href = '/admin/orders';
        }
    });
</script>
</body>
</html>
