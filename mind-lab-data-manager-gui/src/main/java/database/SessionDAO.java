package database;

import app.Config;
import model.Session;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SessionDAO {
    public static List<Session> getAll() {

        List<Session> list = new ArrayList<>();

        String sql = """
            SELECT s.sesija_id,
                   s.datum,
                   s.vreme_pocetka,
                   s.lab_id
            FROM sesija s
        """;

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                list.add(new Session(
                        rs.getInt("sesija_id"),
                        rs.getString("datum"),
                        rs.getString("vreme_pocetka"),
                        rs.getInt("lab_id")
                ));
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public static void update(Session s) {

        String sql = "UPDATE sesija SET datum = ?, laboratorija_id = ? WHERE sesija_id = ?";

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setDate(1, Date.valueOf(s.getDatum()));
            ps.setInt(2, s.getLabId());
            ps.setInt(3, s.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void delete(int id) {

        String sql = "DELETE FROM sesija WHERE sesija_id = ?";

        try {
            Connection conn = Config.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
