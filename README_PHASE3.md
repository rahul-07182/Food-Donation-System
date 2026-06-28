# Online Food Donation System - Phase 3 Implementation Guide

## 🎯 Phase 3: Login System with Session Handling

This guide provides step-by-step instructions for implementing Phase 3 of the Online Food Donation System with complete user authentication and session management.

---

## 📋 Prerequisites

- ✅ Phase 1 completed (Database setup and JDBC connection)
- ✅ Phase 2 completed (User registration system)
- Java 17 installed
- Apache Tomcat 10.1 installed and running
- MySQL Server running with `food_donation_db` database
- Existing registered users in the database

---

## 🗂️ Phase 3 File Structure

```
FoodDonation/
├── WEB-INF/
│   ├── classes/
│   │   ├── database/
│   │   │   ├── DBConnection.java ✅ (Phase 1)
│   │   │   └── TestDBServlet.java ✅ (Phase 1)
│   │   ├── model/
│   │   │   └── User.java ✅ (Phase 2)
│   │   ├── dao/
│   │   │   └── UserDAO.java 🔄 (updated with login methods)
│   │   └── servlet/
│   │       ├── RegisterServlet.java ✅ (Phase 2)
│   │       ├── LoginServlet.java 🆕
│   │       └── LogoutServlet.java 🆕
│   ├── lib/
│   │   └── mysql-connector-j-8.4.0.jar ✅ (Phase 1)
│   └── web.xml 🔄 (updated with new servlets)
├── register.jsp ✅ (Phase 2)
├── register-success.jsp ✅ (Phase 2)
├── login.jsp 🆕
├── dashboard.jsp 🆕
├── index.html ✅ (Phase 1)
├── database_setup.sql ✅ (Phase 1)
└── README_PHASE3.md 🆕
```

---

## 🔧 Step 1: Compile Java Files

### 1.1 Set CLASSPATH
```bash
set CLASSPATH=.;C:\Program Files\Apache Software Foundation\Tomcat 10.1\lib\servlet-api.jar;C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\lib\mysql-connector-j-8.4.0.jar
```

### 1.2 Compile Updated DAO Classes
```bash
cd "C:\Program Files\Apache Software Foundation\Tomcat 10.1\webapps\FoodDonation\WEB-INF\classes"
javac -cp "%CLASSPATH%" dao\UserDAO.java
```

### 1.3 Compile New Servlet Classes
```bash
javac -cp "%CLASSPATH%" servlet\LoginServlet.java
javac -cp "%CLASSPATH%" servlet\LogoutServlet.java
```

### 1.4 Alternative: Compile All at Once
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

## 🧪 Step 3: Test Login System

### 3.1 Access Login Form
Open your browser and go to:
```
http://localhost:8080/FoodDonation/login.jsp
```

### 3.2 Test Login Features

#### ✅ Login Tests:
1. **Valid Login**: Use registered user credentials
2. **Invalid Email**: Try non-existent email
3. **Invalid Password**: Try wrong password
4. **Empty Fields**: Submit without filling required fields
5. **Remember Me**: Test session persistence
6. **Logout**: Test session cleanup
7. **Session Protection**: Try accessing dashboard without login

### 3.3 Expected Login Flow:
1. Enter valid email and password
2. Click "Login" button
3. Redirect to dashboard with user information
4. See logged-in user name and role
5. Access session-protected content

---

## 📊 Database Integration

### JDBC Login Query Used:
```sql
SELECT id, username, password, full_name, email, phone, address, user_type, 
       DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, 
       DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at 
FROM users WHERE email = ? AND password = ?
```

### Session Management:
- **Session Creation**: `HttpSession session = request.getSession(true);`
- **Session Attributes**: `loggedInUser`, `userEmail`, `userType`, `userName`, `loginTime`
- **Session Timeout**: 30 minutes (7 days if "Remember Me" checked)
- **Session Invalidation**: `session.invalidate();`

---

## 🔍 Session Handling Explained

### How Sessions Work:
1. **Login Process**:
   - User submits login form
   - Server validates credentials against database
   - If successful, creates HTTP session
   - Stores user object and metadata in session
   - Redirects to dashboard

2. **Session Storage**:
   ```java
   HttpSession session = request.getSession(true);
   session.setAttribute("loggedInUser", authenticatedUser);
   session.setAttribute("userEmail", email);
   session.setAttribute("userType", authenticatedUser.getUserType());
   session.setAttribute("userName", authenticatedUser.getFullName());
   session.setAttribute("loginTime", System.currentTimeMillis());
   ```

