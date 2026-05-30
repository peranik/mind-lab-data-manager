package view;

import app.Config;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.sql.CallableStatement;
import java.sql.Connection;

public class PromeniStatusIzvodjenjaView {
    public void show(int idSesije, String statusIzvodjenja) {
        HBox root = new HBox();
        Scene scene = new Scene(root, 260, 150);

        TextField statusText = new TextField(statusIzvodjenja);
        Label statusLabel = new Label("Status izvodjenja:");
        Button btnPromeniStatus = new Button("Promeni status");
        btnPromeniStatus.setOnAction(actionEvent -> {
            String sql = "{CALL izmeni_status_izvodjenja(?, ?, ?)}";

            try (Connection conn = Config.getConnection();
                 CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, idSesije);
                cs.setString(2, statusText.getText().trim());
                cs.registerOutParameter(3, java.sql.Types.VARCHAR);
                cs.execute();

                String poruka = cs.getString(3);
                Alert alert = new Alert("Uspesno izmenjeno".equals(poruka)
                        ? Alert.AlertType.INFORMATION
                        : Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText(poruka);
                alert.showAndWait();

                if ("Uspesno izmenjeno".equals(poruka)) {
                    ((Stage) btnPromeniStatus.getScene().getWindow()).close();
                }
            } catch (Exception ex) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText("Greska pri izmeni statusa");
                alert.setContentText(ex.getMessage());
                alert.showAndWait();
            }
        });
        VBox vbox = new VBox();
        vbox.getChildren().addAll(statusLabel, statusText, btnPromeniStatus);
        vbox.setSpacing(10);
        root.setAlignment(Pos.CENTER);
        root.setSpacing(20);
        root.getChildren().addAll(vbox);
        Stage stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
