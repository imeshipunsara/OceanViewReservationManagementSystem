package com.oceanview.controller;

import com.oceanview.service.ReservationService;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.User;
import com.oceanview.model.Reservation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/ReservationController")
public class ReservationController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ReservationService reservationService;
    private RoomDAO roomDAO;

    public void init() {
        reservationService = new ReservationService();
        roomDAO = new RoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Reservation> list = reservationService.getAllReservations();
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("manage_reservations.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("reservationId");

        // Basic validation
        if (idStr == null || action == null) {
            response.sendRedirect("ReservationController?error=Invalid+Request");
            return;
        }

        int reservationId = Integer.parseInt(idStr);
        boolean success = false;
        String errorMessage = "Action+failed";

        if ("confirm".equals(action)) {
            success = reservationService.confirmReservation(reservationId, user.getUserId());
        } else if ("cancel".equals(action)) {
            success = reservationService.cancelReservation(reservationId);
        } else if ("checkIn".equals(action)) {
            success = reservationService.checkInReservation(reservationId);
        } else if ("checkOut".equals(action)) {
            success = reservationService.checkOutReservation(reservationId);
        } else if ("updateRoom".equals(action)) {
            String roomType = request.getParameter("roomType");
            Reservation r = reservationService.getReservationById(reservationId);

            if (r != null) {
                int newRoomId = roomDAO.findAvailableRoomIdByType(roomType, r.getCheckInDate(), r.getCheckOutDate());

                if (newRoomId != -1) {
                    success = reservationService.updateReservationRoom(reservationId, newRoomId);
                } else {
                    errorMessage = "No+available+rooms+of+type+" + roomType;
                }
            } else {
                errorMessage = "Reservation+not+found";
            }
        }

        if (success) {
            response.sendRedirect("dashboard?view=bookings&message=Action+successful");
        } else {
            response.sendRedirect("dashboard?view=bookings&error=" + errorMessage);
        }
    }
}
