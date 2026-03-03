package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import java.sql.Date;
import java.util.List;

public class ReservationService {

    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;

    public ReservationService() {
        this.reservationDAO = new ReservationDAO();
        this.roomDAO = new RoomDAO();
    }

    // Constructor for Dependency Injection (Testing)
    public ReservationService(ReservationDAO reservationDAO, RoomDAO roomDAO) {
        this.reservationDAO = reservationDAO;
        this.roomDAO = roomDAO;
    }

    public boolean createReservation(int guestId, int roomId, Date checkIn, Date checkOut, String initialStatus)
            throws java.sql.SQLException, ClassNotFoundException {
        // Business Logic: Check if check-out is after check-in
        if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
            System.out.println("Error: Check-out must be after check-in.");
            return false;
        }

        Reservation r = new Reservation();
        r.setGuestId(guestId);
        r.setRoomId(roomId);
        r.setCheckInDate(checkIn);
        r.setCheckOutDate(checkOut);
        r.setStatus(initialStatus);

        boolean created = reservationDAO.createReservation(r);
        // Do NOT update room status to "Occupied" here.
        // Room status should only change when the guest actually checks in.
        // Availability for future dates is handled by checking the reservations table.
        return created;
    }

    public boolean createReservation(int guestId, int roomId, Date checkIn, Date checkOut)
            throws java.sql.SQLException, ClassNotFoundException {
        return createReservation(guestId, roomId, checkIn, checkOut, "Pending");
    }

    public boolean confirmReservation(int reservationId, int staffId) {
        boolean confirmed = reservationDAO.confirmReservation(reservationId, staffId);
        if (confirmed) {
            Reservation res = reservationDAO.getReservationById(reservationId);
            if (res != null) {
                EmailService.sendBookingConfirmation(res);
            }
        }
        return confirmed;
    }

    public boolean updateReservationStatus(int reservationId, String newStatus) {
        Reservation r = reservationDAO.getReservationById(reservationId);
        if (r == null)
            return false;

        String oldStatus = r.getStatus();
        // Prevent unnecessary updates
        if (oldStatus != null && oldStatus.equals(newStatus))
            return true;

        boolean statusUpdated = reservationDAO.updateReservationStatus(reservationId, newStatus);
        if (statusUpdated) {
            // Send confirmation email if status is Confirmed
            if ("Confirmed".equalsIgnoreCase(newStatus)) {
                EmailService.sendBookingConfirmation(r);
            }
            // Handle side effects on Room status
            if ("Checked In".equalsIgnoreCase(newStatus)) {
                roomDAO.updateRoomStatus(r.getRoomId(), "Occupied");
            } else if ("Checked Out".equalsIgnoreCase(newStatus)) {
                roomDAO.updateRoomStatus(r.getRoomId(), "Available");
            } else if ("Cancelled".equalsIgnoreCase(newStatus)) {
                // If it was previously occupied, free it
                if ("Checked In".equalsIgnoreCase(oldStatus)) {
                    roomDAO.updateRoomStatus(r.getRoomId(), "Available");
                }
                // If just confirmed/pending, room might still be marked unavailable in some
                // logic,
                // but usually room status is only 'Occupied' when checked in.
                // However, for safety, if we cancel, we ensure room is available?
                // Actually, logic usually is:
                // Pending/Confirmed -> Room is still 'Available' physically, but booked
                // logically.
                // Checked In -> Room is 'Occupied'.
                // So cancelling a Checked In reservation should default to Available.
                roomDAO.updateRoomStatus(r.getRoomId(), "Available");
            }
            return true;
        }
        return false;
    }

    public boolean updateReservationRoom(int reservationId, int newRoomId) {
        Reservation r = reservationDAO.getReservationById(reservationId);
        if (r == null) {
            return false;
        }

        int oldRoomId = r.getRoomId();
        if (oldRoomId == newRoomId) {
            return true;
        }

        boolean updated = reservationDAO.updateReservationRoom(reservationId, newRoomId);
        if (updated) {
            // If the guest is currently checked in, we need to swap the room status
            if ("Checked In".equalsIgnoreCase(r.getStatus())) {
                roomDAO.updateRoomStatus(oldRoomId, "Available");
                roomDAO.updateRoomStatus(newRoomId, "Occupied");
            }
        }
        return updated;
    }

    public boolean checkInReservation(int reservationId) {
        return updateReservationStatus(reservationId, "Checked In");
    }

    public boolean checkOutReservation(int reservationId) {
        return updateReservationStatus(reservationId, "Checked Out");
    }

    public List<Reservation> getAllReservations() {
        return reservationDAO.getAllReservations();
    }

    public boolean cancelReservation(int reservationId) {
        return reservationDAO.cancelReservation(reservationId);
    }

    public List<Reservation> getReservationsByDate(Date date, String type) {
        return reservationDAO.getReservationsByDate(date, type);
    }

    public List<Reservation> getReservationsByStatus(String status) {
        return reservationDAO.getReservationsByStatus(status);
    }

    public List<Reservation> getExpectedCheckIns(Date date) {
        return reservationDAO.getExpectedCheckIns(date);
    }

    public List<Reservation> getExpectedCheckOuts(Date date) {
        return reservationDAO.getExpectedCheckOuts(date);
    }

    public Reservation getReservationById(int reservationId) {
        return reservationDAO.getReservationById(reservationId);
    }
}
