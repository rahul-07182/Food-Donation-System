<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser != null && loggedInUser.isAdmin()) {
        response.sendRedirect("admin?action=dashboard");
        return;
    }
    if (loggedInUser != null && !loggedInUser.isAdmin()) {
        response.sendRedirect("dashboard.jsp?error=You are logged in as a regular user. Please logout first.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Food Donation System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            padding: 20px;
        }
        .login-card {
            background: #fff;
            width: 100%;
            max-width: 420px;
            border-radius: 12px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.35);
            overflow: hidden;
        }
        .login-header {
            background: #1a73e8;
            color: #fff;
            padding: 30px 25px;
            text-align: center;
        }
        .login-header .icon { font-size: 42px; margin-bottom: 10px; }
        .login-header h1 { font-size: 22px; font-weight: 600; margin-bottom: 6px; }
        .login-header p { font-size: 13px; opacity: 0.9; }
        .login-body { padding: 30px 25px; }
        .alert {
            padding: 12px 14px;
            border-radius: 6px;
            margin-bottom: 18px;
            font-size: 14px;
        }
        .alert-error { background: #fce8e6; color: #c5221f; border: 1px solid #f5c6cb; }
        .alert-success { background: #e6f4ea; color: #137333; border: 1px solid #c3e6cb; }
        .alert-warning { background: #fef7e0; color: #b06000; border: 1px solid #ffeaa7; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; color: #3c4043; font-weight: 600; font-size: 14px; }
        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #dadce0;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.2s;
        }
        input:focus { outline: none; border-color: #1a73e8; box-shadow: 0 0 0 3px rgba(26, 115, 232, 0.15); }
        .btn-admin {
            width: 100%;
            padding: 13px;
            background: #1a73e8;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-admin:hover { background: #1557b0; }
        .btn-back {
            display: block;
            width: 100%;
            margin-top: 12px;
            padding: 11px;
            background: #f1f3f4;
            color: #3c4043;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-back:hover { background: #e8eaed; }
        .footer-links {
            text-align: center;
            margin-top: 20px;
            padding-top: 18px;
            border-top: 1px solid #eee;
            font-size: 13px;
        }
        .footer-links a { color: #1a73e8; text-decoration: none; }
        .footer-links a:hover { text-decoration: underline; }
        .secure-note {
            text-align: center;
            font-size: 12px;
            color: #80868b;
            margin-top: 14px;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <div class="icon">🛡️</div>
        <h1>Administrator Login</h1>
        <p>Food Donation System — Admin Panel</p>
    </div>

    <div class="login-body">

        <% if ("success".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-success">You have been logged out successfully.</div>
        <% } %>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Invalid email or password. Please try again.</div>
        <% } else if ("notadmin".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Access denied. This login is for administrators only.</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="alert alert-error"><%= request.getParameter("error") %></div>
        <% } %>

        <form method="post" action="admin-login">
            <div class="form-group">
                <label for="email">Admin Email</label>
                <input type="email" id="email" name="email" required
                       placeholder="admin@fooddonation.com" autocomplete="email">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required
                       placeholder="Enter admin password" autocomplete="current-password">
            </div>

            <button type="submit" class="btn-admin">Sign In to Admin Panel</button>
        </form>

        <a href="index.html" class="btn-back">← Back to Homepage</a>

        <div class="footer-links">
            <p>Not an admin? <a href="login.jsp">User Login</a></p>
        </div>

        <p class="secure-note">🔒 Authorized personnel only</p>
    </div>
</div>

</body>
</html>
