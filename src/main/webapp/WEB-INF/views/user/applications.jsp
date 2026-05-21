<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.AdoptionApplication" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/user/home">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/user/applications" class="active">My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/user/wishlist">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    // animal adoption application
    <div class="page-wrapper">
        <div class="container">
            <h2 class="mb-2">My Adoption Applications</h2>

            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr><th>Animal</th><th>Applied On</th><th>Reason</th><th>Status</th><th>Reviewed By</th></tr>
                        </thead>
                        <tbody>
                        <% List<AdoptionApplication> apps = (List<AdoptionApplication>) request.getAttribute("applications");
                           if (apps != null && !apps.isEmpty()) {
                               for (AdoptionApplication app : apps) { %>
                            <tr>
                                <td><strong><%= app.getAnimalName() %></strong></td>
                                <td><%= app.getApplyDate() %></td>
                                <td><%= app.getReason() != null ? (app.getReason().length() > 50 ? app.getReason().substring(0, 50) + "..." : app.getReason()) : "-" %></td>
                                <td>
                                    <span class="badge <%= "Pending".equals(app.getStatus()) ? "badge-pending" : "Approved".equals(app.getStatus()) ? "badge-success" : "badge-danger" %>">
                                        <%= app.getStatus() %>
                                    </span>
                                </td>
                                <td><%= app.getReviewerName() != null ? app.getReviewerName() : "-" %></td>
                            </tr>
                        <% } } else { %>
                            <tr><td colspan="5" class="text-center text-muted" style="padding:2rem;">You have not submitted any adoption applications yet. <a href="${pageContext.request.contextPath}/user/home">Browse animals</a> to get started!</td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer"><p>&copy; 2026 PawHome. All rights reserved.</p></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
