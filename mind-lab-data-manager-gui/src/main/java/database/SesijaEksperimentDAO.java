package database;

import app.Config;
import database.SesijaEksperiment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SesijaEksperimentDAO {

    public static List<SesijaEksperiment> getAll() {

        String sql = "SELECT * FROM pregled_sesija_eksperimenata";

        List<SesijaEksperiment> list = new ArrayList<>();

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new SesijaEksperiment(
                        rs.getInt("sesija_id"),
                        rs.getDate("datum"),
                        rs.getTime("vreme_pocetka"),
                        rs.getTime("vreme_zavrsetka"),
                        rs.getString("status_izvodjenja"),
                        rs.getString("naziv_ankete"),
                        rs.getString("naziv_laboratorije"),
                        rs.getInt("broj_alata"),
                        rs.getInt("broj_ucesnika")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
