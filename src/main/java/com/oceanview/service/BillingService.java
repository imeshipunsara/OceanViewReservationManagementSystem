package com.oceanview.service;

import com.oceanview.dao.*;
import com.oceanview.model.*;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.temporal.ChronoUnit;
import java.util.List;

public class BillingService {
    private BillDAO billDAO;
    private PaymentDAO paymentDAO;
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;

    public BillingService() {
        this.billDAO = new BillDAO();
        this.paymentDAO = new PaymentDAO();
        this.reservationDAO = new ReservationDAO();
        this.roomDAO = new RoomDAO();
        this.guestDAO = new GuestDAO();
    }

    public long calculateNights(java.sql.Date checkIn, java.sql.Date checkOut) {
        return ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
    }

    public Bill generateBill(int reservationId, List<ExtraCharge> extraCharges) throws Exception {
        Reservation res = reservationDAO.getReservationById(reservationId);
        if (res == null)
            throw new Exception("Reservation not found");

        Room room = roomDAO.getRoomById(res.getRoomId());
        if (room == null)
            throw new Exception("Room not found");

        long nights = calculateNights(res.getCheckInDate(), res.getCheckOutDate());
        if (nights <= 0)
            nights = 1; // Minimum 1 night charge

        BigDecimal roomCharge = room.getPricePerNight().multiply(new BigDecimal(nights));

        BigDecimal extraTotal = BigDecimal.ZERO;
        for (ExtraCharge ec : extraCharges) {
            BigDecimal subtotal = ec.getPrice().multiply(new BigDecimal(ec.getQuantity()));
            ec.setSubtotal(subtotal);
            extraTotal = extraTotal.add(subtotal);
        }

        Bill bill = new Bill();
        bill.setReservationId(reservationId);
        bill.setNumberOfNights((int) nights);
        bill.setRoomCharge(roomCharge);
        bill.setExtraChargesTotal(extraTotal);
        bill.setTotalAmount(roomCharge.add(extraTotal));

        Bill existingBill = billDAO.getBillByReservationId(reservationId);
        int billId;

        if (existingBill != null) {
            // Update existing bill
            bill.setBillId(existingBill.getBillId());
            billDAO.updateBill(bill);
            billId = existingBill.getBillId();

            // Clear existing extra charges to replace with new ones
            billDAO.deleteExtraChargesByBillId(billId);
        } else {
            // Create new bill
            billId = billDAO.createBill(bill);
            bill.setBillId(billId);
        }

        for (ExtraCharge ec : extraCharges) {
            ec.setBillId(billId);
            billDAO.addExtraCharge(ec);
        }
        bill.setExtraCharges(extraCharges);

        return bill;
    }

    public boolean processPayment(int billId, String method, BigDecimal amount)
            throws SQLException, ClassNotFoundException {
        Payment payment = new Payment();
        payment.setBillId(billId);
        payment.setPaymentMethod(method);
        payment.setAmountPaid(amount);
        payment.setStatus("Paid");

        boolean paymentCreated = paymentDAO.createPayment(payment);
        if (paymentCreated) {
            // Update Reservation Status
            Bill bill = billDAO.getBillById(billId);
            if (bill != null) {
                reservationDAO.updateReservationStatus(bill.getReservationId(), "Checked Out");
                Reservation res = reservationDAO.getReservationById(bill.getReservationId());
                roomDAO.updateRoomStatus(res.getRoomId(), "Available");
            }
            return true;
        }
        return false;
    }
}
