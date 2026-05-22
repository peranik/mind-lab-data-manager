package view;

import database.*;
import javafx.collections.FXCollections;
import javafx.geometry.Pos;
import javafx.scene.Parent;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import model.*;

import java.util.List;

public class AdminDashboard {

    public Parent getRoot() {

        HBox hBox = new HBox();
        hBox.setAlignment(Pos.CENTER);
        VBox vboxDugmici = new VBox();
        vboxDugmici.setAlignment(Pos.CENTER);
        vboxDugmici.setSpacing(20);
        hBox.getChildren().addAll(vboxDugmici);
        Button btnSesAnk=btnPregledSesijaAnketa();
        vboxDugmici.getChildren().add(btnSesAnk);
        return hBox;
    }
    private Button btnPregledSesijaAnketa(){
        Button btnPregledSesijaAnketa = new Button();
        btnPregledSesijaAnketa.setText("Pregled Sesija i Anketa");
        btnPregledSesijaAnketa.setPrefWidth(400);
        btnPregledSesijaAnketa.setOnAction(e -> {
            SesijaEksperimentView form = new SesijaEksperimentView();
            form.show();
        });
        return btnPregledSesijaAnketa;
    }
}
