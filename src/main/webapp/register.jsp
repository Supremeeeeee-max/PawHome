<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register" class="active btn btn-primary btn-sm">Register</a></li>
            </ul>
        </div>
    </nav>

    <div class="auth-wrapper">
        <div class="auth-card" style="max-width:560px;">
            <h2>Create Your Account</h2>
            <p class="subtitle">Join PawHome and find your perfect companion</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data" id="registerForm">
                <div class="form-row">
                    <div class="form-group">
                        <label for="fullName">Full Name *</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               placeholder="Enter your full name" required
                               oninput="validateName(this)"
                               value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address *</label>
                        <input type="email" id="email" name="email" class="form-control" 
                               placeholder="Enter your email" required
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone Number *</label>
                        <input type="text" id="phone" name="phone" class="form-control" 
                               placeholder="10-15 digit number" required
                               oninput="validatePhone(this)" maxlength="15"
                               value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" class="form-control"
                               value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label for="address">Address *</label>
                    <input type="text" id="address" name="address" class="form-control" 
                           placeholder="Enter your address" required
                           value="<%= request.getAttribute("address") != null ? request.getAttribute("address") : "" %>">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password *</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Minimum 6 characters" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Re-enter password" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="profileImage">Profile Image (optional)</label>
                    <input type="file" id="profileImage" name="profileImage" class="form-control" 
                           accept="image/*" onchange="previewImage(this, 'imgPreview')">
                    <img id="imgPreview" style="display:none;max-height:100px;margin-top:8px;border-radius:4px;">
                </div>

                <button type="submit" class="btn btn-primary" style="width:100%;">Register</button>

                <p class="text-center mt-2 text-muted" style="font-size:0.8125rem;">
                    Your account will be reviewed by admin before activation.
                </p>
                <p class="text-center mt-1" style="font-size:0.9375rem;">
                    Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
                </p>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
