import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class test_database_connection {
    public static void main(String[] args) {
        try {
            // Test database connection
            String url = "jdbc:mysql://localhost:3306/food_donation_db";
            String user = "root";
            String password = "123654";
            
            System.out.println("Testing database connection...");
            System.out.println("URL: " + url);
            System.out.println("User: " + user);
            
            Connection conn = DriverManager.getConnection(url, user, password);
            
            if (conn != null) {
                System.out.println("✅ Database connection successful!");
                System.out.println("Connected to: " + conn.getCatalog());
                
                // Test if database exists
                var stmt = conn.createStatement();
                var rs = stmt.executeQuery("SHOW DATABASES LIKE 'food_donation_db'");
                
                if (rs.next()) {
                    System.out.println("✅ Database 'food_donation_db' exists!");
                } else {
                    System.out.println("❌ Database 'food_donation_db' does NOT exist!");
                }
                
                // Test if users table exists
                rs = stmt.executeQuery("SHOW TABLES LIKE 'users'");
                if (rs.next()) {
                    System.out.println("✅ Table 'users' exists!");
                    
                    // Count users
                    rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
                    if (rs.next()) {
                        System.out.println("✅ Users table has " + rs.getInt(1) + " records");
                    }
                } else {
                    System.out.println("❌ Table 'users' does NOT exist!");
                }
                
                conn.close();
            } else {
                System.out.println("❌ Failed to connect to database!");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Database connection error:");
            System.out.println("Error Code: " + e.getErrorCode());
            System.out.println("Error Message: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("❌ General error:");
            System.out.println("Error Message: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
