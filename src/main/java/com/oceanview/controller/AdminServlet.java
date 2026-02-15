package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.UserDAO;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;
    private RoomDAO roomDAO;
    private GuestDAO guestDAO;
    private ReservationDAO reservationDAO;

    public void init() {
        userDAO = new UserDAO();
        roomDAO = new RoomDAO();
        guestDAO = new GuestDAO();
        reservationDAO = new ReservationDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String view = request.getParameter("view");
        String action = request.getParameter("action");
        if (view == null)
            view = "users";

        if ("editUser".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User userToEdit = userDAO.getUserById(userId);
            request.setAttribute("userToEdit", userToEdit);
            view = "editUser";
        } else if ("editRoom".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Room roomToEdit = roomDAO.getRoomById(roomId);
            request.setAttribute("roomToEdit", roomToEdit);
            view = "editRoom";
        } else if ("users".equals(view)) {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
        } else if ("rooms".equals(view)) {
            List<Room> rooms = roomDAO.getAllRooms();
            request.setAttribute("rooms", rooms);
        } else if ("guests".equals(view)) {
            List<Guest> guests = guestDAO.getAllGuests();
            request.setAttribute("guests", guests);
        } else if ("reservations".equals(view)) {
            List<Reservation> reservations = reservationDAO.getAllReservations();
            request.setAttribute("reservations", reservations);
        }

        request.setAttribute("currentView", view);
        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("addUser".equals(action)) {
                handleAddUser(request);
            } else if ("updateUser".equals(action)) {
                handleUpdateUser(request);
            } else if ("deleteUser".equals(action)) {
                handleDeleteUser(request);
            } else if ("addRoom".equals(action)) {
                handleAddRoom(request);
            } else if ("updateRoom".equals(action)) {
                handleUpdateRoom(request);
            } else if ("deleteRoom".equals(action)) {
                handleDeleteRoom(request);
            } else if ("deleteGuest".equals(action)) {
                handleDeleteGuest(request);
            } else if ("updateReservationStatus".equals(action)) {
                handleUpdateReservationStatus(request);
            } else if ("deleteReservation".equals(action)) {
                handleDeleteReservation(request);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Operation failed: " + e.getMessage());
        }

        String referrer = request.getHeader("referer");
        // Simple redirect back to list view usually, but preserving view param is
        // better if possible
        // For now, simpler redirection
        if ("updateUser".equals(action))
            response.sendRedirect("admin?view=users");
        else if ("updateRoom".equals(action))
            response.sendRedirect("admin?view=rooms");
        else if ("updateReservationStatus".equals(action))
            response.sendRedirect("admin?view=reservations");
        else if ("deleteReservation".equals(action))
            response.sendRedirect("admin?view=reservations");
        else
            response.sendRedirect(referrer != null ? referrer : "admin");
    }

    private void handleAddUser(HttpServletRequest request) throws Exception {
        User user = new User();
        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setRole(request.getParameter("role"));
        userDAO.saveUser(user);
    }

    private void handleUpdateUser(HttpServletRequest request) {
        User user = new User();
        user.setUserId(Integer.parseInt(request.getParameter("userId")));
        user.setUsername(request.getParameter("username"));
        user.setRole(request.getParameter("role"));
        String password = request.getParameter("password");
        if (password != null && !password.isEmpty()) {
            user.setPassword(password);
        }
        userDAO.updateUser(user);
    }

    private void handleDeleteUser(HttpServletRequest request) {
        int userId = Integer.parseInt(request.getParameter("userId"));
        userDAO.deleteUser(userId);
    }

    private void handleAddRoom(HttpServletRequest request) {
        Room room = new Room();
        room.setRoomNumber(Integer.parseInt(request.getParameter("roomNumber")));
        room.setRoomType(request.getParameter("roomType"));
        room.setPricePerNight(new BigDecimal(request.getParameter("price")));
        String status = request.getParameter("status");
        if (status == null || status.isEmpty()) {
            status = "Available";
        }
        room.setStatus(status);
        roomDAO.addRoom(room);
    }

    private void handleUpdateRoom(HttpServletRequest request) {
        Room room = new Room();
        room.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        room.setRoomNumber(Integer.parseInt(request.getParameter("roomNumber")));
        room.setRoomType(request.getParameter("roomType"));
        room.setPricePerNight(new BigDecimal(request.getParameter("price")));
        room.setStatus(request.getParameter("status"));
        roomDAO.updateRoom(room);
    }

    private void handleDeleteRoom(HttpServletRequest request) {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        roomDAO.deleteRoom(roomId);
    }

    private void handleDeleteGuest(HttpServletRequest request) {
        int guestId = Integer.parseInt(request.getParameter("guestId"));
        guestDAO.deleteGuest(guestId);
    }

    private void handleUpdateReservationStatus(HttpServletRequest request) {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        String status = request.getParameter("status");

        // Use service to ensure side effects (room status updates) trigger
        ReservationService reservationService = new ReservationService();
        reservationService.updateReservationStatus(reservationId, status);
    }

    private void handleDeleteReservation(HttpServletRequest request) {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        reservationDAO.deleteReservation(reservationId);
    }
}
