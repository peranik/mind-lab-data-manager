package model;

public class Alat {
    private int alatId;
    private String naziv;

    public Alat(int alatId, String naziv) {
        this.alatId = alatId;
        this.naziv = naziv;
    }

    public int getAlatId() {
        return alatId;
    }

    public String getNaziv() {
        return naziv;
    }

    @Override
    public String toString() {
        return naziv;
    }
}
