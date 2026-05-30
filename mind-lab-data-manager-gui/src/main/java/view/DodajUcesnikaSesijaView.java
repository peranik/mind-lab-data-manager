package view;

import app.Config;
import database.ParticipantDAO;
import javafx.collections.FXCollections;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import model.Participant;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

public class DodajUcesnikaSesijaView {
    public void show(int idSesije) {
        HBox root = new HBox();
        Scene scene = new Scene(root, 320, 180);

        Label ucesnikLabel = new Label("Izaberi učesnika:");
        ComboBox<Participant> ucesnikComboBox = new ComboBox<>();
        List<Participant> ucesnici = ParticipantDAO.getDostupniUcesniciZaSesiju(idSesije);
        ucesnikComboBox.setItems(FXCollections.observableArrayList(ucesnici));

        Button btnDodajUcesnika = new Button("Dodaj učesnika");
        btnDodajUcesnika.setOnAction(actionEvent -> {
            Participant izabraniUcesnik = ucesnikComboBox.getSelectionModel().getSelectedItem();

            if (izabraniUcesnik == null) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText("Izaberi učesnika.");
                alert.showAndWait();
                return;
            }

            String sql = "{CALL dodaj_ucesnika_u_sesiju(?, ?, ?)}";

            try (Connection conn = Config.getConnection();
                 CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, idSesije);
                cs.setInt(2, izabraniUcesnik.getId());
                cs.registerOutParameter(3, java.sql.Types.VARCHAR);
                cs.execute();

                String poruka = cs.getString(3);
                Alert alert = new Alert("Uspesno dodat ucesnik".equals(poruka)
                        ? Alert.AlertType.INFORMATION
                        : Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText(poruka);
                alert.showAndWait();

                if ("Uspesno dodat ucesnik".equals(poruka)) {
                    ((Stage) btnDodajUcesnika.getScene().getWindow()).close();
                }
            } catch (Exception ex) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText("Greska pri dodavanju učesnika");
                alert.setContentText(ex.getMessage());
                alert.showAndWait();
            }
        });

        VBox vbox = new VBox();
        vbox.getChildren().addAll(ucesnikLabel, ucesnikComboBox, btnDodajUcesnika);
        vbox.setSpacing(10);
        root.setAlignment(Pos.CENTER);
        root.setSpacing(20);
        root.getChildren().addAll(vbox);
        Stage stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
