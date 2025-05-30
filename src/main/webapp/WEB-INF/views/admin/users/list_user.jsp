<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người dùng</title>
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
                <h1 class="text-3xl font-bold tracking-tight">Người dùng</h1>
                <p class="text-muted-foreground">Quản lý tài khoản người dùng trong hệ thống</p>
            </div>
            <a href="/admin/users/create"
               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-primary text-primary-foreground hover:bg-primary/90 h-10 px-4 py-2">
                <i class="fas fa-plus w-4 h-4 mr-2"></i>
                Thêm người dùng
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
                    <h3 class="tracking-tight text-sm font-medium">Tổng người dùng</h3>
                    <i class="fas fa-users h-4 w-4 text-muted-foreground"></i>
                </div>
                <div class="text-2xl font-bold">${users.size()}</div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Admin</h3>
                    <i class="fas fa-user-shield h-4 w-4 text-red-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="adminCount" value="0"/>
                    <c:forEach items="${users}" var="user">
                        <c:if test="${user.role == 'ADMIN'}">
                            <c:set var="adminCount" value="${adminCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${adminCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Khách hàng</h3>
                    <i class="fas fa-user h-4 w-4 text-blue-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="userCount" value="0"/>
                    <c:forEach items="${users}" var="user">
                        <c:if test="${user.role == 'USER'}">
                            <c:set var="userCount" value="${userCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${userCount}
                </div>
            </div>

            <div class="rounded-lg border bg-card text-card-foreground shadow-sm p-6">
                <div class="flex flex-row items-center justify-between space-y-0 pb-2">
                    <h3 class="tracking-tight text-sm font-medium">Đang hoạt động</h3>
                    <i class="fas fa-check-circle h-4 w-4 text-green-600"></i>
                </div>
                <div class="text-2xl font-bold">
                    <c:set var="activeCount" value="0"/>
                    <c:forEach items="${users}" var="user">
                        <c:if test="${user.status == 'ACTIVE'}">
                            <c:set var="activeCount" value="${activeCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${activeCount}
                </div>
            </div>
        </div>

        <!-- Search and Filter -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="p-6">
                <div class="flex flex-col md:flex-row gap-4">
                    <div class="flex-1">
                        <input type="text" placeholder="Tìm kiếm theo tên, email..."
                               class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                               id="searchInput">
                    </div>
                    <div class="flex gap-2">
                        <select class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                id="roleFilter">
                            <option value="">Tất cả vai trò</option>
                            <option value="ADMIN">Admin</option>
                            <option value="USER">Khách hàng</option>
                        </select>
                        <select class="flex h-10 rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50"
                                id="statusFilter">
                            <option value="">Tất cả trạng thái</option>
                            <option value="ACTIVE">Hoạt động</option>
                            <option value="INACTIVE">Bị khóa</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users Table -->
        <div class="rounded-lg border bg-card text-card-foreground shadow-sm">
            <div class="relative w-full overflow-auto">
                <c:choose>
                    <c:when test="${not empty users}">
                        <table class="w-full caption-bottom text-sm" id="usersTable">
                            <thead class="[&_tr]:border-b">
                            <tr class="border-b transition-colors hover:bg-muted/50">
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">ID</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Người
                                    dùng
                                </th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Email
                                </th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Vai trò
                                </th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Điểm</th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Trạng
                                    thái
                                </th>
                                <th class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">Thao
                                    tác
                                </th>
                            </tr>
                            </thead>
                            <tbody class="[&_tr:last-child]:border-0">
                            <c:forEach items="${users}" var="user">
                                <tr class="border-b transition-colors hover:bg-muted/50 user-row"
                                    data-username="${user.username}"
                                    data-fullname="${user.fullName}"
                                    data-email="${user.email}"
                                    data-role="${user.role}"
                                    data-status="${user.status}">
                                    <td class="p-4 align-middle">
                                        <div class="font-mono text-sm">#${user.id}</div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-3">
                                            <div class="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-primary-foreground font-medium">
                                                    ${user.fullName != null ? user.fullName.substring(0, 1).toUpperCase() : user.username.substring(0, 1).toUpperCase()}
                                            </div>
                                            <div>
                                                <div class="font-medium text-sm">${user.fullName != null ? user.fullName : user.username}</div>
                                                <div class="text-muted-foreground text-xs">@${user.username}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="text-sm">${user.email}</div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <c:choose>
                                            <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-red-100 text-red-800">
                                                            <i class="fas fa-shield-alt w-3 h-3 mr-1"></i>
                                                            Admin
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-blue-100 text-blue-800">
                                                            <i class="fas fa-user w-3 h-3 mr-1"></i>
                                                            Khách hàng
                                                        </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-1">
                                            <i class="fas fa-star text-yellow-500 w-3 h-3"></i>
                                            <span class="font-medium">${user.points}</span>
                                        </div>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <c:choose>
                                            <c:when test="${user.status == 'ACTIVE'}">
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-green-100 text-green-800">
                                                            <i class="fas fa-check-circle w-3 h-3 mr-1"></i>
                                                            Hoạt động
                                                        </span>
                                            </c:when>
                                            <c:otherwise>
                                                        <span class="inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium bg-gray-100 text-gray-800">
                                                            <i class="fas fa-lock w-3 h-3 mr-1"></i>
                                                            Bị khóa
                                                        </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="p-4 align-middle">
                                        <div class="flex items-center gap-1">
                                            <a href="/admin/users/detail/${user.id}"
                                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8"
                                               title="Xem chi tiết">
                                                <i class="fas fa-eye w-3 h-3"></i>
                                            </a>
                                            <a href="/admin/users/edit/${user.id}"
                                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8"
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit w-3 h-3"></i>
                                            </a>
                                            <a href="/admin/users/change-status/${user.id}"
                                               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-8 w-8 ${user.status == 'ACTIVE' ? 'text-orange-600 hover:text-orange-700' : 'text-green-600 hover:text-green-700'}"
                                               title="${user.status == 'ACTIVE' ? 'Khóa tài khoản' : 'Mở khóa'}">
                                                <i class="fas ${user.status == 'ACTIVE' ? 'fa-lock' : 'fa-unlock'} w-3 h-3"></i>
                                            </a>
                                            <button onclick="confirmDelete(${user.id}, '${user.username}')"
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
                            <i class="fas fa-users text-4xl text-muted-foreground mb-4"></i>
                            <h3 class="text-lg font-semibold">Chưa có người dùng</h3>
                            <p class="text-muted-foreground">Hãy thêm người dùng đầu tiên</p>
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
            Bạn có chắc chắn muốn xóa người dùng này?
        </p>
        <div class="flex justify-end gap-3">
            <button onclick="closeDeleteModal()"
                    class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-accent hover:text-accent-foreground h-10 px-4 py-2">
                Hủy
            </button>
            <a href="#" id="confirmDeleteButton"
               class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-red-600 text-white hover:bg-red-700 h-10 px-4 py-2">
                Xóa
            </a>
        </div>
    </div>
