package database;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.model.Filters;
import model.CompletedExperiment;
import model.ExperimentInsight;
import org.bson.Document;
import service.AiExperimentInsightGenerator;

import java.util.Collections;
import java.util.List;

public class ExperimentInsightRepository {

    public int syncMissingInsights() {
        int insertedCount = 0;
        MongoCollection<Document> collection = MongoManager.getInsightsCollection();

        for (CompletedExperiment summary : CompletedExperimentDAO.getAllCompleted()) {
            if (collection.find(Filters.eq("izvodjenje_id", summary.getExecutionId())).first() != null) {
                continue;
            }

            CompletedExperiment detailedExperiment = CompletedExperimentDAO.getCompletedExperiment(summary.getExecutionId());
            if (detailedExperiment == null) {
                continue;
            }

            collection.insertOne(AiExperimentInsightGenerator.generate(detailedExperiment));
            insertedCount++;
        }

        return insertedCount;
    }

    public ExperimentInsight getByExecutionId(int executionId) {
        MongoCollection<Document> collection = MongoManager.getInsightsCollection();
        Document document = collection.find(Filters.eq("izvodjenje_id", executionId)).first();

        if (document == null) {
            CompletedExperiment detailedExperiment = CompletedExperimentDAO.getCompletedExperiment(executionId);
            if (detailedExperiment == null) {
                return null;
            }

            document = AiExperimentInsightGenerator.generate(detailedExperiment);
            collection.insertOne(document);
        }

        return map(document);
    }

    private ExperimentInsight map(Document document) {
        Document aiMeta = getDocument(document, "ai_meta");
        Document qualitative = getDocument(document, "kvalitativni_rezultati");
        Document quantitative = getDocument(document, "kvantitativni_rezultati");
        Document genderBreakdown = getDocument(quantitative, "polna_struktura");
        Document supportingData = getDocument(document, "prateci_podaci");

        return new ExperimentInsight(
                document.getInteger("izvodjenje_id", 0),
                document.getInteger("anketa_id", 0),
                document.getString("naziv_ankete"),
                document.getString("naziv_laboratorije"),
                document.getString("datum_izvodjenja"),
                document.getString("status"),
                aiMeta.getString("generator"),
                aiMeta.getString("generated_at_utc"),
                qualitative.getString("sazetak"),
                qualitative.getString("metodoloska_procena"),
                qualitative.getString("preporuka"),
                qualitative.getString("kvalitet_podataka"),
                getStringList(qualitative, "kljucne_opservacije"),
                getStringList(supportingData, "vremenska_linija_sesija"),
                getStringList(supportingData, "korisceni_alati"),
                getStringList(supportingData, "obrazovna_struktura"),
                quantitative.getInteger("broj_sesija", 0),
                quantitative.getInteger("broj_ucesnika", 0),
                quantitative.getInteger("broj_alata", 0),
                quantitative.getInteger("ukupno_trajanje_minuta", 0),
                quantitative.getDouble("prosecna_starost"),
                genderBreakdown.getInteger("muski", 0),
                genderBreakdown.getInteger("zenski", 0),
                genderBreakdown.getInteger("ostali", 0),
                quantitative.getDouble("indeks_pouzdanosti") == null ? 0.0 : quantitative.getDouble("indeks_pouzdanosti"),
                quantitative.getDouble("skor_angazovanosti") == null ? 0.0 : quantitative.getDouble("skor_angazovanosti"),
                document.toJson()
        );
    }

    private Document getDocument(Document source, String key) {
        if (source == null) {
            return new Document();
        }

        Document value = source.get(key, Document.class);
        return value == null ? new Document() : value;
    }

    private List<String> getStringList(Document source, String key) {
        if (source == null) {
            return Collections.emptyList();
        }

        List<String> values = source.getList(key, String.class);
        return values == null ? Collections.emptyList() : values;
    }
}
