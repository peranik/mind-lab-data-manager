package model;

public class Participant {

    private int id;
    private String sifra;
    private String pol;
    private int starost;
    private String obrazovanje;
    private String opis;

    public Participant(int id, String sifra, String pol, int starost, String obrazovanje, String opis) {
        this.id = id;
        this.sifra = sifra;
        this.pol = pol;
        this.starost = starost;
        this.obrazovanje = obrazovanje;
        this.opis = opis;
    }

    public int getId() {
        return id;
    }

    public String getSifra() {
        return sifra;
    }

    public String getPol() {
        return pol;
    }

    public int getStarost() {
        return starost;
    }

    public String getObrazovanje() {
        return obrazovanje;
    }

    public String getOpis() {
        return opis;
    }
}
