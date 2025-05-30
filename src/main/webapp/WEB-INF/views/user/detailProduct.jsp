<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name}- Candle Shop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/detailProduct.css">
</head>

<body>
<!-- Header -->
<jsp:include page="layouts/nav.jsp" />
<div class="container">
    <div class="product-details">
        <!-- Product Gallery -->
        <div class="product-gallery">
            <div class="thumbnail-list">
                <c:forEach items="${images}" var="image" varStatus="status">
                    <div class="thumbnail ${status.index == 0 ? 'active' : ''}">
                        <img src="${pageContext.request.contextPath}/uploads/${image.imageUrl}" alt="${product.name} - View ${status.index + 1}">
                    </div>
                </c:forEach>

                <c:if test="${empty images}">
                    <div class="thumbnail active">
                        <img src="${pageContext.request.contextPath}/images/default-product.jpg" alt="${product.name}">
                    </div>
                </c:if>
            </div>
            <div class="main-image">
                <c:choose>
                    <c:when test="${not empty images}"><jsp:useBean id="images" scope="request" type="java.util.List"/>

                        <img src="${pageContext.request.contextPath}/uploads/${images[0].imageUrl}" alt="${product.name}" id="mainProductImage">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/images/default-product.jpg" alt="${product.name}" id="mainProductImage">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Product Info -->
        <div class="product-info">
            <h1 class="product-title">${product.name}</h1>

            <!-- Rating -->
            <div class="rating">
                <div class="stars">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star-half-alt"></i>
                </div>
                <span class="rating-value">4.5</span>
                <span class="review-count">110 Reviews</span>
            </div>

            <!-- Description -->
            <p class="description">
                ${product.description}
            </p>

            <!-- Size Options -->
            <div class="size-options">
                <c:forEach items="${sizes}" var="size" varStatus="status">
                    <button class="size-option ${status.index == 0 ? 'active' : ''}"
                            data-size="${size.sizeValue}"
                            data-price="${size.price}"
                            data-size-id="${size.id}">
                            ${size.sizeValue} ml
                    </button>
                </c:forEach>

                <!-- Nếu không có kích thước, hiển thị kích thước mặc định -->
                <c:if test="${empty sizes}">
                    <button class="size-option active" data-size="2333" data-price="${product.basePrice}" data-size-id="0">
                        2333 ml
                    </button>
                </c:if>
            </div>

            <!-- Price -->
            <!-- Price -->
            <div class="price-container">
                <c:choose>
                    <c:when test="${not empty sizes}">
                        <span class="current-price" id="current-price"><fmt:formatNumber value="${sizes[0].price}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                        <span class="original-price" id="original-price"><fmt:formatNumber value="${sizes[0].price * 1.08}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                    </c:when>
                    <c:otherwise>
                        <span class="current-price" id="current-price"><fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                        <span class="original-price" id="original-price"><fmt:formatNumber value="${product.basePrice * 1.08}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Phần chọn số lượng và thêm vào giỏ hàng -->
            <div class="mt-8 space-y-4">
                <!-- Quantity Selector -->
                <div class="quantity-container">
                    <label for="quantity">Số lượng:</label>
                    <div class="quantity-controls">
                        <button type="button" class="quantity-btn minus" onclick="decrementQuantity()">-</button>
                        <input type="number" id="quantity" name="quantity" value="1" min="1" max="99">
                        <button type="button" class="quantity-btn plus" onclick="incrementQuantity()">+</button>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button onclick="addToCart()"
                            class="flex-1 bg-brown-600 hover:bg-brown-700 text-white px-6 py-3 rounded-md
                flex items-center justify-center gap-2 transition-all duration-300">
                        <i class="fas fa-shopping-cart"></i>
                        <span>Add to cart</span>
                    </button>
                    <div class="wishlist-button">
                        <a href="${pageContext.request.contextPath}/wishlist/add/${product.id}?redirect=wishlist" class="btn wishlist-btn">
                            <i class="fa fa-heart-o"></i> Add to Wishlist
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Favorite Products Section -->
<section class="favorite-products">
    <div class="container">
        <h2 class="section-title">OUR FAVORITE CANDLES</h2>
        <p class="section-subtitle">TRY OUR BEST CANDLES ACCORDING TO OUR CUSTOMER</p>

        <div class="product-grid">
            <c:forEach items="${favoriteProducts}" var="favProduct" begin="0" end="4">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product/${favProduct.id}">
                        <c:set var="favProductImages" value="${productImageService.getImagesByProductId(favProduct.id)}" />
                        <c:choose>
                            <c:when test="${not empty favProductImages}">
                                <img src="${pageContext.request.contextPath}/uploads/${favProductImages[0].imageUrl}" alt="${favProduct.name}" class="product-image">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/default-product.jpg" alt="${favProduct.name}" class="product-image">
                            </c:otherwise>
                        </c:choose>
                        <div class="product-info">
                            <h3 class="product-name">${favProduct.name}</h3>
                            <p class="product-price"><fmt:formatNumber value="${favProduct.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VND</p>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <div class="see-all-container">
            <a href="${pageContext.request.contextPath}/shop" class="see-all-btn">See all</a>
        </div>
    </div>
