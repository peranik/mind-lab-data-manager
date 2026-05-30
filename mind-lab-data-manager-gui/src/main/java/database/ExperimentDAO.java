package database;

import app.Config;
import model.Experiment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ExperimentDAO {

    public static List<Experiment> getAll() {

        List<Experiment> list = new ArrayList<>();

        String sql = "SELECT anketa_id, naziv, tip_id FROM anketa";

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Experiment e = new Experiment(
                        rs.getInt("anketa_id"),
                        rs.getString("naziv"),
                        rs.getInt("tip_id")
                );

                list.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


}
