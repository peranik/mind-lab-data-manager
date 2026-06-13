package view;

import database.ExperimentInsightRepository;
import javafx.collections.FXCollections;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.Accordion;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.TextArea;
import javafx.scene.control.TitledPane;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import model.ExperimentInsight;

public class ExperimentInsightDetailsView {

    private final ExperimentInsightRepository insightRepository;

    public ExperimentInsightDetailsView(ExperimentInsightRepository insightRepository) {
        this.insightRepository = insightRepository;
    }

    public void show(int executionId) {
        ExperimentInsight insight = insightRepository.getByExecutionId(executionId);
        if (insight == null) {
            throw new IllegalStateException("Za izabrano izvodjenje ne postoji dokument u MongoDB.");
        }

        Stage stage = new Stage();

        GridPane summaryGrid = new GridPane();
        summaryGrid.setHgap(15);
        summaryGrid.setVgap(10);
        summaryGrid.addRow(0, new Label("Izvodjenje ID:"), new Label(String.valueOf(insight.getExecutionId())));
        summaryGrid.addRow(1, new Label("Anketa ID:"), new Label(String.valueOf(insight.getSurveyId())));
        summaryGrid.addRow(2, new Label("Naziv ankete:"), new Label(insight.getSurveyName()));
        summaryGrid.addRow(3, new Label("Laboratorija:"), new Label(insight.getLaboratoryName()));
        summaryGrid.addRow(4, new Label("Datum:"), new Label(insight.getExecutionDate()));
        summaryGrid.addRow(5, new Label("Generator:"), new Label(insight.getGeneratorName()));
        summaryGrid.addRow(6, new Label("Generisano:"), new Label(insight.getGeneratedAt()));

        TextArea summaryArea = buildTextArea(insight.getQualitativeSummary());
        TextArea methodologyArea = buildTextArea(insight.getMethodologicalAssessment() + System.lineSeparator()
                + System.lineSeparator() + "Preporuka: " + insight.getRecommendation());
        TextArea metricsArea = buildTextArea(buildMetricsText(insight));
        TextArea rawJsonArea = buildTextArea(insight.getRawJson());

        ListView<String> observationsView = buildListView(insight.getKeyObservations());
        ListView<String> sessionsView = buildListView(insight.getSessionTimeline());
        ListView<String> toolsView = buildListView(insight.getToolNames());
        ListView<String> educationView = buildListView(insight.getEducationBreakdown());

        Accordion accordion = new Accordion(
                new TitledPane("AI sažetak", summaryArea),
                new TitledPane("Ključna opažanja", observationsView),
                new TitledPane("Kvantitativni rezultati", metricsArea),
                new TitledPane("Metodološka procena", methodologyArea),
                new TitledPane("Vremenska linija sesija", sessionsView),
                new TitledPane("Korišćeni alati", toolsView),
                new TitledPane("Obrazovna struktura", educationView),
                new TitledPane("JSON dokument", rawJsonArea)
        );
        if (!accordion.getPanes().isEmpty()) {
            accordion.setExpandedPane(accordion.getPanes().get(0));
        }

        VBox content = new VBox(summaryGrid, accordion);
        content.setSpacing(15);
        content.setPadding(new Insets(15));
        VBox.setVgrow(accordion, Priority.ALWAYS);

        ScrollPane scrollPane = new ScrollPane(content);
        scrollPane.setFitToWidth(true);

        Scene scene = new Scene(scrollPane, 820, 720);
        stage.setTitle("Mongo detalji eksperimenta");
        stage.setScene(scene);
        stage.show();
    }

    private TextArea buildTextArea(String text) {
        TextArea textArea = new TextArea(text == null ? "" : text);
        textArea.setWrapText(true);
        textArea.setEditable(false);
        textArea.setPrefRowCount(6);
        return textArea;
    }

    private ListView<String> buildListView(java.util.List<String> values) {
        ListView<String> listView = new ListView<>(FXCollections.observableArrayList(values));
        listView.setPrefHeight(180);
        return listView;
    }

    private String buildMetricsText(ExperimentInsight insight) {
        return "Status: " + insight.getStatus() + System.lineSeparator() +
                "Kvalitet podataka: " + insight.getDataQuality() + System.lineSeparator() +
                "Broj sesija: " + insight.getSessionCount() + System.lineSeparator() +
                "Broj učesnika: " + insight.getParticipantCount() + System.lineSeparator() +
                "Broj alata: " + insight.getToolCount() + System.lineSeparator() +
                "Ukupno trajanje: " + insight.getTotalDurationMinutes() + " minuta" + System.lineSeparator() +
                "Prosečna starost: " + (insight.getAverageAge() == null ? "n/d" : insight.getAverageAge()) + System.lineSeparator() +
                "Polna struktura: M=" + insight.getMaleCount() +
                ", Ž=" + insight.getFemaleCount() +
                ", ostali=" + insight.getOtherCount() + System.lineSeparator() +
                "Indeks pouzdanosti: " + insight.getReliabilityIndex() + System.lineSeparator() +
                "Skor angažovanosti: " + insight.getEngagementScore();
    }
}
