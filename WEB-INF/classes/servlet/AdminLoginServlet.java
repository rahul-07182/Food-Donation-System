package servlet;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import dao.UserDAO;

/**
 * AdminLoginServlet
 * Separate login handler for administrators only.
 * Normal users (donor/ngo) cannot login through this servlet.
 */
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    /**
     * GET - show admin login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("loggedInUser");
            if (user != null && user.isAdmin()) {
                response.sendRedirect("admin?action=dashboard");
                return;
            }
        }

        request.getRequestDispatcher("admin-login.jsp").forward(request, response);
    }

    /**
     * POST - process admin login
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            response.sendRedirect("admin-login.jsp?error=Email and password are required.");
            return;
        }

        email = email.trim();

        try {
            User user = userDAO.authenticateUser(email, password);

            if (user == null) {
                response.sendRedirect("admin-login.jsp?error=invalid");
                return;
            }

            // Role check - only admin allowed
            if (!user.isAdmin()) {
                System.out.println("Admin login denied for non-admin user: " + email
                        + " (role: " + user.getUserType() + ")");
                response.sendRedirect("admin-login.jsp?error=notadmin");
                return;
            }

            // Create session (same attributes as normal login)
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userEmail", email);
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("loginTime", System.currentTimeMillis());
            session.setAttribute("adminLogin", "true");
            session.setMaxInactiveInterval(30 * 60);

            System.out.println("Admin logged in: " + email);

            // Redirect to admin dashboard via AdminServlet (loads data)
            response.sendRedirect("admin?action=dashboard");

        } catch (SQLException e) {
            System.err.println("Admin login database error: " + e.getMessage());
            response.sendRedirect("admin-login.jsp?error=Database error. Please try again.");
        }
    }

    @Override
    public void destroy() {
        userDAO = null;
    }
}
