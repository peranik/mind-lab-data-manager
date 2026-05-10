package database;

import app.Config;
import model.Laboratory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LaboratoryDAO {

    public static List<Laboratory> getAll() {

        List<Laboratory> list = new ArrayList<>();

        String sql = "SELECT lab_id, naziv FROM laboratorija";

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Laboratory lab = new Laboratory(
                        rs.getInt("lab_id"),
                        rs.getString("naziv")
                );

                list.add(lab);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // (OPCIONALNO - ali korisno za CRUD kasnije)
    public static void insert(String naziv) {

        String sql = "INSERT INTO laboratorija (naziv) VALUES (?)";

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, naziv);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void delete(int id) {

        String sql =
                "DELETE FROM laboratorija WHERE laboratorija_id = ?";

        try {

            Connection conn = Config.getConnection();

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setInt(1, id);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}