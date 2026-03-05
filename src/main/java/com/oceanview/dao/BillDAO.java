package com.oceanview.dao;

import com.oceanview.model.Bill;
import com.oceanview.model.ExtraCharge;
import com.oceanview.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {

    public int createBill(Bill bill) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO billing (reservation_id, number_of_nights, room_charge, extra_charges_total, total_amount) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, bill.getReservationId());
            pstmt.setInt(2, bill.getNumberOfNights());
            pstmt.setBigDecimal(3, bill.getRoomCharge());
            pstmt.setBigDecimal(4, bill.getExtraChargesTotal());
            pstmt.setBigDecimal(5, bill.getTotalAmount());

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public void addExtraCharge(ExtraCharge charge) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO extra_charges (bill_id, item_name, price, quantity, subtotal) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, charge.getBillId());
            pstmt.setString(2, charge.getItemName());
            pstmt.setBigDecimal(3, charge.getPrice());
            pstmt.setInt(4, charge.getQuantity());
            pstmt.setBigDecimal(5, charge.getSubtotal());

            pstmt.executeUpdate();
        }
    }

    public boolean updateBill(Bill bill) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE billing SET number_of_nights = ?, room_charge = ?, extra_charges_total = ?, total_amount = ? WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bill.getNumberOfNights());
            pstmt.setBigDecimal(2, bill.getRoomCharge());
            pstmt.setBigDecimal(3, bill.getExtraChargesTotal());
            pstmt.setBigDecimal(4, bill.getTotalAmount());
            pstmt.setInt(5, bill.getBillId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public void deleteExtraChargesByBillId(int billId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM extra_charges WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, billId);
            pstmt.executeUpdate();
        }
    }

    public Bill getBillByReservationId(int reservationId) {
        String sql = "SELECT * FROM billing WHERE reservation_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reservationId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractBillFromResultSet(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Bill getBillById(int billId) {
        String sql = "SELECT * FROM billing WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractBillFromResultSet(rs);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Bill extractBillFromResultSet(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setReservationId(rs.getInt("reservation_id"));
        bill.setNumberOfNights(rs.getInt("number_of_nights"));
        bill.setRoomCharge(rs.getBigDecimal("room_charge"));
        bill.setExtraChargesTotal(rs.getBigDecimal("extra_charges_total"));
        bill.setTotalAmount(rs.getBigDecimal("total_amount"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        bill.setExtraCharges(getExtraChargesByBillId(bill.getBillId()));
        return bill;
    }

    public List<ExtraCharge> getExtraChargesByBillId(int billId) {
        List<ExtraCharge> charges = new ArrayList<>();
        String sql = "SELECT * FROM extra_charges WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, billId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ExtraCharge charge = new ExtraCharge();
                    charge.setChargeId(rs.getInt("charge_id"));
                    charge.setBillId(rs.getInt("bill_id"));
                    charge.setItemName(rs.getString("item_name"));
                    charge.setPrice(rs.getBigDecimal("price"));
                    charge.setQuantity(rs.getInt("quantity"));
                    charge.setSubtotal(rs.getBigDecimal("subtotal"));
                    charges.add(charge);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return charges;
    }

    public List<Bill> getAllBills() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM billing ORDER BY bill_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setReservationId(rs.getInt("reservation_id"));
                bill.setNumberOfNights(rs.getInt("number_of_nights"));
                bill.setRoomCharge(rs.getBigDecimal("room_charge"));
                bill.setExtraChargesTotal(rs.getBigDecimal("extra_charges_total"));
                bill.setTotalAmount(rs.getBigDecimal("total_amount"));
                bill.setBillDate(rs.getTimestamp("bill_date"));
                bills.add(bill);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return bills;
    }
}
