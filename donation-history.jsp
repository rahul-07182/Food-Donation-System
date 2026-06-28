<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Donation, dao.DonationDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Please login to view history");
        return;
    }
    
    DonationDAO donationDAO = new DonationDAO();
    List<Donation> donations = donationDAO.getDonationsByDonor(user.getId());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Donation History - Online Food Donation System</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; }
        .container { max-width: 900px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; text-align: center; }
        .success { color: #27ae60; background: #d4efdf; padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f8f9fa; color: #34495e; }
        .status { padding: 4px 8px; border-radius: 12px; font-size: 0.85em; font-weight: bold; text-transform: uppercase; }
        .status-available { background: #d4efdf; color: #27ae60; }
        .status-claimed { background: #fcf3cf; color: #f1c40f; }
        .status-distributed { background: #d6eaf8; color: #3498db; }
        .nav-links { text-align: center; margin-top: 30px; }
        .nav-links a { color: #3498db; text-decoration: none; margin: 0 10px; }
        .empty-msg { text-align: center; padding: 40px; color: #7f8c8d; }
    </style>
</head>
<body>

<div class="container">
    <h2>📋 Your Donation History</h2>

    <% String success = request.getParameter("success"); %>
    <% if (success != null) { %>
        <div class="success"><%= success %></div>
    <% } %>

    <% if (donations.isEmpty()) { %>
        <div class="empty-msg">
            <p>You haven't posted any donations yet.</p>
            <a href="donate.jsp" style="color: #27ae60; font-weight: bold;">Post your first donation now!</a>
        </div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Food Item</th>
                    <th>Category</th>
                    <th>Quantity</th>
                    <th>Expiry</th>
                    <th>Status</th>
                    <th>Date Posted</th>
                </tr>
            </thead>
            <tbody>
                <% for (Donation d : donations) { %>
                    <tr>
                        <td><strong><%= d.getFoodName() %></strong></td>
                        <td><%= d.getFoodCategory() %></td>
                        <td><%= d.getQuantity() %> <%= d.getUnit() %></td>
                        <td><%= d.getExpiryDate() %></td>
                        <td>
                            <span class="status status-<%= d.getStatus().toLowerCase() %>">
                                <%= d.getStatus() %>
                            </span>
                        </td>
                        <td><%= d.getCreatedAt().substring(0, 10) %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a> | 
        <a href="donate.jsp">Donate More</a> | 
        <a href="logout">Logout</a>
    </div>
</div>

</body>
</html>
