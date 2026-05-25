package view;

import app.Config;
import javafx.geometry.Pos;
import javafx.scene.Scene;
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
    public void show(int idSesije,Time vremePocetka,Time vremeZavrsetka){
        HBox root=new HBox();
        Scene scene=new Scene(root,200,200);

        TextField vremePocetkaText=new TextField(vremePocetka.toString());
        TextField vremeZavrsetkaText=new TextField(vremeZavrsetka.toString());
        Label vremePocetkaLabel=new Label("Vreme pocetka:");
        Label vremeZavrsetkaLabel=new Label("Vreme zavrsetka:");
        Button btnPromeniVreme=new  Button("Promeni vreme");
        btnPromeniVreme.setOnAction(actionEvent -> {
//            String sql = "{CALL delete_laboratory(?, ?)}";
//
//            try (Connection conn = Config.getConnection();
//                 CallableStatement cs = conn.prepareCall(sql)) {
//                cs.setInt();
//                cs.registerOutParameter(2, java.sql.Types.BOOLEAN);
//                cs.execute();
//
//                boolean rezultat = cs.getBoolean(2);
//                if (rezultat) {
//                    System.out.println("Laboratorija obrisana");
//                    cbxIzborLaboratorije.getItems().remove(selectedLaboratory);
//                } else {
//                    System.out.println("Brisanje nije dozvoljeno");
//                }
//            } catch (Exception ex) {
//                ex.printStackTrace();
//            }
        });
        VBox vbox=new VBox();
        vbox.getChildren().addAll(vremePocetkaLabel,vremePocetkaText,vremeZavrsetkaLabel,vremeZavrsetkaText,btnPromeniVreme);
        vbox.setSpacing(10);
        root.setAlignment(Pos.CENTER);
        root.setSpacing(20);
        root.getChildren().addAll(vbox);
        Stage stage=new Stage();
        stage.setScene(scene);
        stage.show();
    }
}
