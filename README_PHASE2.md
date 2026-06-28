# Online Food Donation System - Phase 2 Implementation Guide

## 🎯 Phase 2: User Registration System

This guide provides step-by-step instructions for implementing Phase 2 of the Online Food Donation System with complete user registration functionality.

---

## 📋 Prerequisites

- ✅ Phase 1 completed (Database setup and JDBC connection)
- Java 17 installed
- Apache Tomcat 10.1 installed and running
- MySQL Server running with `food_donation_db` database
- MySQL Connector/J driver in WEB-INF/lib folder

---

## 🗂️ Phase 2 File Structure

```
FoodDonation/
├── WEB-INF/
│   ├── classes/
│   │   ├── database/
│   │   │   ├── DBConnection.java ✅ (from Phase 1)
│   │   │   └── TestDBServlet.java ✅ (from Phase 1)
│   │   ├── model/
│   │   │   └── User.java 🆕
│   │   ├── dao/
│   │   │   └── UserDAO.java 🆕
│   │   └── servlet/
│   │       └── RegisterServlet.java 🆕
│   ├── lib/
│   │   └── mysql-connector-j-8.4.0.jar ✅ (from Phase 1)
│   └── web.xml 🔄 (updated)
├── register.jsp 🆕
├── register-success.jsp 🆕
├── index.html ✅ (from Phase 1)
├── database_setup.sql ✅ (from Phase 1)
└── README_PHASE2.md 🆕
```

---

## 🔧 Step 1: Compile Java Files

### 1.1 Set CLASSPATH
```bash
set CLASSPATH=.;C:\Program Files\Apache Software Foundation\Tomcat 10.1\lib\servlet-api.jar;C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib\mysql-connector-j-8.4.0.jar
```

### 1.2 Compile Model Classes
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\classes"
javac -cp "%CLASSPATH%" model\User.java
```

### 1.3 Compile DAO Classes
```bash
javac -cp "%CLASSPATH%" dao\UserDAO.java
```

### 1.4 Compile Servlet Classes
```bash
javac -cp "%CLASSPATH%" servlet\RegisterServlet.java
```

### 1.5 Alternative: Compile All at Once
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\classes"
javac -cp "%CLASSPATH%" model\*.java dao\*.java servlet\*.java
```

---

## 🚀 Step 2: Restart Tomcat

### 2.1 Stop Tomcat
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin"
shutdown.bat
```

### 2.2 Start Tomcat
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\bin"
startup.bat
```

---

## 🧪 Step 3: Test Registration System

### 3.1 Access Registration Form
Open your browser and go to:
```
http://localhost:8080/FoodDonation/register.jsp
```

### 3.2 Test Registration Form Features

#### ✅ Form Validation Tests:
1. **Empty Fields**: Submit without filling required fields
2. **Username Validation**: 
   - Try usernames shorter than 3 characters
   - Try usernames longer than 20 characters
   - Try special characters (should only allow letters, numbers, underscores)
3. **Password Validation**:
   - Try passwords shorter than 6 characters
   - Test password mismatch
4. **Email Validation**: Try invalid email formats
5. **Phone Validation**: Test invalid phone formats (optional field)

#### ✅ Database Tests:
1. **Duplicate Username**: Register with same username twice
2. **Duplicate Email**: Register with same email twice
3. **Successful Registration**: Complete valid registration

### 3.3 Expected Successful Registration Flow:
1. Fill out registration form with valid data
2. Click "Register Account"
3. See success page with user details
4. Auto-redirect to login page after 30 seconds

---

## 📊 Database Integration

### JDBC Insert Query Used:
```sql
INSERT INTO users (username, password, full_name, email, phone, address, user_type) 
VALUES (?, ?, ?, ?, ?, ?, ?)
```

