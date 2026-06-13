package database;

import app.Config;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.mongodb.client.model.Indexes;
import org.bson.Document;

public final class MongoManager {

    private static MongoClient client;
    private static MongoDatabase database;
    private static MongoCollection<Document> collection;

    public static synchronized MongoCollection<Document> getInsightsCollection() {
        if (collection == null) {
            initialize();
        }

        return collection;
    }

    private static void initialize() {
        String connectionString = Config.getPropertyValue("mongo.uri", "mongodb://localhost:27017");
        String databaseName = Config.getPropertyValue("mongo.db", "mind_lab_data_manager_docs");
        String collectionName = Config.getPropertyValue("mongo.collection", "completed_experiment_insights");

        client = MongoClients.create(connectionString);
        database = client.getDatabase(databaseName);
        collection = database.getCollection(collectionName);
        collection.createIndex(Indexes.ascending("izvodjenje_id"), new IndexOptions().unique(true));

        Runtime.getRuntime().addShutdownHook(new Thread(MongoManager::closeClient));
    }

    private static synchronized void closeClient() {
        if (client != null) {
            client.close();
            client = null;
            database = null;
            collection = null;
        }
    }

    private MongoManager() {
    }
}
