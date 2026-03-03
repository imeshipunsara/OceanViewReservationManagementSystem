<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Sign Up - Ocean View Resort</title>
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body>
        <div class="glass-panel">
            <h2 style="text-align: center;">Ocean View Resort</h2>
            <h3 style="text-align: center;">Staff Registration</h3>

            <% String error=(String) request.getAttribute("errorMessage"); if (error !=null) { %>
                <div class="alert">
                    <%= error %>
                </div>
                <% } %>

                    <form action="signup" method="post">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" id="username" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" id="password" name="password" required>
                        </div>
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required style="width: 100%; padding: 0.5rem;">
                                <option value="Staff">Staff</option>
                                <option value="Admin">Admin</option>
                            </select>
                        </div>
                        <button type="submit" class="btn" style="width: 100%;">Sign Up</button>
                    </form>

                    <p style="text-align: center; margin-top: 1rem;">
                        Already have an account? <a href="login.jsp">Login</a>
                    </p>
        </div>
    </body>

    </html>