package model;

public class Session {
    private int id;
    private String datum;
    private String vreme;
    private int labId;

    public Session(int id, String datum, String vreme, int labId) {
        this.id = id;
        this.datum = datum;
        this.vreme = vreme;
        this.labId = labId;
    }

    public int getId() { return id; }
    public String getDatum() { return datum; }
    public String getVreme() { return vreme; }
    public int getLabId() { return labId; }
}
