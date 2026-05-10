package view;

import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import model.Session;

import java.util.function.Consumer;

public class SessionEditForm {

    private final Session session;
    private Consumer<Session> onSave;

    public SessionEditForm(Session session) {
        this.session = session;
    }

    public void setOnSave(Consumer<Session> onSave) {
        this.onSave = onSave;
    }

    public void show() {

        Stage stage = new Stage();

        TextField datumField = new TextField(session.getDatum());
        TextField vremeField = new TextField(session.getVreme());
        TextField labField = new TextField(String.valueOf(session.getLabId()));

        Button save = new Button("Save");

        save.setOnAction(e -> {

            session.setDatum(datumField.getText());
            session.setVreme(vremeField.getText());
            session.setLabId(Integer.parseInt(labField.getText()));

            if (onSave != null) {
                onSave.accept(session);
            }

            stage.close();
        });

        VBox root = new VBox(10,
                new Label("Datum:"), datumField,
                new Label("Vreme:"), vremeField,
                new Label("Lab ID:"), labField,
                save
        );

        stage.setScene(new Scene(root, 300, 220));
        stage.setTitle("Edit Session");
        stage.show();
    }
}