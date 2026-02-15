<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.util.List" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="com.oceanview.model.User" %>
                <%@ page import="java.time.LocalDate" %>
                    <%@ page import="java.sql.Date" %>

                        <% User user=(User) session.getAttribute("user"); if (user==null) {
                            response.sendRedirect("login.jsp"); return; } try { List<Reservation> reservations = (List
                            <Reservation>) request.getAttribute("reservations");
                                if (reservations == null) {
                                response.sendRedirect("ReservationController");
                                return;
                                }

                                LocalDate today = LocalDate.now();
                                String message = request.getParameter("message");
                                String error = request.getParameter("error");
                                %>
                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <meta charset="UTF-8">
                                    <title>Manage Reservations</title>
                                    <link rel="stylesheet" href="css/style.css">
                                    <style>
                                        .badge {
                                            padding: 4px 8px;
                                            border-radius: 4px;
                                            color: white;
                                        }

                                        .bg-success {
                                            background-color: #28a745;
                                        }

                                        .bg-danger {
                                            background-color: #dc3545;
                                        }

                                        .bg-warning {
                                            background-color: #ffc107;
                                            color: black;
                                        }

                                        .bg-info {
                                            background-color: #17a2b8;
                                        }

                                        .bg-secondary {
                                            background-color: #6c757d;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="container">
                                        <h1>Reservations</h1>
                                        <a href="dashboard.jsp" class="btn">Back</a>

                                        <% if(message !=null) { %>
                                            <div
                                                style="color:green; border:1px solid green; padding:10px; margin:10px 0;">
                                                <%= message %>
                                            </div>
                                            <% } %>

                                                <% if(error !=null) { %>
                                                    <div
                                                        style="color:red; border:1px solid red; padding:10px; margin:10px 0;">
                                                        <%= error %>
                                                    </div>
                                                    <% } %>

                                                        <table border="1"
                                                            style="width:100%; border-collapse: collapse;">
                                                            <thead>
                                                                <tr>
                                                                    <th>ID</th>
                                                                    <th>Guest Email</th>
                                                                    <th>Room</th>
                                                                    <th>In</th>
                                                                    <th>Out</th>
                                                                    <th>Status</th>
                                                                    <th>Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <% if (reservations.isEmpty()) { %>
                                                                    <tr>
                                                                        <td colspan="7">No data found.</td>
                                                                    </tr>
                                                                    <% } else { for(Reservation r : reservations) {
                                                                        String status=r.getStatus(); int
                                                                        id=r.getReservationId(); Date
                                                                        dIn=r.getCheckInDate(); Date
                                                                        dOut=r.getCheckOutDate(); String
                                                                        colorClass="bg-warning" ;
                                                                        if("Confirmed".equals(status))
                                                                        colorClass="bg-success" ; else
                                                                        if("Cancelled".equals(status))
                                                                        colorClass="bg-danger" ; else if("Checked In".equals(status)) colorClass="bg-info" ; else
                                                                        if("Checked Out".equals(status))
                                                                        colorClass="bg-secondary" ; %>
                                                                        <tr>
                                                                            <td>
                                                                                <%= id %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getGuestEmail() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= r.getRoomId() %>
                                                                            </td>
                                                                            <td>
                                                                                <%= dIn %>
                                                                            </td>
                                                                            <td>
                                                                                <%= dOut %>
                                                                            </td>
                                                                            <td><span class="badge <%= colorClass %>">
                                                                                    <%= status %>
                                                                                </span></td>
                                                                            <td>
                                                                                <form action="ReservationController"
                                                                                    method="post"
                                                                                    style="display:inline;">
                                                                                    <input type="hidden"
                                                                                        name="reservationId"
                                                                                        value="<%= id %>">
                                                                                    <% if("Pending".equals(status)) { %>
                                                                                        <button type="submit"
                                                                                            name="action"
                                                                                            value="confirm"
                                                                                            class="btn bg-success">Confirm</button>
                                                                                        <button type="submit"
                                                                                            name="action" value="cancel"
                                                                                            class="btn bg-danger">Cancel</button>
                                                                                        <% } else
                                                                                            if("Confirmed".equals(status))
                                                                                            { %>
                                                                                            <button type="submit"
                                                                                                name="action"
                                                                                                value="checkIn"
                                                                                                class="btn bg-info">Check
                                                                                                In</button>
                                                                                            <button type="submit"
                                                                                                name="action"
                                                                                                value="cancel"
                                                                                                class="btn bg-danger">Cancel</button>
                                                                                            <% } else if("Checked In".equals(status)) { %>
                                                                                                <button type="submit"
                                                                                                    name="action"
                                                                                                    value="checkOut"
                                                                                                    class="btn bg-primary">Check
                                                                                                    Out</button>
                                                                                                <% } %>
                                                                                </form>
                                                                            </td>
                                                                        </tr>
                                                                        <% } } %>
                                                            </tbody>
                                                        </table>
                                    </div>
                                </body>

                                </html>
                                <% } catch (Exception e) { out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
