package model;

public class Experiment {

    private int id;
    private String naziv;
    private int tipId;

    public Experiment(int id, String naziv, int tipId) {
        this.id = id;
        this.naziv = naziv;
        this.tipId = tipId;
    }

    public int getId() {
        return id;
    }

    public String getNaziv() {
        return naziv;
    }

    public int getTipId() {
        return tipId;
    }
}