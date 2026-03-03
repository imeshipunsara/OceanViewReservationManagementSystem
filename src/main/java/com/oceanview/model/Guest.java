package com.oceanview.model;

public class Guest {
    private int guestId;
    private String guestName;
    private String address;
    private String contactNumber;
    private String email;

    public Guest() {
    }

    public Guest(int guestId, String guestName, String address, String contactNumber, String email) {
        this.guestId = guestId;
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.email = email;
    }

    public int getGuestId() {
        return guestId;
    }

    public void setGuestId(int guestId) {
        this.guestId = guestId;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
