package com.lcg.models;

public class Workline {
    private String worklineId;
    private String facilitatorId;
    private String noOfWorklines;

    public Workline() {
    }

    public Workline(String worklineId, String facilitatorId, String noOfWorklines) {
        this.worklineId = worklineId;
        this.facilitatorId = facilitatorId;
        this.noOfWorklines = noOfWorklines;
    }

    public String getWorklineId() {
        return worklineId;
    }

    public void setWorklineId(String worklineId) {
        this.worklineId = worklineId;
    }

    public String getFacilitatorId() {
        return facilitatorId;
    }

    public void setFacilitatorId(String facilitatorId) {
        this.facilitatorId = facilitatorId;
    }

    public String getNoOfWorklines() {
        return noOfWorklines;
    }

    public void setNoOfWorklines(String noOfWorklines) {
        this.noOfWorklines = noOfWorklines;
    }
}
