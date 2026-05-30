package view;

import app.Config;
import database.AlatDAO;
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
import model.Alat;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.List;

public class DodajAlatSesijaView {
    public void show(int idSesije) {
        HBox root = new HBox();
        Scene scene = new Scene(root, 320, 180);

        Label alatLabel = new Label("Izaberi alat:");
        ComboBox<Alat> alatComboBox = new ComboBox<>();
        List<Alat> alati = AlatDAO.getDostupniAlatiZaSesiju(idSesije);
        alatComboBox.setItems(FXCollections.observableArrayList(alati));

        Button btnDodajAlat = new Button("Dodaj alat");
        btnDodajAlat.setOnAction(actionEvent -> {
            Alat izabraniAlat = alatComboBox.getSelectionModel().getSelectedItem();

            if (izabraniAlat == null) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText("Izaberi alat.");
                alert.showAndWait();
                return;
            }

            String sql = "{CALL dodaj_alat_u_sesiju(?, ?, ?)}";

            try (Connection conn = Config.getConnection();
                 CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, idSesije);
                cs.setInt(2, izabraniAlat.getAlatId());
                cs.registerOutParameter(3, java.sql.Types.VARCHAR);
                cs.execute();

                String poruka = cs.getString(3);
                Alert alert = new Alert("Uspesno dodat alat".equals(poruka)
                        ? Alert.AlertType.INFORMATION
                        : Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText(poruka);
                alert.showAndWait();

                if ("Uspesno dodat alat".equals(poruka)) {
                    ((Stage) btnDodajAlat.getScene().getWindow()).close();
                }
            } catch (Exception ex) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText("Greska pri dodavanju alata");
                alert.setContentText(ex.getMessage());
                alert.showAndWait();
            }
        });

        VBox vbox = new VBox();
        vbox.getChildren().addAll(alatLabel, alatComboBox, btnDodajAlat);
        vbox.setSpacing(10);
        root.setAlignment(Pos.CENTER);
        root.setSpacing(20);
        root.getChildren().addAll(vbox);
        Stage stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
