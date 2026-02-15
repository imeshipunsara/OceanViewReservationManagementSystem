package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.List;

@WebServlet("/RoomController")
public class RoomController extends HttpServlet {

    private RoomDAO roomDAO;

    public void init() {
        roomDAO = new RoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("available".equals(action)) {
            try {
                String checkInStr = request.getParameter("checkIn");
                String checkOutStr = request.getParameter("checkOut");

                if (checkInStr != null && checkOutStr != null) {
                    Date checkIn = Date.valueOf(checkInStr);
                    Date checkOut = Date.valueOf(checkOutStr);

                    List<Room> rooms = roomDAO.getAvailableRooms(checkIn, checkOut);

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    PrintWriter out = response.getWriter();

                    // Manual JSON construction to avoid dependency issues if Gson is missing
                    StringBuilder json = new StringBuilder("[");
                    for (int i = 0; i < rooms.size(); i++) {
                        Room r = rooms.get(i);
                        json.append(String.format("{\"roomId\": %d, \"roomType\": \"%s\", \"price\": %.2f}",
                                r.getRoomId(), r.getRoomType(), r.getPricePerNight()));
                        if (i < rooms.size() - 1) {
                            json.append(",");
                        }
                    }
                    json.append("]");
                    out.print(json.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid dates");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("addRoom".equals(action)) {
            try {
                int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
                String roomType = request.getParameter("roomType");
                java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
                String status = request.getParameter("status");

                Room room = new Room();
                room.setRoomNumber(roomNumber);
                room.setRoomType(roomType);
                room.setPricePerNight(price);
                room.setStatus(status);

                if (roomDAO.addRoom(room)) {
                    response.sendRedirect("dashboard?view=rooms&message=Room+added+successfully");
                } else {
                    response.sendRedirect("dashboard?view=rooms&error=Failed+to+add+room");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard?view=rooms&error=Invalid+input");
            }
        } else if ("updateRoom".equals(action)) { // Status and other details
            try {
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                // Check if we are updating just status or full details
                // The requirement mentions "model to update room status", but implies general
                // update
                // If the form provides full details, we update full details.
                // Let's assume the update modal provides all fields.

                int roomNumber = Integer.parseInt(request.getParameter("roomNumber"));
                String roomType = request.getParameter("roomType");
                java.math.BigDecimal price = new java.math.BigDecimal(request.getParameter("price"));
                String status = request.getParameter("status");

                System.out.println("DEBUG: updateRoom - ID: " + roomId);
                System.out.println("DEBUG: updateRoom - Number: " + roomNumber);
                System.out.println("DEBUG: updateRoom - Status: " + status);

                Room room = new Room();
                room.setRoomId(roomId);
                room.setRoomNumber(roomNumber);
                room.setRoomType(roomType);
                room.setPricePerNight(price);
                room.setStatus(status);

                if (roomDAO.updateRoom(room)) {
                    response.sendRedirect("dashboard?view=rooms&message=Room+updated+successfully");
                } else {
                    response.sendRedirect("dashboard?view=rooms&error=Failed+to+update+room");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard?view=rooms&error=Invalid+input");
            }
        } else {
            response.sendRedirect("dashboard?view=rooms");
        }
    }
}
