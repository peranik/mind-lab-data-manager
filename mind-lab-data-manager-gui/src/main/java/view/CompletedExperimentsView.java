package view;

import database.CompletedExperimentDAO;
import database.ExperimentInsightRepository;
import javafx.collections.FXCollections;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableRow;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.HBox;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import model.CompletedExperiment;

import java.sql.Date;
import java.sql.Time;

public class CompletedExperimentsView {

    private final ExperimentInsightRepository insightRepository = new ExperimentInsightRepository();

    public void show() {
        Stage stage = new Stage();
        TableView<CompletedExperiment> table = new TableView<>();

        TableColumn<CompletedExperiment, Integer> colExecutionId =
                new TableColumn<>("Izvodjenje ID");
        colExecutionId.setCellValueFactory(new PropertyValueFactory<>("executionId"));

        TableColumn<CompletedExperiment, Integer> colSurveyId =
                new TableColumn<>("Anketa ID");
        colSurveyId.setCellValueFactory(new PropertyValueFactory<>("surveyId"));

        TableColumn<CompletedExperiment, String> colSurveyName =
                new TableColumn<>("Naziv ankete");
        colSurveyName.setCellValueFactory(new PropertyValueFactory<>("surveyName"));

        TableColumn<CompletedExperiment, String> colLabName =
                new TableColumn<>("Laboratorija");
        colLabName.setCellValueFactory(new PropertyValueFactory<>("laboratoryName"));

        TableColumn<CompletedExperiment, Date> colDate =
                new TableColumn<>("Datum");
        colDate.setCellValueFactory(new PropertyValueFactory<>("executionDate"));

        TableColumn<CompletedExperiment, Time> colStartTime =
                new TableColumn<>("Početak");
        colStartTime.setCellValueFactory(new PropertyValueFactory<>("startTime"));

        TableColumn<CompletedExperiment, Time> colEndTime =
                new TableColumn<>("Kraj");
        colEndTime.setCellValueFactory(new PropertyValueFactory<>("endTime"));

        TableColumn<CompletedExperiment, Integer> colSessions =
                new TableColumn<>("Broj sesija");
        colSessions.setCellValueFactory(new PropertyValueFactory<>("sessionCount"));

        TableColumn<CompletedExperiment, Integer> colParticipants =
                new TableColumn<>("Broj učesnika");
        colParticipants.setCellValueFactory(new PropertyValueFactory<>("participantCount"));

        TableColumn<CompletedExperiment, Integer> colTools =
                new TableColumn<>("Broj alata");
        colTools.setCellValueFactory(new PropertyValueFactory<>("toolCount"));

        table.getColumns().addAll(
                colExecutionId,
                colSurveyId,
                colSurveyName,
                colLabName,
                colDate,
                colStartTime,
                colEndTime,
                colSessions,
                colParticipants,
                colTools
        );

        table.setRowFactory(tv -> {
            TableRow<CompletedExperiment> row = new TableRow<>();
            row.setOnMouseClicked(event -> {
                if (event.getClickCount() == 2 && !row.isEmpty()) {
                    openDetails(row.getItem());
                }
            });
            return row;
        });

        refreshTable(table);
        syncMongoSilently();

        Button btnDetails = new Button("Prikaži detalje");
        btnDetails.setOnAction(e -> {
            CompletedExperiment selectedExperiment = table.getSelectionModel().getSelectedItem();
            if (selectedExperiment == null) {
                showWarning("Izaberite eksperiment iz liste.");
                return;
            }

            openDetails(selectedExperiment);
        });

        Button btnSync = new Button("Sinhronizuj MongoDB");
        btnSync.setOnAction(e -> {
            try {
                int insertedCount = insightRepository.syncMissingInsights();
                showInfo("Sinhronizacija završena. Dodato novih dokumenata: " + insertedCount + ".");
            } catch (Exception ex) {
                showError("Sinhronizacija sa MongoDB nije uspela.", ex);
            }
        });

        Button btnRefresh = new Button("Osveži");
        btnRefresh.setOnAction(e -> refreshTable(table));

        HBox actions = new HBox(btnDetails, btnSync, btnRefresh);
        actions.setSpacing(10);

        VBox root = new VBox(table, actions);
        root.setSpacing(12);
        root.setPadding(new Insets(15));
        VBox.setVgrow(table, Priority.ALWAYS);

        Scene scene = new Scene(root, 1100, 520);
        stage.setTitle("Uspešno završeni eksperimenti");
        stage.setScene(scene);
        stage.show();
    }

    private void refreshTable(TableView<CompletedExperiment> table) {
        table.setItems(FXCollections.observableArrayList(CompletedExperimentDAO.getAllCompleted()));
    }

    private void syncMongoSilently() {
        try {
            insightRepository.syncMissingInsights();
        } catch (Exception ex) {
            showWarning("Lista je učitana iz relacione baze, ali MongoDB detalji trenutno nisu dostupni.");
        }
    }

    private void openDetails(CompletedExperiment experiment) {
        try {
            new ExperimentInsightDetailsView(insightRepository).show(experiment.getExecutionId());
        } catch (Exception ex) {
            showError("Prikaz detalja eksperimenta nije uspeo.", ex);
        }
    }

    private void showInfo(String message) {
        Alert alert = new Alert(Alert.AlertType.INFORMATION);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    private void showWarning(String message) {
        Alert alert = new Alert(Alert.AlertType.WARNING);
        alert.setHeaderText(null);
        alert.setContentText(message);
        alert.showAndWait();
    }

    private void showError(String header, Exception ex) {
        Alert alert = new Alert(Alert.AlertType.ERROR);
        alert.setHeaderText(header);
        alert.setContentText(ex.getMessage());
        alert.showAndWait();
    }
}
