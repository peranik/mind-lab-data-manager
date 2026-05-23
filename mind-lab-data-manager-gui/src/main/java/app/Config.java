package app;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Config {

    private static Properties properties;
    private static String host;
    private static String port;
    private static String database;
    private static String username;
    private static String password;

    public static void connect(String host, String port, String db, String user, String password) {
        Config.host = host;
        Config.port = port;
        Config.database = db;
        Config.username = user;
        Config.password = password;
    }

    public static void disconnect() {
        // No-op: connections are opened and closed per database operation.
    }

    public static void loadProperties(String cfgFile) {
        properties = new Properties();
        try (FileInputStream fileInputStream = new FileInputStream(cfgFile)) {
            properties.load(fileInputStream);
        } catch (IOException e) {
            throw new RuntimeException("Could not load config file: " + cfgFile, e);
        }
    }

    public static String getPropertyValue(String property, String defaultValue) {
        return properties.getProperty(property, defaultValue);
    }

    public static Connection getConnection() {
        validateSettings();

        try {
            return DriverManager.getConnection(buildUrl(), username, password);
        } catch (SQLException e) {
            throw new RuntimeException("Could not open database connection.", e);
        }
    }

    private static String buildUrl() {
        return "jdbc:mysql://" + host + ":" + port + "/" + database +
                "?useSSL=false&serverTimezone=UTC";
    }

    private static void validateSettings() {
        if (host == null || port == null || database == null || username == null || password == null) {
            throw new IllegalStateException("Database connection settings are not initialized.");
        }
    }

    private Config() {

    }
}
