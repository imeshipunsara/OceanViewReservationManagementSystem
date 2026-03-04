package com.oceanview.controller;

import com.oceanview.model.Guest;
import com.oceanview.service.GuestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/GuestController")
public class GuestController extends HttpServlet {

    private GuestService guestService;

    public void init() {
        guestService = new GuestService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("search".equals(action)) {
            String query = request.getParameter("query");
            // Try email first
            Guest guest = guestService.getGuestByEmail(query);
            if (guest == null) {
                // Try contact number
                guest = guestService.getGuestByContactNumber(query);
            }

            if (guest != null) {
                String json = String.format(
                        "{\"success\": true, \"guestId\": %d, \"name\": \"%s\", \"email\": \"%s\", \"contact\": \"%s\", \"address\": \"%s\"}",
                        guest.getGuestId(),
                        escapeJson(guest.getGuestName()),
                        escapeJson(guest.getEmail()),
                        escapeJson(guest.getContactNumber()),
                        escapeJson(guest.getAddress()));
                out.print(json);
            } else {
                out.print("{\"success\": false, \"message\": \"Guest not found\"}");
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if ("add".equals(action)) {
            String name = request.getParameter("guestName");
            String address = request.getParameter("address");
            String contact = request.getParameter("contactNumber");
            String email = request.getParameter("email");

            Guest newGuest = new Guest();
            newGuest.setGuestName(name);
            newGuest.setAddress(address);
            newGuest.setContactNumber(contact);
            newGuest.setEmail(email);

            int guestId = guestService.addGuest(newGuest);

            if (guestId != -1) {
                String json = String.format(
                        "{\"success\": true, \"guestId\": %d, \"name\": \"%s\", \"email\": \"%s\", \"contact\": \"%s\", \"address\": \"%s\"}",
                        guestId,
                        escapeJson(name),
                        escapeJson(email),
                        escapeJson(contact),
                        escapeJson(address));
                out.print(json);
            } else {
                out.print(
                        "{\"success\": false, \"message\": \"Failed to create guest. Email or contact might already exist.\"}");
            }
        }
    }

    private String escapeJson(String str) {
        if (str == null)
            return "N/A";
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
