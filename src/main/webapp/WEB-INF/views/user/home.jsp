<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Animal, com.pawhome.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Animals - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/user/home" class="active">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/user/applications">My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/user/wishlist">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container">
            <div class="page-header">
                <h2>Available Animals</h2>
                <span class="text-muted">Welcome, <%= session.getAttribute("userName") %></span>
            </div>

            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>

            <!-- Search and Filter -->
            <form action="${pageContext.request.contextPath}/user/home" method="get">
                <div class="search-bar">
                    <input type="text" name="search" class="form-control" placeholder="Search by name, breed, species, or location..."
                           value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary">Clear</a>
                </div>
            </form>

            <div class="filter-bar">
                <label>Filter by category:</label>
                <% List<Category> categories = (List<Category>) request.getAttribute("categories");
                   String selectedCat = (String) request.getAttribute("selectedCategory");
                   if (categories != null) {
                       for (Category cat : categories) { %>
                    <a href="${pageContext.request.contextPath}/user/home?category=<%= cat.getCategoryId() %>"
                       class="btn btn-sm <%= String.valueOf(cat.getCategoryId()).equals(selectedCat) ? "btn-primary" : "btn-secondary" %>">
                        <%= cat.getCategoryName() %>
                    </a>
                <% } } %>
                <a href="${pageContext.request.contextPath}/user/home" class="btn btn-sm btn-secondary">All</a>
            </div>

            <!-- Animal Grid -->
            <div class="animal-grid">
                <% List<Animal> animals = (List<Animal>) request.getAttribute("animals");
                   if (animals != null && !animals.isEmpty()) {
                       for (Animal animal : animals) { %>
                    <div class="animal-card">
                        <div class="animal-card-img">
                            <% if (animal.getImagePath() != null && !animal.getImagePath().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= animal.getImagePath() %>" alt="<%= animal.getName() %>"
                                     style="width:100%;height:200px;object-fit:cover;">
                            <% } else { %>
                                &#128054;
                            <% } %>
                        </div>
                        <div class="animal-card-body">
                            <h3><%= animal.getName() %></h3>
                            <p class="meta"><%= animal.getSpecies() %> &middot; <%= animal.getBreed() != null ? animal.getBreed() : "Mixed" %> &middot; <%= animal.getAge() %> yrs &middot; <%= animal.getGender() %></p>
                            <span class="badge <%= "Available".equals(animal.getAvailabilityStatus()) ? "badge-success" : "Reserved".equals(animal.getAvailabilityStatus()) ? "badge-warning" : "badge-info" %>">
                                <%= animal.getAvailabilityStatus() %>
                            </span>
                            <div class="animal-card-actions">
                                <a href="${pageContext.request.contextPath}/user/animal?id=<%= animal.getAnimalId() %>" class="btn btn-sm btn-primary">View Details</a>
                                <a href="${pageContext.request.contextPath}/user/wishlist/add?id=<%= animal.getAnimalId() %>" class="btn btn-sm btn-outline">&#9825; Wishlist</a>
                            </div>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="empty-state" style="width:100%;">
                        <div class="icon">&#128054;</div>
                        <h3>No animals found</h3>
                        <p class="text-muted">Try adjusting your search or filters.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 PawHome. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
