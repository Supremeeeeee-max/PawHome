<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
        </div>
    </nav>

    <div class="auth-wrapper">
        <div class="auth-card text-center">
            <%
                String errorCode = request.getParameter("code");
                if (errorCode == null) {
                    errorCode = String.valueOf(response.getStatus());
                }
            %>
            <div style="font-size:4rem; margin-bottom:1rem;">
                <% if ("403".equals(errorCode)) { %>
                    &#128683;
                <% } else if ("404".equals(errorCode)) { %>
                    &#128269;
                <% } else { %>
                    &#9888;&#65039;
                <% } %>
            </div>

            <h2>
                <% if ("403".equals(errorCode)) { %>
                    Access Denied
                <% } else if ("404".equals(errorCode)) { %>
                    Page Not Found
                <% } else { %>
                    Oops! Something Went Wrong
                <% } %>
            </h2>

            <p class="text-muted mt-1 mb-3">
                <% if ("403".equals(errorCode)) { %>
                    You do not have permission to access this page. Please contact an administrator if you believe this is an error.
                <% } else if ("404".equals(errorCode)) { %>
                    The page you are looking for does not exist or has been moved.
                <% } else { %>
                    An unexpected error occurred. Please try again later or contact support if the problem persists.
                <% } %>
            </p>

            <div class="flex gap-1" style="justify-content:center;">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
                <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
            </div>
        </div>
    </div>
</body>
</html>
