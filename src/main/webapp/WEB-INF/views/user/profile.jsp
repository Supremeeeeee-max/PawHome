<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pawhome.model.User, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/user/home">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/user/applications">My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/user/wishlist">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile" class="active">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container" style="max-width:700px;">
            <h2 class="mb-2">My Profile</h2>

            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>

            <% User user = (User) request.getAttribute("user");
               SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
               if (user != null) { %>

            <!-- Profile Update Form -->
            <div class="card mb-3">
                <div class="card-header">Personal Information</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/user/profile/update" method="post" enctype="multipart/form-data">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="fullName">Full Name</label>
                                <input type="text" id="fullName" name="fullName" class="form-control"
                                       value="<%= user.getFullName() %>" required oninput="validateName(this)">
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control"
                                       value="<%= user.getEmail() %>" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input type="text" id="phone" name="phone" class="form-control"
                                       value="<%= user.getPhone() %>" required oninput="validatePhone(this)">
                            </div>
                            <div class="form-group">
                                <label for="dob">Date of Birth</label>
                                <input type="date" id="dob" name="dob" class="form-control"
                                       value="<%= user.getDob() != null ? sdf.format(user.getDob()) : "" %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" class="form-control"
                                   value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="profileImage">Profile Image</label>
                            <input type="file" id="profileImage" name="profileImage" class="form-control" accept="image/*">
                            <% if (user.getProfileImage() != null) { %>
                                <p class="form-text">Current: <%= user.getProfileImage() %></p>
                            <% } %>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Profile</button>
                    </form>
                </div>
            </div>

            <!-- Password Change Form -->
            <div class="card">
                <div class="card-header">Change Password</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/user/profile/password" method="post">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" required minlength="6">
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning">Change Password</button>
                    </form>
                </div>
            </div>

            <% } %>
        </div>
    </div>

    <footer class="footer"><p>&copy; 2026 PawHome. All rights reserved.</p></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
