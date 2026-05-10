package view;

import database.*;
import javafx.collections.FXCollections;
import javafx.scene.Parent;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.VBox;
import model.*;

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

        table.getColumns().addAll(c1, c2);

        table.setItems(
                FXCollections.observableArrayList(
                        LaboratoryDAO.getAll()
                )
        );
        delete.setOnAction(e -> {

            Laboratory lab = table.getSelectionModel().getSelectedItem();

            if (lab != null) {

                boolean hasResearchers =
                        ResearcherDAO.existsInLab(lab.getId());

                if (hasResearchers) {

                    Alert alert = new Alert(Alert.AlertType.WARNING);
                    alert.setContentText(
                            "Ne možeš obrisati laboratoriju - ima istraživača!"
                    );
                    alert.show();

                } else {

                    LaboratoryDAO.delete(lab.getId());

                    table.getItems().remove(lab);
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
            Session s = table.getSelectionModel().getSelectedItem();
            if (s != null) {
                System.out.println("OPEN EDIT FORM");
                // ovde kasnije otvaraš edit screen
            }
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
