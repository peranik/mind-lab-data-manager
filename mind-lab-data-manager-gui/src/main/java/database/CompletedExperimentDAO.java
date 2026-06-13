package database;

import app.Config;
import model.CompletedExperiment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CompletedExperimentDAO {

    private static final String COMPLETED_STATUS = "zavrseno";

    public static List<CompletedExperiment> getAllCompleted() {
        String sql = """
                SELECT
                    i.izvodjenje_id,
                    i.anketa_id,
                    a.naziv AS naziv_ankete,
                    l.naziv AS naziv_laboratorije,
                    i.datum,
                    i.status,
                    COUNT(DISTINCT s.sesija_id) AS broj_sesija,
                    COUNT(DISTINCT su.ucesnik_id) AS broj_ucesnika,
                    COUNT(DISTINCT als.alat_id) AS broj_alata,
                    MIN(s.vreme_pocetka) AS prvo_vreme_pocetka,
                    MAX(s.vreme_zavrsetka) AS poslednje_vreme_zavrsetka
                FROM izvodjenje i
                JOIN anketa a ON a.anketa_id = i.anketa_id
                JOIN laboratorija l ON l.lab_id = i.lab_id
                LEFT JOIN sesija s ON s.izvodjenje_id = i.izvodjenje_id
                LEFT JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                LEFT JOIN alat_sesija als ON als.sesija_id = s.sesija_id
                WHERE LOWER(TRIM(i.status)) = ?
                GROUP BY
                    i.izvodjenje_id,
                    i.anketa_id,
                    a.naziv,
                    l.naziv,
                    i.datum,
                    i.status
                ORDER BY i.datum DESC, i.izvodjenje_id DESC
                """;

        List<CompletedExperiment> experiments = new ArrayList<>();

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, COMPLETED_STATUS);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    experiments.add(mapSummary(rs));
                }
            }
        } catch (Exception ex) {
            throw new RuntimeException("Neuspesno ucitavanje zavrsenih eksperimenata.", ex);
        }

        return experiments;
    }

    public static CompletedExperiment getCompletedExperiment(int executionId) {
        String sql = """
                SELECT
                    i.izvodjenje_id,
                    i.anketa_id,
                    a.naziv AS naziv_ankete,
                    l.naziv AS naziv_laboratorije,
                    i.datum,
                    i.status,
                    (SELECT COUNT(*)
                     FROM sesija s
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS broj_sesija,
                    (SELECT COUNT(DISTINCT su.ucesnik_id)
                     FROM sesija s
                     JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS broj_ucesnika,
                    (SELECT COUNT(DISTINCT als.alat_id)
                     FROM sesija s
                     JOIN alat_sesija als ON als.sesija_id = s.sesija_id
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS broj_alata,
                    (SELECT MIN(s.vreme_pocetka)
                     FROM sesija s
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS prvo_vreme_pocetka,
                    (SELECT MAX(s.vreme_zavrsetka)
                     FROM sesija s
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS poslednje_vreme_zavrsetka,
                    (SELECT COALESCE(SUM(TIMESTAMPDIFF(MINUTE, s.vreme_pocetka, s.vreme_zavrsetka)), 0)
                     FROM sesija s
                     WHERE s.izvodjenje_id = i.izvodjenje_id) AS ukupno_trajanje_minuta,
                    (SELECT ROUND(AVG(x.starost), 1)
                     FROM (
                         SELECT DISTINCT u.ucesnik_id, u.starost
                         FROM sesija s
                         JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                         JOIN ucesnik u ON u.ucesnik_id = su.ucesnik_id
                         WHERE s.izvodjenje_id = i.izvodjenje_id
                     ) x) AS prosecna_starost,
                    (SELECT COUNT(*)
                     FROM (
                         SELECT DISTINCT u.ucesnik_id
                         FROM sesija s
                         JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                         JOIN ucesnik u ON u.ucesnik_id = su.ucesnik_id
                         WHERE s.izvodjenje_id = i.izvodjenje_id
                         AND u.pol = 'M'
                     ) x) AS broj_muskih,
                    (SELECT COUNT(*)
                     FROM (
                         SELECT DISTINCT u.ucesnik_id
                         FROM sesija s
                         JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                         JOIN ucesnik u ON u.ucesnik_id = su.ucesnik_id
                         WHERE s.izvodjenje_id = i.izvodjenje_id
                         AND u.pol = 'Ž'
                     ) x) AS broj_zenskih,
                    (SELECT COUNT(*)
                     FROM (
                         SELECT DISTINCT u.ucesnik_id
                         FROM sesija s
                         JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                         JOIN ucesnik u ON u.ucesnik_id = su.ucesnik_id
                         WHERE s.izvodjenje_id = i.izvodjenje_id
                         AND u.pol IS NOT NULL
                         AND u.pol NOT IN ('M', 'Ž')
                     ) x) AS broj_ostalih
                FROM izvodjenje i
                JOIN anketa a ON a.anketa_id = i.anketa_id
                JOIN laboratorija l ON l.lab_id = i.lab_id
                WHERE i.izvodjenje_id = ?
                AND LOWER(TRIM(i.status)) = ?
                """;

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, executionId);
            ps.setString(2, COMPLETED_STATUS);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                return new CompletedExperiment(
                        rs.getInt("izvodjenje_id"),
                        rs.getInt("anketa_id"),
                        rs.getString("naziv_ankete"),
                        rs.getString("naziv_laboratorije"),
                        rs.getDate("datum"),
                        rs.getString("status"),
                        rs.getInt("broj_sesija"),
                        rs.getInt("broj_ucesnika"),
                        rs.getInt("broj_alata"),
                        rs.getTime("prvo_vreme_pocetka"),
                        rs.getTime("poslednje_vreme_zavrsetka"),
                        rs.getInt("ukupno_trajanje_minuta"),
                        getNullableDouble(rs, "prosecna_starost"),
                        rs.getInt("broj_muskih"),
                        rs.getInt("broj_zenskih"),
                        rs.getInt("broj_ostalih"),
                        getSessionTimeline(executionId),
                        getToolNames(executionId),
                        getEducationBreakdown(executionId)
                );
            }
        } catch (Exception ex) {
            throw new RuntimeException("Neuspesno ucitavanje detalja eksperimenta " + executionId + ".", ex);
        }
    }

    private static CompletedExperiment mapSummary(ResultSet rs) throws Exception {
        return new CompletedExperiment(
                rs.getInt("izvodjenje_id"),
                rs.getInt("anketa_id"),
                rs.getString("naziv_ankete"),
                rs.getString("naziv_laboratorije"),
                rs.getDate("datum"),
                rs.getString("status"),
                rs.getInt("broj_sesija"),
                rs.getInt("broj_ucesnika"),
                rs.getInt("broj_alata"),
                rs.getTime("prvo_vreme_pocetka"),
                rs.getTime("poslednje_vreme_zavrsetka"),
                calculateDurationMinutes(rs.getTime("prvo_vreme_pocetka"), rs.getTime("poslednje_vreme_zavrsetka")),
                null,
                0,
                0,
                0,
                Collections.emptyList(),
                Collections.emptyList(),
                Collections.emptyList()
        );
    }

    private static int calculateDurationMinutes(Time startTime, Time endTime) {
        if (startTime == null || endTime == null) {
            return 0;
        }

        long millis = endTime.getTime() - startTime.getTime();
        return (int) Math.max(millis / 60000L, 0L);
    }

    private static Double getNullableDouble(ResultSet rs, String columnName) throws Exception {
        double value = rs.getDouble(columnName);
        return rs.wasNull() ? null : value;
    }

    private static List<String> getSessionTimeline(int executionId) {
        String sql = """
                SELECT
                    s.sesija_id,
                    s.vreme_pocetka,
                    s.vreme_zavrsetka,
                    COUNT(DISTINCT su.ucesnik_id) AS broj_ucesnika,
                    COUNT(DISTINCT als.alat_id) AS broj_alata
                FROM sesija s
                LEFT JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                LEFT JOIN alat_sesija als ON als.sesija_id = s.sesija_id
                WHERE s.izvodjenje_id = ?
                GROUP BY s.sesija_id, s.vreme_pocetka, s.vreme_zavrsetka
                ORDER BY s.vreme_pocetka ASC, s.sesija_id ASC
                """;

        List<String> timeline = new ArrayList<>();

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, executionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    timeline.add(
                            "Sesija " + rs.getInt("sesija_id") +
                                    ": " + rs.getTime("vreme_pocetka") +
                                    " - " + rs.getTime("vreme_zavrsetka") +
                                    ", ucesnici: " + rs.getInt("broj_ucesnika") +
                                    ", alati: " + rs.getInt("broj_alata")
                    );
                }
            }
        } catch (Exception ex) {
            throw new RuntimeException("Neuspesno ucitavanje vremenske linije sesija.", ex);
        }

        return timeline;
    }

    private static List<String> getToolNames(int executionId) {
        String sql = """
                SELECT DISTINCT
                    CONCAT('Alat #', a.alat_id, ' - ', ta.naziv) AS opis_alata
                FROM sesija s
                JOIN alat_sesija als ON als.sesija_id = s.sesija_id
                JOIN alat a ON a.alat_id = als.alat_id
                JOIN tip_alata ta ON ta.tip_alata_id = a.tip_alata_id
                WHERE s.izvodjenje_id = ?
                ORDER BY opis_alata ASC
                """;

        List<String> tools = new ArrayList<>();

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, executionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tools.add(rs.getString("opis_alata"));
                }
            }
        } catch (Exception ex) {
            throw new RuntimeException("Neuspesno ucitavanje alata eksperimenta.", ex);
        }

        return tools;
    }

    private static List<String> getEducationBreakdown(int executionId) {
        String sql = """
                SELECT
                    u.obrazovanje,
                    COUNT(DISTINCT u.ucesnik_id) AS broj_ucesnika
                FROM sesija s
                JOIN sesija_ucesnik su ON su.sesija_id = s.sesija_id
                JOIN ucesnik u ON u.ucesnik_id = su.ucesnik_id
                WHERE s.izvodjenje_id = ?
                GROUP BY u.obrazovanje
                ORDER BY broj_ucesnika DESC, u.obrazovanje ASC
                """;

        List<String> breakdown = new ArrayList<>();

        try (Connection conn = Config.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, executionId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    breakdown.add(rs.getString("obrazovanje") + ": " + rs.getInt("broj_ucesnika"));
                }
            }
        } catch (Exception ex) {
            throw new RuntimeException("Neuspesno ucitavanje obrazovne strukture ucesnika.", ex);
        }

        return breakdown;
    }
}
