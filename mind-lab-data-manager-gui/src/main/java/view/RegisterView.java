package view;

import app.SceneManager;
import data.UserFileDB;
import javafx.scene.Parent;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;

public class RegisterView {

    public Parent getRoot() {

        TextField username = new TextField();
        username.setPromptText("Username");

        PasswordField password = new PasswordField();
        password.setPromptText("Password");

        Button registerBtn = new Button("Register");
        Button backBtn = new Button("Back");

        Label msg = new Label();

        VBox root = new VBox(10, username, password, registerBtn, backBtn, msg);
        root.setStyle("-fx-padding: 20;");

        registerBtn.setOnAction(e -> {

            String u = username.getText();
            String p = password.getText();

            if (u.isEmpty() || p.isEmpty()) {
                msg.setText("Popuni polja!");
                return;
            }

            if (UserFileDB.register(u, p)) {
                msg.setText("Uspešna registracija!");
            } else {
                msg.setText("Korisnik već postoji!");
            }
        });

        backBtn.setOnAction(e -> SceneManager.showLogin());

        return root;
    }
}
