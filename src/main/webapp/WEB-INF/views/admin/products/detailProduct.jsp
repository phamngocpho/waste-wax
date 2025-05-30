<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết sản phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="/css/admin.css" rel="stylesheet">
    <jsp:include page="../layouts/header.jsp" />
    <jsp:include page="../layouts/sidebar.jsp" />
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->


        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Chi tiết sản phẩm</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="/admin/products" class="btn btn-secondary me-2">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="/admin/products/edit/${product.id}" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Chỉnh sửa
                    </a>
                </div>
            </div>

            <!-- Thông tin sản phẩm -->
            <div class="row">
                <!-- Hình ảnh sản phẩm -->
                <div class="col-md-4">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5>Hình ảnh sản phẩm</h5>
                        </div>
                        <div class="card-body">
                            <div id="productImageCarousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner">
                                    <c:forEach items="${productImages}" var="image" varStatus="status">
                                        <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                                            <img src="/uploads/${image.imageUrl}" class="d-block w-100" alt="Product Image" style="height: 300px; object-fit: contain;">
                                            <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50">
                                                <h5>${image.primary ? 'Ảnh chính' : 'Ảnh bổ sung'}</h5>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <c:if test="${productImages.size() > 1}">
                                    <button class="carousel-control-prev" type="button" data-bs-target="#productImageCarousel" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#productImageCarousel" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </c:if>
                            </div>

                            <div class="row mt-3">
                                <c:forEach items="${productImages}" var="image" varStatus="status">
                                    <div class="col-3">
                                        <img src="/uploads/${image.imageUrl}" class="img-thumbnail ${image.primary ? 'border-primary' : ''}" alt="Thumbnail"
                                             style="height: 60px; object-fit: cover; cursor: pointer;"
                                             onclick="document.querySelector('#productImageCarousel').querySelector('.carousel-item:nth-child(${status.index + 1})').classList.add('active')">
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông tin cơ bản -->
                <div class="col-md-8">
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5>Thông tin cơ bản</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped">
                                <tr>
                                    <th style="width: 30%">ID</th>
                                    <td>${product.id}</td>
                                </tr>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <td>${product.name}</td>
                                </tr>
                                <tr>
                                    <th>Danh mục</th>
                                    <td>${product.category != null ? product.category.name : 'Không có danh mục'}</td>
                                </tr>
                                <tr>
                                    <th>Giá cơ bản</th>
                                    <td><fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="VNĐ" /></td>
                                </tr>
                                <tr>
                                    <th>Giảm giá</th>
                                    <td>${product.discountPercentage}%</td>
                                </tr>
                                <tr>
                                    <th>Số lượng kho</th>
                                    <td>${product.stockQuantity}</td>
                                </tr>
                                <tr>
                                    <th>Loại hương</th>
                                    <td>${not empty product.scentType ? product.scentType : 'Không có thông tin'}</td>
                                </tr>
                                <tr>
                                    <th>Sản phẩm nổi bật</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.featured}">
                                                <span class="badge bg-success">Có</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Không</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Trạng thái</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.status == 'ACTIVE'}">
                                                <span class="badge bg-success">Đang bán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">Ngừng bán</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Ngày tạo</th>
                                    <td><fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!-- Mô tả sản phẩm -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5>Mô tả sản phẩm</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty product.description}">
                                    <p>${product.description}</p>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Không có mô tả</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Kích thước sản phẩm -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5>Kích thước sản phẩm</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty productSizes}">
                                    <div class="table-responsive">
                                        <table class="table table-striped">
                                            <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Kích thước (ml)</th>
                                                <th>Giá (VNĐ)</th>
                                                <th>Số lượng kho</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${productSizes}" var="size">
                                                <tr>
                                                    <td>${size.id}</td>
                                                    <td>${size.sizeValue}</td>
                                                    <td><fmt:formatNumber value="${size.price}" type="currency" currencySymbol="VNĐ" /></td>
                                                    <td>${size.stockQuantity}</td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted">Không có kích thước nào được định nghĩa</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

