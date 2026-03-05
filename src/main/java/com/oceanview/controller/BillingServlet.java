package com.oceanview.controller;

import com.oceanview.dao.GuestDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.*;
import com.oceanview.service.BillingService;
import com.oceanview.service.PdfService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/billing")
public class BillingServlet extends HttpServlet {
    private BillingService billingService;
    private PdfService pdfService;
    private ReservationDAO reservationDAO;
    private GuestDAO guestDAO;
    private RoomDAO roomDAO;

    public void init() {
        billingService = new BillingService();
        pdfService = new PdfService();
        reservationDAO = new ReservationDAO();
        guestDAO = new GuestDAO();
        roomDAO = new RoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("preview".equals(action)) {
            int resId = Integer.parseInt(request.getParameter("reservationId"));
            Reservation res = reservationDAO.getReservationById(resId);
            Room room = roomDAO.getRoomById(res.getRoomId());
            long nights = billingService.calculateNights(res.getCheckInDate(), res.getCheckOutDate());
            if (nights <= 0)
                nights = 1;

            response.setContentType("application/json");
            response.getWriter().write(String.format(
                    "{\"nights\": %d, \"pricePerNight\": %s, \"roomCharge\": %s}",
                    nights, room.getPricePerNight().toString(),
                    room.getPricePerNight().multiply(new BigDecimal(nights)).toString()));
        } else if ("history".equals(action)) {
            // Forward to bills.jsp
            request.getRequestDispatcher("bills.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            try {
                int resId = Integer.parseInt(request.getParameter("reservationId"));
                String[] itemNames = request.getParameterValues("itemName[]");
                String[] prices = request.getParameterValues("itemPrice[]");
                String[] quantities = request.getParameterValues("itemQty[]");

                List<ExtraCharge> extraCharges = new ArrayList<>();
                if (itemNames != null) {
                    for (int i = 0; i < itemNames.length; i++) {
                        if (itemNames[i] != null && !itemNames[i].isEmpty()) {
                            ExtraCharge ec = new ExtraCharge();
                            ec.setItemName(itemNames[i]);
                            ec.setPrice(new BigDecimal(prices[i]));
                            ec.setQuantity(Integer.parseInt(quantities[i]));
                            extraCharges.add(ec);
                        }
                    }
                }

                Bill bill = billingService.generateBill(resId, extraCharges);
                Reservation res = reservationDAO.getReservationById(resId);
                Guest guest = guestDAO.getGuestById(res.getGuestId());
                if (guest == null)
                    throw new Exception("Guest not found for ID: " + res.getGuestId());

                String pdfPath = pdfService.generateBillPdf(bill, res, guest);

                response.setContentType("application/json");
                response.getWriter().write(String.format(
                        "{\"success\": true, \"billId\": %d, \"total\": %s, \"pdfPath\": \"%s\"}",
                        bill.getBillId(), bill.getTotalAmount().toString(), pdfPath.replace("\\", "\\\\")));
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(500);
                response.getWriter()
                        .write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            }
        } else if ("pay".equals(action)) {
            try {
                String billIdStr = request.getParameter("billId");
                String method = request.getParameter("method");
                String amountStr = request.getParameter("amount");

                System.out.println(
                        "DEBUG: checkout/pay - billId=" + billIdStr + ", method=" + method + ", amount=" + amountStr);

                if (billIdStr == null || billIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Bill ID is missing");
                }
                if (amountStr == null || amountStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("Amount is missing");
                }

                int billId = Integer.parseInt(billIdStr);
                BigDecimal amount = new BigDecimal(amountStr);

                boolean success = billingService.processPayment(billId, method, amount);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(500);
                response.getWriter()
                        .write("{\"success\": false, \"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\"}");
            }
        }
    }
}
