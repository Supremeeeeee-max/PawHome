<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.AdoptionApplication, com.pawhome.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-wrapper { display: flex; min-height: calc(100vh - 64px); }
        .sidebar { width: 220px; min-width: 220px; background: #fff; border-right: 1px solid #e5e7eb; padding: 1.5rem 0; }
        .sidebar-menu { list-style: none; }
        .sidebar-menu li a { display: flex; align-items: center; gap: 10px; padding: 0.75rem 1.5rem; color: #6b7280; font-size: 0.9375rem; font-weight: 500; border-left: 3px solid transparent; transition: all 0.2s; text-decoration: none; }
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background: #e8f5ee; color: #2e7d5b; border-left-color: #2e7d5b; text-decoration: none; }
        .admin-content { flex: 1; padding: 2rem; min-width: 0; background: #f5f7fa; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem; }
        .stat-card { background: #fff; border-radius: 16px; padding: 1.5rem; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.08); transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 10px 25px rgba(0,0,0,0.12); }
        .stat-number { font-size: 2.2rem; font-weight: 700; color: #2e7d5b; }
        .stat-label { font-size: 0.85rem; color: #6b7280; margin-top: 0.3rem; font-weight: 500; }
        .card { background: #fff; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.08); margin-bottom: 1.5rem; overflow: hidden; }
        .card-header { padding: 1rem 1.25rem; border-bottom: 1px solid #e5e7eb; font-weight: 600; font-size: 1rem; display: flex; align-items: center; justify-content: space-between; }
        .sidebar-toggle { display: none; background: none; border: 1px solid #e5e7eb; border-radius: 8px; padding: 8px 14px; cursor: pointer; font-size: 0.875rem; font-weight: 500; color: #2e7d5b; margin-bottom: 1rem; align-items: center; gap: 6px; }
        @media (max-width: 768px) {
            .admin-wrapper { flex-direction: column; }
            .sidebar { width: 100%; min-width: 100%; border-right: none; border-bottom: 1px solid #e5e7eb; padding: 0; overflow: hidden; max-height: 0; transition: max-height 0.3s ease; }
            .sidebar.open { max-height: 400px; }
            .sidebar-menu li a { border-left: none; border-bottom: 2px solid transparent; padding: 0.875rem 1.25rem; }
            .sidebar-menu li a.active, .sidebar-menu li a:hover { border-left: none; border-bottom-color: #2e7d5b; }
            .admin-content { padding: 1rem; }
            .sidebar-toggle { display: flex; }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .stat-number { font-size: 1.75rem; }
        }
        @media (max-width: 400px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            <span>&#128062;</span> PawHome Admin
        </a>
        <ul class="nav-links">
            <li><span class="text-muted" style="font-size:0.9rem;">Welcome, <%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "Admin" %></span></li>
            <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="admin-wrapper">
    <aside class="sidebar" id="adminSidebar">
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
        <button class="sidebar-toggle" onclick="toggleSidebar()">&#9776; Menu</button>

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

        <div class="card">
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
                    <% } } else { %>
                    <tr><td colspan="4" class="text-center text-muted">No pending registrations</td></tr>
                    <% } } else { %>
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
                    <% count++; } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
<script>
    function toggleSidebar() {
        document.getElementById('adminSidebar').classList.toggle('open');
    }
</script>
</body>
</html>