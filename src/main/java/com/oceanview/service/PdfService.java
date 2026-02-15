package com.oceanview.service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.oceanview.model.Bill;
import com.oceanview.model.ExtraCharge;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;

import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PdfService {

    public String generateBillPdf(Bill bill, Reservation reservation, Guest guest) throws Exception {
        String userHome = System.getProperty("user.home");
        String documentsPath = userHome + File.separator + "Documents" + File.separator + "OceanView_Bills";
        File dir = new File(documentsPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String fileName = "Bill_" + bill.getBillId() + "_" + reservation.getReservationId() + ".pdf";
        String filePath = documentsPath + File.separator + fileName;

        Document document = new Document();
        PdfWriter.getInstance(document, new FileOutputStream(filePath));
        document.open();

        // Fonts
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18, BaseColor.BLACK);
        Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.BLACK);
        Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);

        // Header
        Paragraph title = new Paragraph("OCEAN VIEW RESORT - INVOICE", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph(" "));

        // Info Section
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);

        infoTable.addCell(getLabelCell("Bill ID:", headerFont));
        infoTable.addCell(getValueCell(String.valueOf(bill.getBillId()), normalFont));

        infoTable.addCell(getLabelCell("Guest Name:", headerFont));
        infoTable.addCell(getValueCell(guest.getGuestName(), normalFont));

        infoTable.addCell(getLabelCell("Guest Email:", headerFont));
        infoTable.addCell(getValueCell(guest.getEmail(), normalFont));

        infoTable.addCell(getLabelCell("Room Number:", headerFont));
        infoTable.addCell(getValueCell(String.valueOf(reservation.getRoomNumber()), normalFont));

        infoTable.addCell(getLabelCell("Check-in Date:", headerFont));
        infoTable.addCell(getValueCell(reservation.getCheckInDate().toString(), normalFont));

        infoTable.addCell(getLabelCell("Check-out Date:", headerFont));
        infoTable.addCell(getValueCell(reservation.getCheckOutDate().toString(), normalFont));

        infoTable.addCell(getLabelCell("Nights Stayed:", headerFont));
        infoTable.addCell(getValueCell(String.valueOf(bill.getNumberOfNights()), normalFont));

        document.add(infoTable);
        document.add(new Paragraph(" "));

        // Charges Table
        PdfPTable chargesTable = new PdfPTable(4);
        chargesTable.setWidthPercentage(100);
        chargesTable.setSpacingBefore(10f);
        chargesTable.setSpacingAfter(10f);

        // Columns
        chargesTable.addCell(getHeaderCell("Item Description", headerFont));
        chargesTable.addCell(getHeaderCell("Price", headerFont));
        chargesTable.addCell(getHeaderCell("Qty", headerFont));
        chargesTable.addCell(getHeaderCell("Subtotal", headerFont));

        // Room Charge
        chargesTable.addCell(new Phrase("Room Charge (" + bill.getNumberOfNights() + " nights)", normalFont));
        chargesTable.addCell(new Phrase("-", normalFont));
        chargesTable.addCell(new Phrase("-", normalFont));
        chargesTable.addCell(new Phrase(bill.getRoomCharge().toString(), normalFont));

        // Extra Charges
        for (ExtraCharge ec : bill.getExtraCharges()) {
            chargesTable.addCell(new Phrase(ec.getItemName(), normalFont));
            chargesTable.addCell(new Phrase(ec.getPrice().toString(), normalFont));
            chargesTable.addCell(new Phrase(String.valueOf(ec.getQuantity()), normalFont));
            chargesTable.addCell(new Phrase(ec.getSubtotal().toString(), normalFont));
        }

        document.add(chargesTable);

        // Footer / Totals
        Paragraph totals = new Paragraph();
        totals.setAlignment(Element.ALIGN_RIGHT);
        totals.add(new Phrase("Extra Charges Total: " + bill.getExtraChargesTotal().toString() + "\n", headerFont));
        totals.add(new Phrase("GRAND TOTAL: " + bill.getTotalAmount().toString() + "\n", titleFont));
        document.add(totals);

        document.add(new Paragraph(" "));
        Paragraph datePara = new Paragraph(
                "Generated on: " + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()), normalFont);
        datePara.setAlignment(Element.ALIGN_RIGHT);
        document.add(datePara);

        document.close();
        return filePath;
    }

    private PdfPCell getLabelCell(String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
        cell.setBorder(Rectangle.NO_BORDER);
        return cell;
    }

    private PdfPCell getValueCell(String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
        cell.setBorder(Rectangle.NO_BORDER);
        return cell;
    }

    private PdfPCell getHeaderCell(String text, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(5);
        return cell;
    }
}
