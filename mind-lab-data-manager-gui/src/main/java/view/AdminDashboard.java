package view;

import database.*;
import javafx.collections.FXCollections;
import javafx.scene.Parent;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import model.*;

import java.util.List;

public class AdminDashboard {

    public Parent getRoot() {

        TabPane tabs = new TabPane();

        tabs.getTabs().add(createLaboratoryTab());
        tabs.getTabs().add(createExperimentTab());
        tabs.getTabs().add(createParticipantTab());
        tabs.getTabs().add(createResearcherTab());
        tabs.getTabs().add(createSessionTab());

        return tabs;
    }

    // ---------------- LABORATORIES ----------------
    private Tab createLaboratoryTab() {

        TableView<Laboratory> table = new TableView<>();
        Button delete = new Button("Delete");

        TableColumn<Laboratory, Integer> c1 = new TableColumn<>("ID");
        c1.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<Laboratory, String> c2 = new TableColumn<>("Naziv");
        c2.setCellValueFactory(new PropertyValueFactory<>("naziv"));

        TableColumn<Laboratory, TextField> c3 = new TableColumn<>("Naziv");
        c3.setCellValueFactory(new PropertyValueFactory<>("tf"));

        table.getColumns().addAll(c1, c2);

        table.setItems(
                FXCollections.observableArrayList(
                        LaboratoryDAO.getAll()
                )
        );
        delete.setOnAction(e -> {

            Laboratory l = table.getSelectionModel().getSelectedItem();

            if (l != null) {

                if (!LaboratoryDAO.existsInLab(l.getId())) {
                    LaboratoryDAO.delete(l.getId());
                    List<Laboratory> updatedList = LaboratoryDAO.getAll();

                    System.out.println("Broj laboratorija nakon brisanja: " + updatedList.size());

                    //table.setItems(FXCollections.observableArrayList(updatedList));
                    table.getItems().remove(l);
                } else {
                    System.out.println("Ne možeš obrisati laboratoriju - postoje istraživači!");
                }
            }
        });

        VBox layout = new VBox(10);

        layout.getChildren().addAll(table, delete);

        Tab tab = new Tab("Laboratorije", layout);

        tab.setClosable(false);

        return tab;
    }

    // ---------------- EXPERIMENT (ANKETA) ----------------
    private Tab createExperimentTab() {

        TableView<Experiment> table = new TableView<>();

        TableColumn<Experiment, Integer> c1 = new TableColumn<>("ID");
        c1.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<Experiment, String> c2 = new TableColumn<>("Naziv");
        c2.setCellValueFactory(new PropertyValueFactory<>("naziv"));

        TableColumn<Experiment, String> c3 = new TableColumn<>("Tip");
        c3.setCellValueFactory(new PropertyValueFactory<>("tipId"));

        table.getColumns().addAll(c1, c2, c3);

        table.setItems(
                FXCollections.observableArrayList(
                        ExperimentDAO.getAll()
                )
        );

        Tab tab = new Tab("Eksperimenti", table);
        tab.setClosable(false);

        return tab;
    }

    // ---------------- PARTICIPANTS ----------------
    private Tab createParticipantTab() {

        TableView<Participant> table = new TableView<>();

        TableColumn<Participant, Integer> c1 = new TableColumn<>("ID");
        c1.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<Participant, String> c2 = new TableColumn<>("Šifra");
        c2.setCellValueFactory(new PropertyValueFactory<>("sifra"));

        TableColumn<Participant, String> c3 = new TableColumn<>("Pol");
        c3.setCellValueFactory(new PropertyValueFactory<>("pol"));

        TableColumn<Participant, Integer> c4 = new TableColumn<>("Starost");
        c4.setCellValueFactory(new PropertyValueFactory<>("starost"));

        table.getColumns().addAll(c1, c2, c3, c4);

        table.setItems(
                FXCollections.observableArrayList(
                        ParticipantDAO.getAll()
                )
        );

        Tab tab = new Tab("Učesnici", table);
        tab.setClosable(false);

        return tab;
    }

    // ---------------- RESEARCHERS ----------------
    private Tab createResearcherTab() {

        TableView<Researcher> table = new TableView<>();

        TableColumn<Researcher, Integer> c1 = new TableColumn<>("ID");
        c1.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<Researcher, String> c2 = new TableColumn<>("Naziv");
        c2.setCellValueFactory(new PropertyValueFactory<>("naziv"));

        TableColumn<Researcher, String> c3 = new TableColumn<>("Kvalifikacije");
        c3.setCellValueFactory(new PropertyValueFactory<>("kvalifikacije"));

        TableColumn<Researcher, String> c4 = new TableColumn<>("Specijalizacija");
        c4.setCellValueFactory(new PropertyValueFactory<>("specijalizacija"));

        table.getColumns().addAll(c1, c2, c3, c4);

        table.setItems(
                FXCollections.observableArrayList(
                        ResearcherDAO.getAll()
                )
        );

        Tab tab = new Tab("Istraživači", table);
        tab.setClosable(false);

        return tab;
    }

    private Tab createSessionTab() {

        TableView<Session> table = new TableView<>();

        TableColumn<Session, Integer> c1 = new TableColumn<>("ID");
        c1.setCellValueFactory(new PropertyValueFactory<>("id"));

        TableColumn<Session, Object> c2 = new TableColumn<>("Datum");
        c2.setCellValueFactory(new PropertyValueFactory<>("datum"));

        TableColumn<Session, Integer> c3 = new TableColumn<>("Laboratorija");
        c3.setCellValueFactory(new PropertyValueFactory<>("labId"));

        table.getColumns().addAll(c1, c2, c3);

        table.setItems(
                FXCollections.observableArrayList(
                        SessionDAO.getAll()
                )
        );

        // --- BUTTONS ---
        Button edit = new Button("Edit");
        Button delete = new Button("Delete");

        edit.setOnAction(e -> {
            Session selected = table.getSelectionModel().getSelectedItem();

            if (selected == null) {
                System.out.println("Nijedna sesija nije selektovana!");
                return;
            }

            System.out.println("OPEN EDIT FORM za ID: " + selected.getId());

            SessionEditForm form = new SessionEditForm(selected);

            form.setOnSave(updated -> {
                SessionDAO.update(updated);   // UPDATE u bazi
                table.setItems(FXCollections.observableArrayList(SessionDAO.getAll()));
            });

            form.show();
        });

        delete.setOnAction(e -> {
            Session s = table.getSelectionModel().getSelectedItem();
            if (s != null) {
                SessionDAO.delete(s.getId());
                table.getItems().remove(s);
            }
        });

        VBox box = new VBox(table, edit, delete);

        Tab tab = new Tab("Sesije", box);
        tab.setClosable(false);

        return tab;
    }
}
