<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.User" %>
        <%@ page import="com.oceanview.model.Room" %>
            <%@ page import="com.oceanview.model.Guest" %>
                <%@ page import="com.oceanview.model.Reservation" %>
                    <%@ page import="java.util.List" %>

                        <% User user=(User) session.getAttribute("user"); if (user==null ||
                            !"admin".equalsIgnoreCase(user.getRole())) { response.sendRedirect("login.jsp"); return; }
                            String currentView=request.getParameter("view"); if (currentView==null) currentView="users"
                            ; // Helper for active class String activeUsers="users" .equals(currentView) || "editUser"
                            .equals(currentView) ? "active" : "" ; String activeRooms="rooms" .equals(currentView)
                            || "editRoom" .equals(currentView) ? "active" : "" ; String activeGuests="guests"
                            .equals(currentView) ? "active" : "" ; String activeReservations="reservations"
                            .equals(currentView) ? "active" : "" ; %>

                            <!DOCTYPE html>
                            <html lang="en">

                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <title>Admin Dashboard - Ocean View</title>
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
                                            <i class="fa-solid fa-user-shield me-2"></i>Admin Panel
                                        </div>
                                        <div class="list-group list-group-flush my-3">
                                            <a href="admin?view=users"
                                                class="list-group-item list-group-item-action bg-transparent <%= activeUsers %>">
                                                <i class="fa-solid fa-users-gear me-2"></i>User Mgmt
                                            </a>
                                            <a href="admin?view=rooms"
                                                class="list-group-item list-group-item-action bg-transparent <%= activeRooms %>">
                                                <i class="fa-solid fa-bed me-2"></i>Room Mgmt
                                            </a>
                                            <a href="admin?view=guests"
                                                class="list-group-item list-group-item-action bg-transparent <%= activeGuests %>">
                                                <i class="fa-solid fa-address-book me-2"></i>Guest Mgmt
                                            </a>
                                            <a href="admin?view=reservations"
                                                class="list-group-item list-group-item-action bg-transparent <%= activeReservations %>">
                                                <i class="fa-solid fa-calendar-check me-2"></i>Reservations
                                            </a>
                                            <a href="dashboard.jsp"
                                                class="list-group-item list-group-item-action bg-transparent text-white fw-bold mt-3">
                                                <i class="fa-solid fa-arrow-left me-2"></i>Main Dashboard
                                            </a>
                                            <a href="logout"
                                                class="list-group-item list-group-item-action bg-transparent text-danger fw-bold mt-3">
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
                                                <h2 class="fs-2 m-0">
                                                    <%= currentView.substring(0, 1).toUpperCase() +
                                                        currentView.substring(1) %> Management
                                                </h2>
                                            </div>
                                        </nav>

                                        <div class="container-fluid px-4 py-4">
                                            <% String error=(String) request.getAttribute("errorMessage"); if (error
                                                !=null) { %>
                                                <div class="alert alert-danger alert-dismissible fade show"
                                                    role="alert">
                                                    <i class="fa-solid fa-triangle-exclamation me-2"></i>
                                                    <%= error %>
                                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                                            aria-label="Close"></button>
                                                </div>
                                                <% } %>

                                                    <!-- User Management -->
                                                    <% if ("users".equals(currentView)) { %>
                                                        <div class="row g-4">
                                                            <div class="col-md-4">
                                                                <div class="card shadow h-100">
                                                                    <div class="card-header bg-white border-0">
                                                                        <h4 class="mb-0"><i
                                                                                class="fa-solid fa-user-plus me-2 text-primary"></i>Add
                                                                            New User</h4>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <form action="admin" method="post">
                                                                            <input type="hidden" name="action"
                                                                                value="addUser">
                                                                            <div class="form-floating mb-3">
                                                                                <input type="text" class="form-control"
                                                                                    id="username" name="username"
                                                                                    placeholder="Username" required>
                                                                                <label for="username">Username</label>
                                                                            </div>
                                                                            <div class="form-floating mb-3">
                                                                                <input type="password"
                                                                                    class="form-control" id="password"
                                                                                    name="password"
                                                                                    placeholder="Password" required>
                                                                                <label for="password">Password</label>
                                                                            </div>
                                                                            <div class="form-floating mb-3">
                                                                                <select class="form-select" id="role"
                                                                                    name="role">
                                                                                    <option value="staff">Staff</option>
                                                                                    <option value="admin">Admin</option>
                                                                                </select>
                                                                                <label for="role">Role</label>
                                                                            </div>
                                                                            <div class="d-grid">
                                                                                <button type="submit"
                                                                                    class="btn btn-primary">Add
                                                                                    User</button>
                                                                            </div>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-8">
                                                                <div class="card shadow">
                                                                    <div class="card-header bg-white border-0">
                                                                        <h4 class="mb-0">Existing Users</h4>
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <div class="table-responsive">
                                                                            <table
                                                                                class="table table-hover align-middle">
                                                                                <thead>
                                                                                    <tr>
                                                                                        <th>ID</th>
                                                                                        <th>Username</th>
                                                                                        <th>Role</th>
                                                                                        <th>Action</th>
                                                                                    </tr>
                                                                                </thead>
                                                                                <tbody>
                                                                                    <% List<User> users = (List<User>)
                                                                                            request.getAttribute("users");
                                                                                            if (users != null) {
                                                                                            for (User u : users) { %>
                                                                                            <tr>
                                                                                                <td>
                                                                                                    <%= u.getUserId() %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <div
                                                                                                        class="d-flex align-items-center">
                                                                                                        <div class="avatar me-2 bg-light rounded-circle d-flex justify-content-center align-items-center"
                                                                                                            style="width: 40px; height: 40px;">
                                                                                                            <i
                                                                                                                class="fa-solid fa-user text-secondary"></i>
                                                                                                        </div>
                                                                                                        <%= u.getUsername()
                                                                                                            %>
                                                                                                    </div>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <% if
                                                                                                        ("admin".equals(u.getRole()))
                                                                                                        { %>
                                                                                                        <span
                                                                                                            class="badge bg-warning text-dark">Admin</span>
                                                                                                        <% } else { %>
                                                                                                            <span
                                                                                                                class="badge bg-info text-dark">Staff</span>
                                                                                                            <% } %>
                                                                                                </td>
                                                                                                <td>
                                                                                                    <a href="admin?action=editUser&userId=<%= u.getUserId() %>"
                                                                                                        class="btn btn-sm btn-outline-warning me-1"
                                                                                                        title="Edit">
                                                                                                        <i
                                                                                                            class="fa-solid fa-pen"></i>
                                                                                                    </a>
                                                                                                    <form action="admin"
                                                                                                        method="post"
                                                                                                        style="display:inline;">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="action"
                                                                                                            value="deleteUser">
                                                                                                        <input
                                                                                                            type="hidden"
                                                                                                            name="userId"
                                                                                                            value="<%= u.getUserId() %>">
                                                                                                        <button
                                                                                                            type="submit"
                                                                                                            class="btn btn-sm btn-outline-danger"
                                                                                                            onclick="return confirm('Delete user?');"
                                                                                                            title="Delete">
                                                                                                            <i
                                                                                                                class="fa-solid fa-trash"></i>
                                                                                                        </button>
                                                                                                    </form>
                                                                                                </td>
                                                                                            </tr>
                                                                                            <% }} %>
                                                                                </tbody>
                                                                            </table>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Edit User -->
                                                        <% } else if ("editUser".equals(currentView)) { User
                                                            userToEdit=(User) request.getAttribute("userToEdit"); %>
                                                            <div class="row justify-content-center">
                                                                <div class="col-md-6">
                                                                    <div class="card shadow">
                                                                        <div class="card-header bg-white border-0">
                                                                            <h3 class="mb-0">Edit User: <span
                                                                                    class="text-primary">
                                                                                    <%= userToEdit.getUsername() %>
                                                                                </span></h3>
                                                                        </div>
                                                                        <div class="card-body">
                                                                            <form action="admin" method="post">
                                                                                <input type="hidden" name="action"
                                                                                    value="updateUser">
                                                                                <input type="hidden" name="userId"
                                                                                    value="<%= userToEdit.getUserId() %>">

                                                                                <div class="form-floating mb-3">
                                                                                    <input type="text"
                                                                                        class="form-control"
                                                                                        name="username"
                                                                                        value="<%= userToEdit.getUsername() %>"
                                                                                        required>
                                                                                    <label>Username</label>
                                                                                </div>
                                                                                <div class="form-floating mb-3">
                                                                                    <input type="password"
                                                                                        class="form-control"
                                                                                        name="password"
                                                                                        placeholder="Leave blank to keep unchanged">
                                                                                    <label>Password (New)</label>
                                                                                    <div class="form-text">Leave blank
                                                                                        to keep current password.</div>
                                                                                </div>
                                                                                <div class="form-floating mb-3">
                                                                                    <select class="form-select"
                                                                                        name="role">
                                                                                        <option value="staff" <%="staff"
                                                                                            .equals(userToEdit.getRole())
                                                                                            ? "selected" : "" %>>Staff
                                                                                        </option>
                                                                                        <option value="admin" <%="admin"
                                                                                            .equals(userToEdit.getRole())
                                                                                            ? "selected" : "" %>>Admin
                                                                                        </option>
                                                                                    </select>
                                                                                    <label>Role</label>
                                                                                </div>
                                                                                <div
                                                                                    class="d-flex justify-content-between">
                                                                                    <a href="admin?view=users"
                                                                                        class="btn btn-secondary">Cancel</a>
                                                                                    <button type="submit"
                                                                                        class="btn btn-primary">Update
                                                                                        User</button>
                                                                                </div>
                                                                            </form>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Room Management -->
                                                            <% } else if ("rooms".equals(currentView)) { %>
                                                                <div class="row">
                                                                    <div class="col-md-12">
                                                                        <div class="card shadow">
                                                                            <div
                                                                                class="card-header bg-white border-0 d-flex justify-content-between align-items-center">
                                                                                <h4 class="mb-0">Room Management</h4>
                                                                                <button type="button"
                                                                                    class="btn btn-primary"
                                                                                    data-bs-toggle="modal"
                                                                                    data-bs-target="#addRoomModal">
                                                                                    <i
                                                                                        class="fa-solid fa-plus me-2"></i>Add
                                                                                    New Room
                                                                                </button>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <div class="table-responsive">
                                                                                    <table
                                                                                        class="table table-hover align-middle">
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>Room No</th>
                                                                                                <th>Type</th>
                                                                                                <th>Price</th>
                                                                                                <th>Status</th>
                                                                                                <th>Action</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% List<Room> rooms = (List
                                                                                                <Room>)
                                                                                                    request.getAttribute("rooms");
                                                                                                    if (rooms != null) {
                                                                                                    for (Room r : rooms)
                                                                                                    { %>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <%= r.getRoomNumber()
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
                                                                                                            <% String
                                                                                                                badge="bg-danger"
                                                                                                                ; if
                                                                                                                ("Available".equals(r.getStatus()))
                                                                                                                badge="bg-success"
                                                                                                                ; else
                                                                                                                if
                                                                                                                ("Maintenance".equals(r.getStatus()))
                                                                                                                badge="bg-warning text-dark"
                                                                                                                ; %>
                                                                                                                <span
                                                                                                                    class="badge <%= badge %>">
                                                                                                                    <%= r.getStatus()
                                                                                                                        %>
                                                                                                                </span>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <a href="admin?action=editRoom&roomId=<%= r.getRoomId() %>"
                                                                                                                class="btn btn-sm btn-outline-warning me-1">
                                                                                                                <i
                                                                                                                    class="fa-solid fa-pen"></i>
                                                                                                            </a>
                                                                                                            <form
                                                                                                                action="admin"
                                                                                                                method="post"
                                                                                                                style="display:inline;">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="action"
                                                                                                                    value="deleteRoom">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="roomId"
                                                                                                                    value="<%= r.getRoomId() %>">
                                                                                                                <button
                                                                                                                    type="submit"
                                                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                                                    onclick="return confirm('Delete room?');">
                                                                                                                    <i
                                                                                                                        class="fa-solid fa-trash"></i>
                                                                                                                </button>
                                                                                                            </form>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <% }} %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Add Room Modal -->
                                                                <div class="modal fade" id="addRoomModal" tabindex="-1"
                                                                    aria-labelledby="addRoomModalLabel"
                                                                    aria-hidden="true">
                                                                    <div class="modal-dialog">
                                                                        <div class="modal-content">
                                                                            <div class="modal-header">
                                                                                <h5 class="modal-title"
                                                                                    id="addRoomModalLabel">Add New Room
                                                                                </h5>
                                                                                <button type="button" class="btn-close"
                                                                                    data-bs-dismiss="modal"
                                                                                    aria-label="Close"></button>
                                                                            </div>
                                                                            <div class="modal-body">
                                                                                <form action="admin" method="post">
                                                                                    <input type="hidden" name="action"
                                                                                        value="addRoom">
                                                                                    <div class="form-floating mb-3">
                                                                                        <input type="number"
                                                                                            class="form-control"
                                                                                            name="roomNumber"
                                                                                            placeholder="Room Number"
                                                                                            required>
                                                                                        <label>Room Number</label>
                                                                                    </div>
                                                                                    <div class="form-floating mb-3">
                                                                                        <input type="text"
                                                                                            class="form-control"
                                                                                            name="roomType"
                                                                                            placeholder="Room Type"
                                                                                            required>
                                                                                        <label>Room Type (e.g.
                                                                                            Single)</label>
                                                                                    </div>
                                                                                    <div class="form-floating mb-3">
                                                                                        <input type="number" step="0.01"
                                                                                            class="form-control"
                                                                                            name="price"
                                                                                            placeholder="Price"
                                                                                            required>
                                                                                        <label>Price Per Night</label>
                                                                                    </div>
                                                                                    <div class="form-floating mb-3">
                                                                                        <select class="form-select"
                                                                                            name="status">
                                                                                            <option value="Available">
                                                                                                Available</option>
                                                                                            <option value="Maintenance">
                                                                                                Maintenance</option>
                                                                                            <option value="Occupied">
                                                                                                Occupied</option>
                                                                                        </select>
                                                                                        <label>Initial Status</label>
                                                                                    </div>
                                                                                    <div class="d-grid">
                                                                                        <button type="submit"
                                                                                            class="btn btn-primary">Add
                                                                                            Room</button>
                                                                                    </div>
                                                                                </form>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- Edit Room -->
                                                                <% } else if ("editRoom".equals(currentView)) { Room
                                                                    roomToEdit=(Room)
                                                                    request.getAttribute("roomToEdit"); %>
                                                                    <div class="row justify-content-center">
                                                                        <div class="col-md-6">
                                                                            <div class="card shadow">
                                                                                <div
                                                                                    class="card-header bg-white border-0">
                                                                                    <h3 class="mb-0">Edit Room: <%=
                                                                                            roomToEdit.getRoomId() %>
                                                                                    </h3>
                                                                                </div>
                                                                                <div class="card-body">
                                                                                    <form action="admin" method="post">
                                                                                        <input type="hidden"
                                                                                            name="action"
                                                                                            value="updateRoom">
                                                                                        <input type="hidden"
                                                                                            name="roomId"
                                                                                            value="<%= roomToEdit.getRoomId() %>">

                                                                                        <div class="form-floating mb-3">
                                                                                            <input type="number"
                                                                                                class="form-control"
                                                                                                name="roomNumber"
                                                                                                value="<%= roomToEdit.getRoomNumber() %>"
                                                                                                required>
                                                                                            <label>Room Number</label>
                                                                                        </div>

                                                                                        <div class="form-floating mb-3">
                                                                                            <input type="text"
                                                                                                class="form-control"
                                                                                                name="roomType"
                                                                                                value="<%= roomToEdit.getRoomType() %>"
                                                                                                required>
                                                                                            <label>Room Type</label>
                                                                                        </div>
                                                                                        <div class="form-floating mb-3">
                                                                                            <input type="number"
                                                                                                step="0.01"
                                                                                                class="form-control"
                                                                                                name="price"
                                                                                                value="<%= roomToEdit.getPricePerNight() %>"
                                                                                                required>
                                                                                            <label>Price Per
                                                                                                Night</label>
                                                                                        </div>
                                                                                        <div class="form-floating mb-3">
                                                                                            <select class="form-select"
                                                                                                name="status">
                                                                                                <option
                                                                                                    value="Available"
                                                                                                    <%="Available"
                                                                                                    .equals(roomToEdit.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Available</option>
                                                                                                <option value="Occupied"
                                                                                                    <%="Occupied"
                                                                                                    .equals(roomToEdit.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Occupied</option>
                                                                                                <option
                                                                                                    value="Maintenance"
                                                                                                    <%="Maintenance"
                                                                                                    .equals(roomToEdit.getStatus())
                                                                                                    ? "selected" : "" %>
                                                                                                    >Maintenance
                                                                                                </option>
                                                                                            </select>
                                                                                            <label>Status</label>
                                                                                        </div>
                                                                                        <div
                                                                                            class="d-flex justify-content-between">
                                                                                            <a href="admin?view=rooms"
                                                                                                class="btn btn-secondary">Cancel</a>
                                                                                            <button type="submit"
                                                                                                class="btn btn-primary">Update
                                                                                                Room</button>
                                                                                        </div>
                                                                                    </form>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <!-- Guest Management -->
                                                                    <% } else if ("guests".equals(currentView)) { %>
                                                                        <div class="card shadow">
                                                                            <div class="card-header bg-white border-0">
                                                                                <h3 class="mb-0">Guest List</h3>
                                                                            </div>
                                                                            <div class="card-body">
                                                                                <div class="table-responsive">
                                                                                    <table
                                                                                        class="table table-hover align-middle">
                                                                                        <thead>
                                                                                            <tr>
                                                                                                <th>ID</th>
                                                                                                <th>Name</th>
                                                                                                <th>Contact</th>
                                                                                                <th>Email</th>
                                                                                                <th>Action</th>
                                                                                            </tr>
                                                                                        </thead>
                                                                                        <tbody>
                                                                                            <% List<Guest> guests =
                                                                                                (List<Guest>)
                                                                                                    request.getAttribute("guests");
                                                                                                    if (guests != null)
                                                                                                    {
                                                                                                    for (Guest g :
                                                                                                    guests) { %>
                                                                                                    <tr>
                                                                                                        <td>
                                                                                                            <%= g.getGuestId()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= g.getGuestName()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= g.getContactNumber()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <%= g.getEmail()
                                                                                                                %>
                                                                                                        </td>
                                                                                                        <td>
                                                                                                            <form
                                                                                                                action="admin"
                                                                                                                method="post"
                                                                                                                style="display:inline;">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="action"
                                                                                                                    value="deleteGuest">
                                                                                                                <input
                                                                                                                    type="hidden"
                                                                                                                    name="guestId"
                                                                                                                    value="<%= g.getGuestId() %>">
                                                                                                                <button
                                                                                                                    type="submit"
                                                                                                                    class="btn btn-sm btn-outline-danger"
                                                                                                                    onclick="return confirm('Delete guest?');">
                                                                                                                    <i
                                                                                                                        class="fa-solid fa-trash"></i>
                                                                                                                    Delete
                                                                                                                </button>
                                                                                                            </form>
                                                                                                        </td>
                                                                                                    </tr>
                                                                                                    <% }} %>
                                                                                        </tbody>
                                                                                    </table>
                                                                                </div>
                                                                            </div>
                                                                        </div>

                                                                        <!-- Reservation Management -->
                                                                        <% } else if
                                                                            ("reservations".equals(currentView)) { %>
                                                                            <div class="card shadow">
                                                                                <div
                                                                                    class="card-header bg-white border-0">
                                                                                    <h3 class="mb-0">All Reservations
                                                                                    </h3>
                                                                                </div>
                                                                                <div class="card-body">
                                                                                    <div class="table-responsive">
                                                                                        <table
                                                                                            class="table table-hover align-middle">
                                                                                            <thead>
                                                                                                <tr>
                                                                                                    <th>ID</th>
                                                                                                    <th>Guest Email</th>
                                                                                                    <th>Room No</th>
                                                                                                    <th>Dates</th>
                                                                                                    <th>Status</th>
                                                                                                    <th>Action</th>
                                                                                                </tr>
                                                                                            </thead>
                                                                                            <tbody>
                                                                                                <% List<Reservation>
                                                                                                    reservations = (List
                                                                                                    <Reservation>)
                                                                                                        request.getAttribute("reservations");
                                                                                                        if (reservations
                                                                                                        != null) {
                                                                                                        for (Reservation
                                                                                                        res :
                                                                                                        reservations) {
                                                                                                        %>
                                                                                                        <tr>
                                                                                                            <td>
                                                                                                                <%= res.getReservationId()
                                                                                                                    %>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <%= res.getGuestEmail()
                                                                                                                    %>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <%= res.getRoomId()
                                                                                                                    %>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <%= res.getCheckInDate()
                                                                                                                    %>
                                                                                                                    <br><small
                                                                                                                        class="text-muted">to</small>
                                                                                                                    <%= res.getCheckOutDate()
                                                                                                                        %>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <form
                                                                                                                    action="admin"
                                                                                                                    method="post">
                                                                                                                    <input
                                                                                                                        type="hidden"
                                                                                                                        name="action"
                                                                                                                        value="updateReservationStatus">
                                                                                                                    <input
                                                                                                                        type="hidden"
                                                                                                                        name="reservationId"
                                                                                                                        value="<%= res.getReservationId() %>">
                                                                                                                    <select
                                                                                                                        name="status"
                                                                                                                        class="form-select form-select-sm"
                                                                                                                        onchange="this.form.submit()"
                                                                                                                        style="width: 140px; border-color: <%= "Confirmed".equals(res.getStatus())
                                                                                                                        ? "#198754"
                                                                                                                        : "Cancelled"
                                                                                                                        .equals(res.getStatus())
                                                                                                                        ? "#dc3545"
                                                                                                                        : "Checked in"
                                                                                                                        .equalsIgnoreCase(res.getStatus())
                                                                                                                        ? "#0dcaf0"
                                                                                                                        : "#ffc107"
                                                                                                                        %>">
                                                                                                                        <option
                                                                                                                            value="Pending"
                                                                                                                            <%="Pending"
                                                                                                                            .equals(res.getStatus())
                                                                                                                            ? "selected"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                            >Pending
                                                                                                                        </option>
                                                                                                                        <option
                                                                                                                            value="Confirmed"
                                                                                                                            <%="Confirmed"
                                                                                                                            .equals(res.getStatus())
                                                                                                                            ? "selected"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                            >Confirmed
                                                                                                                        </option>
                                                                                                                        <option
                                                                                                                            value="Checked In"
                                                                                                                            <%="Checked In"
                                                                                                                            .equals(res.getStatus())
                                                                                                                            ? "selected"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                            >Checked
                                                                                                                            In
                                                                                                                        </option>
                                                                                                                        <option
                                                                                                                            value="Checked Out"
                                                                                                                            <%="Checked Out"
                                                                                                                            .equals(res.getStatus())
                                                                                                                            ? "selected"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                            >Checked
                                                                                                                            Out
                                                                                                                        </option>
                                                                                                                        <option
                                                                                                                            value="Cancelled"
                                                                                                                            <%="Cancelled"
                                                                                                                            .equals(res.getStatus())
                                                                                                                            ? "selected"
                                                                                                                            : ""
                                                                                                                            %>
                                                                                                                            >Cancelled
                                                                                                                        </option>
                                                                                                                    </select>
                                                                                                                </form>
                                                                                                            </td>
                                                                                                            <td>
                                                                                                                <form
                                                                                                                    action="admin"
                                                                                                                    method="post"
                                                                                                                    style="display:inline;">
                                                                                                                    <input
                                                                                                                        type="hidden"
                                                                                                                        name="action"
                                                                                                                        value="deleteReservation">
                                                                                                                    <input
                                                                                                                        type="hidden"
                                                                                                                        name="reservationId"
                                                                                                                        value="<%= res.getReservationId() %>">
                                                                                                                    <button
                                                                                                                        type="submit"
                                                                                                                        class="btn btn-sm btn-outline-danger"
                                                                                                                        onclick="return confirm('Delete reservation?');">
                                                                                                                        <i
                                                                                                                            class="fa-solid fa-trash"></i>
                                                                                                                    </button>
                                                                                                                </form>
                                                                                                            </td>
                                                                                                        </tr>
                                                                                                        <% }} %>
                                                                                            </tbody>
                                                                                        </table>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                                <!-- /#page-content-wrapper -->

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
                                    /* Reusing global styles, plus sidebar toggle needed for this layout if not in style.css */
                                    #wrapper {
                                        overflow-x: hidden;
                                    }

                                    #sidebar-wrapper {
                                        min-height: 100vh;
                                        margin-left: -15rem;
                                        transition: margin .25s ease-out;
                                        background: linear-gradient(135deg, #2c3e50 0%, #000000 100%);
                                    }

                                    #sidebar-wrapper .sidebar-heading {
                                        padding: 0.875rem 1.25rem;
                                        font-size: 1.2rem;
                                        color: white;
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
                                        color: #bbb;
                                    }

                                    .list-group-item.active {
                                        background-color: rgba(255, 255, 255, 0.1);
                                        color: #fff;
                                        font-weight: bold;
                                        border-left: 4px solid #3498db;
                                    }

                                    .list-group-item:hover {
                                        color: #fff;
                                        background-color: rgba(255, 255, 255, 0.05);
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
