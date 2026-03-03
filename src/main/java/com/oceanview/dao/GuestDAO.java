package com.oceanview.dao;

import com.oceanview.model.Guest;
import com.oceanview.util.DBConnection;
import java.sql.*;

public class GuestDAO {

    public int addGuest(Guest guest) {
        String sql = "INSERT INTO guests (guest_name, address, contact_number, email) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, guest.getGuestName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNumber());
            pstmt.setString(4, guest.getEmail());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public Guest getGuestByContactNumber(String contactNumber) {
        Guest guest = null;
        String sql = "SELECT * FROM guests WHERE contact_number = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, contactNumber);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setGuestName(rs.getString("guest_name"));
                    guest.setAddress(rs.getString("address"));
                    guest.setContactNumber(rs.getString("contact_number"));
                    guest.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return guest;
    }

    public Guest getGuestByEmail(String email) {
        Guest guest = null;
        String sql = "SELECT * FROM guests WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setGuestName(rs.getString("guest_name"));
                    guest.setAddress(rs.getString("address"));
                    guest.setContactNumber(rs.getString("contact_number"));
                    guest.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return guest;
    }

    public java.util.List<Guest> getAllGuests() {
        java.util.List<Guest> guests = new java.util.ArrayList<>();
        String sql = "SELECT * FROM guests";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Guest guest = new Guest();
                guest.setGuestId(rs.getInt("guest_id"));
                guest.setGuestName(rs.getString("guest_name"));
                guest.setAddress(rs.getString("address"));
                guest.setContactNumber(rs.getString("contact_number"));
                guest.setEmail(rs.getString("email"));
                guests.add(guest);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return guests;
    }

    public Guest getGuestById(int guestId) {
        Guest guest = null;
        String sql = "SELECT * FROM guests WHERE guest_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, guestId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    guest = new Guest();
                    guest.setGuestId(rs.getInt("guest_id"));
                    guest.setGuestName(rs.getString("guest_name"));
                    guest.setAddress(rs.getString("address"));
                    guest.setContactNumber(rs.getString("contact_number"));
                    guest.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return guest;
    }

    public boolean updateGuest(Guest guest) {
        String sql = "UPDATE guests SET guest_name = ?, address = ?, contact_number = ?, email = ? WHERE guest_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, guest.getGuestName());
            pstmt.setString(2, guest.getAddress());
            pstmt.setString(3, guest.getContactNumber());
            pstmt.setString(4, guest.getEmail());
            pstmt.setInt(5, guest.getGuestId());

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteGuest(int guestId) {
        String sql = "DELETE FROM guests WHERE guest_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, guestId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
