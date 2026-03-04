package com.setmygoal.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url      = System.getenv("DB_URL");
        String username = System.getenv("DB_USERNAME");
        String password = System.getenv("DB_PASSWORD");

        // Fallback for local development
        if (url == null) url      = "jdbc:mysql://jqe3iy.h.filess.io:61031/setmygoal_bitegently?useSSL=false&allowPublicKeyRetrieval=true";
        if (username == null) username = "setmygoal_bitegently";
        if (password == null) password = "b6e23ac82a6b1580d50bb6b23b1d9fdf1a3820fb";

        return DriverManager.getConnection(url, username, password);
    }
}