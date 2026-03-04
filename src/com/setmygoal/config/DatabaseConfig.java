package com.setmygoal.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {

    private static final String URL      = "jdbc:mysql://jqe3iy.h.filess.io:61031/setmygoal_bitegently?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "setmygoal_bitegently";
    private static final String PASSWORD = "b6e23ac82a6b1580d50bb6b23b1d9fdf1a3820fb";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}