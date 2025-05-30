<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sản phẩm</title>
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
                <h1 class="text-3xl font-bold tracking-tight">Sản phẩm</h1>
                <p class="text-muted-foreground">Quản lý toàn bộ sản phẩm trong hệ thống</p>
            </div>
            <a href="/admin/products/create" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                <i class="fas fa-plus w-4 h-4 mr-2"></i>
                Thêm sản phẩm
            </a>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty success}">
            <div class="rounded-lg border border-green-200 bg-green-50 p-4 text-green-800" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-check-circle w-4 h-4 mr-2"></i>
                        ${success}
                    <button onclick="this.parentElement.parentElement.remove()" class="ml-auto">
                        <i class="fas fa-times w-4 h-4"></i>
                    </button>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="rounded-lg border border-red-200 bg-red-50 p-4 text-red-800" role="alert">
                <div class="flex items-center">
                    <i class="fas fa-exclamation-circle w-4 h-4 mr-2"></i>
                        ${error}
                    <button onclick="this.parentElement.parentElement.remove()" class="ml-auto">
                        <i class="fas fa-times w-4 h-4"></i>
                    </button>
                </div>
            </div>
        </c:if>

        <!-- Stats Cards -->
        <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Tổng sản phẩm</h3>
                    <i class="fas fa-box h-4 w-4 text-muted-foreground"></i>
                </div>
                <div class="text-2xl font-bold">${products.size()}</div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Đang bán</h3>
                    <i class="fas fa-check-circle h-4 w-4 text-green-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="activeCount" value="0"/>
                    <c:forEach items="${products}" var="product">
                        <c:if test="${product.status == 'ACTIVE'}">
                            <c:set var="activeCount" value="${activeCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${activeCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Nổi bật</h3>
                    <i class="fas fa-star h-4 w-4 text-yellow-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="featuredCount" value="0"/>
                    <c:forEach items="${products}" var="product">
                        <c:if test="${product.featured}">
                            <c:set var="featuredCount" value="${featuredCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${featuredCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Sắp hết hàng</h3>
                    <i class="fas fa-exclamation-triangle h-4 w-4 text-red-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="lowStockCount" value="0"/>
                    <c:forEach items="${products}" var="product">
                        <c:if test="${product.stockQuantity <= 5}">
                            <c:set var="lowStockCount" value="${lowStockCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${lowStockCount}
                </div>
            </div>
        </div>

        <!-- Search and Filter -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="p-6">
                <div class="flex flex-col md:flex-row gap-4">
                    <div class="flex-1">
                        <div class="relative">
                            <i class="fas fa-search absolute left-3 top-1/2 transform -translate-y-1/2 text-muted-foreground w-4 h-4"></i>
                            <input type="text" placeholder="Tìm kiếm sản phẩm..."
                                   class="flex h-10 w-full rounded-md border border-input bg-background pl-10 pr-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                   id="searchInput">
                        </div>
                    </div>
                    <div class="flex gap-2">
                        <select class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" id="categoryFilter">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach items="${categories}" var="category">
                                <option value="${category.name}">${category.name}</option>
                            </c:forEach>
                        </select>
                        <select class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50" id="statusFilter">
                            <option value="">Tất cả trạng thái</option>
                            <option value="ACTIVE">Đang bán</option>
                            <option value="INACTIVE">Ngừng bán</option>
                        </select>
                        <button onclick="resetFilters()" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                            <i class="fas fa-undo w-4 h-4"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products Table -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="relative w-full overflow-auto">
                <c:choose>
                    <c:when test="${not empty products}">
                        <table class="w-full caption-bottom text-sm" id="productsTable">
                            <thead class="[&_tr]:border-b">
                            <tr class="border-b transition-colors hover:bg-muted/50">
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">ID</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Sản phẩm</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Danh mục</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Giá</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Kho</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Trạng thái</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody class="[&_tr:last-child]:border-0">
                            <c:forEach items="${products}" var="product">
                                <tr class="border-b transition-colors hover:bg-muted/50 product-row"
                                    data-name="${product.name}"
                                    data-category="${product.category != null ? product.category.name : ''}"
                                    data-status="${product.status}">
                                    <td class="p-4 align-middle">
                                        <div class="font-mono text-sm text-primary">#${product.id}</div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-3">
                                            <div class="relative">
                                                <c:set var="hasImage" value="false"/>
                                                <c:forEach items="${product.images}" var="image">
                                                    <c:if test="${image.primary == true}">
                                                        <img src="/uploads/${image.imageUrl}" alt="${product.name}"
                                                             class="h-12 w-12 rounded-md object-cover border">
                                                        <c:set var="hasImage" value="true"/>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${not hasImage}">
                                                    <div class="h-12 w-12 rounded-md bg-muted flex items-center justify-center">
                                                        <i class="fas fa-image text-muted-foreground"></i>
                                                    </div>
                                                </c:if>
                                                <c:if test="${product.featured}">
                                                    <div class="absolute -top-1 -right-1 h-4 w-4 bg-yellow-500 rounded-full flex items-center justify-center">
                                                        <i class="fas fa-star text-white text-xs"></i>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div>
                                                <div class="font-medium text-sm">${product.name}</div>
                                                <c:if test="${product.discountPercentage > 0}">
                                                    <div class="text-xs text-red-600">
                                                        <i class="fas fa-tag w-3 h-3 mr-1"></i>-${product.discountPercentage}%
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                                <span class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-600 ring-1 ring-inset ring-gray-500/10">
                                                        ${product.category != null ? product.category.name : 'Không có'}
                                                </span>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="font-medium text-green-600">
                                            <fmt:formatNumber value="${product.basePrice}" type="number" groupingUsed="true" maxFractionDigits="0"/> VNĐ
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <c:choose>
                                            <c:when test="${product.stockQuantity > 10}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800">
                                                            <i class="fas fa-check w-3 h-3 mr-1"></i>${product.stockQuantity}
                                                        </span>
                                            </c:when>
                                            <c:when test="${product.stockQuantity > 0}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-yellow-100 text-yellow-800">
                                                            <i class="fas fa-exclamation w-3 h-3 mr-1"></i>${product.stockQuantity}
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-red-100 text-red-800">
                                                            <i class="fas fa-times w-3 h-3 mr-1"></i>Hết hàng
                                                        </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-4 align-middle">
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
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-1">
                                            <a href="/admin/products/detail/${product.id}"
                                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8"
                                               title="Xem chi tiết">
                                                <i class="fas fa-eye w-3 h-3"></i>
                                            </a>
                                            <a href="/admin/products/edit/${product.id}"
                                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8"
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit w-3 h-3"></i>
                                            </a>
                                            <button onclick="confirmDelete(${product.id}, '${product.name}')"
                                                    class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8 text-red-600 hover:text-red-700"
                                                    title="Xóa">
                                                <i class="fas fa-trash w-3 h-3"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="flex flex-col items-center justify-center py-12">
                            <i class="fas fa-box text-4xl text-muted-foreground mb-4"></i>
                            <h3 class="text-lg font-semibold">Chưa có sản phẩm</h3>
                            <p class="text-muted-foreground">Hãy thêm sản phẩm đầu tiên</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center z-50">
    <div class="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <div class="flex items-center mb-4">
            <i class="fas fa-exclamation-triangle text-red-500 text-xl mr-3"></i>
            <h3 class="text-lg font-semibold">Xác nhận xóa</h3>
        </div>
        <p class="text-muted-foreground mb-6" id="deleteModalBody">
            Bạn có chắc chắn muốn xóa sản phẩm này?
        </p>
        <div class="flex justify-end gap-3">
            <button onclick="closeDeleteModal()" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                Hủy
            </button>
            <a href="#" id="confirmDeleteButton" class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-red-600 text-white hover:bg-red-700 h-10 px-4 py-2">
                Xóa
            </a>
        </div>
    </div>
