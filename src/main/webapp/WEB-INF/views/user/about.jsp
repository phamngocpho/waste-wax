<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About Us</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital@1&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .font-playfair {
            font-family: 'Playfair Display', serif;
        }
    </style>
</head>
<body>
<!-- Include Navigation -->
<jsp:include page="layouts/nav.jsp" />

<div class="relative w-full mb-16">
    <img src="${pageContext.request.contextPath}/images/about.jpg" alt="Hero image" class="w-full h-[625px] bg-cover">
</div>

<div class="bg-[#faf6f1]">
    <div class="container mx-auto px-4 py-8 max-w-6xl mt-16">
        <!-- Top Section -->
        <div class="flex flex-col md:flex-row mb-16">
            <div class="md:w-1/2">
                <img src="${pageContext.request.contextPath}/images/home01.png" alt="Pouring oil" class="w-full h-[400px] object-cover rounded-lg">
            </div>
            <div class="md:w-1/2 flex items-center bg-white p-8 rounded-lg">
                <p class="text-gray-700 text-xl leading-relaxed text-center">
                    We believe that small actions can create a big impact. Our mission is simple: to reduce waste,
                    protect the environment, and spread warmth—all through the power of thoughtful exchange.
                </p>
            </div>
        </div>
        <div class="relative mb-16">
            <div class="flex justify-between items-center">
                <!-- DON'T Section -->
                <div class="flex flex-col items-center">
                    <div class="text-6xl font-serif">D</div>
                    <div class="text-6xl font-serif">O</div>
                    <div class="text-6xl font-serif">N'</div>
                    <div class="text-6xl font-serif">T</div>
                </div>

                <!-- Center Image -->
                <div class="flex-1 px-12">
                    <img src="${pageContext.request.contextPath}/images/doit.png" alt="Oil disposal guide" class="w-full">
                </div>

                <!-- DO IT Section -->
                <div class="flex flex-col items-center">
                    <div class="text-6xl font-serif">D</div>
                    <div class="text-6xl font-serif">O</div>
                    <div class="text-6xl font-serif">I</div>
                    <div class="text-6xl font-serif">T</div>
                </div>
            </div>
        </div>

        <!-- Bottom Section -->
        <div class="flex flex-col md:flex-row mb-16">
            <div class="md:w-1/2 flex items-center bg-white p-8 rounded-lg">
                <p class="text-gray-700 text-xl leading-relaxed text-center">
                    We're a community of changemakers. By choosing to exchange used oil for candles, you're joining a
                    movement toward a greener, brighter future. Together, we can illuminate our homes and protect the
                    world we share.
                </p>
            </div>
            <div class="md:w-1/2">
                <img src="${pageContext.request.contextPath}/images/home01.png" alt="Hands holding candle"
                     class="w-full h-[400px] object-cover rounded-lg">
            </div>
        </div>

        <!-- Text overlay on image -->
        <div class="relative w-full mx-auto">
            <img src="${pageContext.request.contextPath}/images/about01.png" alt="About" class="w-full">
            <div class="absolute top-0 left-0 w-full text-left mt-16">
                <h2 class="text-4xl font-playfair text-[#4A3427] italic ml-48 mb-2">Trade used oil for candles</h2>
                <h3 class="text-4xl font-playfair text-[#4A3427] italic ml-64">Brighten your home, save the planet!</h3>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="layouts/footer.jsp" />
</body>
</html>
