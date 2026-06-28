<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    // Check if user is logged in
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get session information
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userType = (String) session.getAttribute("userType");
    Long loginTime = (Long) session.getAttribute("loginTime");
    
    // Calculate session duration
    long sessionDuration = 0;
    String sessionDurationText = "Just now";
    if (loginTime != null) {
        sessionDuration = System.currentTimeMillis() - loginTime;
        long minutes = sessionDuration / (60 * 1000);
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            sessionDurationText = days + " day" + (days > 1 ? "s" : "") + " ago";
        } else if (hours > 0) {
            sessionDurationText = hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        } else if (minutes > 0) {
            sessionDurationText = minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        } else {
            sessionDurationText = "Just now";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - Food Donation System</title>
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
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 20px 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .header-left h1 {
            color: #2c3e50;
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .header-left p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2980b9);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: bold;
        }
        
        .user-details h3 {
            color: #2c3e50;
            margin-bottom: 3px;
        }
        
        .user-details p {
            color: #7f8c8d;
            font-size: 12px;
        }
        
        .role-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 11px;
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
        
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .card h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .card-icon {
            font-size: 24px;
        }
        
        .info-grid {
            display: grid;
            gap: 15px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: bold;
            color: #7f8c8d;
        }
        
        .info-value {
            color: #2c3e50;
            text-align: right;
        }
        
        .quick-actions {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .action-btn {
            padding: 15px;
            border: 2px solid #ecf0f1;
            border-radius: 10px;
            text-decoration: none;
            color: #2c3e50;
            text-align: center;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        
        .action-btn:hover {
            border-color: #3498db;
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.2);
        }
        
        .action-icon {
            font-size: 24px;
        }
        
        .action-text {
            font-size: 14px;
            font-weight: bold;
        }
        
        .logout-btn {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        
        .status-card {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-left: 4px solid #28a745;
        }
        
        .status-card h2 {
            color: #155724;
        }
        
        .session-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .session-time {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .welcome-message {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #2196f3;
        }
        
        .welcome-message h3 {
            color: #1565c0;
            margin-bottom: 10px;
        }
        
        .welcome-message p {
            color: #0d47a1;
            line-height: 1.6;
        }
        
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                gap: 20px;
            }
            
            .user-info {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <div class="header">
            <div class="header-left">
                <h1>🍽️ Food Donation System</h1>
                <p>User Dashboard - Phase 3 Implementation</p>
            </div>
            <div class="user-info">
                <div class="user-avatar">
                    <%= userName.charAt(0) %>
                </div>
                <div class="user-details">
                    <h3><%= userName %></h3>
                    <p><%= userEmail %></p>
                    <span class="role-badge role-<%= userType %>">
                        <%= loggedInUser.getRoleDisplayName() %>
                    </span>
                </div>
                <form action="logout" method="post" style="margin: 0;">
                    <button type="submit" class="logout-btn">🚪 Logout</button>
                </form>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- User Profile Card -->
            <div class="card">
                <h2><span class="card-icon">👤</span> User Profile</h2>
                
                <div class="welcome-message">
                    <h3>Welcome back, <%= userName %>! 👋</h3>
                    <p>You are successfully logged into the Online Food Donation System. 
                    Your session is active and you can access all features based on your role.</p>
                </div>
                
                <div class="session-info">
                    <div>
                        <strong>Session Status:</strong> 
                        <span style="color: #28a745;">✅ Active</span>
                    </div>
                    <div class="session-time">
                        Logged in <%= sessionDurationText %>
                    </div>
                </div>
                
                <div class="info-grid">
                    <div class="info-row">
                        <span class="info-label">User ID:</span>
                        <span class="info-value">#<%= loggedInUser.getId() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Username:</span>
                        <span class="info-value"><%= loggedInUser.getUsername() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Full Name:</span>
                        <span class="info-value"><%= loggedInUser.getFullName() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= loggedInUser.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phone:</span>
                        <span class="info-value">
                            <%= loggedInUser.getPhone() != null && !loggedInUser.getPhone().trim().isEmpty() ? 
                               loggedInUser.getPhone() : "Not provided" %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Address:</span>
                        <span class="info-value">
                            <%= loggedInUser.getAddress() != null && !loggedInUser.getAddress().trim().isEmpty() ? 
                               loggedInUser.getAddress() : "Not provided" %>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Member Since:</span>
                        <span class="info-value"><%= loggedInUser.getCreatedAt() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Last Updated:</span>
                        <span class="info-value"><%= loggedInUser.getUpdatedAt() %></span>
                    </div>
                </div>
            </div>
            
            <!-- Quick Actions Card -->
            <div class="card">
                <h2><span class="card-icon">🚀</span> Quick Actions</h2>
                
                <div class="quick-actions">
                    <% if (loggedInUser.isDonor()) { %>
                        <a href="donate.jsp" class="action-btn">
                            <span class="action-icon">🎁</span>
                            <span class="action-text">Donate Food</span>
                        </a>
                        <a href="donation-history.jsp" class="action-btn">
                            <span class="action-icon">📋</span>
                            <span class="action-text">My Donations</span>
                        </a>
                        <a href="#" class="action-btn">
                            <span class="action-icon">🔍</span>
                            <span class="action-text">Browse Requests</span>
                        </a>
                        <a href="donation-history.jsp" class="action-btn">
                            <span class="action-icon">📊</span>
                            <span class="action-text">Donation History</span>
                        </a>
                    <% } else if (loggedInUser.isNGO()) { %>
                        <a href="ngo?action=dashboard" class="action-btn">
                            <span class="action-icon">🏢</span>
                            <span class="action-text">NGO Dashboard</span>
                        </a>
                        <a href="ngo?action=requestForm" class="action-btn">
                            <span class="action-icon">📝</span>
                            <span class="action-text">Request Food</span>
                        </a>
                        <a href="ngo?action=history" class="action-btn">
                            <span class="action-icon">📋</span>
                            <span class="action-text">Request History</span>
                        </a>
                        <a href="ngo?action=dashboard" class="action-btn">
                            <span class="action-icon">🔍</span>
                            <span class="action-text">View Donations</span>
                        </a>
                    <% } else if (loggedInUser.isAdmin()) { %>
                        <a href="admin" class="action-btn">
                            <span class="action-icon">🛠️</span>
                            <span class="action-text">Admin Panel</span>
                        </a>
                        <a href="admin?action=dashboard" class="action-btn">
                            <span class="action-icon">👥</span>
                            <span class="action-text">Manage Users</span>
                        </a>
                        <a href="admin?action=dashboard" class="action-btn">
                            <span class="action-icon">🎁</span>
                            <span class="action-text">All Donations</span>
                        </a>
                        <a href="#" class="action-btn">
                            <span class="action-icon">📊</span>
                            <span class="action-text">System Reports</span>
                        </a>
                    <% } %>
                    
                    <a href="#" class="action-btn">
                        <span class="action-icon">⚙️</span>
                        <span class="action-text">Edit Profile</span>
                    </a>
                    <a href="#" class="action-btn">
                        <span class="action-icon">🔒</span>
                        <span class="action-text">Change Password</span>
                    </a>
                    <a href="#" class="action-btn">
                        <span class="action-icon">📞</span>
                        <span class="action-text">Contact Support</span>
                    </a>
                    <a href="testdb" class="action-btn">
                        <span class="action-icon">🔧</span>
                        <span class="action-text">Test Database</span>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- System Status Card -->
        <div class="card status-card">
            <h2><span class="card-icon">✅</span> System Status</h2>
            <div class="info-grid">
                <div class="info-row">
                    <span class="info-label">Database Connection:</span>
                    <span class="info-value" style="color: #28a745;">✅ Connected</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Session Management:</span>
                    <span class="info-value" style="color: #28a745;">✅ Active</span>
                </div>
                <div class="info-row">
                    <span class="info-label">User Authentication:</span>
                    <span class="info-value" style="color: #28a745;">✅ Verified</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Application Phase:</span>
                    <span class="info-value">Phase 3 - Login System</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Server Time:</span>
                    <span class="info-value"><%= new java.util.Date() %></span>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Auto-refresh session duration
        function updateSessionDuration() {
            const sessionDurationElement = document.querySelector('.session-time');
            if (sessionDurationElement) {
                const loginTimeValue = <%= loginTime != null ? loginTime : 0 %>;
                const now = Date.now();
                const duration = now - loginTimeValue;
                
                const minutes = Math.floor(duration / (60 * 1000));
                const hours = Math.floor(minutes / 60);
                const days = Math.floor(hours / 24);
                
                let durationText = "Just now";
                if (days > 0) {
                    durationText = days + " day" + (days > 1 ? "s" : "") + " ago";
                } else if (hours > 0) {
                    durationText = hours + " hour" + (hours > 1 ? "s" : "") + " ago";
                } else if (minutes > 0) {
                    durationText = minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
                }
                
                sessionDurationElement.textContent = "Logged in " + durationText;
            }
        }
        
        // Update session duration every minute
        setInterval(updateSessionDuration, 60000);
        
        // Handle logout confirmation
        document.querySelector('.logout-btn').addEventListener('click', function(e) {
            if (!confirm('Are you sure you want to logout?')) {
                e.preventDefault();
            }
        });
        
        // Add click feedback to action buttons
        document.querySelectorAll('.action-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                // Check if it's a placeholder link
                if (this.getAttribute('href') === '#') {
                    e.preventDefault();
                    alert('This feature will be implemented in the next phases of the project.');
                }
            });
        });
    </script>
</body>
</html>
