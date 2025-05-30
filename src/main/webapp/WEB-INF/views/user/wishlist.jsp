<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - Candle Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shopcandle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <style>
        .wishlist-container {
            margin-top: 8%;
            max-width: 1200px;
            padding: 20px;
        }

        .wishlist-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .wishlist-items {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        .wishlist-item {
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            padding: 15px;
            position: relative;
            transition: all 0.3s ease;
        }

        .wishlist-item:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .wishlist-item img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            margin-bottom: 10px;
        }

        .remove-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255, 255, 255, 0.8);
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background: #f44336;
            color: white;
        }

        .empty-wishlist {
            text-align: center;
            padding: 50px;
        }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<jsp:include page="layouts/nav.jsp" />
<main>
    <div class="wishlist-container">
        <div class="wishlist-header">
            <h1>My Wishlist</h1>
            <p>Items you've saved for later</p>
        </div>

        <div class="wishlist-items">
            <c:if test="${empty wishlistItems}">
                <div class="empty-wishlist">
                    <h2>Your wishlist is empty</h2>
                    <p>Browse our shop and add items to your wishlist</p>
                    <a href="${pageContext.request.contextPath}/shop" class="btn">Shop Now</a>
                </div>
            </c:if>

            <jsp:useBean id="wishlistItems" scope="request" type="java.util.List"/>
            <c:forEach items="${wishlistItems}" var="item">
                <div class="wishlist-item">
                    <button class="remove-btn" onclick="removeFromWishlist(${item.product.id})">
                        <i class="fa fa-times"></i>
                    </button>
                    <a href="${pageContext.request.contextPath}/product/${item.product.id}">
                        <c:choose>
                            <c:when test="${not empty item.product.images}">
                                <img src="${pageContext.request.contextPath}/uploads/${item.product.images[0].imageUrl}" alt="${item.product.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/default-product.jpg" alt="${item.product.name}">
                            </c:otherwise>
                        </c:choose>

                        <h3>${item.product.name}</h3>
                        <p class="price">
                            <fmt:formatNumber value="${item.product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                        </p>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</main>
<jsp:include page="layouts/footer.jsp" />

<script>
    function removeFromWishlist(productId) {
        window.location.href = "${pageContext.request.contextPath}/wishlist/remove/" + productId;
    }

    function addToCart(productId) {
        // Thêm vào giỏ hàng - điều chỉnh URL theo cấu trúc của bạn
        fetch("${pageContext.request.contextPath}/cart/add", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "productId=" + productId + "&quantity=1"
        })
            .then(response => {
                if (response.ok) {
                    alert("Sản phẩm đã được thêm vào giỏ hàng!");
                } else {
                    alert("Có lỗi xảy ra khi thêm vào giỏ hàng!");
                }
            });
    }
</script>
</body>
</html>
