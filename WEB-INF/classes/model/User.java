package model;

/**
 * User Model Class
 * Represents a user in the Online Food Donation System
 * 
 * This class encapsulates user data including personal information
 * and role-based access control for donors, NGOs, and admins.
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - Jakarta Servlet API
 */
public class User {
    
    // Private fields to store user information
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String userType; // donor, ngo, admin
    private String createdAt;
    private String updatedAt;
    
    // Default constructor
    public User() {
    }
    
    // Parameterized constructor for creating new users
    public User(String username, String password, String fullName, String email, 
                String phone, String address, String userType) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.userType = userType;
    }
    
    // Full constructor including database-generated fields
    public User(int id, String username, String password, String fullName, String email,
                String phone, String address, String userType, String createdAt, String updatedAt) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.userType = userType;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getter and Setter methods
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Utility methods
    
    /**
     * Check if user is a donor
     */
    public boolean isDonor() {
        return "donor".equals(userType);
    }
    
    /**
     * Check if user is an NGO
     */
    public boolean isNGO() {
        return "ngo".equals(userType);
    }
    
    /**
     * Check if user is an admin
     */
    public boolean isAdmin() {
        return "admin".equals(userType);
    }
    
    /**
     * Get user-friendly role name
     */
    public String getRoleDisplayName() {
        switch (userType) {
            case "donor":
                return "Food Donor";
            case "ngo":
                return "NGO Representative";
            case "admin":
                return "System Administrator";
            default:
                return "Unknown Role";
        }
    }
    
    /**
     * Validate user data for registration
     */
    public boolean isValidForRegistration() {
        return username != null && !username.trim().isEmpty() &&
               password != null && !password.trim().isEmpty() &&
               fullName != null && !fullName.trim().isEmpty() &&
               email != null && !email.trim().isEmpty() &&
               userType != null && !userType.trim().isEmpty() &&
               (userType.equals("donor") || userType.equals("ngo") || userType.equals("admin"));
    }
    
    /**
     * Return string representation of user
     */
    @Override
    public String toString() {
        return "User{" +
               "id=" + id +
               ", username='" + username + '\'' +
               ", fullName='" + fullName + '\'' +
               ", email='" + email + '\'' +
               ", userType='" + userType + '\'' +
               ", createdAt='" + createdAt + '\'' +
               '}';
    }
}
