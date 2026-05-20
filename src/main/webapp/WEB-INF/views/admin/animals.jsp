<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Animal" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Animals - PawHome Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="admin-layout">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#128202; Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/animals" class="active">&#128054; Animals</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/applications">&#128221; Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users">&#128100; Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
            </ul>
        </aside>

        <main class="admin-content">
            <div class="page-header">
                <h2>Manage Animals</h2>
                <a href="${pageContext.request.contextPath}/admin/animals/add" class="btn btn-primary">+ Add Animal</a>
            </div>

            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/admin/animals" method="get" class="search-bar">
                <input type="text" name="search" class="form-control" placeholder="Search animals..."
                       value="<%= request.getAttribute("searchTerm") != null ? request.getAttribute("searchTerm") : "" %>">
                <button type="submit" class="btn btn-primary">Search</button>
                <a href="${pageContext.request.contextPath}/admin/animals" class="btn btn-secondary">Clear</a>
            </form>

            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr><th>ID</th><th>Name</th><th>Species</th><th>Breed</th><th>Age</th><th>Gender</th><th>Status</th><th>Category</th><th>Actions</th></tr>
                        </thead>
                        <tbody>
                        <% List<Animal> animals = (List<Animal>) request.getAttribute("animals");
                           if (animals != null && !animals.isEmpty()) {
                               for (Animal a : animals) { %>
                        <tr>
                            <td><%= a.getAnimalId() %></td>
                            <td><strong><%= a.getName() %></strong></td>
                            <td><%= a.getSpecies() %></td>
                            <td><%= a.getBreed() != null ? a.getBreed() : "-" %></td>
                            <td><%= a.getAge() %></td>
                            <td><%= a.getGender() %></td>
                            <td><span class="badge <%= "Available".equals(a.getAvailabilityStatus()) ? "badge-success" : "Adopted".equals(a.getAvailabilityStatus()) ? "badge-info" : "badge-warning" %>"><%= a.getAvailabilityStatus() %></span></td>
                            <td><%= a.getCategoryName() != null ? a.getCategoryName() : "-" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/animals/edit?id=<%= a.getAnimalId() %>" class="btn btn-sm btn-secondary">Edit</a>
                                <a href="${pageContext.request.contextPath}/admin/animals/delete?id=<%= a.getAnimalId() %>" class="btn btn-sm btn-danger" onclick="return confirmDelete('Delete this animal?')">Delete</a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="9" class="text-center text-muted" style="padding:2rem;">No animals found.</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