</div>

<script>
    // Auto-hide alerts
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('[role="alert"]');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.3s';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });

    // Search and filter functionality
    document.getElementById('searchInput').addEventListener('input', filterProducts);
    document.getElementById('categoryFilter').addEventListener('change', filterProducts);
    document.getElementById('statusFilter').addEventListener('change', filterProducts);

    function filterProducts() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const categoryFilter = document.getElementById('categoryFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('.product-row');

        rows.forEach(row => {
            const name = row.dataset.name.toLowerCase();
            const category = row.dataset.category;
            const status = row.dataset.status;

            const matchesSearch = name.includes(searchTerm);
            const matchesCategory = !categoryFilter || category === categoryFilter;
            const matchesStatus = !statusFilter || status === statusFilter;

            if (matchesSearch && matchesCategory && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function resetFilters() {
        document.getElementById('searchInput').value = '';
        document.getElementById('categoryFilter').value = '';
        document.getElementById('statusFilter').value = '';
        filterProducts();
    }

    // Delete modal functions
    function confirmDelete(productId, productName) {
        document.getElementById('deleteModalBody').textContent = `Bạn có chắc chắn muốn xóa sản phẩm "${productName}"?`;
        document.getElementById('confirmDeleteButton').href = `/admin/products/delete/${productId}`;
        document.getElementById('deleteModal').classList.remove('hidden');
        document.getElementById('deleteModal').classList.add('flex');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
        document.getElementById('deleteModal').classList.remove('flex');
    }

    // Close modal when clicking outside
    document.getElementById('deleteModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeDeleteModal();
        }
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeDeleteModal();
        }
        if (e.ctrlKey && e.key === 'k') {
            e.preventDefault();
            document.getElementById('searchInput').focus();
        }
    });
</script>
</body>
</html>