package com.oceanview.dao;

import com.oceanview.model.Payment;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean createPayment(Payment payment) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO payments (bill_id, payment_method, amount_paid, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, payment.getBillId());
            pstmt.setString(2, payment.getPaymentMethod());
            pstmt.setBigDecimal(3, payment.getAmountPaid());
            pstmt.setString(4, payment.getStatus());

            int rows = pstmt.executeUpdate();
            return rows > 0;
        }
    }

    public List<Payment> getPaymentsByBillId(int billId) {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setBillId(rs.getInt("bill_id"));
                    p.setPaymentMethod(rs.getString("payment_method"));
                    p.setPaymentDate(rs.getTimestamp("payment_date"));
                    p.setAmountPaid(rs.getBigDecimal("amount_paid"));
                    p.setStatus(rs.getString("status"));
                    payments.add(p);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return payments;
    }

    public List<Payment> getAllPayments() {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setBillId(rs.getInt("bill_id"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                p.setAmountPaid(rs.getBigDecimal("amount_paid"));
                p.setStatus(rs.getString("status"));
                payments.add(p);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return payments;
    }
}
