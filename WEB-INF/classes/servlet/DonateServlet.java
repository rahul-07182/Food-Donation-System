package servlet;

import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import model.Donation;
import dao.DonationDAO;

/**
 * DonateServlet
 * Handles food donation form submissions
 */
public class DonateServlet extends HttpServlet {
    private DonationDAO donationDAO;

    @Override
    public void init() throws ServletException {
        donationDAO = new DonationDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp?error=Please login to donate food");
            return;
        }

        // Get form parameters
        String foodName = request.getParameter("foodName");
        String foodCategory = request.getParameter("foodCategory");
        String quantityStr = request.getParameter("quantity");
        String unit = request.getParameter("unit");
        String expiryDate = request.getParameter("expiryDate");
        String pickupAddress = request.getParameter("pickupAddress");
        String description = request.getParameter("description");
        String contactNumber = request.getParameter("contactNumber");
        String donorName = request.getParameter("donorName");

        // Simple validation
        if (foodName == null || foodName.isEmpty() || quantityStr == null || quantityStr.isEmpty()) {
            response.sendRedirect("donate.jsp?error=All required fields must be filled");
            return;
        }

        try {
            double quantity = Double.parseDouble(quantityStr);
            
            // Create Donation object
            Donation donation = new Donation(user.getId(), foodName, foodCategory, quantity, 
                                           unit, description, expiryDate, pickupAddress, 
                                           contactNumber, donorName);

            // Save to database
            if (donationDAO.saveDonation(donation)) {
                response.sendRedirect("donation-history.jsp?success=Donation posted successfully!");
            } else {
                response.sendRedirect("donate.jsp?error=Failed to save donation");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("donate.jsp?error=Invalid quantity format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("donate.jsp?error=Database error: " + e.getMessage());
        }
    }
}
