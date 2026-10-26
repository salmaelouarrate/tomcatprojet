package com.testweba.model;

import java.sql.Date;

public class Mandat {

    private int id;
    private int directeurId;
    private Integer viceDirecteurId;
    private Integer membreId;
    private String typeMandat;
    private Date dateDebut;
    private Date dateFin;
    private boolean actif;
    private String description;

    private String nomMembre;
    private String prenomMembre;
    private String emailMembre;

    public Mandat() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public int getDirecteurId() {
        return directeurId;
    }

    public void setDirecteurId(int directeurId) {
        this.directeurId = directeurId;
    }

    public Integer getViceDirecteurId() {
        return viceDirecteurId;
    }

    public void setViceDirecteurId(Integer viceDirecteurId) {
        this.viceDirecteurId = viceDirecteurId;
    }

    public Integer getMembreId() {
        return membreId;
    }

    public void setMembreId(Integer membreId) {
        this.membreId = membreId;
    }

    public String getTypeMandat() {
        return typeMandat;
    }

    public void setTypeMandat(String typeMandat) {
        this.typeMandat = typeMandat;
    }

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    public boolean isActif() {
        return actif;
    }

    public void setActif(boolean actif) {
        this.actif = actif;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNomMembre() {
        return nomMembre;
    }

    public void setNomMembre(String nomMembre) {
        this.nomMembre = nomMembre;
    }

    public String getPrenomMembre() {
        return prenomMembre;
    }

    public void setPrenomMembre(String prenomMembre) {
        this.prenomMembre = prenomMembre;
    }

    public String getEmailMembre() {
        return emailMembre;
    }

    public void setEmailMembre(String emailMembre) {
        this.emailMembre = emailMembre;
    }

    public String getNomCompletMembre() {
        String prenom = prenomMembre == null ? "" : prenomMembre;
        String nom = nomMembre == null ? "" : nomMembre;
        return (prenom + " " + nom).trim();
    }
}