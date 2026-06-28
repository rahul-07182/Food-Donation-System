<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Please login to access this page");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Donate Food - Online Food Donation System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 30px; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 5px; color: #34495e; font-weight: bold; }
        input[type="text"], input[type="number"], input[type="date"], select, textarea { 
            width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; 
        }
        textarea { height: 100px; }
        .btn { 
            background-color: #27ae60; color: white; padding: 12px 20px; border: none; border-radius: 4px; 
            cursor: pointer; width: 100%; font-size: 16px; font-weight: bold; transition: background 0.3s;
        }
        .btn:hover { background-color: #219150; }
        .error { color: #e74c3c; background: #fadbd8; padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; }
        .nav-links { text-align: center; margin-top: 20px; }
        .nav-links a { color: #3498db; text-decoration: none; margin: 0 10px; }
        .user-info { background: #ecf0f1; padding: 10px; border-radius: 4px; margin-bottom: 20px; font-size: 0.9em; }
    </style>
</head>
<body>

<div class="container">
    <h2>🍽️ Post Food Donation</h2>
    
    <div class="user-info">
        Logged in as: <strong><%= user.getFullName() %></strong> (<%= user.getRoleDisplayName() %>)
    </div>

    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
        <div class="error"><%= error %></div>
    <% } %>

    <form action="donate" method="post">
        <div class="form-group">
            <label>Food Name *</label>
            <input type="text" name="foodName" required placeholder="e.g. Rice, Fresh Vegetables">
        </div>

        <div class="form-group">
            <label>Category</label>
            <select name="foodCategory">
                <option value="Grains">Grains</option>
                <option value="Fresh Produce">Fresh Produce</option>
                <option value="Cooked Food">Cooked Food</option>
                <option value="Canned Goods">Canned Goods</option>
                <option value="Other">Other</option>
            </select>
        </div>

        <div class="form-group">
            <label>Quantity *</label>
            <div style="display: flex; gap: 10px;">
                <input type="number" name="quantity" step="0.1" required style="flex: 2;">
                <select name="unit" style="flex: 1;">
                    <option value="kg">kg</option>
                    <option value="liters">liters</option>
                    <option value="pieces">pieces</option>
                    <option value="servings">servings</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <label>Expiry Time/Date *</label>
            <input type="date" name="expiryDate" required>
        </div>

        <div class="form-group">
            <label>Pickup Address *</label>
            <textarea name="pickupAddress" required><%= user.getAddress() %></textarea>
        </div>

        <div class="form-group">
            <label>Contact Number *</label>
            <input type="text" name="contactNumber" required value="<%= user.getPhone() %>">
        </div>

        <div class="form-group">
            <label>Donor Name *</label>
            <input type="text" name="donorName" required value="<%= user.getFullName() %>">
        </div>

        <div class="form-group">
            <label>Description (Optional)</label>
            <textarea name="description" placeholder="Any special instructions..."></textarea>
        </div>

        <button type="submit" class="btn">Submit Donation</button>
    </form>

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a> | 
        <a href="donation-history.jsp">View History</a> | 
        <a href="logout">Logout</a>
    </div>
</div>

</body>
</html>
