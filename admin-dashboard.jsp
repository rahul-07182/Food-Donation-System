<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Donation, java.util.List" %>
<%
    User admin = (User) session.getAttribute("loggedInUser");
    if (admin == null || !admin.isAdmin()) {
        response.sendRedirect("admin-login.jsp?error=Admin access required. Please login.");
        return;
    }
    
    List<User> userList = (List<User>) request.getAttribute("userList");
    List<Donation> donationList = (List<Donation>) request.getAttribute("donationList");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Food Donation System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
        .container { max-width: 1200px; margin: auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 30px; }
        h1 { color: #1a73e8; margin: 0; }
        h2 { color: #3c4043; border-left: 5px solid #1a73e8; padding-left: 10px; margin-top: 40px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; background: white; }
        th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; color: #5f6368; font-weight: 600; }
        tr:hover { background-color: #f1f3f4; }
        .badge { padding: 5px 10px; border-radius: 20px; font-size: 0.85em; font-weight: bold; }
        .badge-donor { background: #e8f0fe; color: #1967d2; }
        .badge-ngo { background: #fef7e0; color: #c5221f; }
        .status-pending { color: #f29900; }
        .status-accepted { color: #1a73e8; }
        .status-completed { color: #188038; }
        .btn { padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 0.9em; cursor: pointer; border: none; }
        .btn-delete { background: #d93025; color: white; }
        .btn-update { background: #1a73e8; color: white; }
        .logout-link { color: #d93025; font-weight: bold; text-decoration: none; }
        .success-msg { background: #e6f4ea; color: #137333; padding: 10px; border-radius: 4px; margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>🛠️ Admin Control Panel</h1>
        <div>
            <span>Welcome, <strong><%= admin.getFullName() %></strong></span> | 
            <a href="logout?from=admin" class="logout-link">Logout</a>
        </div>
    </div>

    <% if (request.getParameter("success") != null) { %>
        <div class="success-msg">✅ Action successful: <%= request.getParameter("success") %></div>
    <% } %>

    <!-- User Management Section -->
    <h2>👥 Registered Users</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Type</th>
                <th>Phone</th>
            </tr>
        </thead>
        <tbody>
            <% for (User u : userList) { %>
                <tr>
                    <td>#<%= u.getId() %></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><span class="badge badge-<%= u.getUserType() %>"><%= u.getUserType().toUpperCase() %></span></td>
                    <td><%= u.getPhone() %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <!-- Donation Management Section -->
    <h2>🎁 All Food Donations</h2>
    <table>
        <thead>
            <tr>
                <th>Item</th>
                <th>Donor</th>
                <th>Quantity</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% for (Donation d : donationList) { %>
                <tr>
                    <td><strong><%= d.getFoodName() %></strong><br><small><%= d.getFoodCategory() %></small></td>
                    <td><%= d.getDonorName() %></td>
                    <td><%= d.getQuantity() %> <%= d.getUnit() %></td>
                    <td class="status-<%= d.getStatus().toLowerCase() %>">
                        <strong><%= d.getStatus() %></strong>
                    </td>
                    <td>
                        <form action="admin" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="id" value="<%= d.getId() %>">
                            <select name="status" onchange="this.form.submit()">
                                <option value="">Update Status</option>
                                <option value="Pending">Pending</option>
                                <option value="Accepted">Accepted</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </form>
                        <a href="admin?action=delete&id=<%= d.getId() %>" 
                           class="btn btn-delete" 
                           onclick="return confirm('Are you sure you want to delete this donation?')">Delete</a>
                    </td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>

</body>
</html>