3. **Session Protection**:
   ```java
   // In dashboard.jsp and other protected pages
   User loggedInUser = (User) session.getAttribute("loggedInUser");
   if (loggedInUser == null) {
       response.sendRedirect("login.jsp");
       return;
   }
   ```

4. **Logout Process**:
   ```java
   HttpSession session = request.getSession(false);
   if (session != null) {
       session.invalidate();
   }
   response.sendRedirect("login.jsp?logout=success");
   ```

---

## 🧪 Testing Scenarios

### Test Case 1: Valid Login
```
Email: john.doe@example.com (registered user)
Password: password123 (correct password)
Remember Me: unchecked
```
**Expected**: Redirect to dashboard with user profile

### Test Case 2: Invalid Credentials
```
Email: john.doe@example.com
Password: wrongpassword
```
**Expected**: Error message "Invalid email or password"

### Test Case 3: Non-existent User
```
Email: nonexist@example.com
Password: anypassword
```
**Expected**: Error message "Invalid email or password"

### Test Case 4: Session Protection
Try accessing: `http://localhost:8080/FoodDonation/dashboard.jsp` without login
**Expected**: Redirect to login page

### Test Case 5: Logout Test
1. Login successfully
2. Click logout button
3. Try accessing dashboard again
**Expected**: Redirect to login page with "logged out" message

---

## 🎨 Features Implemented

### ✅ Authentication Features:
- **Email/Password Login**: Secure credential validation
- **Session Management**: Automatic session creation and cleanup
- **Remember Me**: Extended session duration option
- **Logout Functionality**: Complete session invalidation
- **Access Control**: Prevent unauthorized access to protected pages

### ✅ UI/UX Features:
- **Beautiful Login Form**: Modern gradient design
- **Real-time Validation**: Client-side input validation
- **Error Handling**: Clear error messages
- **Success Feedback**: Logout confirmation messages
- **Responsive Design**: Works on all devices

### ✅ Security Features:
- **SQL Injection Prevention**: Using prepared statements
- **Session Security**: HttpOnly cookies configured
- **Access Control**: Server-side session validation
- **Input Validation**: Both client and server-side

---

## 📱 Expected Outputs

### Successful Login Dashboard:
- User profile information
- Role-based quick actions
- Session status indicator
- Logout functionality
- System status display

### Login Error Messages:
- "Invalid email or password. Please try again."
- "Email is required."
- "Password is required."
- "Please enter a valid email address."

### Logout Success:
- "You have been successfully logged out."
- Redirect to login page

---

## 🔧 Troubleshooting

### Common Issues and Solutions

#### 1. Login Always Fails
**Problem**: Database connection or query issue
**Solution**:
- Test database connection: `http://localhost:8080/FoodDonation/testdb`
- Verify users table exists and has data
- Check UserDAO authentication query

#### 2. Session Not Working
**Problem**: Session configuration issue
**Solution**:
- Check web.xml session configuration
- Verify cookies are enabled in browser
- Check Tomcat session timeout settings

#### 3. Dashboard Not Loading After Login
**Problem**: Redirect issue or session attribute missing
**Solution**:
- Check LoginServlet session attribute setting
- Verify dashboard.jsp session validation
- Check browser network tab for redirect issues

#### 4. Logout Not Working
**Problem**: Session invalidation issue
**Solution**:
- Check LogoutServlet session.invalidate() call
- Verify logout form submission method
- Check browser cookie clearing

#### 5. Access Control Bypassed
**Problem**: Session validation not working
**Solution**:
- Verify session.getAttribute("loggedInUser") check
- Check response.sendRedirect() implementation
- Test with private/incognito browser window

---

## 🚀 Next Phase

After completing Phase 3 successfully, you can proceed to:
- **Phase 4**: Donation Management System
- **Phase 5**: Food Request System
- **Phase 6**: User Dashboard Enhancement

---

## 📞 Support

If you encounter issues:

1. **Check Tomcat Logs**: `C:\Program Files\Apache Software Foundation\Tomcat 10.1\logs\catalina.YYYY-MM-DD.log`
2. **Check MySQL Logs**: MySQL error log for database issues
3. **Browser Console**: F12 → Console for JavaScript errors
4. **Network Tab**: F12 → Network for HTTP request issues
5. **Session Debugging**: Check browser cookies and session storage

---

**Phase 3 Complete! 🎉**

Your Online Food Donation System now has a fully functional login system with:
- ✅ Secure email/password authentication
- ✅ Complete session management
- ✅ Logout functionality with session cleanup
- ✅ Access control for protected pages
- ✅ Beautiful, responsive login interface
- ✅ Role-based dashboard display
- ✅ Remember me functionality
- ✅ Professional error handling

Ready for Phase 4: Donation Management System!
