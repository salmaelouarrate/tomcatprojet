package com.testweba.model;

public class Message {

    private int id;
    private String contexte;
    private Integer contexteId;
    private int membreId;
    private String contenu;
    private String dateEnvoi;
    private String membreNom;

    public Message() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getContexte() { return contexte; }
    public void setContexte(String contexte) { this.contexte = contexte; }

    public Integer getContexteId() { return contexteId; }
    public void setContexteId(Integer contexteId) { this.contexteId = contexteId; }

    public int getMembreId() { return membreId; }
    public void setMembreId(int membreId) { this.membreId = membreId; }

    public String getContenu() { return contenu; }
    public void setContenu(String contenu) { this.contenu = contenu; }

    public String getDateEnvoi() { return dateEnvoi; }
    public void setDateEnvoi(String dateEnvoi) { this.dateEnvoi = dateEnvoi; }

    public String getMembreNom() { return membreNom; }
    public void setMembreNom(String membreNom) { this.membreNom = membreNom; }
}