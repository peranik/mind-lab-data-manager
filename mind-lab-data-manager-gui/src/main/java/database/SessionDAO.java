package database;

import app.Config;
import model.Session;

import java.sql.*;
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

        String sql = "{CALL sp_update_session(?,?,?)}";

        try {
            Connection conn = Config.getConnection();
            CallableStatement cs = conn.prepareCall(sql);

            cs.setString(1, s.getDatum());
            cs.setString(2, s.getVreme());
            cs.setInt(3, s.getLabId());

            cs.execute();

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
