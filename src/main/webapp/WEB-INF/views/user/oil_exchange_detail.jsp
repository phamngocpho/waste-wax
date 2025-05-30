<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết trao đổi dầu - Candle Shop</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
<%
    pageContext.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    pageContext.setAttribute("dateTimeFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>
<jsp:include page="layouts/nav.jsp" />

<div class="max-w-7xl mx-auto px-4 py-8 sm:px-6 lg:px-8 pt-[8%]">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-2xl font-bold text-gray-800">Chi tiết trao đổi dầu</h2>
        <a href="${pageContext.request.contextPath}/oil_exchange" class="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2">Quay lại</a>
    </div>

    <div class="bg-white rounded-lg shadow overflow-hidden">
        <div class="bg-[#A67B5B] text-white px-6 py-3">
            <h5 class="font-medium">Mã yêu cầu: ${exchange.exchangeNumber}</h5>
        </div>
        <div class="p-6">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                    <h6 class="font-bold text-gray-800 mb-3">Thông tin cơ bản</h6>
                    <div class="border rounded-md overflow-hidden">
                        <table class="min-w-full divide-y divide-gray-200">
                            <tbody class="divide-y divide-gray-200">
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700 w-2/5">Trạng thái</th>
                                <td class="px-4 py-3 text-sm text-gray-700">
                                    <c:choose>
                                        <c:when test="${exchange.status == 'PENDING'}">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">Đang chờ xử lý</span>
                                        </c:when>
                                        <c:when test="${exchange.status == 'APPROVED'}">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">Đã duyệt, chờ lấy dầu</span>
                                        </c:when>
                                        <c:when test="${exchange.status == 'COMPLETED'}">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-green-100 text-green-800">Đã hoàn thành</span>
                                        </c:when>
                                        <c:when test="${exchange.status == 'CANCELLED'}">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-gray-100 text-gray-800">Đã hủy</span>
                                        </c:when>
                                        <c:when test="${exchange.status == 'REJECTED'}">
                                            <span class="px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-800">Đã từ chối</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Ngày tạo yêu cầu</th>
                                <td class="px-4 py-3 text-sm text-gray-700">
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
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Số lượng dầu</th>
                                <td class="px-4 py-3 text-sm text-gray-700">${exchange.oilAmount} lít</td>
                            </tr>
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Điểm nhận được</th>
                                <td class="px-4 py-3 text-sm text-gray-700">${exchange.pointsEarned} điểm</td>
                            </tr>
                            <c:if test="${exchange.status == 'APPROVED' || exchange.status == 'COMPLETED'}">
                                <tr>
                                    <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Ngày lấy dầu dự kiến</th>
                                    <td class="px-4 py-3 text-sm text-gray-700">
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
                                    <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Ngày hoàn thành</th>
                                    <td class="px-4 py-3 text-sm text-gray-700">
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
                            </tbody>
                        </table>
                    </div>
                </div>

                <div>
                    <h6 class="font-bold text-gray-800 mb-3">Thông tin liên hệ</h6>
                    <div class="border rounded-md overflow-hidden">
                        <table class="min-w-full divide-y divide-gray-200">
                            <tbody class="divide-y divide-gray-200">
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700 w-2/5">Người liên hệ</th>
                                <td class="px-4 py-3 text-sm text-gray-700">${exchange.pickupName}</td>
                            </tr>
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Số điện thoại</th>
                                <td class="px-4 py-3 text-sm text-gray-700">${exchange.pickupPhone}</td>
                            </tr>
                            <tr>
                                <th class="px-4 py-3 bg-gray-50 text-left text-sm font-medium text-gray-700">Địa chỉ lấy dầu</th>
                                <td class="px-4 py-3 text-sm text-gray-700">${exchange.pickupAddress}</td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div class="mt-6">
                <c:if test="${exchange.status == 'PENDING' || exchange.status == 'APPROVED'}">
                    <form action="${pageContext.request.contextPath}/oil_exchange/cancel/${exchange.id}" method="post" class="inline">
                        <button type="submit" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2" onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">Hủy yêu cầu</button>
                    </form>
                </c:if>
            </div>
        </div>
    </div>
</div>

<jsp:include page="layouts/footer.jsp" />
</body>
</html>
