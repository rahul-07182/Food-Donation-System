package database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Connection Utility Class
 * Handles MySQL database connection for the Online Food Donation System
 * 
 * This class provides a simple way to get database connections
 * and handles connection cleanup properly.
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - MySQL Connector/J 8.x
 * - Jakarta Servlet API
 */
public class DBConnection {
    
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/food_donation_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123654";
    
    // MySQL JDBC Driver class name
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    /**
     * Get a database connection
     * 
     * @return Connection object to the MySQL database
     * @throws SQLException if connection fails
     * @throws ClassNotFoundException if MySQL driver is not found
     */
    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load the MySQL JDBC driver
        Class.forName(JDBC_DRIVER);
        
        // Establish and return the connection
        Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        
        System.out.println("✅ Database connection established successfully!");
        return connection;
    }
    
    /**
     * Close a database connection safely
     * 
     * @param connection The connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("✅ Database connection closed successfully!");
            } catch (SQLException e) {
                System.err.println("❌ Error closing database connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Test database connection
     * This method can be used to verify that the database is accessible
     * 
     * @return true if connection is successful, false otherwise
     */
    public static boolean testConnection() {
        Connection connection = null;
        try {
            connection = getConnection();
            return connection != null && !connection.isClosed();
        } catch (Exception e) {
            System.err.println("❌ Database connection test failed: " + e.getMessage());
            return false;
        } finally {
            closeConnection(connection);
        }
    }
    
    /**
     * Get database URL (for debugging purposes)
     */
    public static String getDatabaseUrl() {
        return DB_URL;
    }
    
    /**
     * Get database username (for debugging purposes)
     */
    public static String getDatabaseUser() {
        return DB_USER;
    }
}
