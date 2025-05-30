<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .footer {
        width: 100%;
        background-color: #f8f8f8;
        border-top: 1px solid #eee;
        margin-top: 50px;
        padding: 0;
    }

    .footer-container {
        max-width: 100%;
        margin: 0 auto;
        padding: 40px 20px;
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        align-items: flex-start;
    }

    .footer-section {
        width: 18%;
        min-width: 150px;
        margin-bottom: 20px;
    }

    .footer-section h3 {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 20px;
        color: #333;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .footer-section ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-section ul li {
        margin-bottom: 10px;
    }

    .footer-section ul li a {
        text-decoration: none;
        color: #666;
        font-size: 20px;
        transition: color 0.3s;
    }

    .footer-section ul li a:hover {
        color: #000;
    }

    .logo-section {
        width: 20%;
        text-align: center;
        min-width: 200px;
        order: 3; /* Đặt logo ở vị trí thứ 3 (giữa) */
    }

    .logo-section img {
        width: 120px;
        height: auto;
        margin-bottom: 20px;
    }

    .subscribe-section {
        width: 20%;
        min-width: 250px;
        margin-bottom: 20px;
    }

    .subscribe-form {
        display: flex;
        margin-bottom: 20px;
        width: 100%;
    }

    .subscribe-form input {
        flex: 1;
        padding: 10px 15px;
        border: 1px solid #ddd;
        border-right: none;
        font-size: 14px;
        outline: none;
    }

    .subscribe-form button {
        padding: 10px 20px;
        background: #000;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 14px;
        white-space: nowrap;
        transition: background-color 0.3s;
    }

    .subscribe-form button:hover {
        background-color: #333;
    }

    .social-links {
        display: flex;
        gap: 20px;
    }

    .social-links a {
        text-decoration: none;
        color: #000;
        font-size: 14px;
        transition: color 0.3s;
    }

    .social-links a:hover {
        color: #666;
    }

    /* Tablet Styles */
    @media only screen and (max-width: 992px) {
        .footer-container {
            padding: 30px 20px;
            justify-content: space-between;
        }

        .footer-section {
            width: 30%;
            margin-bottom: 30px;
        }

        .logo-section {
            width: 100%;
            order: -1; /* Đưa logo lên đầu trong tablet */
            margin-bottom: 30px;
        }

        .subscribe-section {
            width: 100%;
        }
    }

    /* Mobile Styles */
    @media only screen and (max-width: 768px) {
        .footer-container {
            padding: 25px 15px;
            flex-direction: column;
        }

        .footer-section {
            width: 100%;
            margin-bottom: 25px;
        }

        .footer-section h3 {
            margin-bottom: 15px;
        }

        .subscribe-form {
            flex-direction: column;
            gap: 10px;
        }

        .subscribe-form input {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 0;
        }

        .subscribe-form button {
            width: 100%;
        }

        .social-links {
            margin-top: 15px;
            justify-content: flex-start;
            flex-wrap: wrap;
        }
    }

    /* Fix for extra small screens */
    @media only screen and (max-width: 480px) {
        .social-links {
            gap: 15px;
        }

        .social-links a {
            font-size: 13px;
        }
    }
</style>

<footer class="footer">
    <div class="footer-container">
        <div class="footer-section">
            <h3>SHOP</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/products/home-candles">Home Candles</a></li>
                <li><a href="${pageContext.request.contextPath}/products/new-collection">New Collection</a></li>
                <li><a href="${pageContext.request.contextPath}/products">Shop All</a></li>
            </ul>
        </div>

        <div class="footer-section">
            <h3>ABOUT</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/about">About Us</a></li>
                <li><a href="${pageContext.request.contextPath}/how-to-use">How to Use</a></li>
                <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
                <li><a href="${pageContext.request.contextPath}/our-goals">Our Goals</a></li>
            </ul>
        </div>

        <div class="logo-section">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/images/logo.svg" alt="Candle Logo">
            </a>
        </div>

        <div class="footer-section">
            <h3>FOR CLIENTS</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/contact">Contacts</a></li>
                <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
                <li><a href="${pageContext.request.contextPath}/our-goals">Our Goals</a></li>
            </ul>
        </div>

        <div class="subscribe-section">
            <h3>Follow us & Subscribe</h3>
            <form class="subscribe-form" action="${pageContext.request.contextPath}/subscribe" method="post">
                <input type="email" name="email" placeholder="Enter your e-mail address" required>
                <button type="submit">SEND</button>
            </form>
            <div class="social-links">
                <a href="https://facebook.com/candleshop" target="_blank">FACEBOOK</a>
                <a href="https://instagram.com/candleshop" target="_blank">INSTAGRAM</a>
                <a href="https://youtube.com/candleshop" target="_blank">YOUTUBE</a>
            </div>
        </div>
    </div>
</footer>
