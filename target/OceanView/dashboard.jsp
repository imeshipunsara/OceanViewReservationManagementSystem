<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="com.oceanview.model.Room" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.time.LocalDate" %>
                        <%@ page import="java.sql.Date" %>

                            <% User user=(User) session.getAttribute("user"); if (user==null) {
                                response.sendRedirect("login.jsp"); return; } String
                                currentView=request.getParameter("view"); if (currentView==null) { currentView="default"
                                ; } // Helper to determine active class safely String activeNew="new"
                                .equals(currentView) ? "active" : "" ; String activeBookings="bookings"
                                .equals(currentView) ? "active" : "" ; String activeCheckins="checkins"
                                .equals(currentView) ? "active" : "" ; String activeCheckouts="checkouts"
                                .equals(currentView) ? "active" : "" ; String activeActive="active" .equals(currentView)
                                ? "active" : "" ; String activeRooms="rooms" .equals(currentView) ? "active" : "" ; %>

                                <!DOCTYPE html>
                                <html>

                                <head>
                                    <meta charset="UTF-8">
                                    <title>Dashboard - Ocean View Resort</title>
                                    <link rel="stylesheet" href="css/style.css">
                                    <style>
                                        /* Embed styles from manage_reservations.jsp for badges */
                                        .badge {
                                            padding: 4px 8px;
                                            border-radius: 4px;
                                            color: white;
                                            display: inline-block;
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

                                        .bg-primary {
                                            background-color: #007bff;
                                        }
                                    </style>
                                </head>

                                <body>
                                    <div class="dashboard-container">
                                        <!-- Sidebar -->
                                        <nav class="sidebar">
                                            <div style="padding: 20px; text-align: center;">
                                                <h2 style="margin:0; font-size:1.2rem;">Ocean View</h2>
                                                <div style="font-size: 0.8rem; color: #bdc3c7; margin-top: 5px;">Staff
                                                    Panel</div>
                                            </div>

                                            <ul>
                                                <li><a href="dashboard?view=new" class="<%= activeNew %>">New
                                                        Reservation</a></li>
                                                <li><a href="dashboard?view=bookings"
                                                        class="<%= activeBookings %>">Guest Reservation Bookings</a>
                                                </li>
                                                <li><a href="dashboard?view=checkins"
                                                        class="<%= activeCheckins %>">Today Check-ins</a></li>
                                                <li><a href="dashboard?view=checkouts"
                                                        class="<%= activeCheckouts %>">Today Check-outs</a></li>
                                                <li><a href="dashboard?view=active" class="<%= activeActive %>">Active
                                                        Reservations</a></li>
                                                <li><a href="dashboard?view=rooms" class="<%= activeRooms %>">Room
                                                        Availability</a></li>
                                                <li style="margin-top: 2rem; border-top: 1px solid #34495e;">
                                                    <a href="logout" style="color: #e74c3c;">Logout</a>
                                                </li>
                                            </ul>
                                        </nav>

                                        <!-- Main Content -->
                                        <main class="main-content">
                                            <header
                                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                                                <h1 style="font-size: 1.8rem; color: #2c3e50; margin: 0;">
                                                    <% String title=(String) request.getAttribute("sectionTitle"); if
                                                        (title==null) title="Overview" ; out.print(title); %>
                                                </h1>
                                                <div class="user-info">
                                                    <span>Welcome, <strong>
                                                            <%= user.getUsername() %>
                                                        </strong></span>
                                                </div>
                                            </header>

                                            <% String msg=request.getParameter("message"); if (msg !=null) { %>
                                                <div class="alert"
                                                    style="background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb;">
                                                    <%= msg %>
                                                </div>
                                                <% } %>

                                                    <% String error=(String) request.getAttribute("error"); if (error
                                                        !=null) { %>
                                                        <div class="alert"
                                                            style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;">
                                                            <%= error %>
                                                        </div>
                                                        <% } %>

                                                            <!-- Dynamic Content Area -->
                                                            <div class="card">
                                                                <% if ("new".equals(currentView)) { %>
                                                                    <h3>New Reservation</h3>
                                                                    <p>Please use the reservation form below or click <a
                                                                            href="reservation_form.jsp">here</a> to open
                                                                        in full page.</p>
                                                                    <iframe src="reservation_form.jsp"
                                                                        style="width:100%; height:600px; border:none;"></iframe>

                                                                    <% } else if ("rooms".equals(currentView)) {
                                                                        List<Room> rooms = (List<Room>)
                                                                            request.getAttribute("rooms");
                                                                            %>
                                                                            <% if (rooms==null || rooms.isEmpty()) { %>
                                                                                <p>No room information available.</p>
                                                                                <% } else { %>
                                                                                    <table class="table">
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Room ID</th>
                                                                                                <th>Type</th>
                                                                                                <th>Price</th>
                                                                                                <th>Status</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% for (Room r : rooms) { %>
                                                                                                <tr>
                                                                                                    <td>
                                                                                                        <%= r.getRoomId()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <%= r.getRoomType()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>$<%= r.getPricePerNight()
                                                                                                            %>
                                                                                                    </td>
                                                                                                    <td>
                                                                                                        <span
                                                                                                            class="badge <%= "
                                                                                                            Available".equals(r.getStatus())
                                                                                                            ? "bg-success"
                                                                                                            : "bg-danger"
                                                                                                            %>">
                                                                                                            <%= r.getStatus()
                                                                                                                %>
                                                                                                        </span>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <% } %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                    <% } %>

                                                                                        <% } else { // Default to
                                                                                            showing reservation list
                                                                                            (conceptually for bookings,
                                                                                            checkins, checkouts, active)
                                                                                            List<Reservation>
                                                                                            reservations = (List
                                                                                            <Reservation>)
                                                                                                request.getAttribute("reservations");
                                                                                                %>
                                                                                                <% if
                                                                                                    (reservations==null
                                                                                                    ||
                                                                                                    reservations.isEmpty())
                                                                                                    { %>
                                                                                                    <% if(!"default".equals(currentView))
                                                                                                        { %>
                                                                                                        <p>No
                                                                                                            reservations
                                                                                                            found for
                                                                                                            this view.
                                                                                                        </p>
                                                                                                        <% } else { %>
                                                                                                            <p>Select an
                                                                                                                option
                                                                                                                from the
                                                                                                                sidebar
                                                                                                                to get
                                                                                                                started.
                                                                                                            </p>
                                                                                                            <div
                                                                                                                class="stat-cards">
                                                                                                                <div
                                                                                                                    class="stat-card">
                                                                                                                    <h3>Quick
                                                                                                                        Actions
                                                                                                                    </h3>
                                                                                                                    <a href="dashboard?view=new"
                                                                                                                        class="btn">New
                                                                                                                        Reservation</a>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <% } %>
                                                                                                                <% } else
                                                                                                                    { %>
                                                                                                                    <table
                                                                                                                        class="table">
                                                                                                                        <thead>
                                                                                                                            <tr>
                                                                                                                                <th>ID
                                                                                                                                </th>
                                                                                                                                <th>Guest
                                                                                                                                    ID
                                                                                                                                </th>
                                                                                                                                <th>Room
                                                                                                                                    ID
                                                                                                                                </th>
                                                                                                                                <th>Check
                                                                                                                                    In
                                                                                                                                </th>
                                                                                                                                <th>Check
                                                                                                                                    Out
                                                                                                                                </th>
                                                                                                                                <th>Status
                                                                                                                                </th>
                                                                                                                                <th>Action
                                                                                                                                </th>
                                                                                                                            </tr>
                                                                                                                        </thead>
                                                                                                                        <tbody>
                                                                                                                            <% for
                                                                                                                                (Reservation
                                                                                                                                r
                                                                                                                                :
                                                                                                                                reservations)
                                                                                                                                {
                                                                                                                                String
                                                                                                                                status=r.getStatus();
                                                                                                                                String
                                                                                                                                colorClass="bg-warning"
                                                                                                                                ;
                                                                                                                                if
                                                                                                                                ("Confirmed".equals(status))
                                                                                                                                colorClass="bg-success"
                                                                                                                                ;
                                                                                                                                else
                                                                                                                                if
                                                                                                                                ("Cancelled".equals(status))
                                                                                                                                colorClass="bg-danger"
                                                                                                                                ;
                                                                                                                                else
                                                                                                                                if
                                                                                                                                ("Checked
                                                                                                                                In".equals(status))
                                                                                                                                colorClass="bg-info"
                                                                                                                                ;
                                                                                                                                else
                                                                                                                                if
                                                                                                                                ("Checked
                                                                                                                                Out".equals(status))
                                                                                                                                colorClass="bg-secondary"
                                                                                                                                ;
                                                                                                                                %>
                                                                                                                                <tr>
                                                                                                                                    <td>
                                                                                                                                        <%= r.getReservationId()
                                                                                                                                            %>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= r.getGuestId()
                                                                                                                                            %>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= r.getRoomId()
                                                                                                                                            %>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= r.getCheckInDate()
                                                                                                                                            %>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <%= r.getCheckOutDate()
                                                                                                                                            %>
                                                                                                                                    </td>
                                                                                                                                    <td><span
                                                                                                                                            class="badge <%= colorClass %>">
                                                                                                                                            <%= status
                                                                                                                                                %>
                                                                                                                                        </span>
                                                                                                                                    </td>
                                                                                                                                    <td>
                                                                                                                                        <form
                                                                                                                                            action="ReservationController"
                                                                                                                                            method="post"
                                                                                                                                            style="display:inline;">
                                                                                                                                            <input
                                                                                                                                                type="hidden"
                                                                                                                                                name="reservationId"
                                                                                                                                                value="<%= r.getReservationId() %>">

                                                                                                                                            <% if
                                                                                                                                                ("Pending".equals(status))
                                                                                                                                                {
                                                                                                                                                %>
                                                                                                                                                <button
                                                                                                                                                    type="submit"
                                                                                                                                                    name="action"
                                                                                                                                                    value="confirm"
                                                                                                                                                    class="btn bg-success"
                                                                                                                                                    style="padding: 5px 10px; font-size: 0.8rem;">Confirm</button>
                                                                                                                                                <button
                                                                                                                                                    type="submit"
                                                                                                                                                    name="action"
                                                                                                                                                    value="cancel"
                                                                                                                                                    class="btn bg-danger"
                                                                                                                                                    style="padding: 5px 10px; font-size: 0.8rem;">Cancel</button>
                                                                                                                                                <% } else
                                                                                                                                                    if
                                                                                                                                                    ("Confirmed".equals(status))
                                                                                                                                                    {
                                                                                                                                                    %>
                                                                                                                                                    <button
                                                                                                                                                        type="submit"
                                                                                                                                                        name="action"
                                                                                                                                                        value="checkIn"
                                                                                                                                                        class="btn bg-info"
                                                                                                                                                        style="padding: 5px 10px; font-size: 0.8rem;">Check
                                                                                                                                                        In</button>
                                                                                                                                                    <button
                                                                                                                                                        type="submit"
                                                                                                                                                        name="action"
                                                                                                                                                        value="cancel"
                                                                                                                                                        class="btn bg-danger"
                                                                                                                                                        style="padding: 5px 10px; font-size: 0.8rem;">Cancel</button>
                                                                                                                                                    <% } else
                                                                                                                                                        if
                                                                                                                                                        ("Checked
                                                                                                                                                        In".equals(status))
                                                                                                                                                        {
                                                                                                                                                        %>
                                                                                                                                                        <button
                                                                                                                                                            type="submit"
                                                                                                                                                            name="action"
                                                                                                                                                            value="checkOut"
                                                                                                                                                            class="btn bg-primary"
                                                                                                                                                            style="padding: 5px 10px; font-size: 0.8rem;">Check
                                                                                                                                                            Out</button>
                                                                                                                                                        <% }
                                                                                                                                                            %>
                                                                                                                                        </form>
                                                                                                                                    </td>
                                                                                                                                </tr>
                                                                                                                                <% }
                                                                                                                                    %>
                                                                                                                        </tbody>
                                                                                                                    </table>
                                                                                                                    <% }
                                                                                                                        %>
                                                                                                                        <% }
                                                                                                                            %>
                                                            </div>
                                        </main>
                                    </div>
                                </body>

                                </html>