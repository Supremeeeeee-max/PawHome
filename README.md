# PawHome - Animal Shelter & Adoption System

A Java EE web application built with Servlets, JSP, CSS, and MySQL.

---

## COMPLETE SETUP GUIDE (VS Code)

### STEP 1: Install Required Software

Download and install ALL of the following (skip any you already have):

1. **JDK 11 or higher**
   - Download: https://adoptium.net/temurin/releases/
   - Pick: Windows x64 → .msi installer
   - During install: CHECK "Set JAVA_HOME variable"
   - After install, verify by opening Command Prompt:
     ```
     java -version
     ```

2. **Apache Maven**
   - Download: https://maven.apache.org/download.cgi
   - Pick: "Binary zip archive" (apache-maven-3.9.x-bin.zip)
   - Extract to: C:\Program Files\Apache\maven
   - Add to System PATH:
     - Search "Environment Variables" in Windows
     - Under "System Variables" → find PATH → Edit → New
     - Add: C:\Program Files\Apache\maven\bin
   - Verify:
     ```
     mvn -version
     ```

3. **XAMPP** (for MySQL)
   - Download: https://www.apachefriends.org/download.html
   - Install with default settings
   - You only need MySQL from XAMPP

4. **Apache Tomcat 9**
   - Download: https://tomcat.apache.org/download-90.cgi
   - Pick: "64-bit Windows zip" under Core
   - Extract to: C:\Program Files\Apache\tomcat9
   - (Do NOT run the installer version)

5. **VS Code Extensions** — Open VS Code and install these:
   - Extension Pack for Java (by Microsoft)
   - Maven for Java (by Microsoft)
   - Community Server Connectors (by Red Hat) — this lets you run Tomcat

---

### STEP 2: Setup the Database

1. Open XAMPP Control Panel
2. Click "Start" next to MySQL
3. Click "Start" next to Apache (needed for phpMyAdmin)
4. Open browser and go to: http://localhost/phpmyadmin
5. Click "SQL" tab at the top
6. Open the file: `PawHome/sql/schema.sql`
7. Copy ALL the content and paste it into the SQL box
8. Click "Go" button
9. You should see "pawhome" database appear in the left sidebar with 6 tables

**Verify the database:**
- Click on "pawhome" in the left sidebar
- You should see these tables:
  - adoption_applications
  - animals
  - categories
  - inquiries
  - users
  - wishlists
- Click on "users" table → you should see 1 admin row
- Click on "animals" table → you should see 5 sample animals
- Click on "categories" table → you should see 6 categories

---

### STEP 3: Open Project in VS Code

1. Extract the PawHome.zip file to a location like:
   ```
   C:\Projects\PawHome
   ```

2. Open VS Code

3. File → Open Folder → navigate to `C:\Projects\PawHome` → Select Folder

4. VS Code will detect the Maven project (pom.xml) and ask to import it.
   Click "Yes" or "Import"

