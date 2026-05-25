package view;

import database.SesijaEksperimentDAO;
import database.SesijaEksperiment;

import javafx.collections.FXCollections;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;

import java.sql.Date;
import java.sql.Time;

public class SesijaEksperimentView {

    public void show() {

        Stage stage = new Stage();

        TableView<SesijaEksperiment> table = new TableView<>();

        // ===== KOLONE =====

        TableColumn<SesijaEksperiment, Date> colDatum =
                new TableColumn<>("Datum");
        colDatum.setCellValueFactory(new PropertyValueFactory<>("datum"));

        TableColumn<SesijaEksperiment, Time> colPocetak =
                new TableColumn<>("Početak");
        colPocetak.setCellValueFactory(new PropertyValueFactory<>("vremePocetka"));

        TableColumn<SesijaEksperiment, Time> colKraj =
                new TableColumn<>("Kraj");
        colKraj.setCellValueFactory(new PropertyValueFactory<>("vremeZavrsetka"));

        TableColumn<SesijaEksperiment, String> colStatus =
                new TableColumn<>("Status");
        colStatus.setCellValueFactory(new PropertyValueFactory<>("statusIzvodjenja"));

        TableColumn<SesijaEksperiment, String> colAnketa =
                new TableColumn<>("Anketa");
        colAnketa.setCellValueFactory(new PropertyValueFactory<>("nazivAnkete"));

        TableColumn<SesijaEksperiment, String> colLab =
                new TableColumn<>("Laboratorija");
        colLab.setCellValueFactory(new PropertyValueFactory<>("nazivLaboratorije"));

        // ===== TABLE =====
        table.getColumns().addAll(
                colDatum,colPocetak,colKraj,colStatus,colAnketa,colLab
        );

        table.setItems(FXCollections.observableArrayList(
                SesijaEksperimentDAO.getAll()
        ));

        Button btnPromeniVreme = new Button("Promeni vreme");
        PromeniVremeView promeniVreme=new PromeniVremeView();
        btnPromeniVreme.setOnAction(e -> {
           if(table.getSelectionModel().getSelectedItem()!=null)promeniVreme.show(
                       table.getSelectionModel().getSelectedItem().getSesijaId()
                       ,table.getSelectionModel().getSelectedItem().getVremePocetka()
                       ,table.getSelectionModel().getSelectedItem().getVremeZavrsetka());
        });
        HBox dugmici=new HBox(btnPromeniVreme);
        dugmici.setSpacing(10);
        VBox root = new VBox(table,dugmici);
        root.setSpacing(20);

        Scene scene = new Scene(root, 900, 500);

        stage.setTitle("Sesije eksperimenata");
        stage.setScene(scene);
        stage.show();
    }
}
