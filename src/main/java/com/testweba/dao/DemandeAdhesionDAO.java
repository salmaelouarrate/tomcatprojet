package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.DemandeAdhesion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DemandeAdhesionDAO {

    public List<DemandeAdhesion> findAll() {
        List<DemandeAdhesion> demandes = new ArrayList<>();

        String sql = "SELECT * FROM demande_adhesion ORDER BY id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                demandes.add(mapDemande(rs));
            }

        } catch (SQLException e) {
            System.err.println("[DemandeAdhesionDAO] Erreur findAll : " + e.getMessage());
        }

        return demandes;
    }

    public DemandeAdhesion findById(int id) {
        String sql = "SELECT * FROM demande_adhesion WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapDemande(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[DemandeAdhesionDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(DemandeAdhesion demande) {
        String sql = "INSERT INTO demande_adhesion "
                + "(nom, prenom, email, motivation, cv_path, statut, statut_membre, role_membre) "
                + "VALUES (?, ?, ?, ?, ?, 'en_attente', ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String statutMembre = demande.getStatutMembre();
            String roleMembre = demande.getRoleMembre();

            if (statutMembre == null || statutMembre.trim().isEmpty()) {
                statutMembre = "doctorant";
            }

            if (roleMembre == null || roleMembre.trim().isEmpty()) {
                roleMembre = "doctorant";
            }

            ps.setString(1, demande.getNom());
            ps.setString(2, demande.getPrenom());
            ps.setString(3, demande.getEmail());
            ps.setString(4, demande.getMotivation());
            ps.setString(5, demande.getCvPath());
            ps.setString(6, statutMembre);
            ps.setString(7, roleMembre);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeAdhesionDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean changerStatut(int id, String statut, int traitePar) {
        String sql = "UPDATE demande_adhesion "
                + "SET statut = ?, traite_par = ?, date_decision = CURRENT_TIMESTAMP "
                + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, statut);
            ps.setInt(2, traitePar);
            ps.setInt(3, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeAdhesionDAO] Erreur changerStatut : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM demande_adhesion WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeAdhesionDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    private DemandeAdhesion mapDemande(ResultSet rs) throws SQLException {
        DemandeAdhesion demande = new DemandeAdhesion();

        demande.setId(rs.getInt("id"));
        demande.setNom(rs.getString("nom"));
        demande.setPrenom(rs.getString("prenom"));
        demande.setEmail(rs.getString("email"));
        demande.setMotivation(rs.getString("motivation"));
        demande.setCvPath(rs.getString("cv_path"));
        demande.setStatut(rs.getString("statut"));
        demande.setStatutMembre(safeString(rs, "statut_membre"));
        demande.setRoleMembre(safeString(rs, "role_membre"));

        int traitePar = rs.getInt("traite_par");
        if (rs.wasNull()) {
            demande.setTraitePar(null);
        } else {
            demande.setTraitePar(traitePar);
        }

        demande.setDateDemande(safeString(rs, "date_demande"));
        demande.setDateDecision(safeString(rs, "date_decision"));

        return demande;
    }

    private String safeString(ResultSet rs, String column) {
        try {
            Object value = rs.getObject(column);
            return value != null ? value.toString() : "";
        } catch (Exception e) {
            return "";
        }
    }
}