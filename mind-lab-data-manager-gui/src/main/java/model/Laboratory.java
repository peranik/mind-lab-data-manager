package model;

public class Laboratory {

    private int id;
    private String naziv;

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
}
