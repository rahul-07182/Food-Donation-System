package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.User;
import dao.UserDAO;

/**
 * User Registration Servlet
 * Handles user registration for the Online Food Donation System
 * 
 * This servlet processes registration form submissions, validates input,
 * checks for duplicate usernames/emails, and saves user data to database.
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - Jakarta Servlet API
 * - MySQL Connector/J
 */
public class RegisterServlet extends HttpServlet {
    
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
     * Handle HTTP GET requests - redirect to registration form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect to registration form
        response.sendRedirect("register.jsp");
    }
    
    /**
     * Handle HTTP POST requests - process registration form
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set response content type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String userType = request.getParameter("userType");
        
        // Validate input
        String errorMessage = validateRegistrationInput(username, password, confirmPassword, 
                                                       fullName, email, phone, address, userType);
        
        if (errorMessage != null) {
            // If validation fails, show error message
            showRegistrationError(out, errorMessage, username, fullName, email, phone, address, userType);
            return;
        }
        
        try {
            // Check if username already exists
            if (userDAO.usernameExists(username)) {
                showRegistrationError(out, "Username '" + username + "' already exists. Please choose a different username.", 
                                     username, fullName, email, phone, address, userType);
                return;
            }
            
            // Check if email already exists
            if (userDAO.emailExists(email)) {
                showRegistrationError(out, "Email '" + email + "' is already registered. Please use a different email.", 
                                     username, fullName, email, phone, address, userType);
                return;
            }
            
            // Create new user object
            User newUser = new User(username, password, fullName, email, phone, address, userType);
            
            // Register user in database
            boolean registrationSuccess = userDAO.registerUser(newUser);
            
            if (registrationSuccess) {
                // Registration successful - redirect to success page
                request.getSession().setAttribute("registeredUser", newUser);
                response.sendRedirect("register-success.jsp");
            } else {
                // Registration failed
                showRegistrationError(out, "Registration failed. Please try again later.", 
                                     username, fullName, email, phone, address, userType);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Database error during registration: " + e.getMessage());
            showRegistrationError(out, "Database error occurred. Please try again later.", 
                                 username, fullName, email, phone, address, userType);
        } catch (Exception e) {
            System.err.println("❌ Unexpected error during registration: " + e.getMessage());
            showRegistrationError(out, "An unexpected error occurred. Please try again later.", 
                                 username, fullName, email, phone, address, userType);
        }
    }
    
    /**
     * Validate registration input fields
     * 
     * @return error message if validation fails, null if all valid
     */
    private String validateRegistrationInput(String username, String password, String confirmPassword,
                                          String fullName, String email, String phone, String address, String userType) {
        
        // Check required fields
        if (username == null || username.trim().isEmpty()) {
            return "Username is required.";
        }
        
        if (password == null || password.trim().isEmpty()) {
            return "Password is required.";
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return "Please confirm your password.";
        }
        
        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }
        
        if (email == null || email.trim().isEmpty()) {
            return "Email is required.";
        }
        
        if (userType == null || userType.trim().isEmpty()) {
            return "User type is required.";
        }
        
        // Validate username length and format
        if (username.length() < 3 || username.length() > 20) {
            return "Username must be between 3 and 20 characters.";
        }
        
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            return "Username can only contain letters, numbers, and underscores.";
        }
        
        // Validate password
        if (password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }
        
        if (!password.equals(confirmPassword)) {
            return "Passwords do not match.";
        }
        
        // Validate full name
        if (fullName.length() < 2 || fullName.length() > 100) {
            return "Full name must be between 2 and 100 characters.";
        }
        
        // Validate email format
        if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,}$")) {
            return "Please enter a valid email address.";
        }
        
        // Validate phone (optional but if provided, should be valid)
        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.matches("^[\\d\\-\\+\\(\\)\\s]+$")) {
                return "Please enter a valid phone number.";
            }
            if (phone.length() < 10 || phone.length() > 20) {
                return "Phone number must be between 10 and 20 characters.";
            }
        }
        
        // Validate address (optional but if provided, should be reasonable)
        if (address != null && !address.trim().isEmpty()) {
            if (address.length() < 10 || address.length() > 500) {
                return "Address must be between 10 and 500 characters.";
            }
        }
        
        // Validate user type
        if (!userType.equals("donor") && !userType.equals("ngo") && !userType.equals("admin")) {
            return "Invalid user type selected.";
        }
        
        return null; // All validations passed
    }
    
    /**
     * Display registration error message with form
     */
    private void showRegistrationError(PrintWriter out, String errorMessage, 
                                     String username, String fullName, String email, 
                                     String phone, String address, String userType) {
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Registration Error - Food Donation System</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }");
        out.println(".container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px; border: 1px solid #f5c6cb; }");
        out.println(".form-group { margin-bottom: 15px; }");
        out.println("label { display: block; margin-bottom: 5px; font-weight: bold; }");
        out.println("input[type='text'], input[type='password'], input[type='email'], select, textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }");
        out.println("button { background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; }");
        out.println("button:hover { background-color: #0056b3; }");
        out.println(".btn-secondary { background-color: #6c757d; }");
        out.println(".btn-secondary:hover { background-color: #545b62; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<div class='container'>");
        out.println("<h1>🚫 Registration Error</h1>");
        
        out.println("<div class='error'>");
        out.println("<strong>Error:</strong> " + errorMessage);
        out.println("</div>");
        
        out.println("<p>Please correct the error(s) below and try again:</p>");
        
        out.println("<form method='post' action='register'>");
        
        // Username
        out.println("<div class='form-group'>");
        out.println("<label for='username'>Username:</label>");
        out.println("<input type='text' id='username' name='username' value='" + (username != null ? username : "") + "' required>");
        out.println("</div>");
        
        // Password
        out.println("<div class='form-group'>");
        out.println("<label for='password'>Password:</label>");
        out.println("<input type='password' id='password' name='password' required>");
        out.println("</div>");
        
        // Confirm Password
        out.println("<div class='form-group'>");
        out.println("<label for='confirmPassword'>Confirm Password:</label>");
        out.println("<input type='password' id='confirmPassword' name='confirmPassword' required>");
        out.println("</div>");
        
        // Full Name
        out.println("<div class='form-group'>");
        out.println("<label for='fullName'>Full Name:</label>");
        out.println("<input type='text' id='fullName' name='fullName' value='" + (fullName != null ? fullName : "") + "' required>");
        out.println("</div>");
        
        // Email
        out.println("<div class='form-group'>");
        out.println("<label for='email'>Email:</label>");
        out.println("<input type='email' id='email' name='email' value='" + (email != null ? email : "") + "' required>");
        out.println("</div>");
        
        // Phone
        out.println("<div class='form-group'>");
        out.println("<label for='phone'>Phone:</label>");
        out.println("<input type='text' id='phone' name='phone' value='" + (phone != null ? phone : "") + "'>");
        out.println("</div>");
        
        // Address
        out.println("<div class='form-group'>");
        out.println("<label for='address'>Address:</label>");
        out.println("<textarea id='address' name='address' rows='3'>" + (address != null ? address : "") + "</textarea>");
        out.println("</div>");
        
        // User Type
        out.println("<div class='form-group'>");
        out.println("<label for='userType'>User Type:</label>");
        out.println("<select id='userType' name='userType' required>");
        out.println("<option value=''>Select User Type</option>");
        out.println("<option value='donor' " + ("donor".equals(userType) ? "selected" : "") + ">Food Donor</option>");
        out.println("<option value='ngo' " + ("ngo".equals(userType) ? "selected" : "") + ">NGO Representative</option>");
        out.println("<option value='admin' " + ("admin".equals(userType) ? "selected" : "") + ">System Administrator</option>");
        out.println("</select>");
        out.println("</div>");
        
        out.println("<button type='submit'>Register</button>");
        out.println("<button type='button' class='btn-secondary' onclick='history.back()'>Cancel</button>");
        
        out.println("</form>");
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
