package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.Room;
import com.oceanview.service.ReservationService;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/guestBooking")
public class GuestBookingServlet extends HttpServlet {

    private GuestDAO guestDAO;
    private RoomDAO roomDAO;
    private ReservationService reservationService;

    public void init() {
        guestDAO = new GuestDAO();
        roomDAO = new RoomDAO();
        reservationService = new ReservationService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            if ("checkEmail".equals(action)) {
                handleCheckEmail(request, response, session);
            } else if ("register".equals(action)) {
                handleRegister(request, response, session);
            } else if ("book".equals(action)) {
                handleBook(request, response, session);
            } else {
                response.sendRedirect("guest_booking.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("guest_booking.jsp").forward(request, response);
        }
    }

    private void handleCheckEmail(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        Guest guest = guestDAO.getGuestByEmail(email);

        if (guest != null) {
            session.setAttribute("currentGuest", guest);
            request.setAttribute("step", "booking");
        } else {
            request.setAttribute("email", email); // Pre-fill email
            request.setAttribute("step", "register");
        }
        request.getRequestDispatcher("guest_booking.jsp").forward(request, response);
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");

        Guest newGuest = new Guest();
        newGuest.setGuestName(name);
        newGuest.setAddress(address);
        newGuest.setContactNumber(contact);
        newGuest.setEmail(email);

        int guestId = guestDAO.addGuest(newGuest);

        if (guestId != -1) {
            newGuest.setGuestId(guestId);
            session.setAttribute("currentGuest", newGuest);
            request.setAttribute("step", "booking");
            request.setAttribute("message", "Registration successful! Please proceed to booking.");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.setAttribute("email", email);
            request.setAttribute("step", "register");
        }
        request.getRequestDispatcher("guest_booking.jsp").forward(request, response);
    }

    private void handleBook(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        try {
            // 1. Get Form Data
            String name = request.getParameter("guestName");
            String email = request.getParameter("email");
            String contact = request.getParameter("contactNumber");
            String roomType = request.getParameter("roomType");
            Date checkIn = Date.valueOf(request.getParameter("checkInDate"));
            Date checkOut = Date.valueOf(request.getParameter("checkOutDate"));

            // 2. Handle Guest
            Guest currentGuest = guestDAO.getGuestByEmail(email);
            if (currentGuest == null) {
                // Create new guest
                currentGuest = new Guest();
                currentGuest.setGuestName(name);
                currentGuest.setEmail(email);
                currentGuest.setContactNumber(contact);
                currentGuest.setAddress("N/A"); // Default as not in form

                int guestId = guestDAO.addGuest(currentGuest);
                if (guestId != -1) {
                    currentGuest.setGuestId(guestId);
                } else {
                    throw new Exception("Failed to register guest.");
                }
            } else {
                session.setAttribute("currentGuest", currentGuest);
            }

            // 3. Find Available Room
            List<Room> availableRooms = roomDAO.getAvailableRooms(checkIn, checkOut);
            int selectedRoomId = -1;

            for (Room r : availableRooms) {
                if (r.getRoomType().equalsIgnoreCase(roomType)) {
                    selectedRoomId = r.getRoomId();
                    break;
                }
            }

            if (selectedRoomId == -1) {
                request.setAttribute("errorMessage", "No " + roomType + " rooms available for selected dates.");
                request.setAttribute("step", "booking");
                request.getRequestDispatcher("guest_booking.jsp").forward(request, response);
                return;
            }

            // 4. Create Reservation
            boolean success = reservationService.createReservation(currentGuest.getGuestId(), selectedRoomId, checkIn,
                    checkOut, "Pending");

            if (success) {
                request.setAttribute("step", "confirmed");
                request.setAttribute("message", "Booking Request Sent! Status: Pending.");
            } else {
                request.setAttribute("errorMessage", "Booking failed. Please try again.");
                request.setAttribute("step", "booking");
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Invalid date format.");
            request.setAttribute("step", "booking");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.setAttribute("step", "booking");
        }

        request.getRequestDispatcher("guest_booking.jsp").forward(request, response);
    }
}
