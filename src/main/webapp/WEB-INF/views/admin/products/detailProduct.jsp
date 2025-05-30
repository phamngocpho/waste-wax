<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm - ${product.name}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp"/>
    <jsp:include page="../layouts/sidebar.jsp"/>
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
<div class="ml-[250px] min-h-screen">
    <main class="flex-1 p-6 space-y-6">
        <!-- Header -->
        <div class="flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-bold tracking-tight">Chi tiết sản phẩm</h1>
                <p class="text-muted-foreground">Thông tin chi tiết về sản phẩm ${product.name}</p>
            </div>
            <div class="flex gap-2">
                <a href="/admin/products"
                   class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                    <i class="fas fa-arrow-left w-4 h-4 mr-2"></i>
                    Quay lại
                </a>
                <a href="/admin/products/edit/${product.id}" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors
                                                focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                    <i class="fas fa-edit w-4 h-4 mr-2"></i>
                    Chỉnh sửa
                </a>
            </div>
        </div>

        <div class="grid gap-6 lg:grid-cols-2">
            <!-- Product Images -->
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                <div class="flex flex-col space-y-1.5 p-6 pb-4">
                    <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                        <i class="fas fa-images w-4 h-4 mr-2 text-blue-600"></i>
                        Hình ảnh sản phẩm
                    </h3>
                </div>
                <div class="p-6 pt-0">
                    <c:choose>
                        <c:when test="${not empty productImages}">
                            <div class="space-y-4">
                                <!-- Main Image -->
                                <div class="relative rounded-lg overflow-hidden bg-gray-50">
                                    <img id="mainImage"
                                         src="/uploads/${productImages[0].imageUrl}"
                                         alt="${product.name}"
                                         class="w-full h-80 object-contain">
                                    <c:forEach items="${productImages}" var="image">
                                        <c:if test="${image.primary}">
                                            <div class="absolute top-4 right-4">
                                                    <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                                                        <i class="fas fa-star w-3 h-3 mr-1"></i>Ảnh chính
                                                    </span>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>

                                <!-- Thumbnail Grid -->
                                <c:if test="${productImages.size() > 1}">
                                    <div class="grid grid-cols-4 gap-2">
                                        <c:forEach items="${productImages}" var="image" varStatus="status">
                                            <img src="/uploads/${image.imageUrl}"
                                                 alt="Thumbnail ${status.index + 1}"
                                                 class="w-full h-20 object-cover rounded-md cursor-pointer border-2 transition-all hover:border-primary ${status.index == 0 ? 'border-primary' : 'border-gray-200'}"
                                                 onclick="changeMainImage(this, ${status.index})">
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-col items-center justify-center py-12 text-muted-foreground">
                                <i class="fas fa-image text-4xl mb-4"></i>
                                <p>Không có hình ảnh</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Product Information -->
            <div class="space-y-6">
                <!-- Basic Info -->
                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6 pb-4">
                        <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                            <i class="fas fa-info-circle w-4 h-4 mr-2 text-green-600"></i>
                            Thông tin cơ bản
                        </h3>
                    </div>
                    <div class="p-6 pt-0 space-y-4">
                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="text-sm font-medium text-muted-foreground">ID sản phẩm</label>
                                <div class="font-mono text-sm text-primary">#${product.id}</div>
                            </div>
                            <div>
                                <label class="text-sm font-medium text-muted-foreground">Trạng thái</label>
                                <div class="mt-1">
                                    <c:choose>
                                        <c:when test="${product.status == 'ACTIVE'}">
                                                <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800">
                                                    <i class="fas fa-check-circle w-3 h-3 mr-1"></i>Đang bán
                                                </span>
                                        </c:when>
                                        <c:otherwise>
                                                <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-gray-100 text-gray-800">
                                                    <i class="fas fa-pause w-3 h-3 mr-1"></i>Ngừng bán
                                                </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <div>
                            <label class="text-sm font-medium text-muted-foreground">Tên sản phẩm</label>
                            <div class="text-lg font-semibold">${product.name}</div>
                        </div>

                        <div>
                            <label class="text-sm font-medium text-muted-foreground">Danh mục</label>
                            <div class="mt-1">
                                    <span class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-sm font-medium text-gray-600 ring-1 ring-inset ring-gray-500/10">
                                        ${product.category != null ? product.category.name : 'Không có danh mục'}
                                    </span>
                            </div>
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label class="text-sm font-medium text-muted-foreground">Giá cơ bản</label>
                                <div class="text-xl font-bold text-green-600">
                                    <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true"
                                                      maxFractionDigits="0"/> VNĐ
                                </div>
                            </div>
                            <div>
                                <label class="text-sm font-medium text-muted-foreground">Số lượng tồn kho</label>
                                <div class="text-xl font-bold">
                                    <c:choose>
                                        <c:when test="${product.stockQuantity > 10}">
                                            <span class="text-green-600">${product.stockQuantity}</span>
                                        </c:when>
                                        <c:when test="${product.stockQuantity > 0}">
                                            <span class="text-yellow-600">${product.stockQuantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-red-600">Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <c:if test="${product.discountPercentage > 0}">
                            <div>
                                <label class="text-sm font-medium text-muted-foreground">Giảm giá</label>
                                <div class="flex items-center gap-2">
                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-red-100 text-red-800">
                                            <i class="fas fa-tag w-3 h-3 mr-1"></i>${product.discountPercentage}%
                                        </span>
                                    <span class="text-sm text-muted-foreground">
                                            Giá sau giảm: <span class="font-semibold text-green-600">
                                                <fmt:formatNumber
                                                        value="${product.basePrice * (100 - product.discountPercentage) / 100}"
                                                        type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ
                                            </span>
                                        </span>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${product.featured}">
                            <div>
                                    <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                                        <i class="fas fa-star w-3 h-3 mr-1"></i>Sản phẩm nổi bật
                                    </span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Description -->
                <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                    <div class="flex flex-col space-y-1.5 p-6 pb-4">
                        <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                            <i class="fas fa-align-left w-4 h-4 mr-2 text-purple-600"></i>
                            Mô tả sản phẩm
                        </h3>
                    </div>
                    <div class="p-6 pt-0">
                        <c:choose>
                            <c:when test="${not empty product.description}">
                                <div class="prose prose-sm max-w-none">
                                    <div class="bg-gray-50 rounded-lg p-4 border-l-4 border-primary">
                                            ${product.description}
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-8 text-muted-foreground">
                                    <i class="fas fa-file-alt text-2xl mb-2"></i>
                                    <p>Chưa có mô tả</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Product Sizes -->
        <c:if test="${not empty productSizes}">
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
                <div class="flex flex-col space-y-1.5 p-6 pb-4">
                    <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                        <i class="fas fa-ruler w-4 h-4 mr-2 text-orange-600"></i>
                        Kích thước và giá
                    </h3>
                </div>
                <div class="p-6 pt-0">
                    <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                        <c:forEach items="${productSizes}" var="size">
                            <div class="rounded-lg border p-4 space-y-2">
                                <div class="flex items-center justify-between">
                                    <h4 class="font-semibold">${size.size.name}</h4>
                                    <span class="text-sm text-muted-foreground">${size.size.description}</span>
                                </div>
                                <div class="text-lg font-bold text-green-600">
                                    <fmt:formatNumber value="${size.price}" type="number" groupingUsed="true"
                                                      maxFractionDigits="0"/> VNĐ
                                </div>
                                <div class="text-sm text-muted-foreground">
                                    Kho: <span class="font-medium">${size.stockQuantity}</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Timestamps -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="flex flex-col space-y-1.5 p-6 pb-4">
                <h3 class="text-lg font-semibold leading-none tracking-tight flex items-center">
                    <i class="fas fa-clock w-4 h-4 mr-2 text-gray-600"></i>
                    Thông tin thời gian
                </h3>
            </div>
            <div class="p-6 pt-0">
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <label class="font-medium text-muted-foreground">Ngày tạo</label>
                        <div class="mt-1">
                            <fmt:parseDate value="${product.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="createdDate"
                                           type="both"/>
                            <fmt:formatDate value="${createdDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                        </div>
                    </div>
                    <div>
                        <label class="font-medium text-muted-foreground">Cập nhật cuối</label>
                        <div class="mt-1">
                            <fmt:parseDate value="${product.updatedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="updatedDate"
                                           type="both"/>
                            <fmt:formatDate value="${updatedDate}" pattern="dd/MM/yyyy 'lúc' HH:mm"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function changeMainImage(thumbnail, index) {
        // Update main image
        const mainImage = document.getElementById('mainImage');
        mainImage.src = thumbnail.src;

        // Update thumbnail borders
        document.querySelectorAll('.grid img').forEach((img, i) => {
            if (i === index) {
                img.classList.add('border-primary');
                img.classList.remove('border-gray-200');
            } else {
                img.classList.remove('border-primary');
                img.classList.add('border-gray-200');
            }
        });
    }

    // Keyboard navigation for images
    document.addEventListener('keydown', function (e) {
        const thumbnails = document.querySelectorAll('.grid img');
        if (thumbnails.length <= 1) return;

        let currentIndex = Array.from(thumbnails).findIndex(img =>
            img.classList.contains('border-primary')
        );

        if (e.key === 'ArrowLeft' && currentIndex > 0) {
            e.preventDefault();
            changeMainImage(thumbnails[currentIndex - 1], currentIndex - 1);
        } else if (e.key === 'ArrowRight' && currentIndex < thumbnails.length - 1) {
            e.preventDefault();
            changeMainImage(thumbnails[currentIndex + 1], currentIndex + 1);
        }
    });
</script>
</body>
</html>
