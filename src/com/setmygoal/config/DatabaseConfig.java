package com.setmygoal.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Centralized database configuration and connection factory.
 * Uses environment variables when available, with local defaults for development.
 */
public class DatabaseConfig {

    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/setmygoal";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "Adarsh@1708";

    private static final String ENV_URL = "SETMYGOAL_DB_URL";
    private static final String ENV_USERNAME = "SETMYGOAL_DB_USERNAME";
    private static final String ENV_PASSWORD = "SETMYGOAL_DB_PASSWORD";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = getEnvOrDefault(ENV_URL, DEFAULT_URL);
        String username = getEnvOrDefault(ENV_USERNAME, DEFAULT_USERNAME);
        String password = getEnvOrDefault(ENV_PASSWORD, DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, username, password);
    }

    private static String getEnvOrDefault(String envKey, String defaultValue) {
        String value = System.getenv(envKey);
        return (value == null || value.isBlank()) ? defaultValue : value;
    }
}