</section>

<!-- Benefits Section -->
<section class="benefits-section">
    <div class="container">
        <div class="benefits-grid">
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-tag"></i>
                </div>
                <div class="benefit-content">
                    <h3>Best prices</h3>
                    <p>Orders $50 or more</p>
                </div>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <div class="benefit-content">
                    <h3>Free delivery</h3>
                    <p>24/7 amazing services</p>
                </div>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-percent"></i>
                </div>
                <div class="benefit-content">
                    <h3>Great daily deal</h3>
                    <p>When you sign up</p>
                </div>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-th-large"></i>
                </div>
                <div class="benefit-content">
                    <h3>Wide assortment</h3>
                    <p>Mega Discounts</p>
                </div>
            </div>
            <div class="benefit-item">
                <div class="benefit-icon">
                    <i class="fas fa-undo"></i>
                </div>
                <div class="benefit-content">
                    <h3>Easy returns</h3>
                    <p>Within 30 days</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<jsp:include page="layouts/footer.jsp" />

<script>
    // Xử lý chọn kích thước
    document.addEventListener('DOMContentLoaded', function() {
        const sizeOptions = document.querySelectorAll('.size-option');
        const currentPriceElement = document.getElementById('current-price');
        const originalPriceElement = document.getElementById('original-price');
        const quantityInput = document.getElementById('quantity');

        // Khởi tạo giá ban đầu
        let currentPrice = parseFloat('${not empty sizes ? sizes[0].price : product.basePrice}');
        let currentOriginalPrice = currentPrice * 1.08;
        let currentSizeId = '${not empty sizes ? sizes[0].id : "0"}';

        function formatPrice(price) {
            return '$' + price.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        }

        function updatePrice() {
            const quantity = parseInt(quantityInput.value) || 1;
            currentPriceElement.textContent = formatPrice(currentPrice);
            originalPriceElement.textContent = formatPrice(currentOriginalPrice);
        }

        function formatPrice(price) {
            return price.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ',') + ' VND';
        }

        // Thêm sự kiện click cho mỗi nút kích thước
        sizeOptions.forEach(option => {
            option.addEventListener('click', function() {
                // Bỏ class active khỏi tất cả các nút
                sizeOptions.forEach(opt => opt.classList.remove('active'));

                // Thêm class active vào nút được chọn
                this.classList.add('active');

                // Lấy giá của kích thước được chọn
                currentPrice = parseFloat(this.getAttribute('data-price'));
                currentOriginalPrice = currentPrice * 1.08;
                currentSizeId = this.getAttribute('data-size-id');

                // Cập nhật giá hiển thị
                updatePrice();
            });
        });

        // Xử lý số lượng
        window.incrementQuantity = function() {
            const value = parseInt(quantityInput.value) || 0;
            quantityInput.value = value + 1;
            updatePrice();
        }

        window.decrementQuantity = function() {
            const value = parseInt(quantityInput.value) || 2;
            if (value > 1) {
                quantityInput.value = value - 1;
                updatePrice();
            }
        }

        // Xử lý khi người dùng nhập số lượng trực tiếp
        quantityInput.addEventListener('input', updatePrice);

        // Xử lý thêm vào giỏ hàng
        window.addToCart = function() {
            const productId = ${product.id};
            const quantity = parseInt(quantityInput.value) || 1;

            const sizeSelect = document.querySelector('.size-option.active');
            if (!sizeSelect) {
                alert("Vui lòng chọn kích thước sản phẩm");
                return;
            }

            const sizeId = sizeSelect.dataset.sizeId;

            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/cart/add';

            const inputs = {
                productId: productId,
                sizeId: sizeId,
                quantity: quantity
            };

            for (const [name, value] of Object.entries(inputs)) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = name;
                input.value = value;
                form.appendChild(input);
            }

            document.body.appendChild(form);
            form.submit();
        }

        // Khởi tạo giá ban đầu khi trang load xong
        updatePrice();
    });

    // Xử lý hình ảnh thu nhỏ
    document.addEventListener('DOMContentLoaded', function() {
        const thumbnails = document.querySelectorAll('.thumbnail');
        const mainImage = document.getElementById('mainProductImage');

        thumbnails.forEach(thumbnail => {
            thumbnail.addEventListener('click', function() {
                // Bỏ class active khỏi tất cả các thumbnail
                thumbnails.forEach(thumb => thumb.classList.remove('active'));

                // Thêm class active vào thumbnail được chọn
                this.classList.add('active');

                // Cập nhật hình ảnh chính
                const imgSrc = this.querySelector('img').src;
                mainImage.src = imgSrc;
            });
        });
    });

    // Cập nhật số lượng giỏ hàng
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(response => response.text())
            .then(count => {
                const cartCountElement = document.getElementById('cartCount');
                if (cartCountElement) {
                    cartCountElement.textContent = count;
                }
            })
            .catch(error => console.error('Error updating cart count:', error));
    }
</script>

</body>
</html>