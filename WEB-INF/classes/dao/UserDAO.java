package dao;

import model.User;
import database.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * User Data Access Object (DAO)
 * Handles all database operations for User entities
 * 
 * This class provides methods to create, read, update, and delete users
 * from the food_donation_db database using JDBC.
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - MySQL Connector/J
 * - Jakarta Servlet API
 */
public class UserDAO {
    
    // SQL Queries
    private static final String INSERT_USER = 
        "INSERT INTO users (username, password, full_name, email, phone, address, user_type) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_USER_BY_ID = 
        "SELECT id, username, password, full_name, email, phone, address, user_type, " +
        "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, " +
        "DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at " +
        "FROM users WHERE id = ?";
    
    private static final String SELECT_USER_BY_USERNAME = 
        "SELECT id, username, password, full_name, email, phone, address, user_type, " +
        "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, " +
        "DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at " +
        "FROM users WHERE username = ?";
    
    private static final String SELECT_USER_BY_EMAIL = 
        "SELECT id, username, password, full_name, email, phone, address, user_type, " +
        "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, " +
        "DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at " +
        "FROM users WHERE email = ?";
    
    private static final String SELECT_ALL_USERS = 
        "SELECT id, username, password, full_name, email, phone, address, user_type, " +
        "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, " +
        "DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at " +
        "FROM users ORDER BY created_at DESC";
    
    private static final String UPDATE_USER = 
        "UPDATE users SET full_name = ?, email = ?, phone = ?, address = ?, " +
        "user_type = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
    
    private static final String DELETE_USER = "DELETE FROM users WHERE id = ?";
    
    private static final String CHECK_USERNAME_EXISTS = 
        "SELECT COUNT(*) FROM users WHERE username = ?";
    
    private static final String CHECK_EMAIL_EXISTS = 
        "SELECT COUNT(*) FROM users WHERE email = ?";
    
    /**
     * Register a new user in the database
     * 
     * @param user User object containing registration data
     * @return true if registration successful, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean registerUser(User user) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);
            
            // Set parameters for the prepared statement
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getPassword());
            preparedStatement.setString(3, user.getFullName());
            preparedStatement.setString(4, user.getEmail());
            preparedStatement.setString(5, user.getPhone());
            preparedStatement.setString(6, user.getAddress());
            preparedStatement.setString(7, user.getUserType());
            
            // Execute the insert operation
            int rowsAffected = preparedStatement.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated ID and set it in the user object
                ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                if (generatedKeys.next()) {
                    user.setId(generatedKeys.getInt(1));
                }
                return true;
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return false;
    }
    
    /**
     * Check if username already exists
     * 
     * @param username Username to check
     * @return true if username exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean usernameExists(String username) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(CHECK_USERNAME_EXISTS);
            preparedStatement.setString(1, username);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return false;
    }
    
    /**
     * Check if email already exists
     * 
     * @param email Email to check
     * @return true if email exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean emailExists(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(CHECK_EMAIL_EXISTS);
            preparedStatement.setString(1, email);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return false;
    }
    
    /**
     * Get user by username
     * 
     * @param username Username to search
     * @return User object if found, null otherwise
     * @throws SQLException if database error occurs
     */
    public User getUserByUsername(String username) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME);
            preparedStatement.setString(1, username);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return extractUserFromResultSet(resultSet);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return null;
    }
    
    /**
     * Get user by ID
     * 
     * @param userId User ID to search
     * @return User object if found, null otherwise
     * @throws SQLException if database error occurs
     */
    public User getUserById(int userId) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_USER_BY_ID);
            preparedStatement.setInt(1, userId);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return extractUserFromResultSet(resultSet);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return null;
    }
    
    /**
     * Get all users
     * 
     * @return List of all users
     * @throws SQLException if database error occurs
     */
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_ALL_USERS);
            
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                users.add(extractUserFromResultSet(resultSet));
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return users;
    }
    
    /**
     * Authenticate user with email and password
     * 
     * @param email User's email address
     * @param password User's password
     * @return User object if authentication successful, null otherwise
     * @throws SQLException if database error occurs
     */
    public User authenticateUser(String email, String password) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            
            // SQL query to authenticate user
            String authenticateQuery = 
                "SELECT id, username, password, full_name, email, phone, address, user_type, " +
                "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') as created_at, " +
                "DATE_FORMAT(updated_at, '%Y-%m-%d %H:%i:%s') as updated_at " +
                "FROM users WHERE email = ? AND password = ?";
            
            preparedStatement = connection.prepareStatement(authenticateQuery);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return extractUserFromResultSet(resultSet);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return null; // Authentication failed
    }
    
    /**
     * Get user by email (for login purposes)
     * 
     * @param email Email to search
     * @return User object if found, null otherwise
     * @throws SQLException if database error occurs
     */
    public User getUserByEmail(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(SELECT_USER_BY_EMAIL);
            preparedStatement.setString(1, email);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return extractUserFromResultSet(resultSet);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return null;
    }
    
    /**
     * Check if user exists by email
     * 
     * @param email Email to check
     * @return true if user exists, false otherwise
     * @throws SQLException if database error occurs
     */
    public boolean userExistsByEmail(String email) throws SQLException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        
        try {
            connection = DBConnection.getConnection();
            preparedStatement = connection.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE email = ?");
            preparedStatement.setString(1, email);
            
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            throw new SQLException("Database driver not found", e);
        } finally {
            // Close resources
            if (resultSet != null) {
                try {
                    resultSet.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing ResultSet: " + e.getMessage());
                }
            }
            if (preparedStatement != null) {
                try {
                    preparedStatement.close();
                } catch (SQLException e) {
                    System.err.println("❌ Error closing PreparedStatement: " + e.getMessage());
                }
            }
            DBConnection.closeConnection(connection);
        }
        
        return false;
    }
    
    /**
     * Helper method to extract User object from ResultSet
     * 
     * @param resultSet ResultSet containing user data
     * @return User object
     * @throws SQLException if database error occurs
     */
    private User extractUserFromResultSet(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getInt("id"));
        user.setUsername(resultSet.getString("username"));
        user.setPassword(resultSet.getString("password"));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        user.setAddress(resultSet.getString("address"));
        user.setUserType(resultSet.getString("user_type"));
        user.setCreatedAt(resultSet.getString("created_at"));
        user.setUpdatedAt(resultSet.getString("updated_at"));
        
        return user;
    }
}
