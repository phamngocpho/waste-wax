<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <div class="auth-card">
        <a href="home" class="close-btn">×</a>
        <h2>Register</h2>

        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="success-message">${success}</div>
        </c:if>

        <form action="register" method="post">
            <div class="form-group">
                <label>
                    <input type="text" name="username" placeholder="Username" value="${username}" required>
                </label>
                <div class="icon user-icon"></div>
            </div>

            <div class="form-group">
                <label>
                    <input type="email" name="email" placeholder="Email" value="${email}" required>
                </label>
                <div class="icon email-icon"></div>
            </div>
            <div class="form-group">
                <label>
                    <input type="text" name="fullName" placeholder="FullName" value="${fullName}" required>
                </label>
                <div class="icon user-icon"></div>
            </div>
            <div class="form-group">
                <label>
                    <input type="password" name="password" placeholder="Password" required>
                </label>
                <div class="icon lock-icon"></div>
            </div>

            <div class="form-group">
                <label>
                    <input type="password" name="confirmPassword" placeholder="Confirm Password" required>
                </label>
                <div class="icon lock-icon"></div>
            </div>

            <button type="submit" class="btn">Register</button>
        </form>

        <div class="auth-link">
            Already have an account? <a href="login">Login</a>
        </div>
    </div>
</div>
</body>
</html>
