package model;

public class Researcher {

    private int id;
    private String naziv;
    private String kvalifikacije;
    private String specijalizacija;

    public Researcher(int id, String naziv, String kvalifikacije, String specijalizacija) {
        this.id = id;
        this.naziv = naziv;
        this.kvalifikacije = kvalifikacije;
        this.specijalizacija = specijalizacija;
    }

    public int getId() {
        return id;
    }

    public String getNaziv() {
        return naziv;
    }

    public String getKvalifikacije() {
        return kvalifikacije;
    }

    public String getSpecijalizacija() {
        return specijalizacija;
    }
}