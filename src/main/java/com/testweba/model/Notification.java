package com.testweba.model;

import java.sql.Timestamp;

public class Notification {

    private int id;
    private int membreId;
    private String message;
    private boolean lue;
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(int membreId, String message) {
        this.membreId = membreId;
        this.message = message;
        this.lue = false;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMembreId() {
        return membreId;
    }

    public void setMembreId(int membreId) {
        this.membreId = membreId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isLue() {
        return lue;
    }

    public void setLue(boolean lue) {
        this.lue = lue;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}