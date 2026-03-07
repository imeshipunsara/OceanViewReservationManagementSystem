package com.oceanview.service;

import com.oceanview.model.Reservation;
import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EmailService {

    private static final String FROM_EMAIL = "punsaragunarathna498@gmail.com";
    private static final String PASSWORD = "nltr jmtg zzwn nytg"; // App Password
    private static final String HOST = "smtp.gmail.com";
    private static final String PORT = "587";

    public static void sendBookingConfirmation(Reservation reservation) {
        if (reservation.getGuestEmail() == null || reservation.getGuestEmail().isEmpty()) {
            System.out.println("No guest email found for reservation ID: " + reservation.getReservationId());
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", HOST);
        props.put("mail.smtp.port", PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(reservation.getGuestEmail()));
            message.setSubject("Booking Confirmed - Ocean View Resort");

            String content = "Dear Guest,\n\n"
                    + "Your booking (ID: " + reservation.getReservationId() + ") has been confirmed.\n"
                    + "Room Number: " + reservation.getRoomNumber() + "\n"
                    + "Check-in: " + reservation.getCheckInDate() + "\n"
                    + "Check-out: " + reservation.getCheckOutDate() + "\n\n"
                    + "We look forward to seeing you!\n\n"
                    + "Best regards,\n"
                    + "Ocean View Resort Team";

            message.setText(content);

            Transport.send(message);
            System.out.println("Confirmation email sent to: " + reservation.getGuestEmail());

        } catch (MessagingException e) {
            e.printStackTrace();
            System.out.println("Failed to send email to: " + reservation.getGuestEmail());
        }
    }
}
