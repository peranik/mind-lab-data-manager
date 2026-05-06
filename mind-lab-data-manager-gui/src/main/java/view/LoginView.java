package view;

import app.SceneManager;
import data.UserFileDB;
import javafx.scene.Parent;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;

public class LoginView {

    public Parent getRoot() {

        TextField username = new TextField();
        username.setPromptText("Username");

        PasswordField password = new PasswordField();
        password.setPromptText("Password");

        Button loginBtn = new Button("Login");
        Button registerBtn = new Button("Sign up");

        Label error = new Label();

        VBox root = new VBox(10, username, password, loginBtn, registerBtn, error);
        root.setStyle("-fx-padding: 20;");

        loginBtn.setOnAction(e -> {

            String u = username.getText();
            String p = password.getText();

            if (u.isEmpty() || p.isEmpty()) {
                error.setText("Popuni polja!");
                return;
            }

            if (UserFileDB.login(u, p)) {
                SceneManager.showDashboard();
            } else {
                error.setText("Pogrešni podaci!");
            }
        });

        registerBtn.setOnAction(e -> {
            SceneManager.showRegister();
        });

        return root;
    }
}
