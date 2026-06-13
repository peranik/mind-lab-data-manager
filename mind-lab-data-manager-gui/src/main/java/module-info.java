module artikli {
    requires javafx.controls;
    requires javafx.graphics;
    requires javafx.base;
    requires java.sql;
    requires java.desktop;
    requires org.mongodb.driver.sync.client;
    requires org.mongodb.driver.core;
    requires org.mongodb.bson;
    opens model to javafx.base;
    opens database to javafx.base;
    exports app;
}
