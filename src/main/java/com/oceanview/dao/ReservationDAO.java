package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    public boolean createReservation(Reservation reservation) throws SQLException, ClassNotFoundException {
        // If status is not Pending, we use raw insert to ensure status is correctly
        // set.
        // The SP only supports creating 'Pending' reservations.
        if (reservation.getStatus() != null && !reservation.getStatus().equals("Pending")) {
            return createReservationRaw(reservation);
        }

        String sql = "{CALL sp_create_reservation(?, ?, ?, ?)}";
        try (Connection conn = DBConnection.getConnection();
                CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, reservation.getGuestId());
            stmt.setInt(2, reservation.getRoomId());
            stmt.setDate(3, reservation.getCheckInDate());
            stmt.setDate(4, reservation.getCheckOutDate());

            stmt.execute();
            return true;
        }
    }

    private boolean createReservationRaw(Reservation reservation) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO reservations (guest_id, room_id, check_in_date, check_out_date, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservation.getGuestId());
            pstmt.setInt(2, reservation.getRoomId());
            pstmt.setDate(3, reservation.getCheckInDate());
            pstmt.setDate(4, reservation.getCheckOutDate());
            pstmt.setString(5, reservation.getStatus() != null ? reservation.getStatus() : "Pending");

            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    public boolean updateReservationStatus(int reservationId, String status) {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, reservationId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReservationRoom(int reservationId, int newRoomId) {
        String sql = "UPDATE reservations SET room_id = ? WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, newRoomId);
            pstmt.setInt(2, reservationId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean confirmReservation(int reservationId, int staffId) {
        String sql = "{CALL sp_confirm_reservation(?, ?)}";
        try (Connection conn = DBConnection.getConnection();
                CallableStatement stmt = conn.prepareCall(sql)) {

            stmt.setInt(1, reservationId);
            stmt.setInt(2, staffId);

            stmt.execute();
            return true;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservation> getAllReservations() {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id ORDER BY r.check_in_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Reservation res = new Reservation();
                res.setReservationId(rs.getInt("reservation_id"));
                res.setGuestId(rs.getInt("guest_id"));
                res.setRoomId(rs.getInt("room_id"));
                int userId = rs.getInt("user_id");
                if (!rs.wasNull()) {
                    res.setUserId(userId);
                }
                res.setCheckInDate(rs.getDate("check_in_date"));
                res.setCheckOutDate(rs.getDate("check_out_date"));
                res.setStatus(rs.getString("status"));
                res.setRoomNumber(rs.getInt("room_number"));
                res.setGuestEmail(rs.getString("guest_email"));
                reservations.add(res);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public boolean cancelReservation(int reservationId) {
        String sql = "UPDATE reservations SET status = 'Cancelled' WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Reservation> getReservationsByDate(Date date, String type) {
        List<Reservation> reservations = new ArrayList<>();
        String column = type.equals("check_in") ? "r.check_in_date" : "r.check_out_date";
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id WHERE "
                + column + " = ? AND r.status != 'Cancelled'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, date);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationId(rs.getInt("reservation_id"));
                    res.setGuestId(rs.getInt("guest_id"));
                    res.setRoomId(rs.getInt("room_id"));
                    res.setCheckInDate(rs.getDate("check_in_date"));
                    res.setCheckOutDate(rs.getDate("check_out_date"));
                    res.setStatus(rs.getString("status"));
                    res.setRoomNumber(rs.getInt("room_number"));
                    res.setGuestEmail(rs.getString("guest_email"));
                    reservations.add(res);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getReservationsByStatus(String status) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id WHERE r.status = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationId(rs.getInt("reservation_id"));
                    res.setGuestId(rs.getInt("guest_id"));
                    res.setRoomId(rs.getInt("room_id"));
                    res.setCheckInDate(rs.getDate("check_in_date"));
                    res.setCheckOutDate(rs.getDate("check_out_date"));
                    res.setStatus(rs.getString("status"));
                    res.setRoomNumber(rs.getInt("room_number"));
                    res.setGuestEmail(rs.getString("guest_email"));
                    reservations.add(res);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getExpectedCheckIns(Date date) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id WHERE r.check_in_date = ? AND r.status = 'Confirmed'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, date);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationId(rs.getInt("reservation_id"));
                    res.setGuestId(rs.getInt("guest_id"));
                    res.setRoomId(rs.getInt("room_id"));
                    res.setCheckInDate(rs.getDate("check_in_date"));
                    res.setCheckOutDate(rs.getDate("check_out_date"));
                    res.setStatus(rs.getString("status"));
                    res.setRoomNumber(rs.getInt("room_number"));
                    res.setGuestEmail(rs.getString("guest_email"));
                    reservations.add(res);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getExpectedCheckOuts(Date date) {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id WHERE r.check_out_date = ? AND r.status = 'Checked In'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, date);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation res = new Reservation();
                    res.setReservationId(rs.getInt("reservation_id"));
                    res.setGuestId(rs.getInt("guest_id"));
                    res.setRoomId(rs.getInt("room_id"));
                    res.setCheckInDate(rs.getDate("check_in_date"));
                    res.setCheckOutDate(rs.getDate("check_out_date"));
                    res.setStatus(rs.getString("status"));
                    res.setRoomNumber(rs.getInt("room_number"));
                    res.setGuestEmail(rs.getString("guest_email"));
                    reservations.add(res);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public Reservation getReservationById(int reservationId) {
        Reservation reservation = null;
        String sql = "SELECT r.*, rm.room_number, g.email AS guest_email FROM reservations r JOIN rooms rm ON r.room_id = rm.room_id JOIN guests g ON r.guest_id = g.guest_id WHERE r.reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    reservation = new Reservation();
                    reservation.setReservationId(rs.getInt("reservation_id"));
                    reservation.setGuestId(rs.getInt("guest_id"));
                    reservation.setRoomId(rs.getInt("room_id"));
                    reservation.setCheckInDate(rs.getDate("check_in_date"));
                    reservation.setCheckOutDate(rs.getDate("check_out_date"));
                    reservation.setStatus(rs.getString("status"));
                    reservation.setRoomNumber(rs.getInt("room_number"));
                    reservation.setGuestEmail(rs.getString("guest_email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return reservation;
    }

    public boolean deleteReservation(int reservationId) {
        String sql = "DELETE FROM reservations WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
