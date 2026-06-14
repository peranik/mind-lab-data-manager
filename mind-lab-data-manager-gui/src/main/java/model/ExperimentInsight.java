package model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ExperimentInsight {

    private final int executionId;
    private final int surveyId;
    private final String surveyName;
    private final String laboratoryName;
    private final String executionDate;
    private final String status;
    private final String qualitativeSummary;
    private final String methodologicalAssessment;
    private final String recommendation;
    private final String dataQuality;
    private final List<String> keyObservations;
    private final List<String> sessionTimeline;
    private final List<String> toolNames;
    private final List<String> educationBreakdown;
    private final int sessionCount;
    private final int participantCount;
    private final int toolCount;
    private final int totalDurationMinutes;
    private final Double averageAge;
    private final int maleCount;
    private final int femaleCount;
    private final int otherCount;
    private final double reliabilityIndex;
    private final double engagementScore;
    private final String rawJson;

    public ExperimentInsight(int executionId,
                             int surveyId,
                             String surveyName,
                             String laboratoryName,
                             String executionDate,
                             String status,
                             String qualitativeSummary,
                             String methodologicalAssessment,
                             String recommendation,
                             String dataQuality,
                             List<String> keyObservations,
                             List<String> sessionTimeline,
                             List<String> toolNames,
                             List<String> educationBreakdown,
                             int sessionCount,
                             int participantCount,
                             int toolCount,
                             int totalDurationMinutes,
                             Double averageAge,
                             int maleCount,
                             int femaleCount,
                             int otherCount,
                             double reliabilityIndex,
                             double engagementScore,
                             String rawJson) {
        this.executionId = executionId;
        this.surveyId = surveyId;
        this.surveyName = surveyName;
        this.laboratoryName = laboratoryName;
        this.executionDate = executionDate;
        this.status = status;
        this.qualitativeSummary = qualitativeSummary;
        this.methodologicalAssessment = methodologicalAssessment;
        this.recommendation = recommendation;
        this.dataQuality = dataQuality;
        this.keyObservations = copyOf(keyObservations);
        this.sessionTimeline = copyOf(sessionTimeline);
        this.toolNames = copyOf(toolNames);
        this.educationBreakdown = copyOf(educationBreakdown);
        this.sessionCount = sessionCount;
        this.participantCount = participantCount;
        this.toolCount = toolCount;
        this.totalDurationMinutes = totalDurationMinutes;
        this.averageAge = averageAge;
        this.maleCount = maleCount;
        this.femaleCount = femaleCount;
        this.otherCount = otherCount;
        this.reliabilityIndex = reliabilityIndex;
        this.engagementScore = engagementScore;
        this.rawJson = rawJson;
    }

    public int getExecutionId() {
        return executionId;
    }

    public int getSurveyId() {
        return surveyId;
    }

    public String getSurveyName() {
        return surveyName;
    }

    public String getLaboratoryName() {
        return laboratoryName;
    }

    public String getExecutionDate() {
        return executionDate;
    }

    public String getStatus() {
        return status;
    }

    public String getQualitativeSummary() {
        return qualitativeSummary;
    }

    public String getMethodologicalAssessment() {
        return methodologicalAssessment;
    }

    public String getRecommendation() {
        return recommendation;
    }

    public String getDataQuality() {
        return dataQuality;
    }

    public List<String> getKeyObservations() {
        return keyObservations;
    }

    public List<String> getSessionTimeline() {
        return sessionTimeline;
    }

    public List<String> getToolNames() {
        return toolNames;
    }

    public List<String> getEducationBreakdown() {
        return educationBreakdown;
    }

    public int getSessionCount() {
        return sessionCount;
    }

    public int getParticipantCount() {
        return participantCount;
    }

    public int getToolCount() {
        return toolCount;
    }

    public int getTotalDurationMinutes() {
        return totalDurationMinutes;
    }

    public Double getAverageAge() {
        return averageAge;
    }

    public int getMaleCount() {
        return maleCount;
    }

    public int getFemaleCount() {
        return femaleCount;
    }

    public int getOtherCount() {
        return otherCount;
    }

    public double getReliabilityIndex() {
        return reliabilityIndex;
    }

    public double getEngagementScore() {
        return engagementScore;
    }

    public String getRawJson() {
        return rawJson;
    }

    private List<String> copyOf(List<String> values) {
        if (values == null || values.isEmpty()) {
            return Collections.emptyList();
        }

        return Collections.unmodifiableList(new ArrayList<>(values));
    }
}
