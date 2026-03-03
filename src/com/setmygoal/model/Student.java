package com.setmygoal.model;

public class Student {
    private int id;
    private String fullName;
    private String email;
    private String password;      // used by new code
    private String passwordHash;  // used by old AuthService
    private String standard;
    private String board;
    private String medium;
    private String interest;
    private String state;
    private String careerStream;
    private String goalTimeline;
    private String prepLevel;
    private String createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    // New code uses getPassword/setPassword
    public String getPassword() { return password; }
    public void setPassword(String password) {
        this.password = password;
        this.passwordHash = password; // keep both in sync
    }

    // Old AuthService uses getPasswordHash/setPasswordHash
    public String getPasswordHash() { return passwordHash != null ? passwordHash : password; }
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
        this.password = passwordHash; // keep both in sync
    }

    public String getStandard() { return standard; }
    public void setStandard(String standard) { this.standard = standard; }

    public String getBoard() { return board; }
    public void setBoard(String board) { this.board = board; }

    public String getMedium() { return medium; }
    public void setMedium(String medium) { this.medium = medium; }

    public String getInterest() { return interest; }
    public void setInterest(String interest) { this.interest = interest; }

    // Old code still calls this — return empty string so no crash
    public String getConfusionLevel() { return ""; }
    public void setConfusionLevel(String c) { /* ignored, column removed */ }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getCareerStream() { return careerStream; }
    public void setCareerStream(String careerStream) { this.careerStream = careerStream; }

    public String getGoalTimeline() { return goalTimeline; }
    public void setGoalTimeline(String goalTimeline) { this.goalTimeline = goalTimeline; }

    public String getPrepLevel() { return prepLevel; }
    public void setPrepLevel(String prepLevel) { this.prepLevel = prepLevel; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}