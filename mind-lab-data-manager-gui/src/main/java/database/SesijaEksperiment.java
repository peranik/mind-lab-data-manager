package database;

import java.sql.Time;
import java.sql.Date;

public class SesijaEksperiment {
    public int sesijaId;
    public Date datum;
    public Time vremePocetka;
    public Time vremeZavrsetka;

    public String statusIzvodjenja;
    public String nazivAnkete;
    public String nazivLaboratorije;

    public SesijaEksperiment(int sesijaId,
                             Date datum,
                             Time vremePocetka,
                             Time vremeZavrsetka,
                             String statusIzvodjenja,
                             String nazivAnkete,
                             String nazivLaboratorije) {
        this.sesijaId = sesijaId;
        this.datum = datum;
        this.vremePocetka = vremePocetka;
        this.vremeZavrsetka = vremeZavrsetka;
        this.statusIzvodjenja = statusIzvodjenja;
        this.nazivAnkete = nazivAnkete;
        this.nazivLaboratorije = nazivLaboratorije;

    }
    public int getSesijaId() {
        return sesijaId;
    }
    public Date getDatum() {
        return datum;
    }

    public Time getVremePocetka() {
        return vremePocetka;
    }

    public Time getVremeZavrsetka() {
        return vremeZavrsetka;
    }

    public String getStatusIzvodjenja() {
        return statusIzvodjenja;
    }

    public String getNazivAnkete() {
        return nazivAnkete;
    }

    public String getNazivLaboratorije() {
        return nazivLaboratorije;
    }
}