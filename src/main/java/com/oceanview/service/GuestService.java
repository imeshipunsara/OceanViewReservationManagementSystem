package com.oceanview.service;

import com.oceanview.dao.GuestDAO;
import com.oceanview.model.Guest;

public class GuestService {

    private GuestDAO guestDAO;

    public GuestService() {
        this.guestDAO = new GuestDAO();
    }

    public int addGuest(Guest guest) {
        return guestDAO.addGuest(guest);
    }

    public Guest getGuestByEmail(String email) {
        return guestDAO.getGuestByEmail(email);
    }

    public Guest getGuestByContactNumber(String contactNumber) {
        return guestDAO.getGuestByContactNumber(contactNumber);
    }
}
