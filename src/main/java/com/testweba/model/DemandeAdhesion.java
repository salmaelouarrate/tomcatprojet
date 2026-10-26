package com.testweba.model;

public class DemandeAdhesion {

    private int id;
    private String nom;
    private String prenom;
    private String email;
    private String motivation;
    private String cvPath;
    private String statut;
    private String statutMembre;
    private String roleMembre;
    private Integer traitePar;
    private String dateDemande;
    private String dateDecision;

    public DemandeAdhesion() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    } 

    public String getMotivation() {
        return motivation;
    }

    public void setMotivation(String motivation) {
        this.motivation = motivation;
    }

    public String getCvPath() {
        return cvPath;
    }

    public void setCvPath(String cvPath) {
        this.cvPath = cvPath;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getStatutMembre() {
        return statutMembre;
    }

    public void setStatutMembre(String statutMembre) {
        this.statutMembre = statutMembre;
    }

    public String getRoleMembre() {
        return roleMembre;
    }

    public void setRoleMembre(String roleMembre) {
        this.roleMembre = roleMembre;
    }

    public Integer getTraitePar() {
        return traitePar;
    }

    public void setTraitePar(Integer traitePar) {
        this.traitePar = traitePar;
    }

    public String getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(String dateDemande) {
        this.dateDemande = dateDemande;
    }

    public String getDateDecision() {
        return dateDecision;
    }

    public void setDateDecision(String dateDecision) {
        this.dateDecision = dateDecision;
    }

    public String getNomComplet() {
        String p = prenom == null ? "" : prenom;
        String n = nom == null ? "" : nom;
        return (p + " " + n).trim();
    }
}