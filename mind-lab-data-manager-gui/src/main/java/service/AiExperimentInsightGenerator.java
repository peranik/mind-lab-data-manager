package service;

import model.CompletedExperiment;
import org.bson.Document;

import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

public final class AiExperimentInsightGenerator {

    private static final String GENERATOR_NAME = "Codex AI Insight Builder";

    public static Document generate(CompletedExperiment experiment) {
        double reliabilityIndex = roundTo2(calculateReliabilityIndex(experiment));
        double engagementScore = roundTo2(calculateEngagementScore(experiment));

        Document qualitative = new Document()
                .append("sazetak", buildSummary(experiment))
                .append("kljucne_opservacije", buildObservations(experiment))
                .append("metodoloska_procena", buildMethodologicalAssessment(experiment, reliabilityIndex))
                .append("preporuka", buildRecommendation(experiment))
                .append("kvalitet_podataka", describeDataQuality(reliabilityIndex));

        Document quantitative = new Document()
                .append("broj_sesija", experiment.getSessionCount())
                .append("broj_ucesnika", experiment.getParticipantCount())
                .append("broj_alata", experiment.getToolCount())
                .append("ukupno_trajanje_minuta", experiment.getTotalDurationMinutes())
                .append("prosecna_starost", experiment.getAverageAge())
                .append("polna_struktura", new Document()
                        .append("muski", experiment.getMaleCount())
                        .append("zenski", experiment.getFemaleCount())
                        .append("ostali", experiment.getOtherCount()))
                .append("indeks_pouzdanosti", reliabilityIndex)
                .append("skor_angazovanosti", engagementScore);

        Document supportingData = new Document()
                .append("vremenska_linija_sesija", experiment.getSessionTimeline())
                .append("korisceni_alati", experiment.getToolNames())
                .append("obrazovna_struktura", experiment.getEducationBreakdown());

        return new Document()
                .append("izvodjenje_id", experiment.getExecutionId())
                .append("anketa_id", experiment.getSurveyId())
                .append("naziv_ankete", experiment.getSurveyName())
                .append("naziv_laboratorije", experiment.getLaboratoryName())
                .append("datum_izvodjenja", experiment.getExecutionDate() == null ? null : experiment.getExecutionDate().toString())
                .append("status", experiment.getStatus())
                .append("ai_meta", new Document()
                        .append("generator", GENERATOR_NAME)
                        .append("generated_at_utc", OffsetDateTime.now(ZoneOffset.UTC).toString())
                        .append("source", "relational-to-document enrichment"))
                .append("kvalitativni_rezultati", qualitative)
                .append("kvantitativni_rezultati", quantitative)
                .append("prateci_podaci", supportingData);
    }

    private static String buildSummary(CompletedExperiment experiment) {
        String agePart = experiment.getAverageAge() == null
                ? "bez dovoljnog broja demografskih uzoraka za pouzdanu procenu starosti"
                : "uz prosečnu starost učesnika od " + experiment.getAverageAge() + " godina";

        return "AI analiza ukazuje da je eksperiment \"" + experiment.getSurveyName() + "\" u laboratoriji \"" +
                experiment.getLaboratoryName() + "\" uspešno realizovan kroz " + experiment.getSessionCount() +
                " sesija, sa " + experiment.getParticipantCount() + " učesnika i " + experiment.getToolCount() +
                " alata, " + agePart + ".";
    }

    private static List<String> buildObservations(CompletedExperiment experiment) {
        List<String> observations = new ArrayList<>();
        observations.add("Završeni status izvođenja i kompletiran vremenski raspon ukazuju na stabilno sproveden protokol.");

        if (experiment.getParticipantCount() >= 4) {
            observations.add("Veličina uzorka je dovoljna za osnovnu internu komparaciju obrazaca ponašanja među učesnicima.");
        } else if (experiment.getParticipantCount() > 0) {
            observations.add("Uzorak je manji i rezultate treba tumačiti kao eksploratorne, ali dovoljno fokusirane za kvalitativne uvide.");
        } else {
            observations.add("Nema evidentiranih učesnika u relacijskoj bazi, pa je dokument pripremljen kao operativni zapis eksperimenta.");
        }

        if (experiment.getToolCount() >= 3) {
            observations.add("Broj korišćenih alata sugeriše višekanalno prikupljanje podataka i bolju pokrivenost ponašajnih signala.");
        } else if (experiment.getToolCount() > 0) {
            observations.add("Ograničen broj alata verovatno je doprineo jednostavnijem, ali konzistentnijem izvođenju sesije.");
        } else {
            observations.add("Za izvođenje nije vezan nijedan alat, pa je potreban dodatni oprez pri proceni dubine merenja.");
        }

        observations.add("Ukupno trajanje od " + experiment.getTotalDurationMinutes() +
                " minuta ostavlja prostor za umereno duboku interpretaciju bez preopterećenja učesnika.");
        return observations;
    }

    private static String buildMethodologicalAssessment(CompletedExperiment experiment, double reliabilityIndex) {
        String reliabilityText = reliabilityIndex >= 0.85
                ? "visoku"
                : reliabilityIndex >= 0.72 ? "solidnu" : "ograničenu";

        return "Metodološka procena daje " + reliabilityText +
                " internu pouzdanost dokumentovanih rezultata, uz dominantan oslonac na trajanje sesije, broj učesnika i broj instrumenata.";
    }

    private static String buildRecommendation(CompletedExperiment experiment) {
        if (experiment.getParticipantCount() < 3) {
            return "Preporučuje se proširenje uzorka pre izvođenja naredne iteracije kako bi kvantitativni trendovi bili stabilniji.";
        }

        if (experiment.getToolCount() < 2) {
            return "Za naredni ciklus preporučuje se uključivanje dodatnog mernog alata radi bogatije triangulacije podataka.";
        }

        return "Rezultati su pogodni za dalje poređenje sa srodnim eksperimentima i izradu naprednijih interpretativnih beleški.";
    }

    private static String describeDataQuality(double reliabilityIndex) {
        if (reliabilityIndex >= 0.85) {
            return "visok";
        }
        if (reliabilityIndex >= 0.72) {
            return "srednji";
        }
        return "potrebna dopuna";
    }

    private static double calculateReliabilityIndex(CompletedExperiment experiment) {
        double score = 0.58;
        score += Math.min(experiment.getParticipantCount(), 8) * 0.03;
        score += Math.min(experiment.getToolCount(), 5) * 0.04;
        score += Math.min(experiment.getSessionCount(), 4) * 0.03;
        score += Math.min(experiment.getTotalDurationMinutes(), 120) / 120.0 * 0.12;
        return Math.min(score, 0.98);
    }

    private static double calculateEngagementScore(CompletedExperiment experiment) {
        double score = 52.0;
        score += Math.min(experiment.getParticipantCount(), 10) * 3.2;
        score += Math.min(experiment.getToolCount(), 6) * 3.8;
        score += Math.min(experiment.getTotalDurationMinutes(), 120) / 120.0 * 12.0;
        return Math.min(score, 100.0);
    }

    private static double roundTo2(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private AiExperimentInsightGenerator() {
    }
}
