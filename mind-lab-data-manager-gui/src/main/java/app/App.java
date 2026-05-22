package app;

import javafx.application.Application;
import javafx.stage.Stage;
public class App extends Application {

    @Override
    public void start(Stage stage) {
        SceneManager.init(stage);
        SceneManager.showLogin();
    }

    @Override
    public void stop() {
        Config.disconnect();
    }

    public static void main(String[] args){
        Launcher.setUp();
        Application.launch(App.class, args);
    }
}
