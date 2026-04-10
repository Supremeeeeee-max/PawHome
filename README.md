# PawHome - Animal Shelter & Adoption System

A comprehensive web-based Animal Shelter and Adoption Management System built with Java EE technologies.

## About

PawHome is a digital platform that connects shelter animals with loving families. Shelter administrators can manage animal records, process adoption applications, and generate reports, while potential adopters can browse available animals, submit adoption applications, and maintain a wishlist.

## Technologies Used

- **Backend:** Java, Java EE (Servlets), JSP
- **Database:** MySQL / MariaDB
- **Frontend:** CSS3 (Flexbox & Media Queries - No Bootstrap), JavaScript
- **Architecture:** MVC (Model-View-Controller)
- **Server:** Apache Tomcat 9
- **Build Tool:** Apache Maven
- **IDE:** IntelliJ IDEA

## Features

### Admin Module
- Dashboard with statistics overview
- Animal record management (CRUD with image upload)
- User registration approval/rejection
- Adoption application review (approve/reject)
- Category management
- Reports and analytics
- Contact inquiry management

### User Module
- User registration with admin approval workflow
- Secure login with SHA-256 password encryption
- Browse animals with search and category filter
- Animal detail view with metadata
- Adoption application submission
- Wishlist management
- Profile management with password change

### Public Pages
- Landing page with call-to-action
- About page (shelter mission and values)
- Contact page with inquiry form
- Custom error pages (404, 403, 500)

### Security
- SHA-256 password hashing
- HTTP session management (30-minute timeout)
- Cookie-based remember-me functionality
- Servlet filter for authentication and role-based authorization
- Input validation (server-side and client-side)

## Project Structure

```
PawHome/
├── pom.xml
├── sql/
│   └── schema.sql
└── src/main/
    ├── java/com/pawhome/
    │   ├── model/          (User, Animal, Category, AdoptionApplication, Wishlist, Inquiry)
    │   ├── dao/            (UserDAO, AnimalDAO, CategoryDAO, AdoptionDAO, WishlistDAO, InquiryDAO)
    │   ├── service/        (UserService, AnimalService, AdoptionService)
    │   ├── controller/     (LoginServlet, RegisterServlet, AdminServlet, UserPortalServlet, ContactServlet)
    │   ├── filter/         (AuthFilter)
    │   └── util/           (DatabaseConnection, PasswordEncryptor, InputValidator)
    └── webapp/
        ├── WEB-INF/web.xml
        ├── css/style.css
        ├── js/main.js
        ├── index.jsp, login.jsp, register.jsp, about.jsp, contact.jsp, error.jsp
        ├── admin/          (dashboard, animals, animal-form, applications, users, categories, reports, inquiries)
        └── user/           (home, animal-detail, applications, wishlist, profile)
```

## Database

The system uses 6 normalized tables (3NF):

- **users** - Admin and user accounts with encrypted passwords
- **categories** - Animal categories (Dog, Cat, Bird, Rabbit, Fish, Other)
- **animals** - Animal records with species, breed, health status, image, and shelter location
- **adoption_applications** - Adoption requests with status tracking and admin review
- **wishlists** - User-saved favorite animals
- **inquiries** - Contact form submissions

## Setup Instructions

### Prerequisites
- JDK 11 or higher
- Apache Maven 3.9+
- MySQL Server (or XAMPP with MySQL)
- Apache Tomcat 9

### Database Setup
1. Open MySQL Workbench (or phpMyAdmin)
2. Run the SQL script located at `sql/schema.sql`
3. This creates the `pawhome` database with all tables and sample data

### Configuration
Update the database connection in `src/main/java/com/pawhome/util/DatabaseConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/pawhome?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String USER = "root";
private static final String PASSWORD = "your_password_here";
```

### Build and Run
```bash
mvn clean package
```
Deploy the generated `target/PawHome.war` to Tomcat's `webapps/` directory, or use IntelliJ with Smart Tomcat plugin.


## Team Members

| Name              | Student ID | Role                              |
|-------------------|----|-----------------------------------|
| [Suprim Bista]    | [24046115] | [Backend]                         |
| [Kunald Rai]      | [24046170] | [Backend]                         |
| [Lija Niraula]    | [] | [Backend and Database Connection] |
| [Asmita Bhattrai] | [24046161] | [Frontend]                        |
| [Yuna Karki]      | [] | [Frontend]                        |


## License

This project is developed for academic purposes.