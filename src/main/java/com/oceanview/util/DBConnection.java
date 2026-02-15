package com.oceanview.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/ocean_view_resort?useSSL=false&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "toor";

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println(
                    "CRITICAL ERROR: MySQL JDBC Driver not found! Ensure it is defined in pom.xml and deployed to WEB-INF/lib.");
            e.printStackTrace();
            throw e;
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
