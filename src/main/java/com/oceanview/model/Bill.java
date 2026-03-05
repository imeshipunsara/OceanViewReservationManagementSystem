package com.oceanview.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Bill {
    private int billId;
    private int reservationId;
    private int numberOfNights;
    private BigDecimal roomCharge;
    private BigDecimal extraChargesTotal;
    private BigDecimal totalAmount;
    private Timestamp billDate;
    private List<ExtraCharge> extraCharges = new ArrayList<>();

    public Bill() {
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getNumberOfNights() {
        return numberOfNights;
    }

    public void setNumberOfNights(int numberOfNights) {
        this.numberOfNights = numberOfNights;
    }

    public BigDecimal getRoomCharge() {
        return roomCharge;
    }

    public void setRoomCharge(BigDecimal roomCharge) {
        this.roomCharge = roomCharge;
    }

    public BigDecimal getExtraChargesTotal() {
        return extraChargesTotal;
    }

    public void setExtraChargesTotal(BigDecimal extraChargesTotal) {
        this.extraChargesTotal = extraChargesTotal;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getBillDate() {
        return billDate;
    }

    public void setBillDate(Timestamp billDate) {
        this.billDate = billDate;
    }

    public List<ExtraCharge> getExtraCharges() {
        return extraCharges;
    }

    public void setExtraCharges(List<ExtraCharge> extraCharges) {
        this.extraCharges = extraCharges;
    }

    public void addExtraCharge(ExtraCharge charge) {
        this.extraCharges.add(charge);
    }
}
