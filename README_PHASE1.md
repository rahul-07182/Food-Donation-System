# Online Food Donation System - Phase 1 Implementation Guide

## 🎯 Phase 1: MySQL Database Setup and JDBC Connection

This guide provides step-by-step instructions for implementing Phase 1 of the Online Food Donation System.

---

## 📋 Prerequisites

- Java 17 installed
- Apache Tomcat 10.1 installed
- MySQL Server installed and running
- MySQL Connector/J driver

---

## 🗄️ Step 1: Create MySQL Database

### 1.1 Connect to MySQL
```bash
mysql -u root -p
# Enter password: root
```

### 1.2 Run the Database Setup Script
```bash
mysql -u root -p food_donation_db < database_setup.sql
```

Or execute the SQL commands manually in MySQL Workbench or phpMyAdmin.

---

## 📦 Step 2: Install MySQL Connector/J

### 2.1 Download MySQL Connector/J
Download from: https://dev.mysql.com/downloads/connector/j/

### 2.2 Place the JAR file
**Exact Location:** 
```
C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib\mysql-connector-j-8.4.0.jar
```

### 2.3 Create lib directory if it doesn't exist
```bash
mkdir "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib"
```

---

## 🔧 Step 3: Compile Java Files

### 3.1 Set up CLASSPATH
```bash
set CLASSPATH=.;C:\Program Files\Apache Software Foundation\Tomcat 10.1\lib\servlet-api.jar;C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib\mysql-connector-j-8.4.0.jar
```

### 3.2 Compile DBConnection.java
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\classes"
javac -cp "%CLASSPATH%" database\DBConnection.java
```

### 3.3 Compile TestDBServlet.java
```bash
javac -cp "%CLASSPATH%" database\TestDBServlet.java
```

### 3.4 Alternative: Compile all at once
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\classes"
javac -cp "%CLASSPATH%" database/*.java
```

---

## 🚀 Step 4: Start Tomcat

### 4.1 Stop existing Tomcat (if running)
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin"
shutdown.bat
```

### 4.2 Start Tomcat
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin"
startup.bat
```

---

## 🧪 Step 5: Test Database Connection

### 5.1 Access the Test Servlet
Open your browser and go to:
```
http://localhost:8080/FoodDonation/testdb
```

### 5.2 Expected Successful Output
You should see:
- ✅ Database connection successful!
- Database information table with MySQL details
- List of tables in food_donation_db
- ✅ All database tests passed!

---

## 📁 Project Structure

```
FoodDonation/
├── WEB-INF/
│   ├── classes/
│   │   └── database/
│   │       ├── DBConnection.java
│   │       ├── DBConnection.class
│   │       ├── TestDBServlet.java
│   │       └── TestDBServlet.class
│   ├── lib/
│   │   └── mysql-connector-j-8.4.0.jar
│   └── web.xml
├── database_setup.sql
├── index.html
└── README_PHASE1.md
```

---

## 🔍 Troubleshooting

### Common Issues and Solutions

#### 1. ClassNotFoundException: com.mysql.cj.jdbc.Driver
**Problem:** MySQL Connector/J not found
**Solution:** 
- Verify mysql-connector-j.jar is in WEB-INF/lib folder
- Check JAR file name matches your version
- Restart Tomcat after placing the JAR

#### 2. Connection refused: connect
**Problem:** MySQL server not running
**Solution:**
- Start MySQL service
- Verify MySQL is running on port 3306
- Check if firewall is blocking the connection

#### 3. Access denied for user 'root'@'localhost'
**Problem:** Incorrect MySQL credentials
**Solution:**
- Verify MySQL username and password
- Update DBConnection.java with correct credentials
- Recompile the Java files

#### 4. Unknown database 'food_donation_db'
**Problem:** Database doesn't exist
**Solution:**
- Run the database_setup.sql script
- Verify database was created successfully

#### 5. HTTP 404 - Not Found
**Problem:** Servlet not deployed properly
**Solution:**
- Verify web.xml configuration
- Check if servlet classes are compiled
- Restart Tomcat

---

## 🎯 Verification Checklist

- [ ] MySQL server is running
- [ ] Database 'food_donation_db' exists
- [ ] Tables (users, donations, food_requests) created
- [ ] mysql-connector-j.jar in WEB-INF/lib
- [ ] Java files compiled successfully
- [ ] Tomcat started without errors
- [ ] Test servlet accessible at /testdb
- [ ] Database connection test shows ✅ success

---

## 📞 Support

If you encounter issues:

1. Check Tomcat logs: `C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.YYYY-MM-DD.log`
2. Verify MySQL logs for connection issues
3. Check browser console for JavaScript errors
4. Ensure all file paths are correct

---

## 🚀 Next Phase

After completing Phase 1 successfully, you can proceed to:
- Phase 2: User Registration and Login
- Phase 3: Donation Management
- Phase 4: Food Request System
- Phase 5: Admin Dashboard

---

**Phase 1 Complete! 🎉**
