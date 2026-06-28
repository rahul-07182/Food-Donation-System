package dao;

import model.FoodRequest;
import database.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * FoodRequest Data Access Object (DAO)
 * Handles database operations for NGO food requests (Phase 6)
 */
public class FoodRequestDAO {

    private static final String INSERT_REQUEST =
        "INSERT INTO food_requests (ngo_id, food_needed, quantity, address, contact_number, ngo_name, request_status) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_NGO =
        "SELECT id, ngo_id, food_needed, quantity, address, contact_number, ngo_name, request_status, " +
        "DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') AS created_at " +
        "FROM food_requests WHERE ngo_id = ? ORDER BY created_at DESC";

    private static final String COUNT_BY_NGO =
        "SELECT COUNT(*) FROM food_requests WHERE ngo_id = ?";

    private static final String COUNT_BY_NGO_AND_STATUS =
        "SELECT COUNT(*) FROM food_requests WHERE ngo_id = ? AND request_status = ?";

    /**
     * Save a new food request
     */
    public boolean saveFoodRequest(FoodRequest request) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(INSERT_REQUEST, Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, request.getNgoId());
            ps.setString(2, request.getFoodNeeded());
            ps.setDouble(3, request.getQuantity());
            ps.setString(4, request.getAddress());
            ps.setString(5, request.getContactNumber());
            ps.setString(6, request.getNgoName());
            ps.setString(7, "pending");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    request.setId(keys.getInt(1));
                }
                return true;
            }
            return false;

        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (ps != null) {
                ps.close();
            }
            DBConnection.closeConnection(connection);
        }
    }

    /**
     * Get all requests submitted by one NGO
     */
    public List<FoodRequest> getRequestsByNgoId(int ngoId) throws SQLException {
        List<FoodRequest> list = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(SELECT_BY_NGO);
            ps.setInt(1, ngoId);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            DBConnection.closeConnection(connection);
        }

        return list;
    }

    /**
     * Count total requests for dashboard stats
     */
    public int countRequestsByNgo(int ngoId) throws SQLException {
        return countByStatus(ngoId, null);
    }

    public int countRequestsByNgoAndStatus(int ngoId, String status) throws SQLException {
        return countByStatus(ngoId, status);
    }

    private int countByStatus(int ngoId, String status) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.getConnection();
            if (status == null) {
                ps = connection.prepareStatement(COUNT_BY_NGO);
                ps.setInt(1, ngoId);
            } else {
                ps = connection.prepareStatement(COUNT_BY_NGO_AND_STATUS);
                ps.setInt(1, ngoId);
                ps.setString(2, status.toLowerCase());
            }
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;

        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            DBConnection.closeConnection(connection);
        }
    }

    private FoodRequest mapRow(ResultSet rs) throws SQLException {
        FoodRequest req = new FoodRequest();
        req.setId(rs.getInt("id"));
        req.setNgoId(rs.getInt("ngo_id"));
        req.setFoodNeeded(rs.getString("food_needed"));
        req.setQuantity(rs.getDouble("quantity"));
        req.setAddress(rs.getString("address"));
        req.setContactNumber(rs.getString("contact_number"));
        req.setNgoName(rs.getString("ngo_name"));
        req.setRequestStatus(rs.getString("request_status"));
        req.setCreatedAt(rs.getString("created_at"));
        return req;
    }
}
