package app;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Config {

    private static Properties properties;
    private static Connection connection;

    public static void connect(String host, String port, String db, String user, String password) {
        String url =
                "jdbc:mysql://" + host + ":" + port + "/" + db +
                        "?useSSL=false&serverTimezone=UTC";

        System.out.println("=== DB CONNECT START ===");
        System.out.println("URL: " + url);
        System.out.println("USER: " + user);

        try {
            connection = DriverManager.getConnection(url, user, password);
            System.out.println("CONNECTED OK");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("DB FAIL");
        }
    }

    public static void disconnect() {
        try {
            connection.close();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
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
        return connection;
    }

    private Config() {

    }
}
