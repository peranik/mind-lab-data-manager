package view;

import app.Config;
import database.LaboratorijaDAO;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import model.Laboratory;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

public class LaboratorijaView {
    public void show(){
        Stage stage=new Stage();

        Label lblNaziv=new Label("Laboratorija:");

        List<Laboratory> listaLaboratorija=new ArrayList<>();
        listaLaboratorija = LaboratorijaDAO.getAll();
        ComboBox<Laboratory> cbxIzborLaboratorije=new ComboBox<>();
        for(int i=0;i<listaLaboratorija.size();i++){
            cbxIzborLaboratorije.getItems().add(listaLaboratorija.get(i));
        }

        Button btnObrisiLaboratorije=new Button("Obriši");
        btnObrisiLaboratorije.setOnAction(e->{
            Laboratory selectedLaboratory = cbxIzborLaboratorije.getSelectionModel().getSelectedItem();
            if (selectedLaboratory == null) {
                Alert alert = new Alert(Alert.AlertType.WARNING);
                alert.setTitle("Upozorenje");
                alert.setHeaderText(null);
                alert.setContentText("Izaberite laboratoriju.");
                alert.showAndWait();
                return;
            }

            int labId=selectedLaboratory.getId();
            String sql = "{CALL delete_laboratory(?, ?)}";

            try (Connection conn = Config.getConnection();
                 CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, labId);
                cs.registerOutParameter(2, java.sql.Types.BOOLEAN);
                cs.execute();

                boolean rezultat = cs.getBoolean(2);if (rezultat) {
                    Alert alert = new Alert(Alert.AlertType.INFORMATION);
                    alert.setTitle("Uspeh");
                    alert.setHeaderText(null);
                    alert.setContentText("Laboratorija je uspešno obrisana.");
                    alert.showAndWait();

                    cbxIzborLaboratorije.getItems().remove(selectedLaboratory);
                } else {
                    Alert alert = new Alert(Alert.AlertType.ERROR);
                    alert.setTitle("Greška");
                    alert.setHeaderText(null);
                    alert.setContentText("Brisanje nije dozvoljeno.");
                    alert.showAndWait();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });

        HBox hb=new HBox(lblNaziv,cbxIzborLaboratorije);
        hb.setSpacing(20);
        hb.setAlignment(Pos.CENTER);
        VBox root = new VBox(hb,btnObrisiLaboratorije);
        root.setSpacing(20);
        root.setAlignment(Pos.CENTER);
        Scene scene = new Scene(root, 450, 250);
        stage.setTitle("Pregled Laboratorija");
        stage.setScene(scene);
        stage.show();
    }
}
