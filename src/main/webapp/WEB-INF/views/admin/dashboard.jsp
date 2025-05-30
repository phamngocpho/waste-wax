<!-- dashboard.jsp -->
<%@ include file="layouts/header.jsp" %>
<%@ include file="layouts/sidebar.jsp" %>

<div class="main-content">
    <div class="header">
        <h4 class="mb-0">Dashboard</h4>
        <div class="ms-auto">
            <span class="text-muted">Welcome, ${adminUser.fullName}</span>
        </div>
    </div>

    <div class="content-area">
        <!-- Statistics Cards -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0">
                                <i class='bx bxs-cart bx-lg'></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h3 class="mb-0">${totalOrders}</h3>
                                <div class="text-white-50">Total Orders</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0">
                                <i class='bx bxs-user bx-lg'></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h3 class="mb-0">${totalUsers}</h3>
                                <div class="text-white-50">Total Users</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0">
                                <i class='bx bxs-droplet bx-lg'></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h3 class="mb-0">${totalOilExchanges}</h3>
                                <div class="text-white-50">Oil Exchanges</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body">
                        <div class="d-flex align-items-center">
                            <div class="flex-shrink-0">
                                <i class='bx bxs-dollar-circle bx-lg'></i>
                            </div>
                            <div class="flex-grow-1 ms-3">
                                <h3 class="mb-0">$${totalRevenue}</h3>
                                <div class="text-white-50">Total Revenue</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row mb-4">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Revenue Statistics</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart" height="300"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Top Products</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="productsChart" height="300"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recent Activities -->
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${recentOrders}" var="order">
                                    <tr>
                                        <td>#${order.orderNumber}</td>
                                        <td>${order.customerName}</td>
                                        <td>$${order.amount}</td>
                                        <td>
                                                <span class="badge bg-${order.status == 'COMPLETED' ? 'success' :
                                                    order.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${order.status}
                                                </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Recent Oil Exchanges</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>Exchange ID</th>
                                    <th>User</th>
                                    <th>Oil Amount</th>
                                    <th>Status</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${recentExchanges}" var="exchange">
                                    <tr>
                                        <td>#${exchange.exchangeNumber}</td>
                                        <td>${exchange.userName}</td>
                                        <td>${exchange.oilAmount}L</td>
                                        <td>
                                                <span class="badge bg-${exchange.status == 'COMPLETED' ? 'success' :
                                                    exchange.status == 'PENDING' ? 'warning' : 'danger'}">
                                                        ${exchange.status}
                                                </span>
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
    </div>
</div>

<script>
    // Revenue Chart
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    new Chart(revenueCtx, {
        type: 'line',
        data: {
            labels: ${revenueLabels},
            datasets: [{
                label: 'Revenue',
                data: ${revenueData},
                borderColor: '#8B4513',
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });

    // Products Chart
    const productsCtx = document.getElementById('productsChart').getContext('2d');
    new Chart(productsCtx, {
        type: 'doughnut',
        data: {
            labels: ${productLabels},
            datasets: [{
                data: ${productData},
                backgroundColor: [
                    '#8B4513',
                    '#D2691E',
                    '#DEB887',
                    '#F4A460',
                    '#CD853F'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
</script>

<%@ include file="layouts/footer.jsp" %>
