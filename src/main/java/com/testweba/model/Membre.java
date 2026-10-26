package com.testweba.model;

import java.sql.Date;

public class Membre {

    private int     id;
    private String  nom;
    private String  prenom;
    private String  email;
    private String  motDePasse;
    private String  statut;
    private String  role;
    private String  etablissement;
    private String  laboratoire;
    private String  laboratoireOrigine;
    private String  biographie;
    private String  centresInteret;
    private String  photo;
    private Date    dateNaissance;
    private Date    dateEmbauche;
    private Integer equipeId;
    private boolean actif;

    public Membre() {}

    // Getters & Setters
    public int     getId()                        { return id; }
    public void    setId(int id)                  { this.id = id; }

    public String  getNom()                       { return nom; }
    public void    setNom(String nom)             { this.nom = nom; }

    public String  getPrenom()                    { return prenom; }
    public void    setPrenom(String prenom)       { this.prenom = prenom; }

    public String  getEmail()                     { return email; }
    public void    setEmail(String email)         { this.email = email; }

    public String  getMotDePasse()                { return motDePasse; }
    public void    setMotDePasse(String mp)       { this.motDePasse = mp; }

    public String  getStatut()                    { return statut; }
    public void    setStatut(String statut)       { this.statut = statut; }

    public String  getRole()                      { return role; }
    public void    setRole(String role)           { this.role = role; }

    public String  getEtablissement()             { return etablissement; }
    public void    setEtablissement(String e)     { this.etablissement = e; }

    public String  getLaboratoire()               { return laboratoire; }
    public void    setLaboratoire(String laboratoire) { this.laboratoire = laboratoire; }

    public String  getLaboratoireOrigine()        { return laboratoireOrigine; }
    public void    setLaboratoireOrigine(String laboratoireOrigine) { this.laboratoireOrigine = laboratoireOrigine; }

    public String  getBiographie()                { return biographie; }
    public void    setBiographie(String b)        { this.biographie = b; }

    public String  getCentresInteret()            { return centresInteret; }
    public void    setCentresInteret(String centresInteret) { this.centresInteret = centresInteret; }

    public String  getPhoto()                     { return photo; }
    public void    setPhoto(String photo)         { this.photo = photo; }

    public Date    getDateNaissance()             { return dateNaissance; }
    public void    setDateNaissance(Date dateNaissance) { this.dateNaissance = dateNaissance; }

    public Date    getDateEmbauche()              { return dateEmbauche; }
    public void    setDateEmbauche(Date dateEmbauche) { this.dateEmbauche = dateEmbauche; }

    public Integer getEquipeId()                  { return equipeId; }
    public void    setEquipeId(Integer equipeId)  { this.equipeId = equipeId; }

    public boolean isActif()                      { return actif; }
    public void    setActif(boolean actif)        { this.actif = actif; }

    public String  getNomComplet()                {
        String p = prenom == null ? "" : prenom;
        String n = nom == null ? "" : nom;
        return (p + " " + n).trim();
    }
}