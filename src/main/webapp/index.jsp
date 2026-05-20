<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PawHome - Animal Shelter & Adoption</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo">
                <span>&#128062;</span> PawHome
            </a>
            <button class="nav-toggle" onclick="toggleNav()">
                <span></span><span></span><span></span>
            </button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/" class="active">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <%
                    if (session.getAttribute("loggedInUser") != null) {
                        String role = (String) session.getAttribute("userRole");
                        if ("admin".equals(role)) {
                %>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/user/home">Browse Animals</a></li>
                <% } %>
                    <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <h1>Find Your Furry Best Friend</h1>
        <p>PawHome connects loving families with shelter animals in need of a forever home. Browse our adorable residents and give them a second chance at happiness.</p>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary" style="font-size:1.1rem; padding: 0.75rem 2rem;">
            Start Adopting Today
        </a>
    </section>

    <!-- Features Section -->
    <section class="page-wrapper">
        <div class="container">
            <h2 class="text-center mb-3">How PawHome Works</h2>
            <div class="stats-grid" style="justify-content: center;">
                <div class="stat-card" style="max-width:280px;">
                    <div class="stat-number" style="font-size:2.5rem;">&#128269;</div>
                    <div class="stat-label"><strong>Browse</strong><br>Search and explore animals available for adoption at our shelters.</div>
                </div>
                <div class="stat-card" style="max-width:280px;">
                    <div class="stat-number" style="font-size:2.5rem;">&#128221;</div>
                    <div class="stat-label"><strong>Apply</strong><br>Submit an adoption application for the animal you love.</div>
                </div>
                <div class="stat-card" style="max-width:280px;">
                    <div class="stat-number" style="font-size:2.5rem;">&#127968;</div>
                    <div class="stat-label"><strong>Adopt</strong><br>Once approved, welcome your new family member home!</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <p>&copy; 2026 PawHome - Animal Shelter & Adoption System. All rights reserved.</p>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
