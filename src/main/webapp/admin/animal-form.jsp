<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, com.pawhome.model.Animal, com.pawhome.model.Category, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("editMode") != null ? "Edit" : "Add" %> Animal - PawHome Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/" class="nav-logo"><span>&#128062;</span> PawHome Admin</a>
            <ul class="nav-links"><li><a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a></li></ul>
        </div>
    </nav>

    <div class="admin-layout">
        <aside class="sidebar">
            <ul class="sidebar-menu">
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">&#128202; Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/animals" class="active">&#128054; Animals</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/applications">&#128221; Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users">&#128100; Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/categories">&#128194; Categories</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/reports">&#128200; Reports</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/inquiries">&#128232; Inquiries</a></li>
            </ul>
        </aside>

        <main class="admin-content">
            <%  boolean editMode = request.getAttribute("editMode") != null;
                Animal animal = editMode ? (Animal) request.getAttribute("animal") : null;
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            %>

            <a href="${pageContext.request.contextPath}/admin/animals" class="btn btn-secondary btn-sm mb-2">&larr; Back to Animals</a>
            <h2 class="mb-2"><%= editMode ? "Edit Animal" : "Add New Animal" %></h2>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <div class="card">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/animals/<%= editMode ? "edit" : "add" %>" method="post" enctype="multipart/form-data">
                        <% if (editMode && animal != null) { %>
                            <input type="hidden" name="animalId" value="<%= animal.getAnimalId() %>">
                        <% } %>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="name">Animal Name *</label>
                                <input type="text" id="name" name="name" class="form-control" required
                                       value="<%= editMode && animal != null ? animal.getName() : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="species">Species *</label>
                                <input type="text" id="species" name="species" class="form-control" required
                                       placeholder="e.g., Dog, Cat, Rabbit"
                                       value="<%= editMode && animal != null ? animal.getSpecies() : "" %>">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="breed">Breed</label>
                                <input type="text" id="breed" name="breed" class="form-control"
                                       value="<%= editMode && animal != null && animal.getBreed() != null ? animal.getBreed() : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="age">Age (years) *</label>
                                <input type="number" id="age" name="age" class="form-control" min="0" max="50" required
                                       value="<%= editMode && animal != null ? animal.getAge() : "" %>">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="gender">Gender *</label>
                                <select id="gender" name="gender" class="form-control" required>
                                    <option value="">Select Gender</option>
                                    <option value="Male" <%= editMode && animal != null && "Male".equals(animal.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="Female" <%= editMode && animal != null && "Female".equals(animal.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="Unknown" <%= editMode && animal != null && "Unknown".equals(animal.getGender()) ? "selected" : "" %>>Unknown</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="healthStatus">Health Status</label>
                                <input type="text" id="healthStatus" name="healthStatus" class="form-control"
                                       placeholder="e.g., Healthy, Vaccinated"
                                       value="<%= editMode && animal != null && animal.getHealthStatus() != null ? animal.getHealthStatus() : "" %>">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="categoryId">Category *</label>
                                <select id="categoryId" name="categoryId" class="form-control" required>
                                    <option value="">Select Category</option>
                                    <% List<Category> categories = (List<Category>) request.getAttribute("categories");
                                       if (categories != null) {
                                           for (Category cat : categories) { %>
                                        <option value="<%= cat.getCategoryId() %>" <%= editMode && animal != null && animal.getCategoryId() == cat.getCategoryId() ? "selected" : "" %>>
                                            <%= cat.getCategoryName() %>
                                        </option>
                                    <% } } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="shelterLocation">Shelter Location</label>
                                <input type="text" id="shelterLocation" name="shelterLocation" class="form-control"
                                       value="<%= editMode && animal != null && animal.getShelterLocation() != null ? animal.getShelterLocation() : "" %>">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="intakeDate">Intake Date</label>
                                <input type="date" id="intakeDate" name="intakeDate" class="form-control"
                                       value="<%= editMode && animal != null && animal.getIntakeDate() != null ? sdf.format(animal.getIntakeDate()) : "" %>">
                            </div>
                            <div class="form-group">
                                <label for="availabilityStatus">Availability *</label>
                                <select id="availabilityStatus" name="availabilityStatus" class="form-control" required>
                                    <option value="Available" <%= editMode && animal != null && "Available".equals(animal.getAvailabilityStatus()) ? "selected" : "" %>>Available</option>
                                    <option value="Reserved" <%= editMode && animal != null && "Reserved".equals(animal.getAvailabilityStatus()) ? "selected" : "" %>>Reserved</option>
                                    <option value="Adopted" <%= editMode && animal != null && "Adopted".equals(animal.getAvailabilityStatus()) ? "selected" : "" %>>Adopted</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4"><%= editMode && animal != null && animal.getDescription() != null ? animal.getDescription() : "" %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="animalImage">Animal Image</label>
                            <input type="file" id="animalImage" name="animalImage" class="form-control" accept="image/*"
                                   onchange="previewImage(this, 'imgPreview')">
                            <img id="imgPreview" style="display:none;max-height:150px;margin-top:8px;border-radius:4px;">
                            <% if (editMode && animal != null && animal.getImagePath() != null) { %>
                                <p class="form-text">Current image: <%= animal.getImagePath() %></p>
                            <% } %>
                        </div>

                        <div class="flex gap-1">
                            <button type="submit" class="btn btn-primary"><%= editMode ? "Update Animal" : "Add Animal" %></button>
                            <a href="${pageContext.request.contextPath}/admin/animals" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
