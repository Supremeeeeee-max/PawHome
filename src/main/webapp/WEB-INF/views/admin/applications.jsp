<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.AdoptionApplication" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Applications - PawHome Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar"><div class="nav-container"><a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a><ul class="nav-links"><li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li></ul></div></nav>
    <div class="admin-layout">
        <aside class="sidebar"><ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#128202; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/animals">&#128054; Animals</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/applications" class="active">&#128221; Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">&#128100; Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
        </ul></aside>
        <main class="admin-content">
            <div class="page-header">
                <h2>Adoption Applications</h2>
                <div class="flex gap-1">
                    <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-sm btn-secondary">All</a>
                    <a href="${pageContext.request.contextPath}/admin/applications?filter=pending" class="btn btn-sm btn-warning">Pending Only</a>
                </div>
            </div>
            <% if (request.getParameter("success") != null) { %><div class="alert alert-success"><%= request.getParameter("success") %></div><% } %>

            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead><tr><th>ID</th><th>User</th><th>Animal</th><th>Date</th><th>Reason</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <% List<AdoptionApplication> apps = (List<AdoptionApplication>) request.getAttribute("applications");
                           if (apps != null && !apps.isEmpty()) { for (AdoptionApplication app : apps) { %>
                        <tr>
                            <td><%= app.getApplicationId() %></td>
                            <td><strong><%= app.getUserName() %></strong></td>
                            <td><%= app.getAnimalName() %></td>
                            <td><%= app.getApplyDate() %></td>
                            <td><%= app.getReason() != null ? (app.getReason().length() > 60 ? app.getReason().substring(0, 60) + "..." : app.getReason()) : "-" %></td>
                            <td><span class="badge <%= "Pending".equals(app.getStatus()) ? "badge-pending" : "Approved".equals(app.getStatus()) ? "badge-success" : "badge-danger" %>"><%= app.getStatus() %></span></td>
                            <td>
                                <% if ("Pending".equals(app.getStatus())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/applications/approve?id=<%= app.getApplicationId() %>" class="btn btn-sm btn-success" onclick="return confirm('Approve this application? The animal will be marked as Adopted.')">Approve</a>
                                    <a href="${pageContext.request.contextPath}/admin/applications/reject?id=<%= app.getApplicationId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Reject this application?')">Reject</a>
                                <% } else { %>
                                    <span class="text-muted"><%= app.getReviewerName() != null ? "By " + app.getReviewerName() : "" %></span>
                                <% } %>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="7" class="text-center text-muted" style="padding:2rem;">No applications found.</td></tr>
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
