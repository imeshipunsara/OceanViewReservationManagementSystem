package com.oceanview.controller;

import com.oceanview.service.ReservationService;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    private ReservationService reservationService;
    private com.oceanview.dao.RoomDAO roomDAO;

    public void init() {
        reservationService = new ReservationService();
        roomDAO = new com.oceanview.dao.RoomDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String guestIdStr = request.getParameter("guestId");
            if (guestIdStr == null || guestIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Guest ID is missing.");
                request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
                return;
            }
            request.setAttribute("guestId", guestIdStr); // Preserve ID for session recovery
            int guestId = Integer.parseInt(guestIdStr.trim());

            String roomType = request.getParameter("roomType");
            String checkInStr = request.getParameter("checkInDate");
            String checkOutStr = request.getParameter("checkOutDate");

            System.out.println("DEBUG: checkInStr = '" + checkInStr + "'");
            System.out.println("DEBUG: checkOutStr = '" + checkOutStr + "'");

            if (checkInStr == null || checkInStr.trim().isEmpty() || checkOutStr == null
                    || checkOutStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Please select both Check-In and Check-Out dates.");
                request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
                return;
            }

            Date checkIn = parseDate(checkInStr);
            Date checkOut = parseDate(checkOutStr);

            // Set these for UI recovery
            request.setAttribute("checkInDate", checkInStr);
            request.setAttribute("checkOutDate", checkOutStr);
            request.setAttribute("roomType", roomType);

            // Find an available room of the requested type
            int roomId = roomDAO.findAvailableRoomIdByType(roomType, checkIn, checkOut);

            if (roomId != -1) {
                // Staff bookings are automatically confirmed
                boolean success = reservationService.createReservation(guestId, roomId, checkIn, checkOut, "Confirmed");

                if (success) {
                    response.sendRedirect("dashboard.jsp?message=Reservation+Created+Successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to create reservation. Please try again.");
                    request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "No available " + roomType + " rooms for the selected dates.");
                request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Guest ID format.");
            request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (msg.contains("Room is already booked")) {
                request.setAttribute("errorMessage", "Error: The selected room is already booked for these dates.");
            } else {
                request.setAttribute("errorMessage", "Database Error: " + msg);
            }
            request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred: " + e.getMessage());
            request.getRequestDispatcher("reservation_form.jsp").forward(request, response);
        }
    }

    private Date parseDate(String dateStr) throws IllegalArgumentException {
        if (dateStr == null)
            return null;
        dateStr = dateStr.trim();

        // Try standard SQL format first (yyyy-MM-dd)
        try {
            return Date.valueOf(dateStr);
        } catch (IllegalArgumentException e) {
            // Check other common formats
            String[] formats = { "MM/dd/yyyy", "dd/MM/yyyy", "yyyy/MM/dd", "dd-MM-yyyy" };
            for (String format : formats) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(format);
                    sdf.setLenient(false);
                    java.util.Date utilDate = sdf.parse(dateStr);
                    return new Date(utilDate.getTime());
                } catch (java.text.ParseException ignored) {
                    // Try next format
                }
            }
            // If all fail
            throw new IllegalArgumentException("Invalid date format: '" + dateStr + "'. Please use yyyy-MM-dd.");
        }
    }
}
