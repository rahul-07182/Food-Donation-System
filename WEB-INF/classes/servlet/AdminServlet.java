package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import model.Donation;
import dao.UserDAO;
import dao.DonationDAO;

/**
 * AdminServlet
 * Handles admin-specific operations like viewing all users/donations,
 * updating status, and deleting donations.
 */
public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;
    private DonationDAO donationDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        donationDAO = new DonationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("loggedInUser");

        // Role-based Access Control - admin login only
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect("admin-login.jsp?error=Please login as administrator");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        try {
            switch (action) {
                case "delete":
                    deleteDonation(request, response);
                    break;
                case "updateStatus":
                    updateStatus(request, response);
                    break;
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        List<Donation> donations = donationDAO.getAllDonations();
        
        request.setAttribute("userList", users);
        request.setAttribute("donationList", donations);
        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        donationDAO.updateDonationStatus(id, status);
        response.sendRedirect("admin?action=dashboard&success=Status updated");
    }

    private void deleteDonation(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        donationDAO.deleteDonation(id);
        response.sendRedirect("admin?action=dashboard&success=Donation deleted");
    }
}
