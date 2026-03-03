<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - Ocean View Resort</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- FontAwesome 6 -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="css/style.css">
    </head>

    <body class="auth-bg">

        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-5">
                    <div class="card auth-card shadow-lg">
                        <div class="auth-header">
                            <i class="fa-solid fa-hotel fa-3x text-primary mb-3"></i>
                            <h2>Welcome Back</h2>
                            <p class="text-muted">Login to Ocean View Resort</p>
                        </div>

                        <% String errorMessage=(String) request.getAttribute("errorMessage"); if (errorMessage !=null) {
                            %>
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-circle-exclamation me-2"></i>
                                <%= errorMessage %>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"
                                        aria-label="Close"></button>
                            </div>
                            <% } %>

                                <form action="login" method="post">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">Username</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fa-solid fa-user"></i></span>
                                            <input type="text" class="form-control" id="username" name="username"
                                                placeholder="Enter username" required>
                                        </div>
                                    </div>
                                    <div class="mb-4">
                                        <label for="password" class="form-label">Password</label>
                                        <div class="input-group">
                                            <span class="input-group-text"><i class="fa-solid fa-lock"></i></span>
                                            <input type="password" class="form-control" id="password" name="password"
                                                placeholder="Enter password" required>
                                        </div>
                                    </div>
                                    <div class="d-grid gap-2">
                                        <button type="submit" class="btn btn-primary btn-lg">
                                            <i class="fa-solid fa-right-to-bracket me-2"></i> Login
                                        </button>
                                    </div>
                                </form>

                                <div class="text-center mt-4">
                                    <p class="mb-0">Don't have an account? <a href="signup.jsp"
                                            class="text-decoration-none fw-bold">Sign Up</a></p>
                                    <p><a href="guest_booking.jsp" class="text-decoration-none text-muted small"><i
                                                class="fa-solid fa-arrow-right"></i> Guest Booking</a></p>
                                </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>