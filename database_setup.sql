-- ========================================
-- Online Food Donation System - Database Setup
-- MySQL Database Creation Script
-- ========================================

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS food_donation_db;

-- Step 2: Use the database
USE food_donation_db;

-- ========================================
-- Step 3: Create Tables
-- ========================================

-- Users Table
-- Stores information about users (donors and recipients)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    user_type ENUM('donor', 'ngo', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Donations Table
-- Stores information about food donations
CREATE TABLE donations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    donor_id INT NOT NULL,
    food_name VARCHAR(100) NOT NULL,
    food_category VARCHAR(50) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit VARCHAR(20) NOT NULL, -- e.g., kg, liters, pieces
    description TEXT,
    expiry_date DATE,
    pickup_address TEXT NOT NULL,
    donation_status ENUM('available', 'claimed', 'distributed') DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Food Requests Table (Phase 6 - NGO Panel)
CREATE TABLE food_requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ngo_id INT NOT NULL,
    food_needed VARCHAR(100) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    address TEXT NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    ngo_name VARCHAR(100) NOT NULL,
    request_status ENUM('pending', 'accepted', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ngo_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- Step 4: Insert Sample Data (Optional for Testing)
-- ========================================

-- Sample Users
INSERT INTO users (username, password, full_name, email, phone, address, user_type) VALUES
('john_donor', 'password123', 'John Smith', 'john@email.com', '1234567890', '123 Main St, City', 'donor'),
('mary_ngo', 'password123', 'Mary Johnson', 'mary@email.com', '0987654321', '456 Oak Ave, City', 'ngo'),
('admin_user', 'admin123', 'System Admin', 'admin@fooddonation.com', '5555555555', '789 Admin Blvd, City', 'admin');

-- Sample Donations
INSERT INTO donations (donor_id, food_name, food_category, quantity, unit, description, expiry_date, pickup_address) VALUES
(1, 'Rice', 'Grains', 10.5, 'kg', 'Premium quality basmati rice', '2024-12-31', '123 Main St, City'),
(1, 'Vegetables', 'Fresh Produce', 5.0, 'kg', 'Mixed fresh vegetables', '2024-11-15', '123 Main St, City');

-- Sample Food Requests (Phase 6)
INSERT INTO food_requests (ngo_id, food_needed, quantity, address, contact_number, ngo_name, request_status) VALUES
(2, 'Rice', 25.00, '456 Oak Ave, City', '0987654321', 'Hope NGO', 'pending'),
(2, 'Vegetables', 10.00, '456 Oak Ave, City', '0987654321', 'Hope NGO', 'accepted');

-- ========================================
-- Step 5: Verification Queries
-- ========================================

-- Check if tables were created successfully
SHOW TABLES;

-- Display table structures
DESCRIBE users;
DESCRIBE donations;
DESCRIBE food_requests;

-- Display sample data
SELECT * FROM users;
SELECT * FROM donations;
SELECT * FROM food_requests;
