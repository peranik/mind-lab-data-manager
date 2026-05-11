package app;

public class Launcher {

    private static Launcher launcher;

    public static Launcher getLauncher() {
        if (launcher == null) {
            synchronized (Launcher.class) {
                if (launcher == null)
                    launcher = new Launcher();
            }
        }
        return launcher;
    }

    private Launcher() {

    }

    public void launch(String... args) {
        this.setUp(args);
        this.work(args);
        this.clean(args);
    }

    public static void setUp(String... args) {
        String cfgFile = "database.cfg";

        Config.loadProperties(cfgFile);

        Config.connect(
                Config.getPropertyValue("host", "localhost"),
                Config.getPropertyValue("port", "3306"),
                Config.getPropertyValue("db", ""),
                Config.getPropertyValue("user", ""),
                Config.getPropertyValue("password", "")
        );
    }

    private void work(String... args) {
        App.launch(App.class, args);
    }

    private void clean(String... args) {
        Config.disconnect();
    }

}
