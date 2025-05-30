<!-- layout/sidebar.jsp -->
<style>
    /* Cố định sidebar */
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        height: 100vh;
        width: 250px;
        background-color: #8B4513;
        z-index: 1000;
        overflow-y: auto;
    }

    /* Điều chỉnh main content */
    .main-content {
        margin-left: 250px; /* Bằng với width của sidebar */
        padding: 20px;
        min-height: 100vh;
        background-color: #f5f5f5;
    }

    /* Đảm bảo responsive */
    @media (max-width: 768px) {
        .sidebar {
            width: 0;
            transform: translateX(-100%);
            transition: all 0.3s;
        }

        .sidebar.show {
            width: 250px;
            transform: translateX(0);
        }

        .main-content {
            margin-left: 0;
            width: 100%;
        }
    }

    /* Đảm bảo header không bị che */
    .header {
        position: sticky;
        top: 0;
        background: #fff;
        padding: 15px;
        z-index: 900;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    /* Tối ưu không gian cho bảng */
    .table-responsive {
        margin-top: 20px;
        overflow-x: auto;
    }

</style>
<div class="sidebar">
    <div class="p-3">
        <h3 class="text-center mb-4">Admin Panel</h3>
        <nav class="nav flex-column">
            <a class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}"
               href="/admin/dashboard">
                <i class='bx bxs-dashboard'></i> Dashboard
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/products') ? 'active' : ''}"
               href="/admin/products">
                <i class='bx bxs-package'></i> Products
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/categories') ? 'active' : ''}"
               href="/admin/categories">
                <i class='bx bxs-category'></i> Categories
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/orders') ? 'active' : ''}"
               href="/admin/orders">
                <i class='bx bxs-cart'></i> Orders
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/users') ? 'active' : ''}"
               href="/admin/users">
                <i class='bx bxs-user'></i> Users
            </a>
            <!-- Thêm mục này vào nav trong sidebar, trước divider -->
            <a class="nav-link ${pageContext.request.requestURI.contains('/vouchers') ? 'active' : ''}"
               href="/admin/vouchers">
                <i class='bx bxs-discount'></i> Vouchers
            </a>

            <a class="nav-link ${pageContext.request.requestURI.contains('/oil_exchanges') ? 'active' : ''}"
               href="/admin/oil_exchanges">
                <i class='bx bxs-droplet'></i> Oil Exchanges
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/rewards') ? 'active' : ''}"
               href="/admin/rewards">
                <i class='bx bxs-gift'></i> Rewards
            </a>
            <a class="nav-link ${pageContext.request.requestURI.contains('/reviews') ? 'active' : ''}"
               href="/admin/reviews">
                <i class='bx bxs-star'></i> Reviews
            </a>
            <div class="dropdown-divider bg-light my-3"></div>
            <a class="nav-link" href="/logout">
                <i class='bx bxs-log-out'></i> Logout
            </a>
        </nav>
    </div>
</div>
