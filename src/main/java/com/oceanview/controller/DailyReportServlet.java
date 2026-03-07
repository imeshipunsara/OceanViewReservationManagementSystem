package com.oceanview.controller;

import com.oceanview.service.ReservationService;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/DailyReportServlet")
public class DailyReportServlet extends HttpServlet {

    private ReservationService reservationService;

    public void init() {
        reservationService = new ReservationService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Date today = new Date(System.currentTimeMillis());

        List<Reservation> checkIns = reservationService.getReservationsByDate(today, "check_in");
        List<Reservation> checkOuts = reservationService.getReservationsByDate(today, "check_out");

        request.setAttribute("checkIns", checkIns);
        request.setAttribute("checkOuts", checkOuts);
        request.setAttribute("reportDate", today);

        request.getRequestDispatcher("daily_report.jsp").forward(request, response);
    }
}
