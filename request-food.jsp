<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Please login first");
        return;
    }
    if (!user.isNGO()) {
        response.sendRedirect("dashboard.jsp?error=Access denied. NGO users only.");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request Food - NGO Panel</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: auto; background: #fff; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; color: #34495e; font-weight: bold; }
        input[type="text"], input[type="number"], textarea {
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box;
        }
        textarea { height: 90px; resize: vertical; }
        .btn {
            background: #2980b9; color: #fff; padding: 12px 20px; border: none; border-radius: 5px;
            cursor: pointer; width: 100%; font-size: 16px; font-weight: bold;
        }
        .btn:hover { background: #1f6dad; }
        .error { color: #c0392b; background: #fadbd8; padding: 12px; border-radius: 5px; margin-bottom: 18px; text-align: center; }
        .user-info { background: #ecf0f1; padding: 12px; border-radius: 5px; margin-bottom: 20px; font-size: 14px; }
        .nav-links { text-align: center; margin-top: 22px; }
        .nav-links a { color: #2980b9; text-decoration: none; margin: 0 10px; }
        .help { font-size: 12px; color: #7f8c8d; margin-top: 4px; }
    </style>
</head>
<body>

<div class="container">
    <h2>📝 Food Request Form</h2>

    <div class="user-info">
        Logged in as: <strong><%= user.getFullName() %></strong> (<%= user.getRoleDisplayName() %>)
    </div>

    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <!-- Form submits to NGOServlet -->
    <form action="ngo" method="post">
        <input type="hidden" name="action" value="submitRequest">

        <div class="form-group">
            <label for="foodNeeded">Food Needed *</label>
            <input type="text" id="foodNeeded" name="foodNeeded" required placeholder="e.g. Rice, Milk, Vegetables">
        </div>

        <div class="form-group">
            <label for="quantity">Quantity *</label>
            <input type="number" id="quantity" name="quantity" step="0.01" min="0.01" required placeholder="e.g. 50">
            <p class="help">Enter amount needed (kg, liters, or units)</p>
        </div>

        <div class="form-group">
            <label for="address">Delivery Address *</label>
            <textarea id="address" name="address" required placeholder="Full address for food delivery"><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="contactNumber">Contact Number *</label>
            <input type="text" id="contactNumber" name="contactNumber" required
                   value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="10-digit phone number">
        </div>

        <div class="form-group">
            <label for="ngoName">NGO Name *</label>
            <input type="text" id="ngoName" name="ngoName" required
                   value="<%= user.getFullName() %>" placeholder="Your organization name">
        </div>

        <button type="submit" class="btn">Submit Food Request</button>
    </form>

    <div class="nav-links">
        <a href="ngo?action=dashboard">← NGO Dashboard</a> |
        <a href="ngo?action=history">Request History</a> |
        <a href="logout">Logout</a>
    </div>
</div>

</body>
</html>
