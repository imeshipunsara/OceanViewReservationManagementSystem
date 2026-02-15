package com.oceanview.controller;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.oceanview.model.Reservation;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/PdfReportServlet")
public class PdfReportServlet extends HttpServlet {

    private ReservationService reservationService;

    public void init() {
        reservationService = new ReservationService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Date date = new Date(System.currentTimeMillis());
        String type = request.getParameter("type"); // "check_in" or "check_out"
        String title = "Daily Report: " + (type.equals("check_in") ? "Check-Ins" : "Check-Outs");

        List<Reservation> reservations = reservationService.getReservationsByDate(date, type);

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"report_" + type + "_" + date + ".pdf\"");

        try {
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            document.add(new Paragraph(title));
            document.add(new Paragraph("Date: " + date));
            document.add(new Paragraph(" ")); // Spacer

            PdfPTable table = new PdfPTable(5); // 5 columns
            table.addCell("ID");
            table.addCell("Guest ID");
            table.addCell("Room ID");
            table.addCell("Status");
            table.addCell(type.equals("check_in") ? "Check-Out Date" : "Check-In Date");

            for (Reservation r : reservations) {
                table.addCell(String.valueOf(r.getReservationId()));
                table.addCell(String.valueOf(r.getGuestId()));
                table.addCell(String.valueOf(r.getRoomId()));
                table.addCell(r.getStatus());
                table.addCell(String.valueOf(type.equals("check_in") ? r.getCheckOutDate() : r.getCheckInDate()));
            }

            document.add(table);
            document.close();
        } catch (DocumentException e) {
            throw new IOException(e);
        }
    }
}
