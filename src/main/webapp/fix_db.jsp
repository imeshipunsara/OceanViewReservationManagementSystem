<%@ page import="java.sql.*" %>
    <%@ page import="com.oceanview.util.DBConnection" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Fix Database</title>
        </head>

        <body>
            <h2>Applying Database Patches...</h2>
            <pre>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {

        // 1. Add room_charge column
        try {
            stmt.executeUpdate("ALTER TABLE billing ADD COLUMN room_charge DECIMAL(10,2) NOT NULL DEFAULT 0.00 AFTER number_of_nights");
            out.println("SUCCESS: Added 'room_charge' column.");
        } catch (SQLException e) {
            out.println("INFO: 'room_charge' column might already exist or error: " + e.getMessage());
        }

        // 2. Add extra_charges_total column
        try {
            stmt.executeUpdate("ALTER TABLE billing ADD COLUMN extra_charges_total DECIMAL(10,2) DEFAULT 0.00 AFTER room_charge");
            out.println("SUCCESS: Added 'extra_charges_total' column.");
        } catch (SQLException e) {
            out.println("INFO: 'extra_charges_total' column might already exist or error: " + e.getMessage());
        }

        // 3. Drop outdated procedure
        try {
            stmt.executeUpdate("DROP PROCEDURE IF EXISTS sp_confirm_reservation");
             out.println("SUCCESS: Dropped 'sp_confirm_reservation'.");
        } catch (SQLException e) {
             out.println("ERROR: Could not drop 'sp_confirm_reservation': " + e.getMessage());
        }

         // 4. Recreate procedure (Updated to include new columns)
        String sp = "CREATE PROCEDURE sp_confirm_reservation(" +
                    "    IN p_reservation_id INT," +
                    "    IN p_staff_id INT" +
                    ")" +
                    "BEGIN" +
                    "    DECLARE v_room_id INT;" +
                    "    DECLARE v_check_in DATE;" +
                    "    DECLARE v_check_out DATE;" +
                    "    DECLARE v_price_per_night DECIMAL(10,2);" +
                    "    DECLARE v_nights INT;" +
                    "    DECLARE v_total_amount DECIMAL(10,2);" +
                    "    DECLARE v_room_charge DECIMAL(10,2);" +
                    "" +
                    "    SELECT room_id, check_in_date, check_out_date " +
                    "    INTO v_room_id, v_check_in, v_check_out" +
                    "    FROM reservations WHERE reservation_id = p_reservation_id;" +
                    "" +
                    "    SELECT price_per_night INTO v_price_per_night FROM rooms WHERE room_id = v_room_id;" +
                    "" +
                    "    SET v_nights = DATEDIFF(v_check_out, v_check_in);" +
                    "    SET v_room_charge = v_nights * v_price_per_night;" +
                    "    SET v_total_amount = v_room_charge;" + 
                    "" +
                    "    UPDATE reservations " +
                    "    SET status = 'Confirmed', user_id = p_staff_id" +
                    "    WHERE reservation_id = p_reservation_id;" +
                    "" +
                    "    INSERT INTO billing (reservation_id, number_of_nights, room_charge, extra_charges_total, total_amount)" +
                    "    VALUES (p_reservation_id, v_nights, v_room_charge, 0.00, v_total_amount);" +
                    "" +
                    "    INSERT INTO email_notifications (reservation_id, recipient_email, sent_date, status)" +
                    "    SELECT p_reservation_id, guests.email, NOW(), 'Sent'" +
                    "    FROM guests " +
                    "    JOIN reservations ON guests.guest_id = reservations.guest_id" +
                    "    WHERE reservations.reservation_id = p_reservation_id;" +
                    "END";

        try {
            stmt.executeUpdate(sp);
            out.println("SUCCESS: Recreated 'sp_confirm_reservation' with correct columns.");
        } catch (SQLException e) {
            out.println("ERROR: Could not recreate 'sp_confirm_reservation': " + e.getMessage());
        }

    } catch (Exception e) {
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
    </pre>
            <br>
            <a href="dashboard.jsp">Go Back to Dashboard</a>
        </body>

        </html>