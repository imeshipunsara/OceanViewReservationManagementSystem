<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="com.oceanview.model.Room" %>
        <%@ page import="java.util.List" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Book a Room - Ocean View Resort</title>
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- FontAwesome 6 -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <!-- Custom CSS -->
                <link rel="stylesheet" href="css/style.css">
                <style>
                    .hero-section {
                        background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
                        background-size: cover;
                        background-position: center;
                        height: 400px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: white;
                        text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.6);
                    }

                    .room-card {
                        transition: transform 0.3s;
                    }

                    .room-card:hover {
                        transform: translateY(-5px);
                    }
                </style>
            </head>

            <body>

                <!-- Navbar -->
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow">
                    <div class="container">
                        <a class="navbar-brand fw-bold" href="#"><i class="fa-solid fa-umbrella-beach me-2"></i>Ocean
                            View Resort</a>
                        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                            data-bs-target="#navbarNav">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarNav">
                            <ul class="navbar-nav ms-auto">
                                <li class="nav-item"><a class="nav-link active" href="guest_booking.jsp">Book Now</a>
                                </li>
                                <li class="nav-item"><a class="nav-link" href="login.jsp">Staff Login</a></li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <!-- Hero Section -->
                <header class="hero-section text-center">
                    <div>
                        <h1 class="display-3 fw-bold">Experience Luxury</h1>
                        <p class="lead">Book your perfect getaway today</p>
                    </div>
                </header>

                <div class="container my-5">

                    <% String message=(String) request.getAttribute("message"); if (message !=null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fa-solid fa-check-circle me-2"></i>
                            <%= message %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                        </div>
                        <% } %>

                            <% String error=(String) request.getAttribute("errorMessage"); if (error !=null) { %>
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fa-solid fa-circle-exclamation me-2"></i>
                                    <%= error %>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert"
                                            aria-label="Close"></button>
                                </div>
                                <% } %>

                                    <div class="row g-5">
                                        <!-- Booking Form -->
                                        <div class="col-lg-4">
                                            <div class="card shadow border-0 position-sticky" style="top: 2rem;">
                                                <div class="card-header bg-primary text-white text-center py-3">
                                                    <h4 class="mb-0">Check Availability</h4>
                                                </div>
                                                <div class="card-body p-4">
                                                    <form action="guestBooking" method="post">
                                                        <input type="hidden" name="action" value="book">

                                                        <h5 class="mb-3 text-muted border-bottom pb-2">Your Details</h5>
                                                        <div class="form-floating mb-3">
                                                            <input type="text" class="form-control" id="name"
                                                                name="guestName" placeholder="Full Name" required>
                                                            <label for="name">Full Name</label>
                                                        </div>
                                                        <div class="form-floating mb-3">
                                                            <input type="email" class="form-control" id="email"
                                                                name="email" placeholder="Email" required>
                                                            <label for="email">Email Address</label>
                                                        </div>
                                                        <div class="form-floating mb-3">
                                                            <input type="tel" class="form-control" id="phone"
                                                                name="contactNumber" placeholder="Phone" required>
                                                            <label for="phone">Phone Number</label>
                                                        </div>

                                                        <h5 class="mb-3 mt-4 text-muted border-bottom pb-2">Stay Details
                                                        </h5>
                                                        <div class="form-floating mb-3">
                                                            <select class="form-select" id="roomType" name="roomType"
                                                                required>
                                                                <option value="" selected disabled>Select a Room Type...
                                                                </option>
                                                                <% List<String> roomTypes = (List<String>)
                                                                        request.getAttribute("roomTypes");
                                                                        if (roomTypes != null) {
                                                                        for(String type : roomTypes) {
                                                                        %>
                                                                        <option value="<%= type %>">
                                                                            <%= type %>
                                                                        </option>
                                                                        <% } } else { /* Fallback if list is missing
                                                                            (e.g. direct JSP access) */ %>
                                                                            <option value="Single">Single</option>
                                                                            <option value="Double">Double</option>
                                                                            <option value="Suite">Suite</option>
                                                                            <% } %>
                                                            </select>
                                                            <label for="roomType">Room Preference</label>
                                                        </div>

                                                        <div class="row g-2">
                                                            <div class="col-6">
                                                                <div class="form-floating mb-3">
                                                                    <input type="date" class="form-control" id="checkIn"
                                                                        name="checkInDate" required>
                                                                    <label for="checkIn">Check In</label>
                                                                </div>
                                                            </div>
                                                            <div class="col-6">
                                                                <div class="form-floating mb-3">
                                                                    <input type="date" class="form-control"
                                                                        id="checkOut" name="checkOutDate" required>
                                                                    <label for="checkOut">Check Out</label>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div class="d-grid mt-4">
                                                            <button type="submit" class="btn btn-primary btn-lg">Book
                                                                Now</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Room Showcase -->
                                        <div class="col-lg-8">
                                            <h3 class="mb-4 pb-2 border-bottom">Our Rooms</h3>

                                            <div class="card mb-4 room-card shadow-sm border-0">
                                                <div class="row g-0">
                                                    <div class="col-md-4">
                                                        <img src="https://images.unsplash.com/photo-1631049307264-da0ec9d70304?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"
                                                            class="img-fluid rounded-start h-100"
                                                            style="object-fit: cover;" alt="Single Room">
                                                    </div>
                                                    <div class="col-md-8">
                                                        <div class="card-body">
                                                            <h5 class="card-title text-primary">Single Room</h5>
                                                            <p class="card-text text-muted">Perfect for solo travelers.
                                                                A cozy retreat with a queen-sized bed, en-suite
                                                                bathroom, and a balcony with a garden view.</p>
                                                            <p class="card-text"><small class="text-body-secondary"><i
                                                                        class="fa-solid fa-wifi me-2"></i>Free Wifi
                                                                    &nbsp; <i class="fa-solid fa-tv me-2"></i>TV</small>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card mb-4 room-card shadow-sm border-0">
                                                <div class="row g-0">
                                                    <div class="col-md-4">
                                                        <img src="https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"
                                                            class="img-fluid rounded-start h-100"
                                                            style="object-fit: cover;" alt="Double Room">
                                                    </div>
                                                    <div class="col-md-8">
                                                        <div class="card-body">
                                                            <h5 class="card-title text-primary">Double Room</h5>
                                                            <p class="card-text text-muted">Ideal for couples. Spacious
                                                                room with a king-sized bed, modern amenities, and a
                                                                breathtaking ocean view.</p>
                                                            <p class="card-text"><small class="text-body-secondary"><i
                                                                        class="fa-solid fa-wifi me-2"></i>Free Wifi
                                                                    &nbsp; <i class="fa-solid fa-water me-2"></i>Ocean
                                                                    View</small></p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="card mb-4 room-card shadow-sm border-0">
                                                <div class="row g-0">
                                                    <div class="col-md-4">
                                                        <img src="https://images.unsplash.com/photo-1578683010236-d716f9a3f461?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80"
                                                            class="img-fluid rounded-start h-100"
                                                            style="object-fit: cover;" alt="Suite">
                                                    </div>
                                                    <div class="col-md-8">
                                                        <div class="card-body">
                                                            <h5 class="card-title text-primary">Luxury Suite</h5>
                                                            <p class="card-text text-muted">The ultimate experience.
                                                                Includes a separate living area, private jacuzzi, and
                                                                premium room service.</p>
                                                            <p class="card-text"><small class="text-body-secondary"><i
                                                                        class="fa-solid fa-star me-2"></i>Premium &nbsp;
                                                                    <i
                                                                        class="fa-solid fa-hot-tub-person me-2"></i>Jacuzzi</small>
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                </div>

                <footer class="bg-dark text-white text-center py-4 mt-5">
                    <div class="container">
                        <p class="mb-0">&copy; 2026 Ocean View Resort. All Rights Reserved.</p>
                    </div>
                </footer>

                <!-- Bootstrap JS Bundle -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>