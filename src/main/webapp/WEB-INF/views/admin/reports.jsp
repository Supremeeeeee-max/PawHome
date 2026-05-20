<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - PawHome Admin</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/reports" class="active">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
        </ul></aside>
        <main class="admin-content">
            <h2 class="mb-2">Reports & Analytics</h2>

            <!-- Summary Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number"><%= request.getAttribute("totalAnimals") %></div>
                    <div class="stat-label">Total Animals</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color:#16a34a;"><%= request.getAttribute("totalAdoptions") %></div>
                    <div class="stat-label">Total Adoptions</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number" style="color:#ea580c;"><%= request.getAttribute("pendingApps") %></div>
                    <div class="stat-label">Pending Applications</div>
                </div>
            </div>

            <!-- Availability Report -->
            <div class="card mb-3">
                <div class="card-header">Animals: Availability vs Adopted</div>
                <div class="card-body">
                    <table class="table">
                        <thead><tr><th>Status</th><th>Count</th><th>Visual</th></tr></thead>
                        <tbody>
                        <% List<Object[]> availReport = (List<Object[]>) request.getAttribute("availabilityReport");
                           int totalForBar = 0;
                           if (availReport != null) { for (Object[] row : availReport) { totalForBar += (int)row[1]; } }
                           if (availReport != null) { for (Object[] row : availReport) {
                               String status = (String) row[0];
                               int count = (int) row[1];
                               int pct = totalForBar > 0 ? (count * 100 / totalForBar) : 0;
                               String barColor = "Available".equals(status) ? "#16a34a" : "Adopted".equals(status) ? "#2563eb" : "#ea580c";
                        %>
                        <tr>
                            <td><strong><%= status %></strong></td>
                            <td><%= count %></td>
                            <td>
                                <div style="background:#f3f4f6;border-radius:4px;height:24px;width:100%;max-width:300px;">
                                    <div style="background:<%= barColor %>;height:100%;border-radius:4px;width:<%= pct %>%;min-width:2px;"></div>
                                </div>
                            </td>
                        </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Species Adoption Report -->
            <div class="card">
                <div class="card-header">Adoptions by Species (Most Popular)</div>
                <div class="card-body">
                    <% List<Object[]> speciesReport = (List<Object[]>) request.getAttribute("speciesReport");
                       if (speciesReport != null && !speciesReport.isEmpty()) { %>
                    <table class="table">
                        <thead><tr><th>Rank</th><th>Species</th><th>Adoptions</th></tr></thead>
                        <tbody>
                        <% int rank = 1;
                           for (Object[] row : speciesReport) { %>
                        <tr>
                            <td><%= rank++ %></td>
                            <td><strong><%= row[0] %></strong></td>
                            <td><%= row[1] %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                    <% } else { %>
                    <p class="text-muted text-center" style="padding:1rem;">No adoption data available yet.</p>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
