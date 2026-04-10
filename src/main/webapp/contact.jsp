<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <button class="nav-toggle" onclick="toggleNav()"><span></span><span></span><span></span></button>
            <ul class="nav-links" id="navLinks">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                <li><a href="${pageContext.request.contextPath}/contact" class="active">Contact</a></li>
                <% if (session.getAttribute("loggedInUser") != null) { %>
                    <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                    <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a></li>
                <% } %>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container" style="max-width:600px;">
            <h1 class="text-center text-primary mb-1">Contact Us</h1>
            <p class="text-center text-muted mb-3">Have questions? We would love to hear from you.</p>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <div class="card">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/contact" method="post">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="name">Your Name *</label>
                                <input type="text" id="name" name="name" class="form-control" placeholder="Full name" required
                                       value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="email">Email Address *</label>
                                <input type="email" id="email" name="email" class="form-control" placeholder="your@email.com" required
                                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="subject">Subject *</label>
                            <input type="text" id="subject" name="subject" class="form-control" placeholder="What is this about?" required
                                   value="<%= request.getAttribute("subject") != null ? request.getAttribute("subject") : "" %>">
                        </div>
                        <div class="form-group">
                            <label for="message">Message *</label>
                            <textarea id="message" name="message" class="form-control" rows="5" placeholder="Your message..." required><%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width:100%;">Send Message</button>
                    </form>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-body text-center">
                    <h3>Our Location</h3>
                    <p class="mt-1 text-muted">PawHome Animal Shelter<br>Itahari, Sunsari, Nepal<br>Phone: +977-9800000000<br>Email: info@pawhome.com</p>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        <p>&copy; 2026 PawHome - Animal Shelter & Adoption System. All rights reserved.</p>
    </footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
