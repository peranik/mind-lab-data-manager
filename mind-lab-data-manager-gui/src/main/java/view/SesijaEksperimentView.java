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

        TableColumn<SesijaEksperiment, Integer> colBrojAlata =
                new TableColumn<>("Broj alata");
        colBrojAlata.setCellValueFactory(new PropertyValueFactory<>("brojAlata"));

        TableColumn<SesijaEksperiment, Integer> colBrojUcesnika =
                new TableColumn<>("Broj učesnika");
        colBrojUcesnika.setCellValueFactory(new PropertyValueFactory<>("brojUcesnika"));

        // ===== TABLE =====
        table.getColumns().addAll(
                colDatum,colPocetak,colKraj,colStatus,colAnketa,colLab,colBrojAlata,colBrojUcesnika
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
        Button btnDodajAlat = new Button("Dodaj alat");
        DodajAlatSesijaView dodajAlatSesijaView = new DodajAlatSesijaView();
        btnDodajAlat.setOnAction(e -> {
            if (table.getSelectionModel().getSelectedItem() != null) {
                dodajAlatSesijaView.show(
                        table.getSelectionModel().getSelectedItem().getSesijaId()
                );
            }
        });
        Button btnUkloniAlat = new Button("Ukloni alat");
        UkloniAlatSesijaView ukloniAlatSesijaView = new UkloniAlatSesijaView();
        btnUkloniAlat.setOnAction(e -> {
            if (table.getSelectionModel().getSelectedItem() != null) {
                ukloniAlatSesijaView.show(
                        table.getSelectionModel().getSelectedItem().getSesijaId()
                );
            }
        });
        Button btnDodajUcesnika = new Button("Dodaj učesnika");
        DodajUcesnikaSesijaView dodajUcesnikaSesijaView = new DodajUcesnikaSesijaView();
        btnDodajUcesnika.setOnAction(e -> {
            if (table.getSelectionModel().getSelectedItem() != null) {
                dodajUcesnikaSesijaView.show(
                        table.getSelectionModel().getSelectedItem().getSesijaId()
                );
            }
        });
        Button btnUkloniUcesnika = new Button("Ukloni učesnika");
        UkloniUcesnikaSesijaView ukloniUcesnikaSesijaView = new UkloniUcesnikaSesijaView();
        btnUkloniUcesnika.setOnAction(e -> {
            if (table.getSelectionModel().getSelectedItem() != null) {
                ukloniUcesnikaSesijaView.show(
                        table.getSelectionModel().getSelectedItem().getSesijaId()
                );
            }
        });
        HBox dugmici=new HBox(btnPromeniVreme, btnDodajAlat, btnUkloniAlat, btnDodajUcesnika, btnUkloniUcesnika);
        dugmici.setSpacing(10);
        VBox root = new VBox(table,dugmici);
        root.setSpacing(20);

        Scene scene = new Scene(root, 900, 500);

        stage.setTitle("Sesije eksperimenata");
        stage.setScene(scene);
        stage.show();
    }
}
