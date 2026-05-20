<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Wishlist" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/user/home">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/user/applications">My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/user/wishlist" class="active">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container">
            <h2 class="mb-2">My Wishlist</h2>

            <% List<Wishlist> items = (List<Wishlist>) request.getAttribute("wishlistItems");
               if (items != null && !items.isEmpty()) { %>
            <div class="animal-grid">
                <% for (Wishlist item : items) { %>
                <div class="animal-card">
                    <div class="animal-card-img">
                        <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                            <img src="${pageContext.request.contextPath}/<%= item.getImagePath() %>" alt="<%= item.getAnimalName() %>"
                                 style="width:100%;height:200px;object-fit:cover;">
                        <% } else { %>
                            &#128054;
                        <% } %>
                    </div>
                    <div class="animal-card-body">
                        <h3><%= item.getAnimalName() %></h3>
                        <p class="meta"><%= item.getSpecies() %> &middot; <%= item.getBreed() != null ? item.getBreed() : "Mixed" %></p>
                        <span class="badge <%= "Available".equals(item.getAvailabilityStatus()) ? "badge-success" : "badge-warning" %>">
                            <%= item.getAvailabilityStatus() %>
                        </span>
                        <div class="animal-card-actions">
                            <a href="${pageContext.request.contextPath}/user/animal?id=<%= item.getAnimalId() %>" class="btn btn-sm btn-primary">View Details</a>
                            <a href="${pageContext.request.contextPath}/user/wishlist/remove?id=<%= item.getAnimalId() %>" class="btn btn-sm btn-danger"
                               onclick="return confirm('Remove from wishlist?')">Remove</a>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-state">
                <div class="icon">&#9825;</div>
                <h3>Your wishlist is empty</h3>
                <p class="text-muted mb-2">Browse animals and add your favorites here!</p>
                <a href="${pageContext.request.contextPath}/user/home" class="btn btn-primary">Browse Animals</a>
            </div>
            <% } %>
        </div>
    </div>

    <footer class="footer"><p>&copy; 2026 PawHome. All rights reserved.</p></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
