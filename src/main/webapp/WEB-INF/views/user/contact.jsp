<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact Us</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body>
<!-- Include Navigation -->
<jsp:include page="layouts/nav.jsp" />

<!-- Hero Section -->
<div class="relative h-[600px] flex items-center justify-end p-8 bg-cover bg-center"
     style="background-image: url('${pageContext.request.contextPath}/images/home01.png')">
    <!-- Overlay -->
    <div class="absolute inset-0 bg-gradient-to-r from-amber-900/20 to-amber-950/30"></div>

    <!-- Text content -->
    <div class="relative z-10 text-left mr-12">
        <h2 class="font-serif text-8xl text-white tracking-wider mb-2">Contact</h2>
        <h2 class="font-serif text-8xl text-white tracking-wider">Us</h2>
    </div>
</div>

<!-- Main Content -->
<div class="container mx-auto p-8">
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        <!-- Map Section -->
        <div class="h-full">
            <iframe
                    src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.0681640413!2d106.73492!3d10.802936!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752f9023a3a85d%3A0x8a1e168ace8fdf87!2s34%20Ng%C3%B4%20Quang%20Huy%2C%20Th%E1%BA%A3o%20%C4%90i%E1%BB%81n%2C%20Qu%E1%BA%ADn%202%2C%20Th%C3%A0nh%20ph%E1%BB%91%20H%E1%BB%93%20Ch%C3%AD%20Minh!5e0!3m2!1svi!2s!4v1703468433789!5m2!1svi!2s"
                    class="w-full h-full min-h-[800px]" style="border:0;" allowfullscreen="" loading="lazy"
                    referrerpolicy="no-referrer-when-downgrade">
            </iframe>
        </div>

        <!-- Contact Form Section -->
        <div class="space-y-8">
            <!-- Contact Information -->
            <div>
                <h2 class="text-3xl font-semibold mb-2">Contact Information</h2>
                <div class="w-12 h-0.5 bg-black mb-8"></div>

                <div class="space-y-4">
                    <div>
                        <h3 class="text-gray-600 mb-1">Address us</h3>
                        <p>34 Ngo Quang Huy, Thao Dien Ward, District 2, Ho Chi Minh City</p>
                    </div>
                    <div>
                        <h3 class="text-gray-600 mb-1">Email</h3>
                        <p>info.vestalifestyle@vestav.com</p>
                    </div>
                    <div>
                        <h3 class="text-gray-600 mb-1">Phone number</h3>
                        <p>0702446153</p>
                    </div>
                    <div>
                        <h3 class="text-gray-600 mb-1">Work time</h3>
                        <p>Mon - Sunday: 9.30am - 9.30pm</p>
                    </div>
                </div>
            </div>

            <!-- Contact Form -->
            <div>
                <h2 class="text-3xl font-semibold mb-2">Send us a question</h2>
                <div class="w-12 h-0.5 bg-black mb-8"></div>

                <form action="${pageContext.request.contextPath}/contact/submit" method="POST" class="space-y-6">
                    <input type="text" name="fullname" placeholder="Fullname"
                           class="w-full p-3 border border-gray-300 rounded" required>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <input type="email" name="email" placeholder="Email"
                               class="w-full p-3 border border-gray-300 rounded" required>
                        <input type="tel" name="phone" placeholder="Phone number"
                               class="w-full p-3 border border-gray-300 rounded" required>
                    </div>

                    <textarea name="message" placeholder="Message" rows="4"
                              class="w-full p-3 border border-gray-300 rounded" required></textarea>

                    <button type="submit" class="px-8 py-3 bg-[#4A3427] text-white rounded hover:bg-[#5D4435]">
                        SEND US
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Include Footer -->
<jsp:include page="layouts/footer.jsp" />
</body>
</html>
