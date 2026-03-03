package com.oceanview.controller;

import com.oceanview.model.User;
import com.oceanview.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/signup")
public class SignupServlet extends HttpServlet {

    private UserService userService;

    public void init() {
        userService = new UserService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Actually, we should check if username exists.
        // For simplicity reusing login check or just try to register and catch error if
        // unique constraint violation.
        // Let's implement registerUser in service which will handle it.

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRole(role);

        try {
            boolean isRegistered = userService.registerUser(newUser);

            if (isRegistered) {
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 1062) { // MySQL Duplicate Entry error code
                request.setAttribute("errorMessage", "Username already exists. Please choose another one.");
            } else {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("signup.jsp").forward(request, response);
    }
}
