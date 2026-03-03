package com.oceanview.dao;

import com.oceanview.model.Room;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomNumber(rs.getInt("room_number"));
                room.setRoomType(rs.getString("room_type"));
                room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                room.setStatus(rs.getString("status"));
                rooms.add(room);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public Room getRoomById(int roomId) {
        Room room = null;
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, roomId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getInt("room_number"));
                    room.setRoomType(rs.getString("room_type"));
                    room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    room.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return room;
    }

    public List<Room> getAvailableRooms(Date checkIn, Date checkOut) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms r WHERE r.room_id NOT IN (" +
                "SELECT res.room_id FROM reservations res " +
                "WHERE res.status IN ('Pending', 'Confirmed', 'Checked In') " +
                "AND ? < res.check_out_date AND ? > res.check_in_date" +
                ") AND status = 'Available'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setDate(1, checkIn);
            pstmt.setDate(2, checkOut);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getInt("room_number"));
                    room.setRoomType(rs.getString("room_type"));
                    room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    room.setStatus(rs.getString("status"));
                    rooms.add(room);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public List<Room> getRoomsByStatus(String status) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getInt("room_id"));
                    room.setRoomNumber(rs.getInt("room_number"));
                    room.setRoomType(rs.getString("room_type"));
                    room.setPricePerNight(rs.getBigDecimal("price_per_night"));
                    room.setStatus(rs.getString("status"));
                    rooms.add(room);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setInt(2, roomId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type, price_per_night, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setString(2, room.getRoomType());
            pstmt.setBigDecimal(3, room.getPricePerNight());
            pstmt.setString(4, room.getStatus());

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int findAvailableRoomIdByType(String roomType, Date checkIn, Date checkOut) {
        String sql = "SELECT r.room_id FROM rooms r WHERE r.room_type = ? AND r.status = 'Available' AND r.room_id NOT IN ("
                +
                "SELECT res.room_id FROM reservations res " +
                "WHERE res.status IN ('Pending', 'Confirmed', 'Checked In') " +
                "AND ? < res.check_out_date AND ? > res.check_in_date" +
                ") LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, roomType);
            pstmt.setDate(2, checkIn);
            pstmt.setDate(3, checkOut);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("room_id");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_number = ?, room_type = ?, price_per_night = ?, status = ? WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, room.getRoomNumber());
            pstmt.setString(2, room.getRoomType());
            pstmt.setBigDecimal(3, room.getPricePerNight());
            pstmt.setString(4, room.getStatus());
            pstmt.setInt(5, room.getRoomId());

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, roomId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
