<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Guest Booking - Ocean View Resort</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="container">
            <header style="margin-bottom: 2rem;">
                <h1>Ocean View Resort - Book Your Stay</h1>
                <a href="login.jsp" class="btn" style="background-color: #7f8c8d;">Staff Login</a>
            </header>

            <div class="card">
                <p>Welcome! Please inspect our rooms and book online.</p>

                <form action="reservation" method="post">
                    <!-- Simplified guest flow: Assuming Guest exists for demo or auto-create logic needed -->
                    <!-- For complete Task B.7, this would have guest registration fields -->
                    <h3>Guest Details</h3>
                    <div class="form-group">
                        <label>Guest ID (Existing)</label>
                        <input type="number" name="guestId" required>
                    </div>

                    <h3>Booking Details</h3>
                    <div class="form-group">
                        <label>Room ID</label>
                        <input type="number" name="roomId" required>
                    </div>
                    <div class="form-group">
                        <label>Check-In</label>
                        <input type="date" name="checkInDate" required>
                    </div>
                    <div class="form-group">
                        <label>Check-Out</label>
                        <input type="date" name="checkOutDate" required>
                    </div>
                    <button type="submit" class="btn">Book Now</button>
                </form>
            </div>
        </div>
    </body>
    <footer style="text-align: center; margin-top: 2rem; padding: 1rem; background-color: #f4f4f4;">
        <a href="login.jsp" style="text-decoration: none; color: #333;">Admin Login</a>
    </footer>

    </html>