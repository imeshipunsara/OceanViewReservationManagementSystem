/* =========================================
   Ocean View Resort Reservation System
   Complete Database Script
   ========================================= */

-- Drop and create database
DROP DATABASE IF EXISTS ocean_view_resort;
CREATE DATABASE ocean_view_resort;
USE ocean_view_resort;

-- =========================================
-- USER TABLE (System Staff)
-- =========================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL
);

-- =========================================
-- GUEST TABLE
-- =========================================
CREATE TABLE guests (
    guest_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    contact_number VARCHAR(20),
    email VARCHAR(100) NOT NULL
);

-- =========================================
-- ROOM TABLE
-- =========================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number INT UNIQUE NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    status ENUM('Available', 'Occupied') DEFAULT 'Available'
);

-- =========================================
-- RESERVATION TABLE
-- =========================================
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    user_id INT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status ENUM('Pending', 'Confirmed', 'Cancelled','Checked In','Checked Out') DEFAULT 'Pending',

    CONSTRAINT fk_guest
        FOREIGN KEY (guest_id) REFERENCES guests(guest_id),

    CONSTRAINT fk_room
        FOREIGN KEY (room_id) REFERENCES rooms(room_id),

    CONSTRAINT fk_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- =========================================
-- BILLING TABLE (1 : 1 with Reservation)
-- =========================================
CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE,
    number_of_nights INT NOT NULL,
    room_charge DECIMAL(10,2) NOT NULL,
    extra_charges_total DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) NOT NULL,
    bill_date DATETIME DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(reservation_id)
        ON DELETE CASCADE
);

-- =========================================
-- EXTRA CHARGES TABLE
-- =========================================
CREATE TABLE extra_charges (
    charge_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_bill_charges
        FOREIGN KEY (bill_id)
        REFERENCES billing(bill_id)
        ON DELETE CASCADE
);

-- =========================================
-- PAYMENT TABLE
-- =========================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'Online') NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2) NOT NULL,
    status ENUM('Paid', 'Partial', 'Refunded') DEFAULT 'Paid',

    CONSTRAINT fk_bill_payment
        FOREIGN KEY (bill_id)
        REFERENCES billing(bill_id)
        ON DELETE CASCADE
);

-- =========================================
-- EMAIL NOTIFICATION TABLE
-- =========================================
CREATE TABLE email_notifications (
    email_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    recipient_email VARCHAR(100),
    sent_date DATETIME,
    status VARCHAR(30),

    CONSTRAINT fk_email_reservation
        FOREIGN KEY (reservation_id)
        REFERENCES reservations(reservation_id)
        ON DELETE CASCADE
);

-- =========================================
-- INDEXES (Performance)
-- =========================================
CREATE INDEX idx_reservation_dates
ON reservations (check_in_date, check_out_date);

CREATE INDEX idx_room_type
ON rooms (room_type);

-- =========================================
-- SAMPLE DATA (Optional for Testing)
-- =========================================
INSERT INTO users (username, password, role)
VALUES ('admin', 'admin123', 'Admin');

INSERT INTO rooms (room_type, price_per_night)
VALUES 
('Single', 5000.00),
('Double', 8000.00),
('Suite', 15000.00);

-- =========================================
-- DATABASE LOGIC (Triggers, Procedures, Functions)
-- =========================================

DELIMITER $$

-- -----------------------------------------
-- Function: Calculate Number of Nights
-- -----------------------------------------
CREATE FUNCTION fn_calculate_nights(check_in DATE, check_out DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN DATEDIFF(check_out, check_in);
END$$

-- -----------------------------------------
-- Trigger: Prevent Double Booking
-- -----------------------------------------
CREATE TRIGGER before_reservation_insert
BEFORE INSERT ON reservations
FOR EACH ROW
BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*) INTO conflict_count
    FROM reservations
    WHERE room_id = NEW.room_id
    AND status IN ('Confirmed', 'Pending') -- Check conflicting active reservations
    AND (NEW.check_in_date < check_out_date AND NEW.check_out_date > check_in_date);
    
    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Room is already booked for the selected dates.';
    END IF;
END$$

-- -----------------------------------------
-- Procedure: Create Reservation (Guest)
-- -----------------------------------------
CREATE PROCEDURE sp_create_reservation(
    IN p_guest_id INT,
    IN p_room_id INT,
    IN p_check_in DATE,
    IN p_check_out DATE
)
BEGIN
    INSERT INTO reservations (guest_id, room_id, check_in_date, check_out_date, status)
    VALUES (p_guest_id, p_room_id, p_check_in, p_check_out, 'Pending');
END$$

-- -----------------------------------------
-- Procedure: Confirm Reservation (Staff)
-- -----------------------------------------
CREATE PROCEDURE sp_confirm_reservation(
    IN p_reservation_id INT,
    IN p_staff_id INT
)
BEGIN
    DECLARE v_room_id INT;
    DECLARE v_check_in DATE;
    DECLARE v_check_out DATE;
    DECLARE v_price_per_night DECIMAL(10,2);
    DECLARE v_nights INT;
    DECLARE v_total_amount DECIMAL(10,2);
    
    -- 1. Get reservation details
    SELECT room_id, check_in_date, check_out_date 
    INTO v_room_id, v_check_in, v_check_out
    FROM reservations WHERE reservation_id = p_reservation_id;
    
    -- 2. Get Room Price
    SELECT price_per_night INTO v_price_per_night FROM rooms WHERE room_id = v_room_id;
    
    -- 3. Calculate Bill
    SET v_nights = fn_calculate_nights(v_check_in, v_check_out);
    SET v_total_amount = v_nights * v_price_per_night;
    
    -- 4. Update Reservation Status
    UPDATE reservations 
    SET status = 'Confirmed', user_id = p_staff_id
    WHERE reservation_id = p_reservation_id;
    
    -- 5. Generate Bill
    INSERT INTO billing (reservation_id, number_of_nights, total_amount)
    VALUES (p_reservation_id, v_nights, v_total_amount);
    
    -- 6. Trigger Email (Simulated Log)
    INSERT INTO email_notifications (reservation_id, recipient_email, sent_date, status)
    SELECT p_reservation_id, guests.email, NOW(), 'Sent'
    FROM guests 
    JOIN reservations ON guests.guest_id = reservations.guest_id
    WHERE reservations.reservation_id = p_reservation_id;
    
END$$

DELIMITER ;

