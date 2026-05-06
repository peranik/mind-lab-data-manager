package view;

import javafx.scene.Parent;
import javafx.scene.control.Label;
import javafx.scene.layout.VBox;

public class AdminDashboard {

    public Parent getRoot() {

        Label label = new Label("Uspesno si ulogovan!");

        VBox root = new VBox(label);
        root.setStyle("-fx-padding: 20; -fx-alignment: center;");

        return root;
    }
}
