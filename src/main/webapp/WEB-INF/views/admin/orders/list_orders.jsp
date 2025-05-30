<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đơn hàng</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        border: "hsl(214.3 31.8% 91.4%)",
                        input: "hsl(214.3 31.8% 91.4%)",
                        ring: "hsl(222.2 84% 4.9%)",
                        background: "hsl(0 0% 100%)",
                        foreground: "hsl(222.2 84% 4.9%)",
                        primary: {
                            DEFAULT: "hsl(222.2 47.4% 11.2%)",
                            foreground: "hsl(210 40% 98%)",
                        },
                        secondary: {
                            DEFAULT: "hsl(210 40% 96%)",
                            foreground: "hsl(222.2 84% 4.9%)",
                        },
                        muted: {
                            DEFAULT: "hsl(210 40% 96%)",
                            foreground: "hsl(215.4 16.3% 46.9%)",
                        },
                        accent: {
                            DEFAULT: "hsl(210 40% 96%)",
                            foreground: "hsl(222.2 84% 4.9%)",
                        },
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-50/40">
<div class="ml-[250px] max-h-screen">
    <main class="flex-1 p-6 space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold tracking-tight">Đơn hàng</h1>
                <p class="text-muted-foreground">Quản lý và theo dõi đơn hàng</p>
            </div>
            <div class="flex gap-2">
                <button onclick="exportOrders()" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                    <i class="fas fa-download w-4 h-4 mr-2"></i>
                    Xuất Excel
                </button>
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Tổng đơn hàng</h3>
                    <i class="fas fa-shopping-cart h-4 w-4 text-muted-foreground"></i>
                </div>
                <div class="text-2xl font-bold">${orders.totalElements}</div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Chờ xử lý</h3>
                    <i class="fas fa-clock h-4 w-4 text-yellow-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="pendingCount" value="0" />
                    <c:forEach items="${orders.content}" var="order">
                        <c:if test="${order.orderStatus == 'PENDING'}">
                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${pendingCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Đang giao</h3>
                    <i class="fas fa-truck h-4 w-4 text-blue-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="shippingCount" value="0" />
                    <c:forEach items="${orders.content}" var="order">
                        <c:if test="${order.orderStatus == 'SHIPPING'}">
                            <c:set var="shippingCount" value="${shippingCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${shippingCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Hoàn thành</h3>
                    <i class="fas fa-check-circle h-4 w-4 text-green-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="deliveredCount" value="0" />
                    <c:forEach items="${orders.content}" var="order">
                        <c:if test="${order.orderStatus == 'DELIVERED'}">
                            <c:set var="deliveredCount" value="${deliveredCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${deliveredCount}
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="p-6">
                <form method="get" action="/admin/orders" class="flex flex-col md:flex-row gap-4">
                    <div class="flex-1">
                        <select name="status" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                            <option value="">Tất cả trạng thái</option>
                            <c:forEach items="${orderStatuses}" var="status">
                                <option value="${status}" ${status == selectedStatus ? 'selected' : ''}>
                                        ${status.getVietnameseName()}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="flex-1">
                        <input type="date" name="fromDate" value="${fromDate}" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                    </div>
                    <div class="flex-1">
                        <input type="date" name="toDate" value="${toDate}" class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50">
                    </div>
                    <div class="flex gap-2">
                        <button type="submit" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                            <i class="fas fa-search w-4 h-4 mr-2"></i>
                            Lọc
                        </button>
                        <a href="/admin/orders" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                            <i class="fas fa-undo"></i>
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Orders Table -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="relative w-full overflow-auto">
                <c:choose>
                    <c:when test="${not empty orders.content}">
                        <table class="w-full caption-bottom text-sm">
                            <thead class="[&_tr]:border-b">
                            <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Mã đơn</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Ngày đặt</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Khách hàng</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Tổng tiền</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Trạng thái</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody class="[&_tr:last-child]:border-0">
                            <c:forEach items="${orders.content}" var="order">
                                <tr class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted">
                                    <td class="p-4 align-middle">
                                        <div class="font-mono text-sm font-medium">#${order.orderNumber}</div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <fmt:parseDate value="${order.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <div class="text-sm">
                                            <div class="font-medium"><fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy"/></div>
                                            <div class="text-muted-foreground"><fmt:formatDate value="${parsedDate}" pattern="HH:mm"/></div>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-3">
                                            <div class="flex h-8 w-8 items-center justify-center rounded-full bg-primary text-primary-foreground text-sm font-medium">
                                                    ${order.user.fullName.substring(0, 1).toUpperCase()}
                                            </div>
                                            <div>
                                                <div class="font-medium text-sm">${order.user.fullName}</div>
                                                <div class="text-muted-foreground text-xs">${order.shippingPhone}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="font-medium text-green-600">
                                            <fmt:formatNumber value="${order.finalAmount}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'PENDING'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                                                            Chờ xử lý
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'CONFIRMED'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-blue-100 text-blue-800">
                                                            Đã xác nhận
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'SHIPPING'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-indigo-100 text-indigo-800">
                                                            Đang giao
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'DELIVERED'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800">
                                                            Hoàn thành
                                                        </span>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'CANCELLED'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-red-100 text-red-800">
                                                            Đã hủy
                                                        </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <a href="/admin/orders/${order.id}" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 px-3">
                                            <i class="fas fa-eye w-4 h-4 mr-1"></i>
                                            Chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center py-12">
                            <i class="fas fa-shopping-cart text-4xl text-muted-foreground mb-4"></i>
                            <h3 class="text-lg font-semibold">Chưa có đơn hàng</h3>
                            <p class="text-muted-foreground">Không tìm thấy đơn hàng nào</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Pagination -->
            <c:if test="${orders.totalPages > 1}">
                <div class="flex items-center justify-center space-x-2 py-4">
                    <nav class="flex items-center space-x-1">
                        <a href="?page=0&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}"
                           class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8 ${orders.number == 0 ? 'opacity-50 cursor-not-allowed' : ''}">
                            <i class="fas fa-chevron-left h-4 w-4"></i>
                        </a>

                        <c:forEach begin="${orders.number - 2 < 0 ? 0 : orders.number - 2}"
                                   end="${orders.number + 2 >= orders.totalPages ? orders.totalPages - 1 : orders.number + 2}"
                                   var="i">
                            <a href="?page=${i}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}"
                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-8 w-8 ${orders.number == i ? 'bg-primary text-primary-foreground' : 'border border-input bg-background hover:bg-accent hover:text-accent-foreground'}">
                                    ${i + 1}
                            </a>
                        </c:forEach>

                        <a href="?page=${orders.number + 1}&size=${orders.size}&status=${selectedStatus}&fromDate=${fromDate}&toDate=${toDate}"
                           class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8 ${orders.number == orders.totalPages - 1 ? 'opacity-50 cursor-not-allowed' : ''}">
                            <i class="fas fa-chevron-right h-4 w-4"></i>
                        </a>
                    </nav>
                </div>
            </c:if>
        </div>
    </main>
</div>

<script>
    function exportOrders() {
        const params = new URLSearchParams(window.location.search);
        window.open(`/admin/orders/export?${params.toString()}`, '_blank');
    }
</script>
</body>
</html>
