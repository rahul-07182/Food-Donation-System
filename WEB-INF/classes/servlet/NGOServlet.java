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
import model.FoodRequest;
import dao.DonationDAO;
import dao.FoodRequestDAO;

/**
 * NGOServlet - Phase 6 NGO Panel + Food Request System
 * Handles NGO dashboard, food requests, and available donations
 */
public class NGOServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private FoodRequestDAO foodRequestDAO;
    private DonationDAO donationDAO;

    @Override
    public void init() throws ServletException {
        foodRequestDAO = new FoodRequestDAO();
        donationDAO = new DonationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isNgoLoggedIn(request.getSession())) {
            response.sendRedirect("login.jsp?error=Access denied. Please login as NGO user.");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        try {
            switch (action) {
                case "requestForm":
                    request.getRequestDispatcher("request-food.jsp").forward(request, response);
                    break;
                case "history":
                    showRequestHistory(request, response);
                    break;
                case "dashboard":
                default:
                    showDashboard(request, response);
                    break;
            }
        } catch (SQLException e) {
            System.err.println("NGO Servlet error: " + e.getMessage());
            response.sendRedirect("ngo-dashboard.jsp?error=Database error. Please try again.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isNgoLoggedIn(request.getSession())) {
            response.sendRedirect("login.jsp?error=Access denied. Please login as NGO user.");
            return;
        }

        String action = request.getParameter("action");
        if ("submitRequest".equals(action)) {
            submitFoodRequest(request, response);
        } else {
            doGet(request, response);
        }
    }

    /**
     * NGO session validation - only logged-in NGO users allowed
     */
    private boolean isNgoLoggedIn(HttpSession session) {
        User user = (User) session.getAttribute("loggedInUser");
        return user != null && user.isNGO();
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        User ngo = (User) request.getSession().getAttribute("loggedInUser");
        int ngoId = ngo.getId();

        List<Donation> availableDonations = donationDAO.getAvailableDonations();
        int totalRequests = foodRequestDAO.countRequestsByNgo(ngoId);
        int pendingCount = foodRequestDAO.countRequestsByNgoAndStatus(ngoId, "pending");
        int acceptedCount = foodRequestDAO.countRequestsByNgoAndStatus(ngoId, "accepted");
        int completedCount = foodRequestDAO.countRequestsByNgoAndStatus(ngoId, "completed");

        request.setAttribute("availableDonations", availableDonations);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("acceptedCount", acceptedCount);
        request.setAttribute("completedCount", completedCount);

        request.getRequestDispatcher("ngo-dashboard.jsp").forward(request, response);
    }

    private void showRequestHistory(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {

        User ngo = (User) request.getSession().getAttribute("loggedInUser");
        List<FoodRequest> requestList = foodRequestDAO.getRequestsByNgoId(ngo.getId());
        request.setAttribute("requestList", requestList);
        request.getRequestDispatcher("request-history.jsp").forward(request, response);
    }

    private void submitFoodRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User ngo = (User) request.getSession().getAttribute("loggedInUser");

        String foodNeeded = request.getParameter("foodNeeded");
        String quantityStr = request.getParameter("quantity");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String ngoName = request.getParameter("ngoName");

        if (foodNeeded == null || foodNeeded.trim().isEmpty()
                || quantityStr == null || quantityStr.trim().isEmpty()
                || address == null || address.trim().isEmpty()
                || contactNumber == null || contactNumber.trim().isEmpty()
                || ngoName == null || ngoName.trim().isEmpty()) {
            response.sendRedirect("request-food.jsp?error=All fields are required.");
            return;
        }

        try {
            double quantity = Double.parseDouble(quantityStr);
            if (quantity <= 0) {
                response.sendRedirect("request-food.jsp?error=Quantity must be greater than zero.");
                return;
            }

            FoodRequest foodRequest = new FoodRequest(
                ngo.getId(),
                foodNeeded.trim(),
                quantity,
                address.trim(),
                contactNumber.trim(),
                ngoName.trim()
            );

            if (foodRequestDAO.saveFoodRequest(foodRequest)) {
                response.sendRedirect("ngo?action=history&success=Food request submitted successfully!");
            } else {
                response.sendRedirect("request-food.jsp?error=Failed to save request. Please try again.");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("request-food.jsp?error=Invalid quantity. Enter a valid number.");
        } catch (SQLException e) {
            System.err.println("Save request error: " + e.getMessage());
            response.sendRedirect("request-food.jsp?error=Database error. Please try again.");
        }
    }

    @Override
    public void destroy() {
        foodRequestDAO = null;
        donationDAO = null;
    }
}
