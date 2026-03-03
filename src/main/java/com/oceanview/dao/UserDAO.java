package com.oceanview.dao;

import com.oceanview.model.User;
import com.oceanview.util.DBConnection;
import com.oceanview.util.PasswordUtil;
import java.sql.*;

public class UserDAO {

    public User validateUser(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String inputHash = PasswordUtil.hashPassword(password);

                    if (inputHash.equals(storedPassword)) {
                        // Match found with hash
                        user = mapUser(rs);
                    } else if (password.equals(storedPassword)) {
                        // Match found with plain text (Legacy support)
                        // Lazy migration: Update to hash
                        updateUserPassword(rs.getInt("user_id"), inputHash);
                        user = mapUser(rs);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return user;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setRole(rs.getString("role"));
        // Don't expose password in object if possible, but keeping for now if needed
        // elsewhere
        return user;
    }

    private void updateUserPassword(int userId, String hashedPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hashedPassword);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public boolean saveUser(User user) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, PasswordUtil.hashPassword(user.getPassword()));
            pstmt.setString(3, user.getRole());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapUser(rs));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapUser(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        // Only update password if it's set (non-empty)
        boolean updatePassword = user.getPassword() != null && !user.getPassword().trim().isEmpty();

        String sql;
        if (updatePassword) {
            sql = "UPDATE users SET username = ?, password = ?, role = ? WHERE user_id = ?";
        } else {
            sql = "UPDATE users SET username = ?, role = ? WHERE user_id = ?";
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());

            if (updatePassword) {
                pstmt.setString(2, PasswordUtil.hashPassword(user.getPassword()));
                pstmt.setString(3, user.getRole());
                pstmt.setInt(4, user.getUserId());
            } else {
                pstmt.setString(2, user.getRole());
                pstmt.setInt(3, user.getUserId());
            }

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }
}
