package data;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

public class UserFileDB {

    private static final String FILE = "users.txt";

    // LOGIN
    public static boolean login(String username, String password) {

        try (BufferedReader br = new BufferedReader(new FileReader(FILE))) {

            String line;
            while ((line = br.readLine()) != null) {

                String[] parts = line.split(" ");
                if (parts.length != 2) continue;

                if (parts[0].equals(username) && parts[1].equals(password)) {
                    return true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // REGISTER
    public static boolean register(String username, String password) {

        if (exists(username)) return false;

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE, true))) {
            bw.write(username + " " + password);
            bw.newLine();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // DELETE
    public static boolean delete(String username) {

        List<String> users = loadAll();
        List<String> updated = new ArrayList<>();

        boolean found = false;

        for (String u : users) {
            String[] parts = u.split(" ");
            if (parts[0].equals(username)) {
                found = true;
                continue;
            }
            updated.add(u);
        }

        if (!found) return false;

        saveAll(updated);
        return true;
    }

    // EXISTS
    private static boolean exists(String username) {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE))) {

            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(" ");
                if (parts[0].equals(username)) return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // LOAD
    private static List<String> loadAll() {
        List<String> list = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(FILE))) {

            String line;
            while ((line = br.readLine()) != null) {
                list.add(line);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // SAVE
    private static void saveAll(List<String> users) {

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE))) {

            for (String u : users) {
                bw.write(u);
                bw.newLine();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
