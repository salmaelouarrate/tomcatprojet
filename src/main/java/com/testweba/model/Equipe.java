package com.testweba.model;

public class Equipe {

    private int id;
    private String nom;
    private String description;
    private String createdAt;
    private int nombreMembres;

    public Equipe() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getNombreMembres() { return nombreMembres; }
    public void setNombreMembres(int nombreMembres) { this.nombreMembres = nombreMembres; }
}