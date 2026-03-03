<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Login - Ocean View Resort</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="glass-panel">
            <h2 style="text-align: center;">Ocean View Resort</h2>
            <h3 style="text-align: center;">Staff Login</h3>

            <% String error=(String) request.getAttribute("errorMessage"); if (error !=null) { %>
                <div class="alert">
                    <%= error %>
                </div>
                <% } %>

                    <form action="login" method="post">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn" style="width: 100%;">Login</button>
                    </form>

                    <a href="guest_booking.jsp">Guest Online Booking</a> | <a href="signup.jsp">Sign Up</a>
                    </p>
        </div>
    </body>

    </html>