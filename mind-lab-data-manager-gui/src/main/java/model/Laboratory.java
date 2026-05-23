package model;

import javafx.scene.control.TextField;

public class Laboratory {

    private int id;
    private String naziv;
    private TextField tf = new TextField();

    public Laboratory(int id, String naziv) {
        this.id = id;
        this.naziv = naziv;
    }

    public int getId() {
        return id;
    }

    public String getNaziv() {
        return naziv;
    }

    public TextField getTf() {
        tf.setText(naziv);
        return tf;
    }
    @Override
    public String toString(){
        return naziv;
    }
}
