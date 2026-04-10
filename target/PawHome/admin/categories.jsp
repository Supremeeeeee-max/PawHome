<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Category" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Categories - PawHome Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar"><div class="nav-container"><a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a><ul class="nav-links"><li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li></ul></div></nav>
    <div class="admin-layout">
        <aside class="sidebar"><ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#128202; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/animals">&#128054; Animals</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/applications">&#128221; Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">&#128100; Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories" class="active">&#128194; Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
        </ul></aside>
        <main class="admin-content">
            <h2 class="mb-2">Manage Categories</h2>
            <% if (request.getParameter("success") != null) { %><div class="alert alert-success"><%= request.getParameter("success") %></div><% } %>

            <!-- Add Category Form -->
            <div class="card mb-3">
                <div class="card-header">Add New Category</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/categories/add" method="post">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="categoryName">Category Name *</label>
                                <input type="text" id="categoryName" name="categoryName" class="form-control" required placeholder="e.g., Reptile">
                            </div>
                            <div class="form-group">
                                <label for="description">Description</label>
                                <input type="text" id="description" name="description" class="form-control" placeholder="Brief description">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary">Add Category</button>
                    </form>
                </div>
            </div>

            <!-- Categories List -->
            <div class="card">
                <div class="card-header">All Categories</div>
                <div class="table-responsive">
                    <table class="table">
                        <thead><tr><th>ID</th><th>Name</th><th>Description</th><th>Actions</th></tr></thead>
                        <tbody>
                        <% List<Category> categories = (List<Category>) request.getAttribute("categories");
                           if (categories != null) { for (Category cat : categories) { %>
                        <tr>
                            <td><%= cat.getCategoryId() %></td>
                            <td><strong><%= cat.getCategoryName() %></strong></td>
                            <td><%= cat.getDescription() != null ? cat.getDescription() : "-" %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/categories/delete?id=<%= cat.getCategoryId() %>"
                                   class="btn btn-sm btn-danger" onclick="return confirmDelete('Delete this category? Animals in this category will have their category set to null.')">Delete</a>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
