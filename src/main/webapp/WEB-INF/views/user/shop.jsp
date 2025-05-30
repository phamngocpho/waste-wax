<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candle Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/shopcandle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<jsp:include page="layouts/nav.jsp" />
<main>
    <div class="hero">
        <div class="hero-content">
            <h1>Shop All</h1>
            <p>Welcome to a place where discarded oil is transformed into elegant, aromatic candles, bringing warmth and
                beauty to your space.</p>
        </div>
        <img src="${pageContext.request.contextPath}/images/shopall.png" alt="Featured Candle" class="hero-image">
    </div>

    <nav class="nav-container">
        <div class="nav-left">
            <a href="#" class="nav-link">featured products</a>
        </div>
        <div class="nav-right">
            <a href="#" class="nav-link">bestsellers</a>
            <a href="#" class="nav-link">our choice</a>
        </div>
    </nav>

    <div class="container">
        <div id="product-grid" class="product-grid">
            <c:choose>
                <c:when test="${not empty allProducts}">
                    <c:forEach items="${allProducts}" var="product">
                        <div class="product-card product-item">
                            <a href="${pageContext.request.contextPath}/product/${product.id}">
                            <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/default-product.png" />
                            <c:if test="${not empty product.images}">
                                <c:forEach items="${product.images}" var="image">
                                    <c:if test="${image.primary}">
                                        <c:set var="imgUrl" value="${pageContext.request.contextPath}/uploads/${image.imageUrl}" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${imgUrl eq pageContext.request.contextPath.concat('/images/default-product.png')}">
                                    <c:set var="imgUrl" value="${pageContext.request.contextPath}/uploads/${product.images[0].imageUrl}" />
                                </c:if>
                            </c:if>

                            <div class="product-image-container">
                                <img src="${imgUrl}" alt="${product.name}" class="product-image">
                            </div>

                            <div class="product-info">
                                <div class="product-name">${product.name}</div>
                                <div class="product-price">
                                    <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                </div>
                            </div>
                                <div class="product-actions">
                                    <a href="${pageContext.request.contextPath}/wishlist/add/${product.id}" class="wishlist-btn">
                                        <i class="fa fa-heart-o"></i> Wishlist
                                    </a>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <p>No
                            products available at the moment. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Phần phân trang bằng JavaScript -->
        <div id="pagination" class="pagination"></div>

        <!-- Popular Products Section -->
        <div class="section-title">
            <h2>Popular Products</h2>
        </div>

        <div class="popular-products">
            <c:choose>
                <c:when test="${not empty allProducts}">
                    <jsp:useBean id="allProducts" scope="request" type="java.util.List"/>
                    <c:forEach items="${allProducts}" var="product" begin="0" end="2">
                        <div class="product-card">
                            <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/default-product.png" />
                            <c:if test="${not empty product.images}">
                                <c:forEach items="${product.images}" var="image">
                                    <c:if test="${image.primary}">
                                        <c:set var="imgUrl" value="${pageContext.request.contextPath}/uploads/${image.imageUrl}" />
                                    </c:if>
                                </c:forEach>
                                <c:if test="${imgUrl eq pageContext.request.contextPath.concat('/images/default-product.png')}">
                                    <c:set var="imgUrl" value="${pageContext.request.contextPath}/uploads/${product.images[0].imageUrl}" />
                                </c:if>
                            </c:if>

                            <div class="product-image-container">
                                <img src="${imgUrl}" alt="${product.name}" class="product-image">
                            </div>

                            <div class="product-info">
                                <div class="product-name">${product.name}</div>
                                <div class="product-price">$<fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</div>
                            </div>
                            <div class="product-actions">
                                <a href="#"><i class="fa fa-heart-o"></i> Wishlist</a>
                                <a><i class="fa fa-shopping-cart"></i>
                                    <button >
                                        Add To Cart
                                    </button></a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <p>No products available at the moment. Check back soon!</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Features Section -->
        <div class="features">
            <div class="feature">
                <div class="feature-icon">
                    <i class="fa fa-tag"></i>
                </div>
                <div class="feature-text">
                    <strong>Best prices</strong>
                    Orders $50 or more
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon">
                    <i class="fa fa-truck"></i>
                </div>
                <div class="feature-text">
                    <strong>Free delivery</strong>
                    Orders $50 or more
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon">
                    <i class="fa fa-percent"></i>
                </div>
                <div class="feature-text">
                    <strong>Great daily deal</strong>
                    When you sign up
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon">
                    <i class="fa fa-th-large"></i>
                </div>
                <div class="feature-text">
                    <strong>Wide assortment</strong>
                    Mega Discounts
                </div>
            </div>
            <div class="feature">
                <div class="feature-icon">
                    <i class="fa fa-refresh"></i>
                </div>
                <div class="feature-text">
                    <strong>Easy returns</strong>
                    Within 30 days
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<jsp:include page="layouts/footer.jsp" />

<!-- JavaScript cho phân trang -->
<script src="${pageContext.request.contextPath}/js/pagination.js"></script>
</body>
</html>
