module artikli {
    requires javafx.controls;
    requires javafx.graphics;
    requires javafx.base;
    requires java.sql;
    requires mysql.connector.j;
    requires java.desktop;
    requires artikli;
    opens model to javafx.base;
    opens database to javafx.base;
    exports app;
}