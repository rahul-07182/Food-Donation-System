package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.User;
import dao.UserDAO;

/**
 * User Login Servlet
 * Handles user authentication for the Online Food Donation System
 * 
 * This servlet processes login form submissions, validates credentials,
 * creates sessions, and handles authentication errors.
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - Jakarta Servlet API
 * - MySQL Connector/J
 */
public class LoginServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    /**
     * Initialize servlet and create UserDAO instance
     */
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    /**
     * Handle HTTP GET requests - redirect to login form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            User user = (User) session.getAttribute("loggedInUser");
            if (user.isAdmin()) {
                response.sendRedirect("admin?action=dashboard");
            } else if (user.isNGO()) {
                response.sendRedirect("ngo?action=dashboard");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
    
    /**
     * Handle HTTP POST requests - process login form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Get form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validate input
        String errorMessage = validateLoginInput(email, password);
        
        if (errorMessage != null) {
            // If validation fails, show error message
            showLoginError(out, errorMessage, email);
            return;
        }
        
        try {
            // Authenticate user
            User authenticatedUser = userDAO.authenticateUser(email, password);
            
            if (authenticatedUser != null) {

                // Admins must use the separate admin login page
                if (authenticatedUser.isAdmin()) {
                    showLoginError(out, "Administrator accounts must use the Admin Login page.", email);
                    return;
                }

                HttpSession session = request.getSession(true);

                session.setAttribute("loggedInUser", authenticatedUser);
                session.setAttribute("userEmail", email);
                session.setAttribute("userType", authenticatedUser.getUserType());
                session.setAttribute("userName", authenticatedUser.getFullName());
                session.setAttribute("loginTime", System.currentTimeMillis());

                int timeout = rememberMe != null ? 60 * 60 * 24 * 7 : 30 * 60;
                session.setMaxInactiveInterval(timeout);

                System.out.println("User logged in successfully: " + email
                        + " (" + authenticatedUser.getUserType() + ")");

                if (authenticatedUser.isNGO()) {
                    response.sendRedirect("ngo?action=dashboard");
                } else {
                    response.sendRedirect("dashboard.jsp");
                }

            } else {
                // Authentication failed
                System.out.println("❌ Login failed for email: " + email);
                showLoginError(out, "Invalid email or password. Please try again.", email);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Database error during login: " + e.getMessage());
            showLoginError(out, "Database error occurred. Please try again later.", email);
        } catch (Exception e) {
            System.err.println("❌ Unexpected error during login: " + e.getMessage());
            showLoginError(out, "An unexpected error occurred. Please try again later.", email);
        }
    }
    
    /**
     * Validate login input fields
     * 
     * @return error message if validation fails, null if all valid
     */
    private String validateLoginInput(String email, String password) {
        
        // Check required fields
        if (email == null || email.trim().isEmpty()) {
            return "Email is required.";
        }
        
        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }
        
        // Validate email format
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            return "Please enter a valid email address.";
        }
        
        // Validate password length
        if (password.length() < 1) {
            return "Password cannot be empty.";
        }
        
        return null; // All validations passed
    }
    
    /**
     * Display login error message with form
     */
    private void showLoginError(PrintWriter out, String errorMessage, String email) {
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Login Error - Food Donation System</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }");
        out.println(".container { max-width: 400px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb; }");
        out.println(".form-group { margin-bottom: 15px; }");
        out.println("label { display: block; margin-bottom: 5px; font-weight: bold; }");
        out.println("input[type='email'], input[type='password'] { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }");
        out.println("button { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; width: 100%; }");
        out.println("button:hover { background-color: #0056b3; }");
        out.println(".btn-secondary { background-color: #6c757d; margin-top: 10px; }");
        out.println(".btn-secondary:hover { background-color: #545b62; }");
        out.println(".checkbox { margin-bottom: 15px; }");
        out.println(".links { text-align: center; margin-top: 20px; }");
        out.println(".links a { color: #007bff; text-decoration: none; }");
        out.println(".links a:hover { text-decoration: underline; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<div class='container'>");
        out.println("<h1>🔐 Login Error</h1>");
        
        out.println("<div class='error'>");
        out.println("<strong>Error:</strong> " + errorMessage);
        out.println("</div>");
        
        out.println("<p>Please correct the error(s) below and try again:</p>");
        
        out.println("<form method='post' action='login'>");
        
        // Email
        out.println("<div class='form-group'>");
        out.println("<label for='email'>Email:</label>");
        out.println("<input type='email' id='email' name='email' value='" + (email != null ? email : "") + "' required>");
        out.println("</div>");
        
        // Password
        out.println("<div class='form-group'>");
        out.println("<label for='password'>Password:</label>");
        out.println("<input type='password' id='password' name='password' required>");
        out.println("</div>");
        
        // Remember Me
        out.println("<div class='checkbox'>");
        out.println("<label>");
        out.println("<input type='checkbox' name='rememberMe'> Remember me for 7 days");
        out.println("</label>");
        out.println("</div>");
        
        out.println("<button type='submit'>Login</button>");
        out.println("<button type='button' class='btn-secondary' onclick='history.back()'>Cancel</button>");
        
        out.println("</form>");
        
        out.println("<div class='links'>");
        out.println("<p><a href='register.jsp'>Don't have an account? Register here</a></p>");
        out.println("<p><a href='index.html'>← Back to Home</a></p>");
        out.println("</div>");
        
        out.println("</div>");
        
        out.println("</body>");
        out.println("</html>");
    }
    
    /**
     * Clean up resources
     */
    @Override
    public void destroy() {
        super.destroy();
        userDAO = null;
    }
}
