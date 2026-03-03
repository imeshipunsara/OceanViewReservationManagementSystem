package com.oceanview.controller;

import com.oceanview.service.ReservationService;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
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

        String view = request.getParameter("view");
        if (view == null) {
            view = "default";
        }

        LocalDate localDate = LocalDate.now();
        Date today = Date.valueOf(localDate);

        // Fetch global stats for the overview cards
        try {
            int bookingsToday = reservationService.getExpectedCheckIns(today).size();
            int availableRooms = roomDAO.getRoomsByStatus("Available").size();
            int activeGuests = reservationService.getReservationsByStatus("Checked In").size();
            int pendingRequests = reservationService.getReservationsByStatus("Pending").size();

            request.setAttribute("bookingsTodayCount", bookingsToday);
            request.setAttribute("availableRoomsCount", availableRooms);
            request.setAttribute("activeGuestsCount", activeGuests);
            request.setAttribute("pendingRequestsCount", pendingRequests);
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            switch (view) {
                case "new":
                    // Redirect or stay on dashboard not needed here as we use links,
                    // but for strict dashboard view, we might forward content.
                    // For now, let's allow dashboard.jsp to handle the link or include.
                    // actually, dashboard.jsp will check 'view' param too.
                    break;
                case "bookings":
                    List<Reservation> allReservations = reservationService.getAllReservations();
                    request.setAttribute("reservations", allReservations);
                    request.setAttribute("sectionTitle", "All Guest Bookings");
                    break;
                case "checkins":
                    List<Reservation> checkins = reservationService.getExpectedCheckIns(today);
                    request.setAttribute("reservations", checkins);
                    request.setAttribute("sectionTitle", "Today's Check-ins");
                    break;
                case "checkouts":
                    List<Reservation> checkouts = reservationService.getExpectedCheckOuts(today);
                    request.setAttribute("reservations", checkouts);
                    request.setAttribute("sectionTitle", "Today's Check-outs");
                    break;
                case "active":
                    List<Reservation> active = reservationService.getReservationsByStatus("Checked In");
                    request.setAttribute("reservations", active);
                    request.setAttribute("sectionTitle", "Active Reservations");
                    break;
                case "maintenance":
                    List<Room> maintenanceRooms = roomDAO.getRoomsByStatus("Maintenance");
                    request.setAttribute("rooms", maintenanceRooms);
                    request.setAttribute("sectionTitle", "Maintenance Rooms");
                    break;
                case "rooms":
                    List<Room> rooms = roomDAO.getAllRooms();
                    request.setAttribute("rooms", rooms);
                    request.setAttribute("sectionTitle", "Room Availability");
                    break;
                case "bills":
                    request.getRequestDispatcher("bills.jsp").forward(request, response);
                    return;
                default:
                    // Default view logic
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching data: " + e.getMessage());
        }

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}
