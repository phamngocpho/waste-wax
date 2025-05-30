<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Candle Shop</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@300;400;500;600&family=Poppins:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homec.css">

</head>
<body>
<jsp:include page="layouts/nav.jsp" />
<div class="hero-section">
    <img class="hero-image" src="${pageContext.request.contextPath}/images/img_1.png" alt="Memoria Candle">
    <div class="exchange-info">
        <h2>Exchange<br>used<br>oil</h2>
        <a href="${pageContext.request.contextPath}/learn-more" class="learn-more">Learn more</a>
    </div>
    <a href="${pageContext.request.contextPath}/shop" class="shop-now-button">
        <span>Shop now</span>
        <div class="arrow-circle">
            <svg class="arrow-icon" width="16" height="16" viewBox="0 0 24 24">
                <path d="M12 4l-1.41 1.41L16.17 11H4v2h12.17l-5.58 5.59L12 20l8-8z"/>
            </svg>
        </div>
    </a>
</div>


<div class="container">
    <div class="content">
        <h1>What Make<br>Us Different</h1>
        <p>
            Welcome to a place where discarded oil is transformed
            into elegant, aromatic candles, bringing warmth and
            beauty to your space. Experience the magic of renewal
            and let every candle tell a story of care for the planet and
            the art of mindful living.
        </p>
        <button class="exchange-btn">Exchange Oil</button>
    </div>
    <div class="image-grid">
        <div class="image-main">
            <img src="${pageContext.request.contextPath}/images/home03.png" alt="Pouring oil" class="main-image">
        </div>
        <div class="image-secondary">
            <img src="${pageContext.request.contextPath}/images/home04.png" alt="Lit candle" class="secondary-image">
        </div>
    </div>
</div>

<div class="favorite-candles">
    <div class="section-header">
        <h2>OUR FAVORITE CANDLES</h2>
        <p>TRY OUR BEST CANDLES<br>ACCORDING TO OUR CUSTOMER</p>
    </div>
    <div class="products">
        <!-- Phần hiển thị sản phẩm nổi bật với thanh cuộn ngang -->
        <section class="featured-products-section">
            <div class="container">
                <div class="featured-products-container">
                    <div class="featured-products-scroll">
                        <jsp:useBean id="featuredProducts" scope="request" type="java.util.List"/>
                        <c:forEach items="${featuredProducts}" var="product">
                            <a href="${pageContext.request.contextPath}/product/${product.id}" class="product-card">
                                <!-- Lấy ảnh đầu tiên hoặc ảnh chính -->
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
                                    <h3 class="product-name">${product.name}</h3>
                                    <p class="product-price">
                                        <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND
                                    </p>
                                </div>
                            </a>
                            </a>
                        </c:forEach>
                    </div>
                    <button class="see-all" id="seeAllButton">See all</button>
                    <script>
                        document.getElementById('seeAllButton').addEventListener('click', function() {
                            window.location.href = '${pageContext.request.contextPath}/shop';
                        });
                    </script>

                </div>
            </div>
        </section>
    </div>

    <!-- Thêm thanh cuộn phía dưới -->
    <div class="bottom-scroll-container">
        <div class="bottom-scroll-content">
            <c:forEach items="${allProducts}" var="product">
                <div class="scroll-item">
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
                    <img src="${imgUrl}" alt="${product.name}">
                    <p>${product.name}</p>
                </div>
            </c:forEach>
        </div>
    </div>

    <img class="hero-image" src="${pageContext.request.contextPath}/images/home01.png" alt="home02">
</div>
<div class="our-process">
    <div class="process-header">
        <h2>Our Process</h2>
        <p>From Used Oil to Beautiful Candles</p>
    </div>
    <div class="process-steps">
        <div class="step">
            <div class="step-icon">
                <img src="${pageContext.request.contextPath}/images/collect.png" alt="Collect">
            </div>
            <h3>01. Collect</h3>
            <p>We collect used cooking oil from homes and restaurants</p>
        </div>
        <div class="step">
            <div class="step-icon">
                <img src="${pageContext.request.contextPath}/images/filter.png" alt="Filter">
            </div>
            <h3>02. Filter</h3>
            <p>The oil undergoes our special filtering process</p>
        </div>
        <div class="step">
            <div class="step-icon">
                <img src="${pageContext.request.contextPath}/images/transform.png" alt="Transform">
            </div>
            <h3>03. Transform</h3>
            <p>We transform the filtered oil into quality wax</p>
        </div>
        <div class="step">
            <div class="step-icon">
                <img src="${pageContext.request.contextPath}/images/create.png" alt="Create">
            </div>
            <h3>04. Create</h3>
            <p>Handcraft beautiful candles with natural fragrances</p>
        </div>
    </div>
</div>

<div class="testimonials">
    <div class="testimonials-header">
        <h2>What Our Customers Say</h2>
        <p>Real experiences from our valued customers</p>
    </div>
    <div class="testimonials-container">
        <div class="testimonial">
            <div class="quote">"These candles are amazing! Not only do they smell wonderful, but I love knowing that I'm contributing to sustainability."</div>
            <div class="author">
                <img src="${pageContext.request.contextPath}/images/avatar1.jpg" alt="Sarah M." class="author-image">
                <div class="author-info">
                    <h4>Sarah M.</h4>
                    <p>Regular Customer</p>
                </div>
            </div>
        </div>
        <div class="testimonial">
            <div class="quote">"The exchange program is brilliant. It's so easy to participate and the candles are of exceptional quality."</div>
            <div class="author">
                <img src="${pageContext.request.contextPath}/images/avatar2.jpg" alt="John D." class="author-image">
                <div class="author-info">
                    <h4>John D.</h4>
                    <p>Restaurant Owner</p>
                </div>
            </div>
        </div>
        <div class="testimonial">
            <div class="quote">"Beautiful packaging, wonderful scents, and an eco-friendly approach. What's not to love?"</div>
            <div class="author">
                <img src="${pageContext.request.contextPath}/images/avatar3.jpg" alt="Emma L." class="author-image">
                <div class="author-info">
                    <h4>Emma L.</h4>
                    <p>Verified Buyer</p>
                </div>
            </div>
        </div>
    </div>
</div>



<%-- Include footer --%>
<jsp:include page="layouts/footer.jsp" />
</body>

</html>