### Database Table Structure:
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    user_type ENUM('donor', 'ngo', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

## 🔍 Testing Scenarios

### Test Case 1: Valid Registration
```
Username: johndoe
Password: password123
Confirm Password: password123
Full Name: John Doe
Email: john.doe@example.com
Phone: +1-555-123-4567
Address: 123 Main St, City, State
User Type: Food Donor
```
**Expected**: Success page with user details

### Test Case 2: Invalid Username
```
Username: ab (too short)
```
**Expected**: Error message "Username must be between 3 and 20 characters"

### Test Case 3: Password Mismatch
```
Password: password123
Confirm Password: differentpassword
```
**Expected**: Error message "Passwords do not match"

### Test Case 4: Duplicate Email
```
Email: existing.email@example.com (already in database)
```
**Expected**: Error message "Email is already registered"

---

## 🎨 Features Implemented

### ✅ Frontend Features:
- **Responsive Design**: Works on desktop and mobile
- **Real-time Validation**: Client-side validation with visual feedback
- **Beautiful UI**: Modern gradient design with animations
- **User-friendly Messages**: Clear error and success messages
- **Accessibility**: Proper labels and semantic HTML

### ✅ Backend Features:
- **Input Validation**: Server-side validation for security
- **Database Integration**: JDBC with prepared statements
- **Duplicate Prevention**: Check for existing usernames/emails
- **Session Management**: Secure session handling
- **Error Handling**: Comprehensive error management

### ✅ Security Features:
- **SQL Injection Prevention**: Using prepared statements
- **Input Sanitization**: Server-side validation
- **Session Security**: HttpOnly cookies configured
- **Password Handling**: Secure password storage (ready for hashing)

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. Compilation Error: "package does not exist"
**Problem**: CLASSPATH not set correctly
**Solution**: 
```bash
set CLASSPATH=.;C:\Program Files\Apache Software Foundation\Tomcat 10.1\lib\servlet-api.jar;C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib\mysql-connector-j-8.4.0.jar
```

#### 2. HTTP 404 - Not Found
**Problem**: Servlet not deployed properly
**Solution**:
- Check web.xml servlet mapping
- Verify .class files exist in correct directories
- Restart Tomcat

#### 3. Database Connection Error
**Problem**: MySQL connection failed
**Solution**:
- Verify MySQL server is running
- Check database credentials in DBConnection.java
- Ensure mysql-connector-j.jar is in WEB-INF/lib

#### 4. Registration Form Not Submitting
**Problem**: JavaScript validation blocking submission
**Solution**: Check browser console for JavaScript errors
- Disable JavaScript temporarily to test server-side validation
- Check form action URL matches servlet mapping

#### 5. Success Page Not Showing User Data
**Problem**: Session not properly set
**Solution**:
- Check RegisterServlet session attribute setting
- Verify register-success.jsp session retrieval
- Ensure cookies are enabled in browser

---

## 📱 Browser Testing

Test the registration system in:
- ✅ Chrome/Chromium
- ✅ Firefox
- ✅ Microsoft Edge
- ✅ Safari (if available)
- ✅ Mobile browsers (responsive design)

---

## 🚀 Next Phase

After completing Phase 2 successfully, you can proceed to:
- **Phase 3**: User Login System
- **Phase 4**: Donation Management
- **Phase 5**: Food Request System
- **Phase 6**: User Dashboard

---

## 📞 Support

If you encounter issues:

1. **Check Tomcat Logs**: `C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.YYYY-MM-DD.log`
2. **Check MySQL Logs**: MySQL error log for database issues
3. **Browser Console**: F12 → Console for JavaScript errors
4. **Network Tab**: F12 → Network for HTTP request issues

---

**Phase 2 Complete! 🎉**

Your Online Food Donation System now has a fully functional user registration system with:
- ✅ Beautiful, responsive registration form
- ✅ Complete input validation
- ✅ Database integration with duplicate prevention
- ✅ User-friendly success and error messages
- ✅ Secure session management
- ✅ Professional UI/UX design

Ready for Phase 3: User Login System!
