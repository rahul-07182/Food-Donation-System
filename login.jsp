<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User sessionUser = (User) session.getAttribute("loggedInUser");
    if (sessionUser != null) {
        if (sessionUser.isAdmin()) {
            response.sendRedirect("admin?action=dashboard");
        } else if (sessionUser.isNGO()) {
            response.sendRedirect("ngo?action=dashboard");
        } else {
            response.sendRedirect("dashboard.jsp");
        }
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Login - Food Donation System</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .required {
            color: #e74c3c;
        }
        
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 2px solid #ecf0f1;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }
        
        input[type="email"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #3498db;
        }
        
        .checkbox {
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }
        
        .checkbox input[type="checkbox"] {
            margin-right: 8px;
            width: auto;
        }
        
        .checkbox label {
            margin-bottom: 0;
            font-weight: normal;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn:active {
            transform: translateY(0);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            margin-top: 10px;
        }
        
        .btn-secondary:hover {
            box-shadow: 0 5px 15px rgba(149, 165, 166, 0.3);
        }
        
        .links {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
        }
        
        .links a {
            color: #3498db;
            text-decoration: none;
            font-size: 14px;
            display: block;
            margin-bottom: 8px;
        }
        
        .links a:hover {
            text-decoration: underline;
        }
        
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
            text-align: center;
        }
        
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            text-align: center;
        }
        
        .info-message {
            background-color: #e3f2fd;
            color: #1565c0;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
            font-size: 13px;
        }
        
        .info-message h4 {
            margin-bottom: 10px;
            color: #0d47a1;
        }
        
        .info-message ul {
            margin-left: 20px;
        }
        
        .info-message li {
            margin-bottom: 5px;
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔐 User Login</h1>
            <p>Welcome back to the Food Donation System</p>
        </div>
        
        <% 
            // Show logout success message
            String logoutParam = request.getParameter("logout");
            if ("success".equals(logoutParam)) {
        %>
        <div class="success-message">
            ✅ You have been successfully logged out.
        </div>
        <% 
            }
            
            // Show error message if any
            String errorParam = request.getParameter("error");
            if ("invalid".equals(errorParam)) {
        %>
        <div class="error-message">
            ❌ Invalid email or password. Please try again.
        </div>
        <% 
            }
        %>
        
        <div class="info-message">
            <h4>📋 Login Instructions:</h4>
            <ul>
                <li>Use the email address you registered with</li>
                <li>Enter your password (case-sensitive)</li>
                <li>Check "Remember me" to stay logged in for 7 days</li>
                <li>New user? <a href="register.jsp">Register here</a></li>
            </ul>
        </div>
        
        <form id="loginForm" method="post" action="login" onsubmit="return validateForm()">
            
            <div class="form-group">
                <label for="email">Email Address: <span class="required">*</span></label>
                <input type="email" id="email" name="email" required 
                       placeholder="your.email@example.com" autocomplete="email">
            </div>
            
            <div class="form-group">
                <label for="password">Password: <span class="required">*</span></label>
                <input type="password" id="password" name="password" required 
                       placeholder="Enter your password" autocomplete="current-password">
            </div>
            
            <div class="checkbox">
                <input type="checkbox" id="rememberMe" name="rememberMe">
                <label for="rememberMe">Remember me for 7 days</label>
            </div>
            
            <button type="submit" class="btn">🚀 Login</button>
            <button type="button" class="btn btn-secondary" onclick="window.location.href='index.html'">
                🏠 Back to Home
            </button>
        </form>
        
        <div class="links">
            <a href="register.jsp">📝 Don't have an account? Register here</a>
            <a href="admin-login.jsp">🛡️ Administrator? Admin Login</a>
            <a href="index.html">🏠 Back to Home</a>
            <a href="testdb">🔧 Test Database Connection</a>
        </div>
    </div>
    
    <script>
        // Client-side validation
        function validateForm() {
            const form = document.getElementById('loginForm');
            const email = form.email.value.trim();
            const password = form.password.value;
            
            // Hide any existing messages
            const messages = document.querySelectorAll('.success-message, .error-message');
            messages.forEach(msg => msg.style.display = 'none');
            
            // Validate email
            if (!email) {
                showError('Email is required.');
                return false;
            }
            
            if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
                showError('Please enter a valid email address.');
                return false;
            }
            
            // Validate password
            if (!password) {
                showError('Password is required.');
                return false;
            }
            
            // Show loading state
            const submitBtn = form.querySelector('button[type="submit"]');
            submitBtn.textContent = '🔄 Logging in...';
            submitBtn.disabled = true;
            
            return true;
        }
        
        function showError(message) {
            // Remove existing error messages
            const existingError = document.querySelector('.error-message');
            if (existingError) {
                existingError.remove();
            }
            
            // Create and show new error message
            const errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            errorDiv.innerHTML = '❌ ' + message;
            
            // Insert after the header
            const header = document.querySelector('.header');
            header.parentNode.insertBefore(errorDiv, header.nextSibling);
            
            // Scroll to top of form
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
        
        // Real-time validation feedback
        document.getElementById('email').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 0 && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                this.style.borderColor = '#e74c3c';
            } else if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
        
        document.getElementById('password').addEventListener('input', function() {
            const value = this.value;
            if (value.length > 0) {
                this.style.borderColor = '#27ae60';
            } else {
                this.style.borderColor = '#ecf0f1';
            }
        });
        
        // Focus on email field when page loads
        window.addEventListener('load', function() {
            document.getElementById('email').focus();
        });
        
        // Handle Enter key in form fields
        document.getElementById('email').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('password').focus();
            }
        });
        
        document.getElementById('password').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('loginForm').submit();
            }
        });
    </script>
</body>
</html>
