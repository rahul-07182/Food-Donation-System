package dao;

import model.Donation;
import database.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Donation Data Access Object (DAO)
 * Handles all database operations for Donation entities
 */
public class DonationDAO {
    
    // SQL Queries
    private static final String INSERT_DONATION = 
        "INSERT INTO donations (donor_id, food_name, food_category, quantity, unit, description, expiry_date, pickup_address, donation_status) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_DONATIONS_BY_DONOR = 
        "SELECT id, donor_id, food_name, food_category, quantity, unit, description, expiry_date, pickup_address, donation_status, created_at " +
        "FROM donations WHERE donor_id = ? ORDER BY created_at DESC";

    private static final String SELECT_ALL_DONATIONS = 
        "SELECT d.id, d.donor_id, d.food_name, d.food_category, d.quantity, d.unit, d.description, d.expiry_date, d.pickup_address, d.donation_status, d.created_at, u.full_name as donor_name " +
        "FROM donations d JOIN users u ON d.donor_id = u.id ORDER BY d.created_at DESC";

    private static final String UPDATE_DONATION_STATUS = 
        "UPDATE donations SET donation_status = ? WHERE id = ?";

    private static final String DELETE_DONATION = 
        "DELETE FROM donations WHERE id = ?";

    private static final String SELECT_AVAILABLE_DONATIONS =
        "SELECT d.id, d.donor_id, d.food_name, d.food_category, d.quantity, d.unit, d.description, " +
        "d.expiry_date, d.pickup_address, d.donation_status, " +
        "DATE_FORMAT(d.created_at, '%Y-%m-%d %H:%i:%s') AS created_at, u.full_name AS donor_name " +
        "FROM donations d JOIN users u ON d.donor_id = u.id " +
        "WHERE d.donation_status = 'available' ORDER BY d.created_at DESC";

    /**
     * Save a new donation to the database
     */
    public boolean saveDonation(Donation donation) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(INSERT_DONATION);
            
            ps.setInt(1, donation.getDonorId());
            ps.setString(2, donation.getFoodName());
            ps.setString(3, donation.getFoodCategory());
            ps.setDouble(4, donation.getQuantity());
            ps.setString(5, donation.getUnit());
            ps.setString(6, donation.getDescription());
            ps.setString(7, donation.getExpiryDate());
            ps.setString(8, donation.getPickupAddress());
            ps.setString(9, "available"); // Default status
            
            return ps.executeUpdate() > 0;
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (ps != null) ps.close();
            DBConnection.closeConnection(connection);
        }
    }

    /**
     * Get donation history for a specific donor
     */
    public List<Donation> getDonationsByDonor(int donorId) throws SQLException {
        List<Donation> donations = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(SELECT_DONATIONS_BY_DONOR);
            ps.setInt(1, donorId);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Donation d = new Donation();
                d.setId(rs.getInt("id"));
                d.setDonorId(rs.getInt("donor_id"));
                d.setFoodName(rs.getString("food_name"));
                d.setFoodCategory(rs.getString("food_category"));
                d.setQuantity(rs.getDouble("quantity"));
                d.setUnit(rs.getString("unit"));
                d.setDescription(rs.getString("description"));
                d.setExpiryDate(rs.getString("expiry_date"));
                d.setPickupAddress(rs.getString("pickup_address"));
                d.setStatus(rs.getString("donation_status"));
                d.setCreatedAt(rs.getString("created_at"));
                donations.add(d);
            }
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            DBConnection.closeConnection(connection);
        }
        return donations;
    }

    /**
     * Get all donations (for Admin)
     */
    public List<Donation> getAllDonations() throws SQLException {
        List<Donation> donations = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(SELECT_ALL_DONATIONS);
            
            rs = ps.executeQuery();
            while (rs.next()) {
                Donation d = new Donation();
                d.setId(rs.getInt("id"));
                d.setDonorId(rs.getInt("donor_id"));
                d.setFoodName(rs.getString("food_name"));
                d.setFoodCategory(rs.getString("food_category"));
                d.setQuantity(rs.getDouble("quantity"));
                d.setUnit(rs.getString("unit"));
                d.setDescription(rs.getString("description"));
                d.setExpiryDate(rs.getString("expiry_date"));
                d.setPickupAddress(rs.getString("pickup_address"));
                d.setStatus(rs.getString("donation_status"));
                d.setCreatedAt(rs.getString("created_at"));
                d.setDonorName(rs.getString("donor_name"));
                donations.add(d);
            }
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            DBConnection.closeConnection(connection);
        }
        return donations;
    }

    /**
     * Update donation status
     */
    public boolean updateDonationStatus(int id, String status) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(UPDATE_DONATION_STATUS);
            ps.setString(1, status);
            ps.setInt(2, id);
            
            return ps.executeUpdate() > 0;
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (ps != null) ps.close();
            DBConnection.closeConnection(connection);
        }
    }

    /**
     * Get donations available for NGOs to view
     */
    public List<Donation> getAvailableDonations() throws SQLException {
        List<Donation> donations = new ArrayList<>();
        Connection connection = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(SELECT_AVAILABLE_DONATIONS);
            rs = ps.executeQuery();

            while (rs.next()) {
                Donation d = new Donation();
                d.setId(rs.getInt("id"));
                d.setDonorId(rs.getInt("donor_id"));
                d.setFoodName(rs.getString("food_name"));
                d.setFoodCategory(rs.getString("food_category"));
                d.setQuantity(rs.getDouble("quantity"));
                d.setUnit(rs.getString("unit"));
                d.setDescription(rs.getString("description"));
                d.setExpiryDate(rs.getString("expiry_date"));
                d.setPickupAddress(rs.getString("pickup_address"));
                d.setStatus(rs.getString("donation_status"));
                d.setCreatedAt(rs.getString("created_at"));
                d.setDonorName(rs.getString("donor_name"));
                donations.add(d);
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
        return donations;
    }

    /**
     * Delete a donation
     */
    public boolean deleteDonation(int id) throws SQLException {
        Connection connection = null;
        PreparedStatement ps = null;
        
        try {
            connection = DBConnection.getConnection();
            ps = connection.prepareStatement(DELETE_DONATION);
            ps.setInt(1, id);
            
            return ps.executeUpdate() > 0;
            
        } catch (ClassNotFoundException e) {
            throw new SQLException("Database driver not found", e);
        } finally {
            if (ps != null) ps.close();
            DBConnection.closeConnection(connection);
        }
    }
}
