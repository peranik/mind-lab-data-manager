package model;

import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class CompletedExperiment {

    private final int executionId;
    private final int surveyId;
    private final String surveyName;
    private final String laboratoryName;
    private final Date executionDate;
    private final String status;
    private final int sessionCount;
    private final int participantCount;
    private final int toolCount;
    private final Time startTime;
    private final Time endTime;
    private final int totalDurationMinutes;
    private final Double averageAge;
    private final int maleCount;
    private final int femaleCount;
    private final int otherCount;
    private final List<String> sessionTimeline;
    private final List<String> toolNames;
    private final List<String> educationBreakdown;

    public CompletedExperiment(int executionId,
                               int surveyId,
                               String surveyName,
                               String laboratoryName,
                               Date executionDate,
                               String status,
                               int sessionCount,
                               int participantCount,
                               int toolCount,
                               Time startTime,
                               Time endTime,
                               int totalDurationMinutes,
                               Double averageAge,
                               int maleCount,
                               int femaleCount,
                               int otherCount,
                               List<String> sessionTimeline,
                               List<String> toolNames,
                               List<String> educationBreakdown) {
        this.executionId = executionId;
        this.surveyId = surveyId;
        this.surveyName = surveyName;
        this.laboratoryName = laboratoryName;
        this.executionDate = executionDate;
        this.status = status;
        this.sessionCount = sessionCount;
        this.participantCount = participantCount;
        this.toolCount = toolCount;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalDurationMinutes = totalDurationMinutes;
        this.averageAge = averageAge;
        this.maleCount = maleCount;
        this.femaleCount = femaleCount;
        this.otherCount = otherCount;
        this.sessionTimeline = copyOf(sessionTimeline);
        this.toolNames = copyOf(toolNames);
        this.educationBreakdown = copyOf(educationBreakdown);
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

    public Date getExecutionDate() {
        return executionDate;
    }

    public String getStatus() {
        return status;
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

    public Time getStartTime() {
        return startTime;
    }

    public Time getEndTime() {
        return endTime;
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

    public List<String> getSessionTimeline() {
        return sessionTimeline;
    }

    public List<String> getToolNames() {
        return toolNames;
    }

    public List<String> getEducationBreakdown() {
        return educationBreakdown;
    }

    private List<String> copyOf(List<String> values) {
        if (values == null || values.isEmpty()) {
            return Collections.emptyList();
        }

        return Collections.unmodifiableList(new ArrayList<>(values));
    }
}
