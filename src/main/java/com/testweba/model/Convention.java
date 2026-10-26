package com.testweba.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Convention {

private int id;
private String partenaire;
private String pays;
private String objet;
private Date dateDebut;
private Date dateFin;
private String statut;
private Timestamp createdAt;

public Convention() {
}

public Convention(int id, String partenaire, String pays, String objet,
Date dateDebut, Date dateFin, String statut, Timestamp createdAt) {
this.id = id;
this.partenaire = partenaire;
this.pays = pays;
this.objet = objet;
this.dateDebut = dateDebut;
this.dateFin = dateFin;
this.statut = statut;

this.createdAt = createdAt;
}

public Convention(String partenaire, String pays, String objet,
Date dateDebut, Date dateFin, String statut) {
this.partenaire = partenaire;
this.pays = pays;
this.objet = objet;
this.dateDebut = dateDebut;
this.dateFin = dateFin;
this.statut = statut;
}

public int getId() {
return id;
}

public void setId(int id) {
this.id = id;
}

public String getPartenaire() {
return partenaire;
}

public void setPartenaire(String partenaire) {
this.partenaire = partenaire;
}

public String getPays() {
return pays;
}

public void setPays(String pays) {
this.pays = pays;
}

public String getObjet() {
return objet;
}

public void setObjet(String objet) {
this.objet = objet;
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

public String getStatut() {
return statut;
}

public void setStatut(String statut) {
this.statut = statut;
}

public Timestamp getCreatedAt() {
return createdAt;
}

public void setCreatedAt(Timestamp createdAt) {
this.createdAt = createdAt;
}
}