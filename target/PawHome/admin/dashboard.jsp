<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.AdoptionApplication, com.pawhome.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a>
        <ul class="nav-links">
            <li><span class="text-muted">Welcome, <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Admin" %></span></li>
            <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div style="display:flex; min-height:calc(100vh - 64px);">
    <aside class="sidebar">
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="active">&#128202; Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/animals">&#128054; Animals</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/applications">&#128221; Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">&#128100; Users</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
        </ul>
    </aside>

    <main class="admin-content">
        <h2 class="mb-2">Dashboard Overview</h2>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number"><%= request.getAttribute("totalAnimals") != null ? request.getAttribute("totalAnimals") : 0 %></div>
                <div class="stat-label">Total Animals</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:#16a34a;"><%= request.getAttribute("availableAnimals") != null ? request.getAttribute("availableAnimals") : 0 %></div>
                <div class="stat-label">Available</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:#2563eb;"><%= request.getAttribute("adoptedAnimals") != null ? request.getAttribute("adoptedAnimals") : 0 %></div>
                <div class="stat-label">Adopted</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:#ea580c;"><%= request.getAttribute("pendingApplications") != null ? request.getAttribute("pendingApplications") : 0 %></div>
                <div class="stat-label">Pending Applications</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:#dc2626;"><%= request.getAttribute("pendingUsers") != null ? request.getAttribute("pendingUsers") : 0 %></div>
                <div class="stat-label">Pending Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-number" style="color:#7c3aed;"><%= request.getAttribute("totalAdoptions") != null ? request.getAttribute("totalAdoptions") : 0 %></div>
                <div class="stat-label">Total Adoptions</div>
            </div>
        </div>

        <div class="card mb-3">
            <div class="card-header">
                Pending User Registrations
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-secondary">View All</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead><tr><th>Name</th><th>Email</th><th>Phone</th><th>Actions</th></tr></thead>
                    <tbody>
                    <%
                        Object pendingObj = request.getAttribute("pendingUsersList");
                        if (pendingObj != null) {
                            List<User> pendingUsers = (List<User>) pendingObj;
                            if (!pendingUsers.isEmpty()) {
                                for (User u : pendingUsers) {
                    %>
                    <tr>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getPhone() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/users/approve?id=<%= u.getUserId() %>" class="btn btn-sm btn-success">Approve</a>
                            <a href="${pageContext.request.contextPath}/admin/users/reject?id=<%= u.getUserId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Reject this user?')">Reject</a>
                        </td>
                    </tr>
                    <%  } } else { %>
                    <tr><td colspan="4" class="text-center text-muted">No pending registrations</td></tr>
                    <%  } } else { %>
                    <tr><td colspan="4" class="text-center text-muted">No pending registrations</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                Recent Adoption Applications
                <a href="${pageContext.request.contextPath}/admin/applications" class="btn btn-sm btn-secondary">View All</a>
            </div>
            <div class="table-responsive">
                <table class="table">
                    <thead><tr><th>User</th><th>Animal</th><th>Date</th><th>Status</th></tr></thead>
                    <tbody>
                    <%
                        Object appsObj = request.getAttribute("recentApplications");
                        if (appsObj != null) {
                            List<AdoptionApplication> apps = (List<AdoptionApplication>) appsObj;
                            int count = 0;
                            for (AdoptionApplication app : apps) {
                                if (count >= 5) break;
                    %>
                    <tr>
                        <td><%= app.getUserName() %></td>
                        <td><%= app.getAnimalName() %></td>
                        <td><%= app.getApplyDate() %></td>
                        <td><span class="badge <%= "Pending".equals(app.getStatus()) ? "badge-pending" : "Approved".equals(app.getStatus()) ? "badge-success" : "badge-danger" %>"><%= app.getStatus() %></span></td>
                    </tr>
                    <%      count++;
                    }
                    }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>