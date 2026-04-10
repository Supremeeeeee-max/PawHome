<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pawhome.model.Animal" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animal Details - PawHome</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome</a>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/user/home">Browse</a></li>
                <li><a href="${pageContext.request.contextPath}/user/applications">My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/user/wishlist">Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

    <div class="page-wrapper">
        <div class="container">
            <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary btn-sm mb-2">&larr; Back to Browse</a>

            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger"><%= request.getParameter("error") %></div>
            <% } %>
            <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success"><%= request.getParameter("success") %></div>
            <% } %>

            <% Animal animal = (Animal) request.getAttribute("animal");
               boolean inWishlist = (Boolean) request.getAttribute("inWishlist");
               boolean hasApplied = (Boolean) request.getAttribute("hasApplied");
               if (animal != null) { %>

            <div class="card">
                <div class="card-body">
                    <div class="animal-detail">
                        <div class="animal-detail-img">
                            <% if (animal.getImagePath() != null && !animal.getImagePath().isEmpty()) { %>
                                <img src="${pageContext.request.contextPath}/<%= animal.getImagePath() %>" alt="<%= animal.getName() %>"
                                     style="width:100%;height:100%;object-fit:cover;border-radius:8px;">
                            <% } else { %>
                                &#128054;
                            <% } %>
                        </div>
                        <div class="animal-detail-info">
                            <h1><%= animal.getName() %></h1>
                            <span class="badge <%= "Available".equals(animal.getAvailabilityStatus()) ? "badge-success" : "badge-warning" %>" style="font-size:0.875rem;">
                                <%= animal.getAvailabilityStatus() %>
                            </span>

                            <div class="meta-grid">
                                <div class="meta-item"><strong>Species</strong> <%= animal.getSpecies() %></div>
                                <div class="meta-item"><strong>Breed</strong> <%= animal.getBreed() != null ? animal.getBreed() : "Mixed" %></div>
                                <div class="meta-item"><strong>Age</strong> <%= animal.getAge() %> years</div>
                                <div class="meta-item"><strong>Gender</strong> <%= animal.getGender() %></div>
                                <div class="meta-item"><strong>Health</strong> <%= animal.getHealthStatus() != null ? animal.getHealthStatus() : "N/A" %></div>
                                <div class="meta-item"><strong>Location</strong> <%= animal.getShelterLocation() != null ? animal.getShelterLocation() : "N/A" %></div>
                                <div class="meta-item"><strong>Category</strong> <%= animal.getCategoryName() != null ? animal.getCategoryName() : "N/A" %></div>
                                <div class="meta-item"><strong>Intake Date</strong> <%= animal.getIntakeDate() != null ? animal.getIntakeDate() : "N/A" %></div>
                            </div>

                            <% if (animal.getDescription() != null) { %>
                                <p style="margin:1rem 0; line-height:1.7;"><%= animal.getDescription() %></p>
                            <% } %>

                            <div class="flex gap-1" style="margin-top:1.5rem;">
                                <% if (inWishlist) { %>
                                    <a href="${pageContext.request.contextPath}/user/wishlist/remove?id=<%= animal.getAnimalId() %>" class="btn btn-secondary">&#9829; Remove from Wishlist</a>
                                <% } else { %>
                                    <a href="${pageContext.request.contextPath}/user/wishlist/add?id=<%= animal.getAnimalId() %>" class="btn btn-outline">&#9825; Add to Wishlist</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Adoption Application Form -->
            <% if ("Available".equals(animal.getAvailabilityStatus()) && !hasApplied) { %>
            <div class="card mt-3">
                <div class="card-header"><h3 style="margin:0;">Apply to Adopt <%= animal.getName() %></h3></div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/user/apply" method="post">
                        <input type="hidden" name="animalId" value="<%= animal.getAnimalId() %>">
                        <div class="form-group">
                            <label for="reason">Why do you want to adopt this animal? *</label>
                            <textarea id="reason" name="reason" class="form-control" rows="4"
                                      placeholder="Tell us about your living situation, experience with animals, and why you would be a great match..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-success">Submit Application</button>
                    </form>
                </div>
            </div>
            <% } else if (hasApplied) { %>
            <div class="alert alert-info mt-3">
                You have already submitted an application for this animal. Check your <a href="${pageContext.request.contextPath}/user/applications">applications page</a> for status updates.
            </div>
            <% } else { %>
            <div class="alert alert-warning mt-3">
                This animal is currently not available for adoption.
            </div>
            <% } %>

            <% } %>
        </div>
    </div>

    <footer class="footer"><p>&copy; 2026 PawHome. All rights reserved.</p></footer>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
