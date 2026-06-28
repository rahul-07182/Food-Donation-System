<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.FoodRequest, java.util.List" %>
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

    if (request.getAttribute("requestList") == null) {
        response.sendRedirect("ngo?action=history");
        return;
    }

    @SuppressWarnings("unchecked")
    List<FoodRequest> requestList = (List<FoodRequest>) request.getAttribute("requestList");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request History - NGO Panel</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f4f8; margin: 0; padding: 20px; }
        .container { max-width: 1100px; margin: 0 auto; }
        .header { background: #fff; padding: 25px; border-radius: 10px; margin-bottom: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .header h1 { color: #2c3e50; }
        .card { background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ecf0f1; }
        th { background: #34495e; color: #fff; }
        tr:hover { background: #f9f9f9; }
        .status-pending { color: #f39c12; font-weight: bold; }
        .status-accepted { color: #3498db; font-weight: bold; }
        .status-completed { color: #27ae60; font-weight: bold; }
        .alert-success { background: #d5f5e3; color: #1e8449; padding: 12px; border-radius: 6px; margin-bottom: 20px; }
        .alert-error { background: #fadbd8; color: #c0392b; padding: 12px; border-radius: 6px; margin-bottom: 20px; }
        .empty { text-align: center; color: #95a5a6; padding: 40px; }
        .nav-links { margin-top: 20px; text-align: center; }
        .nav-links a { color: #2980b9; text-decoration: none; margin: 0 12px; }
        .btn-new { display: inline-block; background: #2980b9; color: #fff; padding: 10px 18px; border-radius: 5px; text-decoration: none; margin-top: 10px; }
        .btn-new:hover { background: #1f6dad; }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>📋 Food Request History</h1>
        <p>Track status of your requests: <strong>Pending</strong>, <strong>Accepted</strong>, <strong>Completed</strong></p>
        <a href="ngo?action=requestForm" class="btn-new">+ New Request</a>
    </div>

    <% if (success != null) { %>
        <div class="alert-success"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert-error"><%= error %></div>
    <% } %>

    <div class="card">
        <% if (requestList.isEmpty()) { %>
            <p class="empty">No food requests yet. <a href="ngo?action=requestForm">Submit your first request</a></p>
        <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Food Needed</th>
                    <th>Quantity</th>
                    <th>NGO Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>Status</th>
                    <th>Requested On</th>
                </tr>
            </thead>
            <tbody>
                <% for (FoodRequest req : requestList) {
                    String status = req.getRequestStatus() != null ? req.getRequestStatus().toLowerCase() : "pending";
                    String statusClass = "status-pending";
                    if ("accepted".equals(status)) statusClass = "status-accepted";
                    if ("completed".equals(status)) statusClass = "status-completed";
                %>
                <tr>
                    <td>#<%= req.getId() %></td>
                    <td><%= req.getFoodNeeded() %></td>
                    <td><%= req.getQuantity() %></td>
                    <td><%= req.getNgoName() %></td>
                    <td><%= req.getAddress() %></td>
                    <td><%= req.getContactNumber() %></td>
                    <td class="<%= statusClass %>"><%= req.getStatusDisplay() %></td>
                    <td><%= req.getCreatedAt() %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <div class="nav-links">
        <a href="ngo?action=dashboard">← NGO Dashboard</a>
        <a href="ngo?action=requestForm">Request Food</a>
        <a href="logout">Logout</a>
    </div>
</div>

</body>
</html>
