package com.testweba.model;

public class DemandeMateriel {

    private int id;
    private int membreId;
    private String materielNom;
    private int quantite;
    private String justification;
    private String description;
    private String statut;
    private String dateDemande;
    private Integer traitePar;
    private String dateDecision;
    private String membreNom;

    public DemandeMateriel() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public String getMaterielNom() { return materielNom; }
    public void setMaterielNom(String materielNom) { this.materielNom = materielNom; }

    public int getQuantite() { return quantite; }
    public void setQuantite(int quantite) { this.quantite = quantite; }

    public String getJustification() { return justification; }
    public void setJustification(String justification) { this.justification = justification; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getDateDemande() { return dateDemande; }
    public void setDateDemande(String dateDemande) { this.dateDemande = dateDemande; }

    public Integer getTraitePar() { return traitePar; }
    public void setTraitePar(Integer traitePar) { this.traitePar = traitePar; }

    public String getDateDecision() { return dateDecision; }
    public void setDateDecision(String dateDecision) { this.dateDecision = dateDecision; }

    public String getMembreNom() { return membreNom; }
    public void setMembreNom(String membreNom) { this.membreNom = membreNom; }
}