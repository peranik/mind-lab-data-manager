package database;

import app.Config;
import model.Alat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AlatDAO {
    public static List<Alat> getAlatiZaSesiju(int sesijaId) {
        List<Alat> list = new ArrayList<>();
        String sql = """
                SELECT alat_id, naziv
                FROM pregled_alata_sesije
                WHERE sesija_id = ?
                ORDER BY naziv ASC, alat_id ASC
                """;

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sesijaId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Alat(
                            rs.getInt("alat_id"),
                            rs.getString("naziv") + " (ID: " + rs.getInt("alat_id") + ")"
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
