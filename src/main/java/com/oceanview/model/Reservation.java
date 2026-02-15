package com.oceanview.model;

import java.sql.Date;

public class Reservation {
    private int reservationId;
    private int guestId;
    private int roomId;
    private int roomNumber; // Added for display purposes
    private Integer userId; // Nullable
    private Date checkInDate;
    private Date checkOutDate;
    private String status;
    private String guestEmail; // Added for display purposes

    public Reservation() {
    }

    public Reservation(int reservationId, int guestId, int roomId, int roomNumber, Integer userId, Date checkInDate,
            Date checkOutDate, String status, String guestEmail) {
        this.reservationId = reservationId;
        this.guestId = guestId;
        this.roomId = roomId;
        this.roomNumber = roomNumber;
        this.userId = userId;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.status = status;
        this.guestEmail = guestEmail;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(Date checkInDate) {
        this.checkInDate = checkInDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
