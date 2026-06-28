<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Successful - Food Donation System</title>
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
            max-width: 600px;
            text-align: center;
        }
        
        .success-icon {
            font-size: 72px;
            color: #27ae60;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-10px);
            }
            60% {
                transform: translateY(-5px);
            }
        }
        
        .success-title {
            color: #27ae60;
            font-size: 32px;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .success-message {
            color: #2c3e50;
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .user-info {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: left;
            border-left: 4px solid #27ae60;
        }
        
        .user-info h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 8px 0;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: bold;
            color: #7f8c8d;
            min-width: 120px;
        }
        
        .info-value {
            color: #2c3e50;
            flex: 1;
        }
        
        .role-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .role-donor {
            background: #e3f2fd;
            color: #1565c0;
        }
        
        .role-ngo {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        
        .role-admin {
            background: #e8f5e8;
            color: #2e7d32;
        }
        
        .next-steps {
            background: #fff3cd;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            border-left: 4px solid #ffc107;
        }
        
        .next-steps h3 {
            color: #856404;
            margin-bottom: 15px;
            font-size: 20px;
        }
        
        .next-steps ul {
            list-style: none;
            text-align: left;
        }
        
        .next-steps li {
            margin-bottom: 10px;
            padding-left: 25px;
            position: relative;
        }
        
        .next-steps li:before {
            content: "→";
            position: absolute;
            left: 0;
            color: #ffc107;
            font-weight: bold;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 10px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            cursor: pointer;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
            color: white;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(149, 165, 166, 0.3);
        }
        
        .footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #ecf0f1;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .footer a {
            color: #3498db;
            text-decoration: none;
        }
        
        .footer a:hover {
            text-decoration: underline;
        }
        
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }
            
            .success-title {
                font-size: 24px;
            }
            
            .info-row {
                flex-direction: column;
            }
            
            .info-label {
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
    <%
        // Get the registered user from session
        User registeredUser = (User) session.getAttribute("registeredUser");
        
        // If no user in session, redirect to registration page
        if (registeredUser == null) {
            response.sendRedirect("register.jsp");
            return;
        }
        
        // Clear the session attribute after displaying
        session.removeAttribute("registeredUser");
    %>
    
    <div class="container">
        <div class="success-icon">✅</div>
        
        <h1 class="success-title">Registration Successful!</h1>
        
        <p class="success-message">
            Welcome to the Online Food Donation System! Your account has been created successfully.
        </p>
        
        <div class="user-info">
            <h3>📋 Your Account Details</h3>
            
            <div class="info-row">
                <span class="info-label">User ID:</span>
                <span class="info-value">#<%= registeredUser.getId() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Username:</span>
                <span class="info-value"><%= registeredUser.getUsername() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Full Name:</span>
                <span class="info-value"><%= registeredUser.getFullName() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Email:</span>
                <span class="info-value"><%= registeredUser.getEmail() %></span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Phone:</span>
                <span class="info-value">
                    <%= registeredUser.getPhone() != null && !registeredUser.getPhone().trim().isEmpty() ? 
                       registeredUser.getPhone() : "Not provided" %>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Address:</span>
                <span class="info-value">
                    <%= registeredUser.getAddress() != null && !registeredUser.getAddress().trim().isEmpty() ? 
                       registeredUser.getAddress() : "Not provided" %>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">User Type:</span>
                <span class="info-value">
                    <span class="role-badge role-<%= registeredUser.getUserType() %>">
                        <%= registeredUser.getRoleDisplayName() %>
                    </span>
                </span>
            </div>
            
            <div class="info-row">
                <span class="info-label">Joined:</span>
                <span class="info-value"><%= registeredUser.getCreatedAt() %></span>
            </div>
        </div>
        
        <div class="next-steps">
            <h3>🚀 What's Next?</h3>
            <ul>
                <li>Login to your account using your username and password</li>
                <li>Complete your profile with additional information</li>
                <% if (registeredUser.isDonor()) { %>
                    <li>Start donating food to help those in need</li>
                    <li>Browse food requests from local NGOs</li>
                <% } else if (registeredUser.isNGO()) { %>
                    <li>Post food requests for your community</li>
                    <li>Connect with local food donors</li>
                <% } else if (registeredUser.isAdmin()) { %>
                    <li>Manage user accounts and system settings</li>
                    <li>Monitor food donations and requests</li>
                <% } %>
                <li>Contact support if you need any assistance</li>
            </ul>
        </div>
        
        <div class="actions">
            <a href="login.jsp" class="btn btn-primary">🔐 Login to Your Account</a>
            <a href="index.html" class="btn btn-secondary">🏠 Back to Home</a>
        </div>
        
        <div class="footer">
            <p>
                <strong>Important:</strong> Please save your login credentials securely. 
                If you forget your password, contact the system administrator.
            </p>
            <p>
                Need help? <a href="mailto:support@fooddonation.com">Contact Support</a>
            </p>
        </div>
    </div>
    
    <script>
        // Auto-redirect to login page after 30 seconds
        let countdown = 30;
        const countdownElement = document.createElement('p');
        countdownElement.style.color = '#7f8c8d';
        countdownElement.style.fontSize = '14px';
        countdownElement.style.marginTop = '20px';
        
        function updateCountdown() {
            countdownElement.innerHTML = `Auto-redirecting to login page in <strong>${countdown}</strong> seconds...`;
            countdown--;
            
            if (countdown < 0) {
                window.location.href = 'login.jsp';
            } else {
                setTimeout(updateCountdown, 1000);
            }
        }
        
        // Add countdown to the page
        document.querySelector('.actions').appendChild(countdownElement);
        updateCountdown();
        
        // Stop countdown if user interacts with the page
        let userInteracted = false;
        document.addEventListener('click', () => { userInteracted = true; });
        document.addEventListener('keypress', () => { userInteracted = true; });
        
        // Check if user has interacted before redirecting
        const originalRedirect = window.location.href;
        setInterval(() => {
            if (countdown < 0 && userInteracted) {
                // Don't redirect if user has interacted
                countdownElement.innerHTML = 'Auto-redirect cancelled. Click "Login to Your Account" when ready.';
            }
        }, 1000);
    </script>
</body>
</html>
