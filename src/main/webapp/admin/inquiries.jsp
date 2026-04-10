<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Inquiry, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inquiries - PawHome Admin</title>
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
            <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/inquiries" class="active">&#128232; Inquiries</a></li>
        </ul></aside>
        <main class="admin-content">
            <h2 class="mb-2">Contact Inquiries</h2>
            <% if (request.getParameter("success") != null) { %><div class="alert alert-success"><%= request.getParameter("success") %></div><% } %>

            <div class="card">
                <div class="table-responsive">
                    <table class="table">
                        <thead><tr><th>Name</th><th>Email</th><th>Subject</th><th>Message</th><th>Date</th><th>Action</th></tr></thead>
                        <tbody>
                        <% List<Inquiry> inquiries = (List<Inquiry>) request.getAttribute("inquiries");
                           SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                           if (inquiries != null && !inquiries.isEmpty()) { for (Inquiry inq : inquiries) { %>
                        <tr>
                            <td><strong><%= inq.getName() %></strong></td>
                            <td><a href="mailto:<%= inq.getEmail() %>"><%= inq.getEmail() %></a></td>
                            <td><%= inq.getSubject() %></td>
                            <td><%= inq.getMessage().length() > 80 ? inq.getMessage().substring(0, 80) + "..." : inq.getMessage() %></td>
                            <td><%= inq.getSubmittedAt() != null ? sdf.format(inq.getSubmittedAt()) : "-" %></td>
                            <td><a href="${pageContext.request.contextPath}/admin/inquiries/delete?id=<%= inq.getInquiryId() %>" class="btn btn-sm btn-danger" onclick="return confirmDelete('Delete this inquiry?')">Delete</a></td>
                        </tr>
                        <% } } else { %>
                        <tr><td colspan="6" class="text-center text-muted" style="padding:2rem;">No inquiries yet.</td></tr>
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
