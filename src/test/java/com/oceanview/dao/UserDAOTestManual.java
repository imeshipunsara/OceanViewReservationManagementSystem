package com.oceanview.dao;

import com.oceanview.model.User;

public class UserDAOTestManual {
    public static void main(String[] args) {
        System.out.println("Starting UserDAO Manual Test...");
        UserDAO userDAO = new UserDAO();
        User newUser = new User();
        newUser.setUsername("testdebug_" + System.currentTimeMillis());
        newUser.setPassword("password123");
        newUser.setRole("Staff");

        System.out.println("Attempting to save user: " + newUser.getUsername());
        try {
            boolean success = userDAO.saveUser(newUser);

            if (success) {
                System.out.println("SUCCESS: User saved successfully.");
            } else {
                System.out.println("FAILURE: User could not be saved.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("FAILURE: Exception " + e.getMessage());
        }
    }
}
