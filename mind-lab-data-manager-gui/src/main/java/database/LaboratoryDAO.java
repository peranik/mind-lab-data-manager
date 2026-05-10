package database;

import app.Config;
import model.Laboratory;

import java.sql.CallableStatement;
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

    public static void delete(int labId) {

        String sql = "{CALL sp_delete_laboratory(?)}";

        try {
            Connection conn = Config.getConnection();
            CallableStatement cs = conn.prepareCall(sql);

            cs.setInt(1, labId);
            cs.execute();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static boolean existsInLab(int labId) {

        String sql = "SELECT fn_lab_can_delete(?)";

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, labId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}