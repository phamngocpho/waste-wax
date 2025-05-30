<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Management | Aromatic Candles</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Lato:wght@300;400;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            margin-top: 8%;
            font-family: 'Lato', sans-serif;
            background-color: #f8f5f2;
            color: #5a5a5a;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Playfair Display', serif;
            color: #3a3a3a;
        }

        .header-section {
            background-color: #f0e6dd;
            padding: 2.5rem 0;
            border-bottom: 1px solid #e9d9c9;
            margin-bottom: 2rem;
        }

        .page-title {
            font-weight: 700;
            letter-spacing: 0.5px;
            position: relative;
            display: inline-block;
        }

        .page-title:after {
            content: "";
            position: absolute;
            width: 60px;
            height: 3px;
            background-color: #d4a373;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background-color: #d4a373;
            color: white;
            border: none;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .table tbody tr:nth-of-type(odd) {
            background-color: rgba(212, 163, 115, 0.05);
        }

        .table tbody tr:hover {
            background-color: rgba(212, 163, 115, 0.1);
        }

        .badge.text-bg-warning {
            background-color: #ffd166 !important;
            color: #5a5a5a !important;
        }

        .badge.text-bg-primary {
            background-color: #118ab2 !important;
        }

        .badge.text-bg-info {
            background-color: #73bfb8 !important;
        }

        .badge.text-bg-success {
            background-color: #06d6a0 !important;
        }

        .badge.text-bg-danger {
            background-color: #ef476f !important;
        }

        .btn-danger {
            background-color: #e76f51;
            border: none;
            border-radius: 20px;
            padding: 0.4rem 1.2rem;
            font-size: 0.8rem;
            transition: all 0.3s ease;
        }

        .btn-danger:hover {
            background-color: #d65f41;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(231, 111, 81, 0.3);
        }

        .footer {
            background-color: #f0e6dd;
            padding: 1rem 0;
            margin-top: 3rem;
            text-align: center;
            font-size: 0.9rem;
            color: #8a8a8a;
        }
    </style>
    <script>
        function cancelOrder(orderId) {
            if (confirm("Are you sure you want to cancel this order?")) {
                fetch('/user/orders/cancel', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: new URLSearchParams({
                        orderId: orderId
                    })
                })
                    .then(response => response.json())
                    .then(data => {
                        alert(data.message);
                        if (data.success) {
                            location.reload(); // Reload the page to update the order list
                        }
                    })
                    .catch(error => console.error('Error:', error));
            }
        }
    </script>
</head>
<body>
<jsp:include page="layouts/nav.jsp" />

<div class="header-section">
    <div class="container">
        <h1 class="text-center page-title">Order List</h1>
    </div>
</div>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Created Date</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td>#${order.id}</td>
                                <td>${order.createdAt}</td>
                                <td>$${order.finalAmount}</td>
                                <td>
                                    <span class="badge
                                        <c:choose>
                                            <c:when test="${order.orderStatus.name() == 'PENDING'}">text-bg-warning</c:when>
                                            <c:when test="${order.orderStatus.name() == 'CONFIRMED'}">text-bg-primary</c:when>
                                            <c:when test="${order.orderStatus.name() == 'SHIPPED'}">text-bg-info</c:when>
                                            <c:when test="${order.orderStatus.name() == 'DELIVERED'}">text-bg-success</c:when>
                                            <c:when test="${order.orderStatus.name() == 'CANCELLED'}">text-bg-danger</c:when>
                                        </c:choose>
                                    ">
                                            ${order.orderStatus}
                                    </span>
                                </td>
                                <td>
                                    <c:if test="${order.orderStatus.name() == 'PENDING'}">
                                        <button class="btn btn-danger btn-sm" onclick="cancelOrder(${order.id})">
                                            <i class="fas fa-times me-1"></i> Cancel Order
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <div class="container">
        <p>&copy; 2025 Aromatic Candles. All rights reserved.</p>
    </div>
</div>

<jsp:include page="layouts/footer.jsp" />
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Font Awesome -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/js/all.min.js"></script>
</body>
</html>