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
                                    <html lang="en">

                                    <head>
                                        <meta charset="UTF-8">
                                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                        <title>Daily Report - Ocean View Resort</title>
                                        <!-- Bootstrap 5 CSS -->
                                        <link
                                            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                            rel="stylesheet">
                                        <!-- FontAwesome 6 -->
                                        <link rel="stylesheet"
                                            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                                        <!-- Custom CSS -->
                                        <link rel="stylesheet" href="css/style.css">
                                    </head>

                                    <body>
                                        <div class="container py-5">
                                            <header class="d-flex justify-content-between align-items-center mb-4">
                                                <div>
                                                    <h1 class="display-5 fw-bold text-primary">Daily Report</h1>
                                                    <p class="text-muted fs-5"><i
                                                            class="fa-solid fa-calendar-day me-2"></i>
                                                        <%= reportDate %>
                                                    </p>
                                                </div>
                                                <a href="dashboard.jsp" class="btn btn-outline-secondary"><i
                                                        class="fa-solid fa-arrow-left me-2"></i>Back to Dashboard</a>
                                            </header>

                                            <div class="row g-4">
                                                <!-- Check-ins -->
                                                <div class="col-12">
                                                    <div class="card shadow">
                                                        <div
                                                            class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center py-3">
                                                            <h3 class="h4 mb-0 text-success"><i
                                                                    class="fa-solid fa-person-walking-luggage me-2"></i>Today's
                                                                Check-Ins</h3>
                                                            <a href="PdfReportServlet?type=check_in"
                                                                class="btn btn-sm btn-primary"><i
                                                                    class="fa-solid fa-file-pdf me-2"></i>Download
                                                                PDF</a>
                                                        </div>
                                                        <div class="card-body">
                                                            <% if (checkIns !=null && !checkIns.isEmpty()) { %>
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover align-middle">
                                                                        <thead class="table-light">
                                                                            <tr>
                                                                                <th>ID</th>
                                                                                <th>Guest Email</th>
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
                                                                                        <%= r.getGuestEmail() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= r.getRoomId() %>
                                                                                    </td>
                                                                                    <td><span
                                                                                            class="badge bg-info text-dark">
                                                                                            <%= r.getStatus() %>
                                                                                        </span></td>
                                                                                    <td>
                                                                                        <%= r.getCheckOutDate() %>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                                <% } else { %>
                                                                    <p class="text-muted text-center py-3">No check-ins
                                                                        scheduled for today.</p>
                                                                    <% } %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- Check-outs -->
                                                <div class="col-12">
                                                    <div class="card shadow">
                                                        <div
                                                            class="card-header bg-white border-bottom-0 d-flex justify-content-between align-items-center py-3">
                                                            <h3 class="h4 mb-0 text-danger"><i
                                                                    class="fa-solid fa-person-walking-arrow-right me-2"></i>Today's
                                                                Check-Outs</h3>
                                                            <a href="PdfReportServlet?type=check_out"
                                                                class="btn btn-sm btn-primary"><i
                                                                    class="fa-solid fa-file-pdf me-2"></i>Download
                                                                PDF</a>
                                                        </div>
                                                        <div class="card-body">
                                                            <% if (checkOuts !=null && !checkOuts.isEmpty()) { %>
                                                                <div class="table-responsive">
                                                                    <table class="table table-hover align-middle">
                                                                        <thead class="table-light">
                                                                            <tr>
                                                                                <th>ID</th>
                                                                                <th>Guest Email</th>
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
                                                                                        <%= r.getGuestEmail() %>
                                                                                    </td>
                                                                                    <td>
                                                                                        <%= r.getRoomId() %>
                                                                                    </td>
                                                                                    <td><span
                                                                                            class="badge bg-secondary">
                                                                                            <%= r.getStatus() %>
                                                                                        </span></td>
                                                                                    <td>
                                                                                        <%= r.getCheckInDate() %>
                                                                                    </td>
                                                                                </tr>
                                                                                <% } %>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                                <% } else { %>
                                                                    <p class="text-muted text-center py-3">No check-outs
                                                                        scheduled for today.</p>
                                                                    <% } %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Bootstrap JS Bundle -->
                                        <script
                                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                    </body>

                                    </html>