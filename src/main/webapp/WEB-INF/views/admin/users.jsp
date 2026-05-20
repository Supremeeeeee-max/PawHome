<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - PawHome Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar"><div class="nav-container"><a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a><ul class="nav-links"><li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li></ul></div></nav>
    <div class="admin-layout">
        <aside class="sidebar"><ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#128202; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/animals">&#128054; Animals</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/applications">&#128221; Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="active">&#128100; Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
        </ul></aside>
        <main class="admin-content">
            <h2 class="mb-2">Manage Users</h2>
            <% if (request.getParameter("success") != null) { %><div class="alert alert-success"><%= request.getParameter("success") %></div><% } %>

            <div class="card">
                <div class="card-header">All Users</div>
                <div class="table-responsive">
                    <table class="table">
                        <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Role</th><th>Status</th><th>Registered</th><th>Actions</th></tr></thead>
                        <tbody>
                        <% List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                           if (allUsers != null) { for (User u : allUsers) { %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><strong><%= u.getFullName() %></strong></td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getPhone() %></td>
                            <td><span class="badge badge-info"><%= u.getRole() %></span></td>
                            <td><span class="badge <%= "approved".equals(u.getStatus()) ? "badge-success" : "pending".equals(u.getStatus()) ? "badge-pending" : "badge-danger" %>"><%= u.getStatus() %></span></td>
                            <td><%= u.getCreatedAt() != null ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(u.getCreatedAt()) : "-" %></td>
                            <td>
                                <% if ("pending".equals(u.getStatus())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/users/approve?id=<%= u.getUserId() %>" class="btn btn-sm btn-success">Approve</a>
                                    <a href="${pageContext.request.contextPath}/admin/users/reject?id=<%= u.getUserId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Reject this user?')">Reject</a>
                                <% } else if ("approved".equals(u.getStatus()) && !"admin".equals(u.getRole())) { %>
                                    <span class="text-muted">Active</span>
                                <% } else if ("admin".equals(u.getRole())) { %>
                                    <span class="text-muted">Admin</span>
                                <% } else { %>
                                    <a href="${pageContext.request.contextPath}/admin/users/approve?id=<%= u.getUserId() %>" class="btn btn-sm btn-success">Re-approve</a>
                                <% } %>
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