5. Wait for Maven to download dependencies (you'll see progress in bottom bar).
   This downloads:
   - javax.servlet-api (Servlet library)
   - javax.servlet.jsp-api (JSP library)
   - mysql-connector-java (MySQL driver)

6. If VS Code does NOT auto-detect, press Ctrl+Shift+P → type "Maven" →
   select "Maven: Update Project"

---

### STEP 4: Configure Tomcat in VS Code

1. After installing "Community Server Connectors" extension, you'll see a
   "SERVERS" panel in the bottom-left of VS Code (or in the Explorer sidebar)

2. In the SERVERS panel:
   - Click "Create New Server"
   - Choose "Download Server" → search "tomcat" → pick "Apache Tomcat 9.x"
   - OR choose "Use Existing Server" → browse to your Tomcat folder
     (e.g., C:\Program Files\Apache\tomcat9)

3. The server should now appear in the SERVERS panel as "Tomcat 9.x"

---

### STEP 5: Build the Project

Open the VS Code terminal (Ctrl + `) and run:

```bash
mvn clean package
```

This will:
- Compile all Java files
- Package everything into: target/PawHome.war

If you see "BUILD SUCCESS" you're good!

**Common errors and fixes:**
- "mvn not recognized" → Maven not in PATH, restart VS Code after adding it
- "JAVA_HOME not set" → Reinstall JDK with "Set JAVA_HOME" checked
- Compilation errors → Make sure you have JDK 11+ (not just JRE)

---

### STEP 6: Deploy and Run

**Option A: Using VS Code Server Connector**
1. In SERVERS panel → Right-click Tomcat → "Start Server"
2. Wait for it to start (you'll see logs)
3. Right-click Tomcat → "Add Deployment"
4. Browse to: PawHome/target/PawHome.war
5. Select it → the app deploys automatically

**Option B: Manual Deployment (simpler)**
1. Copy the file `target/PawHome.war` to Tomcat's webapps folder:
   ```
   C:\Program Files\Apache\tomcat9\webapps\PawHome.war
   ```

2. Start Tomcat by running:
   ```
   C:\Program Files\Apache\tomcat9\bin\startup.bat
   ```
   (Double-click startup.bat or run from Command Prompt)

3. Wait 5-10 seconds for Tomcat to extract and deploy the WAR file

---

### STEP 7: Access the Application

Open your browser and go to:

```
http://localhost:8080/PawHome/
```

You should see the PawHome landing page with the hero section!

**Login credentials:**
- Admin: admin@pawhome.com / admin123
- Users: Register a new account → Admin approves → Then login

---

### STEP 8: Test the Full Workflow

1. Visit http://localhost:8080/PawHome/ → See landing page
2. Click "Register" → Fill the form → Submit
3. Login as admin (admin@pawhome.com / admin123)
4. Go to Users → Approve the new user you registered
5. Logout → Login as the new user
6. Browse animals → Search → Filter by category
7. Click an animal → View details → Add to wishlist
8. Submit adoption application with a reason
9. Logout → Login as admin again
10. Check Applications → Approve/Reject
11. Check Reports → See statistics
12. Check Inquiries (test via Contact page first)

---

## PROJECT STRUCTURE

```
PawHome/
├── pom.xml                          ← Maven config (dependencies)
├── sql/
│   └── schema.sql                   ← Database setup script
└── src/main/
    ├── java/com/pawhome/
    │   ├── model/                   ← Data classes (User, Animal, etc.)
    │   │   ├── User.java
    │   │   ├── Animal.java
    │   │   ├── Category.java
    │   │   ├── AdoptionApplication.java
    │   │   ├── Wishlist.java
    │   │   └── Inquiry.java
    │   ├── dao/                     ← Database operations
    │   │   ├── UserDAO.java
    │   │   ├── AnimalDAO.java
    │   │   ├── CategoryDAO.java
    │   │   ├── AdoptionDAO.java
    │   │   ├── WishlistDAO.java
    │   │   └── InquiryDAO.java
    │   ├── service/                 ← Business logic
    │   │   ├── UserService.java
    │   │   ├── AnimalService.java
    │   │   └── AdoptionService.java
    │   ├── controller/              ← Servlet controllers
    │   │   ├── LoginServlet.java
    │   │   ├── RegisterServlet.java
    │   │   ├── AdminServlet.java
    │   │   ├── UserPortalServlet.java
    │   │   └── ContactServlet.java
    │   ├── filter/                  ← Auth filter
    │   │   └── AuthFilter.java
    │   └── util/                    ← Utilities
    │       ├── DatabaseConnection.java
    │       ├── PasswordEncryptor.java
    │       └── InputValidator.java
    └── webapp/
        ├── WEB-INF/web.xml          ← Deployment descriptor
        ├── css/style.css             ← All styling (no Bootstrap)
        ├── js/main.js                ← Client-side JS
        ├── index.jsp                 ← Landing page
        ├── login.jsp                 ← Login page
        ├── register.jsp              ← Registration page
        ├── about.jsp                 ← About page
        ├── contact.jsp               ← Contact form
        ├── error.jsp                 ← Error pages (404, 403, 500)
        ├── admin/                    ← Admin pages
        │   ├── dashboard.jsp
        │   ├── animals.jsp
        │   ├── animal-form.jsp
        │   ├── applications.jsp
        │   ├── users.jsp
        │   ├── categories.jsp
        │   ├── reports.jsp
        │   └── inquiries.jsp
        └── user/                     ← User pages
            ├── home.jsp
            ├── animal-detail.jsp
            ├── applications.jsp
            ├── wishlist.jsp
            └── profile.jsp
```

---

## DATABASE CONFIGURATION

If your MySQL uses a different password, edit this file:
`src/main/java/com/pawhome/util/DatabaseConnection.java`

Change these lines:
```java
private static final String URL = "jdbc:mysql://localhost:3306/pawhome?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String USER = "root";
private static final String PASSWORD = "";  // Change this if you have a password
```

---

## TROUBLESHOOTING

**"Cannot connect to database"**
→ Make sure XAMPP MySQL is running (green light in XAMPP Control Panel)

**"404 Page Not Found"**
→ Make sure the URL is http://localhost:8080/PawHome/ (capital P and H)
→ Check Tomcat logs in: tomcat9/logs/catalina.out

**"500 Internal Server Error"**
→ Check Tomcat logs for the actual Java exception
→ Most likely database connection issue

**"ClassNotFoundException: com.mysql.cj.jdbc.Driver"**
→ Run `mvn clean package` again to ensure mysql-connector is in the WAR
→ Check target/PawHome/WEB-INF/lib/ for mysql-connector jar

**Images not showing after upload**
→ Uploaded images go to Tomcat's deployed app folder
→ They reset when you redeploy. This is normal for development.

**Tomcat port 8080 already in use**
→ Something else is using port 8080
→ Change Tomcat port: edit tomcat9/conf/server.xml, find port="8080", change to 8081

---

## QUICK REBUILD AFTER CODE CHANGES

After editing any Java or JSP file:

```bash
mvn clean package
```

Then redeploy the WAR file (copy to webapps or redeploy via VS Code).

For JSP/CSS/JS changes only (no Java changes):
- Edit files directly in target/PawHome/ for instant refresh
- OR just redeploy

---

## TECHNOLOGIES USED

- Java 11+ (JDK)
- Java Servlet API 4.0
- JSP (JavaServer Pages)
- MySQL 8.0 (via XAMPP)
- CSS3 (Flexbox + Media Queries, NO Bootstrap)
- JavaScript (vanilla, minimal usage)
- Apache Tomcat 9
- Maven (build tool)
- MVC Architecture
- SHA-256 Password Encryption
- Session & Cookie Management
- Servlet Filters for Auth
