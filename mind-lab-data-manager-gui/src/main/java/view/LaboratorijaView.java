package view;

import app.Config;
import database.LaboratorijaDAO;
import javafx.geometry.Pos;
import javafx.scene.Scene;
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

        Button btnObrisiLaboratorije=new Button("Obrisi");
        btnObrisiLaboratorije.setOnAction(e->{
            int labId=cbxIzborLaboratorije.getSelectionModel().getSelectedItem().getId();
            String sql = "{CALL delete_laboratory(?, ?)}";

            try (Connection conn = Config.getConnection();
                 CallableStatement cs = conn.prepareCall(sql)) {
                cs.setInt(1, labId);
                cs.registerOutParameter(2, java.sql.Types.BOOLEAN);
                cs.execute();

                boolean rezultat = cs.getBoolean(2);
                if (rezultat) {
                    System.out.println("Laboratorija obrisana");
                    cbxIzborLaboratorije.getItems().remove(cbxIzborLaboratorije.getSelectionModel().getSelectedItem());
                } else {
                    System.out.println("Brisanje nije dozvoljeno");
                }

            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });

        HBox hb=new HBox(lblNaziv,cbxIzborLaboratorije);
        hb.setSpacing(20);
        hb.setAlignment(Pos.CENTER);
        VBox root = new VBox(hb,btnObrisiLaboratorije);
        root.setAlignment(Pos.CENTER);
        Scene scene = new Scene(root, 450, 250);
        stage.setTitle("Pregled Laboratorija");
        stage.setScene(scene);
        stage.show();
    }
}
