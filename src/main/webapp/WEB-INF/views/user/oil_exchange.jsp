<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Used Oil Exchange - Candle Shop</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">
<%
    // Định nghĩa các formatter để sử dụng trong trang
    pageContext.setAttribute("dateFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    pageContext.setAttribute("dateTimeFormatter", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
%>
<jsp:include page="layouts/nav.jsp" />

<div class="max-w-7xl mx-auto px-4 py-8 sm:px-6 lg:px-8 pt-[8%]">
    <h2 class="text-2xl font-bold text-gray-800 mb-6">Exchange Used Oil for Points</h2>

    <c:if test="${not empty successMessage}">
        <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 mb-4" role="alert">
            <p>${successMessage}</p>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4" role="alert">
            <p>${errorMessage}</p>
        </div>
    </c:if>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="bg-[#A67B5B] text-white px-6 py-3">
                <h5 class="font-medium">Create New Oil Exchange Request</h5>
            </div>
            <div class="p-6">
                <!-- Sử dụng form HTML thông thường thay vì form:form -->
                <form action="${pageContext.request.contextPath}/oil_exchange/create" method="post">
                    <div class="mb-4">
                        <label for="oilAmount" class="block text-sm font-medium text-gray-700 mb-1">Oil Amount (liters) <span class="text-red-500">*</span></label>
                        <input type="number" name="oilAmount" id="oilAmount" value="${newExchange.oilAmount}" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-[#8B4513]" step="0.1" min="5" required="required" />
                        <p class="mt-1 text-sm text-gray-500">Minimum oil amount is 5 liters. Each liter will be converted to 10 points.</p>
                    </div>

                    <div class="mb-4">
                        <label for="pickupName" class="block text-sm font-medium text-gray-700 mb-1">Contact Name <span class="text-red-500">*</span></label>
                        <input type="text" name="pickupName" id="pickupName" value="${newExchange.pickupName}" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-[#8B4513]" required="required" />
                    </div>

                    <div class="mb-4">
                        <label for="pickupPhone" class="block text-sm font-medium text-gray-700 mb-1">Phone Number <span class="text-red-500">*</span></label>
                        <input type="text" name="pickupPhone" id="pickupPhone" value="${newExchange.pickupPhone}" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-[#8B4513]" required="required" />
                    </div>

                    <div class="mb-4">
                        <label for="pickupAddress" class="block text-sm font-medium text-gray-700 mb-1">Pickup Address <span class="text-red-500">*</span></label>
                        <textarea name="pickupAddress" id="pickupAddress" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-[#8B4513]" rows="3" required="required">${newExchange.pickupAddress}</textarea>
                    </div>

                    <button type="submit" class="w-full bg-[#8B4513] text-white py-2 px-4 rounded-md hover:bg-[#7A3B10] focus:outline-none focus:ring-2 focus:ring-[#8B4513] focus:ring-offset-2">Submit Request</button>
                </form>
            </div>
        </div>

        <div class="bg-white rounded-lg shadow overflow-hidden">
            <div class="bg-[#A67B5B] text-white px-6 py-3">
                <h5 class="font-medium">Oil Exchange Information</h5>
            </div>
            <div class="p-6">
                <p>Our oil exchange program helps you:</p>
                <ul class="list-disc pl-5 mt-2 mb-4 space-y-1">
                    <li>Reuse waste oil in a beneficial way</li>
                    <li>Earn reward points for candle products</li>
                    <li>Contribute to environmental protection</li>
                </ul>
                <p class="font-medium">Conversion Rate: 1 liter of oil = 10 points</p>
                <p class="font-medium">Requirement: Minimum oil amount is 5 liters</p>
                <p class="font-medium mt-3">Process:</p>
                <ol class="list-decimal pl-5 mt-2 space-y-1">
                    <li>Submit your oil exchange request</li>
                    <li>We confirm and arrange pickup time</li>
                    <li>Our staff will visit your address to collect the oil</li>
                    <li>After confirming the oil amount, points will be added to your account</li>
                </ol>
            </div>
        </div>
    </div>

    <div class="mt-8 bg-white rounded-lg shadow overflow-hidden">
        <div class="bg-[#A67B5B] text-white px-6 py-3">
            <h5 class="font-medium">Your Oil Exchange History</h5>
        </div>
        <div class="p-6">
            <c:choose>
                <c:when test="${empty exchanges}">
                    <p class="text-center text-gray-500 py-4">You haven't made any oil exchange requests yet.</p>
                </c:when>
                <c:otherwise>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                            <tr>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Request ID</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Oil Amount</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Points</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Action</th>
                            </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                            <c:forEach items="${exchanges}" var="exchange">
                                <tr>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">${exchange.exchangeNumber}</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                        <c:choose>
                                            <c:when test="${exchange.createdAt != null}">
                                                ${exchange.createdAt.format(pageContext.getAttribute("dateTimeFormatter"))}
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${exchange.oilAmount} liters</td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${exchange.pointsEarned} points</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <c:choose>
                                            <c:when test="${exchange.status == 'PENDING'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Pending</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'APPROVED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">Approved</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'COMPLETED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Completed</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'CANCELLED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Cancelled</span>
                                            </c:when>
                                            <c:when test="${exchange.status == 'REJECTED'}">
                                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">Rejected</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/oil_exchange/${exchange.id}" class="text-[#8B4513] hover:text-[#7A3B10]">View Details</a>
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
</div>

</body>
</html>
