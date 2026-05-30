package database;

import app.Config;
import model.Participant;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ParticipantDAO {

    public static List<Participant> getAll() {

        List<Participant> list = new ArrayList<>();

        String sql = "SELECT ucesnik_id, sifra, pol, starost, obrazovanje, opis FROM ucesnik";

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Participant p = new Participant(
                        rs.getInt("ucesnik_id"),
                        rs.getString("sifra"),
                        rs.getString("pol"),
                        rs.getInt("starost"),
                        rs.getString("obrazovanje"),
                        rs.getString("opis")
                );

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static List<Participant> getUcesniciZaSesiju(int sesijaId) {

        List<Participant> list = new ArrayList<>();

        String sql = """
                SELECT ucesnik_id, sifra, pol, starost, obrazovanje, opis
                FROM pregled_ucesnika_sesije
                WHERE sesija_id = ?
                ORDER BY sifra ASC, ucesnik_id ASC
                """;

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sesijaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Participant p = new Participant(
                            rs.getInt("ucesnik_id"),
                            rs.getString("sifra"),
                            rs.getString("pol"),
                            rs.getInt("starost"),
                            rs.getString("obrazovanje"),
                            rs.getString("opis")
                    );

                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static List<Participant> getDostupniUcesniciZaSesiju(int sesijaId) {

        List<Participant> list = new ArrayList<>();

        String sql = """
                SELECT ucesnik_id, sifra, pol, starost, obrazovanje, opis
                FROM pregled_dostupnih_ucesnika_za_sesiju
                WHERE sesija_id = ?
                ORDER BY sifra ASC, ucesnik_id ASC
                """;

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sesijaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Participant p = new Participant(
                            rs.getInt("ucesnik_id"),
                            rs.getString("sifra"),
                            rs.getString("pol"),
                            rs.getInt("starost"),
                            rs.getString("obrazovanje"),
                            rs.getString("opis")
                    );

                    list.add(p);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
