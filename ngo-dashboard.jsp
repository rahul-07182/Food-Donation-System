<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Donation, java.util.List" %>
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

    if (request.getAttribute("availableDonations") == null) {
        response.sendRedirect("ngo?action=dashboard");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Donation> availableDonations = (List<Donation>) request.getAttribute("availableDonations");
    int totalRequests = (Integer) request.getAttribute("totalRequests");
    int pendingCount = (Integer) request.getAttribute("pendingCount");
    int acceptedCount = (Integer) request.getAttribute("acceptedCount");
    int completedCount = (Integer) request.getAttribute("completedCount");

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Dashboard - Food Donation System</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; }
        .header { background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .header h1 { color: #2c3e50; font-size: 26px; }
        .header p { color: #7f8c8d; margin-top: 5px; }
        .badge { background: #e8f4fd; color: #2980b9; padding: 6px 14px; border-radius: 20px; font-size: 14px; font-weight: bold; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 15px; margin-bottom: 25px; }
        .stat-card { background: #fff; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .stat-card h3 { font-size: 32px; color: #2c3e50; }
        .stat-card p { color: #7f8c8d; margin-top: 5px; }
        .stat-pending h3 { color: #f39c12; }
        .stat-accepted h3 { color: #3498db; }
        .stat-completed h3 { color: #27ae60; }
        .actions { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 25px; }
        .action-btn { background: #fff; padding: 20px; border-radius: 10px; text-decoration: none; color: #2c3e50; text-align: center; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: transform 0.2s; }
        .action-btn:hover { transform: translateY(-3px); background: #2980b9; color: #fff; }
        .card { background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); margin-bottom: 25px; }
        .card h2 { color: #2c3e50; margin-bottom: 15px; font-size: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ecf0f1; }
        th { background: #34495e; color: #fff; }
        tr:hover { background: #f9f9f9; }
        .status-available { color: #27ae60; font-weight: bold; }
        .alert { padding: 12px; border-radius: 6px; margin-bottom: 20px; }
        .alert-error { background: #fadbd8; color: #c0392b; }
        .alert-success { background: #d5f5e3; color: #1e8449; }
        .empty { text-align: center; color: #95a5a6; padding: 30px; }
        .btn-logout { background: #e74c3c; color: #fff; padding: 10px 18px; border-radius: 6px; text-decoration: none; font-size: 14px; }
        .btn-logout:hover { background: #c0392b; }
    </style>
</head>
<body>
<div class="container">

    <div class="header">
        <div>
            <h1>🏢 NGO Dashboard</h1>
            <p>Welcome, <strong><%= user.getFullName() %></strong></p>
        </div>
        <div>
            <span class="badge"><%= user.getRoleDisplayName() %></span>
            <a href="logout" class="btn-logout" style="margin-left:10px;">Logout</a>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="alert alert-error"><%= error %></div>
    <% } %>
    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <div class="stats">
        <div class="stat-card">
            <h3><%= totalRequests %></h3>
            <p>Total Requests</p>
        </div>
        <div class="stat-card stat-pending">
            <h3><%= pendingCount %></h3>
            <p>Pending</p>
        </div>
        <div class="stat-card stat-accepted">
            <h3><%= acceptedCount %></h3>
            <p>Accepted</p>
        </div>
        <div class="stat-card stat-completed">
            <h3><%= completedCount %></h3>
            <p>Completed</p>
        </div>
    </div>

    <div class="actions">
        <a href="ngo?action=requestForm" class="action-btn">📝 Request Food</a>
        <a href="ngo?action=history" class="action-btn">📋 Request History</a>
        <a href="ngo?action=dashboard" class="action-btn">🔍 Refresh Donations</a>
        <a href="dashboard.jsp" class="action-btn">👤 My Profile</a>
    </div>

    <div class="card">
        <h2>🍽️ Available Donations</h2>
        <% if (availableDonations.isEmpty()) { %>
            <p class="empty">No donations available right now. Check again later.</p>
        <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Food</th>
                    <th>Category</th>
                    <th>Quantity</th>
                    <th>Donor</th>
                    <th>Pickup Address</th>
                    <th>Status</th>
                    <th>Posted On</th>
                </tr>
            </thead>
            <tbody>
                <% for (Donation d : availableDonations) { %>
                <tr>
                    <td>#<%= d.getId() %></td>
                    <td><%= d.getFoodName() %></td>
                    <td><%= d.getFoodCategory() %></td>
                    <td><%= d.getQuantity() %> <%= d.getUnit() %></td>
                    <td><%= d.getDonorName() != null ? d.getDonorName() : "—" %></td>
                    <td><%= d.getPickupAddress() %></td>
                    <td class="status-available"><%= d.getStatus() %></td>
                    <td><%= d.getCreatedAt() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

</div>
</body>
</html>
