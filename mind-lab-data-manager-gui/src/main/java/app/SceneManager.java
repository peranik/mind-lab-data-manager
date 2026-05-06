package app;

import javafx.scene.Scene;
import javafx.stage.Stage;
import view.AdminDashboard;
import view.LoginView;
import view.RegisterView;

public class SceneManager {
    private static Stage stage;

    public static void init(Stage s) {
        stage = s;
    }

    public static void showLogin() {
        stage.setScene(new Scene(new LoginView().getRoot(), 400, 250));
        stage.setTitle("Login");
        stage.show();
    }

    public static void showDashboard() {
        stage.setScene(new Scene(new AdminDashboard().getRoot(), 600, 400));
        stage.setTitle("Admin Panel");
    }

    public static void showRegister() {
        stage.setScene(new Scene(new RegisterView().getRoot(), 400, 250));
        stage.setTitle("Register");
    }
}
