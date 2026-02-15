<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Reservation" %>
            <%@ page import="com.oceanview.model.Room" %>
                <%@ page import="java.util.List" %>
                    <%@ page import="java.time.LocalDate" %>
                        <%@ page import="java.sql.Date" %>

                            <% /* Authenticate User */ User user=(User) session.getAttribute("user"); if (user==null) {
                                response.sendRedirect("login.jsp"); return; } /* Determine Current View */ String
                                currentView=request.getParameter("view"); if (currentView==null) { currentView="default"
                                ; } /* Set Active States */ String activeNew="new" .equals(currentView) ? "active" : ""
                                ; String activeBookings="bookings" .equals(currentView) ? "active" : "" ; String
                                activeCheckins="checkins" .equals(currentView) ? "active" : "" ; String
                                activeCheckouts="checkouts" .equals(currentView) ? "active" : "" ; String
                                activeActive="active" .equals(currentView) ? "active" : "" ; String activeRooms="rooms"
                                .equals(currentView) ? "active" : "" ; %>

                                <!DOCTYPE html>
                                <html lang="en">

                                <head>
                                    <meta charset="UTF-8">
                                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                    <title>Staff Dashboard - Ocean View Resort</title>
                                    <!-- Bootstrap 5 CSS -->
                                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                        rel="stylesheet">
                                    <!-- FontAwesome 6 -->
                                    <link rel="stylesheet"
                                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                                    <!-- Custom CSS -->
                                    <link rel="stylesheet" href="css/style.css">
                                </head>

                                <body>

                                    <div class="d-flex" id="wrapper">
                                        <!-- Sidebar -->
                                        <div class="sidebar border-end" id="sidebar-wrapper">
                                            <div
                                                class="sidebar-heading text-center py-4 primary-text fs-4 fw-bold text-uppercase border-bottom">
                                                <i class="fa-solid fa-hotel me-2"></i>Ocean View
                                            </div>
                                            <div class="list-group list-group-flush my-3">
                                                <a href="dashboard?view=new"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeNew %>">
                                                    <i class="fa-solid fa-plus me-2"></i>New Reservation
                                                </a>
                                                <a href="dashboard?view=bookings"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeBookings %>">
                                                    <i class="fa-solid fa-calendar-days me-2"></i>Bookings
                                                </a>
                                                <a href="dashboard?view=checkins"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeCheckins %>">
                                                    <i class="fa-solid fa-person-walking-luggage me-2"></i>Check-ins
                                                </a>
                                                <a href="dashboard?view=checkouts"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeCheckouts %>">
                                                    <i
                                                        class="fa-solid fa-person-walking-arrow-right me-2"></i>Check-outs
                                                </a>
                                                <a href="dashboard?view=active"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeActive %>">
                                                    <i class="fa-solid fa-bed me-2"></i>Active Guests
                                                </a>
                                                <a href="dashboard?view=rooms"
                                                    class="list-group-item list-group-item-action bg-transparent <%= activeRooms %>">
                                                    <i class="fa-solid fa-door-closed me-2"></i>Rooms
                                                </a>
                                                <% if ("admin".equalsIgnoreCase(user.getRole())) { %>
                                                    <a href="admin"
                                                        class="list-group-item list-group-item-action bg-transparent text-warning fw-bold">
                                                        <i class="fa-solid fa-user-shield me-2"></i>Admin Dashboard
                                                    </a>
                                                    <% } %>
                                                        <a href="logout"
                                                            class="list-group-item list-group-item-action bg-transparent text-danger fw-bold mt-5">
                                                            <i class="fa-solid fa-power-off me-2"></i>Logout
                                                        </a>
                                            </div>
                                        </div>
                                        <!-- /#sidebar-wrapper -->

                                        <!-- Page Content -->
                                        <div id="page-content-wrapper" class="w-100">
                                            <nav
                                                class="navbar navbar-expand-lg navbar-light bg-light border-bottom px-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-align-left primary-text fs-4 me-3" id="menu-toggle"
                                                        style="cursor: pointer;"></i>
                                                    <h2 class="fs-2 m-0">Staff Dashboard</h2>
                                                </div>

                                                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                                                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                                                        <li class="nav-item dropdown">
                                                            <a class="nav-link dropdown-toggle second-text fw-bold"
                                                                href="#" id="navbarDropdown" role="button"
                                                                data-bs-toggle="dropdown" aria-expanded="false">
                                                                <i class="fas fa-user me-2"></i>
                                                                <%= user.getUsername() %>
                                                            </a>
                                                            <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                                                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                                                <li><a class="dropdown-item" href="logout">Logout</a>
                                                                </li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </nav>

                                            <div class="container-fluid px-4 py-4">

                                                <% String title=(String) request.getAttribute("sectionTitle"); if
                                                    (title==null) { title="Overview" ; } %>

                                                    <div class="row g-3 my-2">
                                                        <div class="col-md-3">
                                                            <div
                                                                class="p-3 bg-white shadow-sm d-flex justify-content-around align-items-center rounded">
                                                                <div>
                                                                    <h3 class="fs-2">---</h3>
                                                                    <p class="fs-5 text-muted">Bookings Today</p>
                                                                </div>
                                                                <i
                                                                    class="fas fa-calendar-check fs-1 primary-text border rounded-full secondary-bg p-3"></i>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <% String msg=request.getParameter("message"); if (msg !=null) { %>
                                                        <div class="alert alert-success alert-dismissible fade show"
                                                            role="alert">
                                                            <%= msg %>
                                                                <button type="button" class="btn-close"
                                                                    data-bs-dismiss="alert" aria-label="Close"></button>
                                                        </div>
                                                        <% } %>

                                                            <% String error=(String) request.getAttribute("error"); if
                                                                (error !=null) { %>
                                                                <div class="alert alert-danger alert-dismissible fade show"
                                                                    role="alert">
                                                                    <%= error %>
                                                                        <button type="button" class="btn-close"
                                                                            data-bs-dismiss="alert"
                                                                            aria-label="Close"></button>
                                                                </div>
                                                                <% } %>

                                                                    <!-- Dynamic Content -->
                                                                    <div class="row my-5">
                                                                        <div class="col">
                                                                            <div class="card shadow">
                                                                                <div
                                                                                    class="card-header bg-white border-0">
                                                                                    <h3 class="fs-4 mb-0">
                                                                                        <%= title %>
                                                                                    </h3>
                                                                                </div>
                                                                                <div class="card-body">

                                                                                    <% if ("new".equals(currentView)) {
                                                                                        %>
                                                                                        <p>Use the form below or <a
                                                                                                href="reservation_form.jsp"
                                                                                                class="text-decoration-none">open
                                                                                                full page</a>.</p>
                                                                                        <iframe
                                                                                            src="reservation_form.jsp"
                                                                                            style="width:100%; height:800px; border:none;"></iframe>

                                                                                        <% } else if
                                                                                            ("rooms".equals(currentView))
                                                                                            { %>
                                                                                            <% List<Room> rooms = (List
                                                                                                <Room>)
                                                                                                    request.getAttribute("rooms");
                                                                                                    if (rooms == null ||
                                                                                                    rooms.isEmpty()) {
                                                                                                    %>
                                                                                                    <p
                                                                                                        class="text-muted">
                                                                                                        No room
                                                                                                        information
                                                                                                        available.</p>
                                                                                                    <% } else { %>
                                                                                                        <div
                                                                                                            class="table-responsive">
                                                                                                            <table
                                                                                                                class="table bg-white rounded shadow-sm  table-hover">
                                                                                                                <thead>
                                                                                                                    <tr>
                                                                                                                        <th scope="col"
                                                                                                                            width="50">
                                                                                                                            #
                                                                                                                        </th>
                                                                                                                        <th
                                                                                                                            scope="col">
                                                                                                                            Type
                                                                                                                        </th>
                                                                                                                        <th
                                                                                                                            scope="col">
                                                                                                                            Price
                                                                                                                        </th>
                                                                                                                        <th
                                                                                                                            scope="col">
                                                                                                                            Status
                                                                                                                        </th>
                                                                                                                    </tr>
                                                                                                                </thead>
                                                                                                                <tbody>
                                                                                                                    <% for
                                                                                                                        (Room
                                                                                                                        r
                                                                                                                        :
                                                                                                                        rooms)
                                                                                                                        {
                                                                                                                        String
                                                                                                                        rStatus=r.getStatus();
                                                                                                                        String
                                                                                                                        badge="bg-danger"
                                                                                                                        ;
                                                                                                                        if
                                                                                                                        ("Available".equals(rStatus))
                                                                                                                        {
                                                                                                                        badge="bg-success"
                                                                                                                        ;
                                                                                                                        }
                                                                                                                        else
                                                                                                                        if
                                                                                                                        ("Maintenance".equals(rStatus))
                                                                                                                        {
                                                                                                                        badge="bg-warning text-dark"
                                                                                                                        ;
                                                                                                                        }
                                                                                                                        %>
                                                                                                                        <tr>
                                                                                                                            <th
                                                                                                                                scope="row">
                                                                                                                                <%= r.getRoomId()
                                                                                                                                    %>
                                                                                                                            </th>
                                                                                                                            <td>
                                                                                                                                <%= r.getRoomType()
                                                                                                                                    %>
                                                                                                                            </td>
                                                                                                                            <td>$
                                                                                                                                <%= r.getPricePerNight()
                                                                                                                                    %>
                                                                                                                            </td>
                                                                                                                            <td><span
                                                                                                                                    class="badge rounded-pill <%= badge %>">
                                                                                                                                    <%= rStatus
                                                                                                                                        %>
                                                                                                                                </span>
                                                                                                                            </td>
                                                                                                                        </tr>
                                                                                                                        <% }
                                                                                                                            %>
                                                                                                                </tbody>
                                                                                                            </table>
                                                                                                        </div>
                                                                                                        <% } %>

                                                                                                            <% } else {
                                                                                                                %>
                                                                                                                <!-- Default: Reservation List -->
                                                                                                                <%
                                                                                                                    List<Reservation>
                                                                                                                    reservations
                                                                                                                    =
                                                                                                                    (List
                                                                                                                    <Reservation>
                                                                                                                        )
                                                                                                                        request.getAttribute("reservations");
                                                                                                                        if
                                                                                                                        (reservations
                                                                                                                        ==
                                                                                                                        null
                                                                                                                        ||
                                                                                                                        reservations.isEmpty())
                                                                                                                        {
                                                                                                                        if
                                                                                                                        (!"default".equals(currentView))
                                                                                                                        {
                                                                                                                        %>
                                                                                                                        <p
                                                                                                                            class="text-muted">
                                                                                                                            No
                                                                                                                            reservations
                                                                                                                            found.
                                                                                                                        </p>
                                                                                                                        <% } else
                                                                                                                            {
                                                                                                                            %>
                                                                                                                            <div
                                                                                                                                class="text-center py-5">
                                                                                                                                <i
                                                                                                                                    class="fa-solid fa-clipboard-list fa-4x text-muted mb-3"></i>
                                                                                                                                <p
                                                                                                                                    class="fs-5">
                                                                                                                                    Select
                                                                                                                                    an
                                                                                                                                    option
                                                                                                                                    from
                                                                                                                                    the
                                                                                                                                    sidebar
                                                                                                                                    to
                                                                                                                                    get
                                                                                                                                    started.
                                                                                                                                </p>
                                                                                                                                <a href="dashboard?view=new"
                                                                                                                                    class="btn btn-primary btn-lg mt-3">
                                                                                                                                    <i
                                                                                                                                        class="fa-solid fa-plus me-2"></i>New
                                                                                                                                    Reservation
                                                                                                                                </a>
                                                                                                                            </div>
                                                                                                                            <% } }
                                                                                                                                else
                                                                                                                                {
                                                                                                                                %>
                                                                                                                                <div
                                                                                                                                    class="table-responsive">
                                                                                                                                    <table
                                                                                                                                        class="table bg-white rounded shadow-sm  table-hover">
                                                                                                                                        <thead>
                                                                                                                                            <tr>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    ID
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Guest
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Room
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Check
                                                                                                                                                    In
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Check
                                                                                                                                                    Out
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Status
                                                                                                                                                </th>
                                                                                                                                                <th
                                                                                                                                                    scope="col">
                                                                                                                                                    Action
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
                                                                                                                                                badge="bg-warning text-dark"
                                                                                                                                                ;
                                                                                                                                                if
                                                                                                                                                ("Confirmed".equals(status))
                                                                                                                                                {
                                                                                                                                                badge="bg-success"
                                                                                                                                                ;
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                if
                                                                                                                                                ("Cancelled".equals(status))
                                                                                                                                                {
                                                                                                                                                badge="bg-danger"
                                                                                                                                                ;
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                if
                                                                                                                                                ("Checked
                                                                                                                                                In".equals(status))
                                                                                                                                                {
                                                                                                                                                badge="bg-info text-dark"
                                                                                                                                                ;
                                                                                                                                                }
                                                                                                                                                else
                                                                                                                                                if
                                                                                                                                                ("Checked
                                                                                                                                                Out".equals(status))
                                                                                                                                                {
                                                                                                                                                badge="bg-secondary"
                                                                                                                                                ;
                                                                                                                                                }
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
                                                                                                                                                            class="badge rounded-pill <%= badge %>">
                                                                                                                                                            <%= status
                                                                                                                                                                %>
                                                                                                                                                        </span>
                                                                                                                                                    </td>
                                                                                                                                                    <td>
                                                                                                                                                        <form
                                                                                                                                                            action="ReservationController"
                                                                                                                                                            method="post"
                                                                                                                                                            class="d-inline">
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
                                                                                                                                                                    class="btn btn-sm btn-success"
                                                                                                                                                                    title="Confirm"><i
                                                                                                                                                                        class="fa-solid fa-check"></i></button>
                                                                                                                                                                <button
                                                                                                                                                                    type="submit"
                                                                                                                                                                    name="action"
                                                                                                                                                                    value="cancel"
                                                                                                                                                                    class="btn btn-sm btn-danger"
                                                                                                                                                                    title="Cancel"><i
                                                                                                                                                                        class="fa-solid fa-xmark"></i></button>
                                                                                                                                                                <% } else
                                                                                                                                                                    if
                                                                                                                                                                    ("Confirmed".equals(status))
                                                                                                                                                                    {
                                                                                                                                                                    %>
                                                                                                                                                                    <button
                                                                                                                                                                        type="submit"
                                                                                                                                                                        name="action"
                                                                                                                                                                        value="checkIn"
                                                                                                                                                                        class="btn btn-sm btn-info"
                                                                                                                                                                        title="Check In"><i
                                                                                                                                                                            class="fa-solid fa-arrow-right-to-bracket"></i></button>
                                                                                                                                                                    <button
                                                                                                                                                                        type="submit"
                                                                                                                                                                        name="action"
                                                                                                                                                                        value="cancel"
                                                                                                                                                                        class="btn btn-sm btn-danger"
                                                                                                                                                                        title="Cancel"><i
                                                                                                                                                                            class="fa-solid fa-xmark"></i></button>
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
                                                                                                                                                                            class="btn btn-sm btn-primary"
                                                                                                                                                                            title="Check Out"><i
                                                                                                                                                                                class="fa-solid fa-arrow-right-from-bracket"></i></button>
                                                                                                                                                                        <% }
                                                                                                                                                                            %>
                                                                                                                                                        </form>
                                                                                                                                                    </td>
                                                                                                                                                </tr>
                                                                                                                                                <% }
                                                                                                                                                    %>
                                                                                                                                        </tbody>
                                                                                                                                    </table>
                                                                                                                                </div>
                                                                                                                                <% }
                                                                                                                                    %>
                                                                                                                                    <% }
                                                                                                                                        %>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /#page-content-wrapper -->

                                    <!-- Bootstrap JS Bundle -->
                                    <script
                                        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                                    <script>
                                        var el = document.getElementById("wrapper");
                                        var toggleButton = document.getElementById("menu-toggle");

                                        toggleButton.onclick = function () {
                                            el.classList.toggle("toggled");
                                        };
                                    </script>
                                    <style>
                                        :root {
                                            --main-bg-color: #009d63;
                                            --main-text-color: #009d63;
                                            --second-text-color: #bbbec5;
                                            --second-bg-color: #c1efde;
                                        }

                                        .primary-text {
                                            color: var(--main-text-color);
                                        }

                                        .second-text {
                                            color: var(--second-text-color);
                                        }

                                        .primary-bg {
                                            background-color: var(--main-bg-color);
                                        }

                                        .secondary-bg {
                                            background-color: var(--second-bg-color);
                                        }

                                        .rounded-full {
                                            border-radius: 100%;
                                        }

                                        #wrapper {
                                            overflow-x: hidden;
                                            background-image: linear-gradient(to right,
                                                    #baf3d7,
                                                    #c2f5de,
                                                    #cbf7e4,
                                                    #d4f8ea,
                                                    #ddfaef);
                                        }

                                        #sidebar-wrapper {
                                            min-height: 100vh;
                                            margin-left: -15rem;
                                            -webkit-transition: margin .25s ease-out;
                                            -moz-transition: margin .25s ease-out;
                                            -o-transition: margin .25s ease-out;
                                            transition: margin .25s ease-out;
                                        }

                                        #sidebar-wrapper .sidebar-heading {
                                            padding: 0.875rem 1.25rem;
                                            font-size: 1.2rem;
                                        }

                                        #sidebar-wrapper .list-group {
                                            width: 15rem;
                                        }

                                        #page-content-wrapper {
                                            min-width: 100vw;
                                        }

                                        #wrapper.toggled #sidebar-wrapper {
                                            margin-left: 0;
                                        }

                                        #menu-toggle {
                                            cursor: pointer;
                                        }

                                        .list-group-item {
                                            border: none;
                                            padding: 20px 30px;
                                        }

                                        .list-group-item.active {
                                            background-color: transparent;
                                            color: var(--main-text-color);
                                            font-weight: bold;
                                            border: none;
                                        }

                                        @media (min-width: 768px) {
                                            #sidebar-wrapper {
                                                margin-left: 0;
                                            }

                                            #page-content-wrapper {
                                                min-width: 0;
                                                width: 100%;
                                            }

                                            #wrapper.toggled #sidebar-wrapper {
                                                margin-left: -15rem;
                                            }
                                        }
                                    </style>
                                </body>

                                </html>