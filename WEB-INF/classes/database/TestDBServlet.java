package database;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Test Database Connection Servlet
 * 
 * This servlet tests the MySQL database connection and displays
 * database information to verify the connection is working properly.
 * 
 * Access URL: http://localhost:8080/FoodDonation/testdb
 * 
 * Compatible with:
 * - Java 17
 * - Tomcat 10
 * - Jakarta Servlet API
 */
public class TestDBServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;

    /**
     * Handles HTTP GET requests
     * Tests database connection and displays results
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Database Connection Test</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; margin: 40px; }");
        out.println(".success { color: green; font-weight: bold; }");
        out.println(".error { color: red; font-weight: bold; }");
        out.println(".info { color: blue; }");
        out.println("table { border-collapse: collapse; margin: 20px 0; }");
        out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
        out.println("th { background-color: #f2f2f2; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<h1>🔍 Database Connection Test</h1>");
        
        Connection connection = null;
        try {
            // Test database connection
            out.println("<h2>1. Testing Database Connection...</h2>");
            
            connection = DBConnection.getConnection();
            
            if (connection != null && !connection.isClosed()) {
                out.println("<p class='success'>✅ Database connection successful!</p>");
                out.println("<p class='info'>📍 Database URL: " + DBConnection.getDatabaseUrl() + "</p>");
                out.println("<p class='info'>👤 Username: " + DBConnection.getDatabaseUser() + "</p>");
            } else {
                out.println("<p class='error'>❌ Database connection failed!</p>");
                return;
            }
            
            // Get database metadata
            out.println("<h2>2. Database Information</h2>");
            DatabaseMetaData metaData = connection.getMetaData();
            out.println("<table>");
            out.println("<tr><th>Property</th><th>Value</th></tr>");
            out.println("<tr><td>Database Product Name</td><td>" + metaData.getDatabaseProductName() + "</td></tr>");
            out.println("<tr><td>Database Version</td><td>" + metaData.getDatabaseProductVersion() + "</td></tr>");
            out.println("<tr><td>Driver Name</td><td>" + metaData.getDriverName() + "</td></tr>");
            out.println("<tr><td>Driver Version</td><td>" + metaData.getDriverVersion() + "</td></tr>");
            out.println("<tr><td>URL</td><td>" + metaData.getURL() + "</td></tr>");
            out.println("</table>");
            
            // Test database operations
            out.println("<h2>3. Testing Database Operations</h2>");
            testDatabaseOperations(connection, out);
            
            // Test connection pooling (simple test)
            out.println("<h2>4. Connection Test Summary</h2>");
            if (DBConnection.testConnection()) {
                out.println("<p class='success'>✅ All database tests passed!</p>");
            } else {
                out.println("<p class='error'>❌ Some database tests failed!</p>");
            }
            
        } catch (ClassNotFoundException e) {
            out.println("<p class='error'>❌ MySQL Driver not found: " + e.getMessage() + "</p>");
            out.println("<p class='info'>💡 Make sure mysql-connector-j.jar is in the lib folder</p>");
        } catch (SQLException e) {
            out.println("<p class='error'>❌ SQL Error: " + e.getMessage() + "</p>");
            out.println("<p class='info'>💡 Check if MySQL server is running and database exists</p>");
        } catch (Exception e) {
            out.println("<p class='error'>❌ Unexpected Error: " + e.getMessage() + "</p>");
        } finally {
            DBConnection.closeConnection(connection);
        }
        
        out.println("<h2>5. Next Steps</h2>");
        out.println("<p>If you see ✅ above, your database connection is working!</p>");
        out.println("<p>You can now proceed to implement other servlets and JSP pages.</p>");
        
        out.println("<br><br>");
        out.println("<a href='javascript:history.back()'>← Go Back</a>");
        
        out.println("</body>");
        out.println("</html>");
    }
    
    /**
     * Test basic database operations
     */
    private void testDatabaseOperations(Connection connection, PrintWriter out) {
        try {
            Statement statement = connection.createStatement();
            
            // Test if database exists and is accessible
            out.println("<h3>Database Tables:</h3>");
            ResultSet tables = connection.getMetaData().getTables(null, null, "%", new String[]{"TABLE"});
            
            out.println("<table>");
            out.println("<tr><th>Table Name</th><th>Table Type</th></tr>");
            
            boolean hasTables = false;
            while (tables.next()) {
                hasTables = true;
                String tableName = tables.getString("TABLE_NAME");
                String tableType = tables.getString("TABLE_TYPE");
                out.println("<tr><td>" + tableName + "</td><td>" + tableType + "</td></tr>");
            }
            
            if (!hasTables) {
                out.println("<tr><td colspan='2'>No tables found. Run the SQL setup script first.</td></tr>");
            }
            
            out.println("</table>");
            tables.close();
            
            // Test a simple query
            out.println("<h3>Test Query:</h3>");
            ResultSet rs = statement.executeQuery("SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = 'food_donation_db'");
            if (rs.next()) {
                int tableCount = rs.getInt("count");
                out.println("<p class='info'>📊 Found " + tableCount + " tables in food_donation_db database</p>");
            }
            rs.close();
            statement.close();
            
        } catch (SQLException e) {
            out.println("<p class='error'>❌ Error testing database operations: " + e.getMessage() + "</p>");
        }
    }
}
