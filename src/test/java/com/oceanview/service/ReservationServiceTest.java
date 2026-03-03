package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import java.sql.Date;

import com.oceanview.dao.RoomDAO;

// Simple Mock for DAO
class MockReservationDAO extends ReservationDAO {
    @Override
    public boolean createReservation(Reservation reservation) {
        return true; // Simulate success
    }
}

class MockRoomDAO extends RoomDAO {
    @Override
    public boolean updateRoomStatus(int roomId, String status) {
        return true; // Simulate success
    }
}

public class ReservationServiceTest {

    private ReservationService reservationService;
    private MockReservationDAO mockReservationDAO;
    private MockRoomDAO mockRoomDAO;

    @Before
    public void setUp() {
        mockReservationDAO = new MockReservationDAO();
        mockRoomDAO = new MockRoomDAO();
        reservationService = new ReservationService(mockReservationDAO, mockRoomDAO);
    }

    @Test
    public void testCreateReservation_InvalidDates() {
        // Check-In: 2024-01-10, Check-Out: 2024-01-05 (Invalid)
        Date checkIn = Date.valueOf("2024-01-10");
        Date checkOut = Date.valueOf("2024-01-05");

        boolean result = reservationService.createReservation(1, 101, checkIn, checkOut);

        assertFalse("Reservation should fail if check-out is before check-in", result);
    }

    @Test
    public void testCreateReservation_ValidDates() {
        // Check-In: 2024-01-10, Check-Out: 2024-01-15 (Valid)
        Date checkIn = Date.valueOf("2024-01-10");
        Date checkOut = Date.valueOf("2024-01-15");

        boolean result = reservationService.createReservation(1, 101, checkIn, checkOut);

        assertTrue("Reservation should succeed with valid dates", result);
    }
}
