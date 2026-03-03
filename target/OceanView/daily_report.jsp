<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="java.util.List" %>
                <%@ page import="java.sql.Date" %>
                    <% User user=(User) session.getAttribute("user"); if (user==null) {
                        response.sendRedirect("login.jsp"); return; } List<Reservation> checkIns = (List<Reservation>)
                            request.getAttribute("checkIns");
                            List<Reservation> checkOuts = (List<Reservation>) request.getAttribute("checkOuts");
                                    Date reportDate = (Date) request.getAttribute("reportDate");
                                    %>
                                    <!DOCTYPE html>
                                    <html>

                                    <head>
                                        <meta charset="UTF-8">
                                        <title>Daily Report - Ocean View Resort</title>
                                        <link rel="stylesheet" href="css/style.css">
                                        <style>
                                            .report-section {
                                                margin-bottom: 2rem;
                                            }

                                            .report-header {
                                                display: flex;
                                                justify-content: space-between;
                                                align-items: center;
                                                margin-bottom: 1rem;
                                            }
                                        </style>
                                    </head>

                                    <body>
                                        <div class="container">
                                            <header style="margin-bottom: 2rem;">
                                                <h1>Daily Report: <%= reportDate %>
                                                </h1>
                                                <a href="dashboard.jsp" class="btn">Back to Dashboard</a>
                                            </header>

                                            <div class="report-section card">
                                                <div class="report-header">
                                                    <h2>Today's Check-Ins</h2>
                                                    <a href="PdfReportServlet?type=check_in" class="btn"
                                                        style="background-color: #3498db;">Download PDF</a>
                                                </div>
                                                <% if (checkIns !=null && !checkIns.isEmpty()) { %>
                                                    <table>
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Guest ID</th>
                                                                <th>Room ID</th>
                                                                <th>Status</th>
                                                                <th>Check-Out Date</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (Reservation r : checkIns) { %>
                                                                <tr>
                                                                    <td>
                                                                        <%= r.getReservationId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getGuestId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getRoomId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getStatus() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getCheckOutDate() %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                    <% } else { %>
                                                        <p>No check-ins today.</p>
                                                        <% } %>
                                            </div>

                                            <div class="report-section card">
                                                <div class="report-header">
                                                    <h2>Today's Check-Outs</h2>
                                                    <a href="PdfReportServlet?type=check_out" class="btn"
                                                        style="background-color: #3498db;">Download PDF</a>
                                                </div>
                                                <% if (checkOuts !=null && !checkOuts.isEmpty()) { %>
                                                    <table>
                                                        <thead>
                                                            <tr>
                                                                <th>ID</th>
                                                                <th>Guest ID</th>
                                                                <th>Room ID</th>
                                                                <th>Status</th>
                                                                <th>Check-In Date</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (Reservation r : checkOuts) { %>
                                                                <tr>
                                                                    <td>
                                                                        <%= r.getReservationId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getGuestId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getRoomId() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getStatus() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= r.getCheckInDate() %>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                        </tbody>
                                                    </table>
                                                    <% } else { %>
                                                        <p>No check-outs today.</p>
                                                        <% } %>
                                            </div>
                                        </div>
                                    </body>

                                    </html>