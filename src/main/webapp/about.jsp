<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about.jsp" class="active">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <% if (session.getAttribute("loggedInUser") != null) { %>
                    <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container" style="max-width:800px;">
            <h1 class="text-center text-primary mb-3">About PawHome</h1>

            <div class="card mb-3">
                <div class="card-body">
                    <h3>Our Mission</h3>
                    <p class="mt-1">PawHome is dedicated to connecting loving families with shelter animals in need of a forever home. We believe every animal deserves love, care, and a safe place to call home. Our platform makes the adoption process simple, transparent, and accessible to everyone.</p>
                </div>
            </div>

            <div class="card mb-3">
                <div class="card-body">
                    <h3>What We Do</h3>
                    <p class="mt-1">We provide a comprehensive digital platform that bridges the gap between animal shelters and potential adopters. Through PawHome, shelters can list their animals, manage adoption applications, and track successful placements. Meanwhile, adopters can browse available animals, save favorites to their wishlist, and apply for adoption seamlessly.</p>
                </div>
            </div>

            <div class="card mb-3">
                <div class="card-body">
                    <h3>Our Values</h3>
                    <p class="mt-1"><strong>Compassion:</strong> Every animal in our system is treated with dignity and respect.</p>
                    <p class="mt-1"><strong>Transparency:</strong> Our adoption process is open and clear, with status updates at every step.</p>
                    <p class="mt-1"><strong>Responsibility:</strong> We carefully review adoption applications to ensure animals go to safe and loving homes.</p>
                    <p class="mt-1"><strong>Community:</strong> We aim to build a community of animal lovers who support shelter adoption over purchasing.</p>
                </div>
            </div>

            <div class="card mb-3">
                <div class="card-body">
                    <h3>Our Team</h3>
                    <p class="mt-1">PawHome was developed by a passionate team of students as part of the Advanced Programming and Technologies coursework. Our goal is to leverage technology for the betterment of animal welfare while demonstrating proficiency in web application development using Java EE, JSP, and MySQL.</p>
                </div>
            </div>

            <div class="text-center mt-3">
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Join PawHome Today</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-secondary">Get In Touch</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 PawHome - Animal Shelter & Adoption System. All rights reserved.</p>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