</div>

<script>
    // Auto-hide alerts
    document.addEventListener('DOMContentLoaded', function () {
        const alerts = document.querySelectorAll('[role="alert"]');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                alert.style.transition = 'opacity 0.3s';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });

    // Search functionality
    document.getElementById('searchInput').addEventListener('input', filterUsers);
    document.getElementById('roleFilter').addEventListener('change', filterUsers);
    document.getElementById('statusFilter').addEventListener('change', filterUsers);

    function filterUsers() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const roleFilter = document.getElementById('roleFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;
        const rows = document.querySelectorAll('.user-row');

        rows.forEach(row => {
            const username = row.dataset.username.toLowerCase();
            const fullname = row.dataset.fullname ? row.dataset.fullname.toLowerCase() : '';
            const email = row.dataset.email.toLowerCase();
            const role = row.dataset.role;
            const status = row.dataset.status;

            const matchesSearch = username.includes(searchTerm) ||
                fullname.includes(searchTerm) ||
                email.includes(searchTerm);
            const matchesRole = !roleFilter || role === roleFilter;
            const matchesStatus = !statusFilter || status === statusFilter;

            if (matchesSearch && matchesRole && matchesStatus) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    // Delete modal functions
    function confirmDelete(userId, username) {
        document.getElementById('deleteModalBody').textContent = `Bạn có chắc chắn muốn xóa người dùng "${username}"?`;
        document.getElementById('confirmDeleteButton').href = `/admin/users/delete/${userId}`;
        document.getElementById('deleteModal').classList.remove('hidden');
        document.getElementById('deleteModal').classList.add('flex');
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').classList.add('hidden');
        document.getElementById('deleteModal').classList.remove('flex');
    }

    // Close modal when clicking outside
    document.getElementById('deleteModal').addEventListener('click', function (e) {
        if (e.target === this) {
            closeDeleteModal();
        }
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', function (e) {
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