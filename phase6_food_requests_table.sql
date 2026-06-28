-- ========================================
-- Phase 6: NGO Food Request Table
-- Run this in MySQL (food_donation_db)
-- ========================================

USE food_donation_db;

-- Remove old Phase 1 table structure if it exists
DROP TABLE IF EXISTS food_requests;

-- Create Phase 6 food_requests table
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

-- Sample request for testing (ngo user id = 2, adjust if needed)
-- INSERT INTO food_requests (ngo_id, food_needed, quantity, address, contact_number, ngo_name)
-- VALUES (2, 'Rice', 25.00, '456 Oak Ave, City', '0987654321', 'Hope NGO');

SELECT 'food_requests table created successfully!' AS message;
DESCRIBE food_requests;
