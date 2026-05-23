package database;

import app.Config;
import model.Laboratory;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class LaboratorijaDAO {
    public static List<Laboratory> getAll() {
        List<Laboratory> list = new ArrayList<>();
        String sql = "SELECT lab_id, naziv FROM laboratorija";
        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
}
