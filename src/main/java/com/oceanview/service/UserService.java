package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public User login(String username, String password) {
        return userDAO.validateUser(username, password);
    }

    public boolean registerUser(User user) throws java.sql.SQLException, ClassNotFoundException {
        return userDAO.saveUser(user);
    }
}
