package database;

import app.Config;
import model.Researcher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResearcherDAO {

    public static List<Researcher> getAll() {

        List<Researcher> list = new ArrayList<>();

        String sql = "SELECT istrazivac_id, naziv, kvalifikacije, specijalizacija FROM istrazivac";

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Researcher r = new Researcher(
                        rs.getInt("istrazivac_id"),
                        rs.getString("naziv"),
                        rs.getString("kvalifikacije"),
                        rs.getString("specijalizacija")
                );

                list.add(r);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // OPCIONALNO (CRUD kasnije)

    public static void insert(String naziv, String kvalifikacije, String specijalizacija) {

        String sql = "INSERT INTO istrazivac (naziv, kvalifikacije, specijalizacija) VALUES (?, ?, ?)";

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, naziv);
            ps.setString(2, kvalifikacije);
            ps.setString(3, specijalizacija);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
