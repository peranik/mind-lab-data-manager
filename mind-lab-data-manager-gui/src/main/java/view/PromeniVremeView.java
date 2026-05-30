package view;

import app.Config;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import javafx.scene.control.TextField;
import javafx.scene.control.Label;
import javafx.scene.control.Button;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Time;

public class PromeniVremeView {
    public void show(int idSesije, Time vremePocetka, Time vremeZavrsetka) {
        HBox root = new HBox();
        Scene scene = new Scene(root, 260, 200);

        TextField vremePocetkaText = new TextField(vremePocetka.toString());
        TextField vremeZavrsetkaText = new TextField(vremeZavrsetka.toString());
        Label vremePocetkaLabel = new Label("Vreme pocetka:");
        Label vremeZavrsetkaLabel = new Label("Vreme zavrsetka:");
        Button btnPromeniVreme = new Button("Promeni vreme");
        btnPromeniVreme.setOnAction(actionEvent -> {
            String sql = "{CALL izmeni_vreme_sesije(?, ?, ?, ?)}";

            try (Connection conn = Config.getConnection();
                    CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, idSesije);
                cs.setString(2, vremePocetkaText.getText().trim());
                cs.setString(3, vremeZavrsetkaText.getText().trim());
                cs.registerOutParameter(4, java.sql.Types.VARCHAR);
                cs.execute();

                String poruka = cs.getString(4);
                Alert alert = new Alert("Uspesno izmenjeno".equals(poruka)
                        ? Alert.AlertType.INFORMATION
                        : Alert.AlertType.ERROR);
                alert.setHeaderText(null);
                alert.setContentText(poruka);
                alert.showAndWait();

                if ("Uspesno izmenjeno".equals(poruka)) {
                    ((Stage) btnPromeniVreme.getScene().getWindow()).close();
                }
            } catch (Exception ex) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setHeaderText("Greska pri izmeni vremena");
                alert.setContentText(ex.getMessage());
                alert.showAndWait();
            }
        });
        VBox vbox = new VBox();
        vbox.getChildren().addAll(vremePocetkaLabel, vremePocetkaText, vremeZavrsetkaLabel, vremeZavrsetkaText,
                btnPromeniVreme);
        vbox.setSpacing(10);
        root.setAlignment(Pos.CENTER);
        root.setSpacing(20);
        root.getChildren().addAll(vbox);
        Stage stage = new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
