package com.testweba.model;

public class PV {

    private int id;
    private String titre;
    private String dateReunion;
    private String ordreDuJour;
    private String pvPath;
    private Integer createdBy;
    private String createdAt;

    public PV() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDateReunion() { return dateReunion; }
    public void setDateReunion(String dateReunion) { this.dateReunion = dateReunion; }

    public String getOrdreDuJour() { return ordreDuJour; }
    public void setOrdreDuJour(String ordreDuJour) { this.ordreDuJour = ordreDuJour; }

    public String getPvPath() { return pvPath; }
    public void setPvPath(String pvPath) { this.pvPath = pvPath; }

    public Integer getCreatedBy() { return createdBy; }
    public void setCreatedBy(Integer createdBy) { this.createdBy = createdBy; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}