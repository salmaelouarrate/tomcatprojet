package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Evenement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EvenementDAO {

    public List<Evenement> findAll() {
        List<Evenement> evenements = new ArrayList<>();

        String sql = "SELECT * FROM evenement ORDER BY date_debut DESC, id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                evenements.add(mapEvenement(rs));
            }

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur findAll : " + e.getMessage());
        }

        return evenements;
    }

    public Evenement findById(int id) {
        String sql = "SELECT * FROM evenement WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapEvenement(rs);
            }

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Evenement evenement) {
        String sql = "INSERT INTO evenement "
                   + "(titre, type, description, date_debut, date_fin, lieu, edition, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql,
                     java.sql.Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, evenement.getTitre());
            ps.setString(2, evenement.getType());
            ps.setString(3, evenement.getDescription());
            ps.setString(4, evenement.getDateDebut());

            if (evenement.getDateFin() == null || evenement.getDateFin().trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.DATE);
            } else {
                ps.setString(5, evenement.getDateFin());
            }

            ps.setString(6, evenement.getLieu());
            ps.setInt(7, evenement.getEdition());

            if (evenement.getCreatedBy() == null) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, evenement.getCreatedBy());
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    evenement.setId(keys.getInt(1));
                }
                return true;
            }

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Evenement evenement) {
        String sql = "UPDATE evenement "
                   + "SET titre = ?, type = ?, description = ?, date_debut = ?, date_fin = ?, "
                   + "lieu = ?, edition = ?, created_by = ? "
                   + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, evenement.getTitre());
            ps.setString(2, evenement.getType());
            ps.setString(3, evenement.getDescription());
            ps.setString(4, evenement.getDateDebut());

            if (evenement.getDateFin() == null || evenement.getDateFin().trim().isEmpty()) {
                ps.setNull(5, java.sql.Types.DATE);
            } else {
                ps.setString(5, evenement.getDateFin());
            }

            ps.setString(6, evenement.getLieu());
            ps.setInt(7, evenement.getEdition());

            if (evenement.getCreatedBy() == null) {
                ps.setNull(8, java.sql.Types.INTEGER);
            } else {
                ps.setInt(8, evenement.getCreatedBy());
            }

            ps.setInt(9, evenement.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM evenement WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    // ===== ORGANISATEURS =====

    public List<java.util.Map<String, String>> getOrganisateurs(int evenementId) {
        List<java.util.Map<String, String>> organisateurs = new ArrayList<>();

        String sql = "SELECT m.id, m.nom, m.prenom, m.email, eo.role_organisation "
                   + "FROM evenement_organisateur eo "
                   + "JOIN membre m ON eo.membre_id = m.id "
                   + "WHERE eo.evenement_id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, evenementId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> org = new java.util.LinkedHashMap<>();
                org.put("id", String.valueOf(rs.getInt("id")));
                org.put("nom", rs.getString("prenom") + " " + rs.getString("nom"));
                org.put("email", rs.getString("email"));
                org.put("role", rs.getString("role_organisation"));
                organisateurs.add(org);
            }

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur getOrganisateurs : " + e.getMessage());
        }

        return organisateurs;
    }

    public void supprimerOrganisateurs(int evenementId) {
        String sql = "DELETE FROM evenement_organisateur WHERE evenement_id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, evenementId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur supprimerOrganisateurs : " + e.getMessage());
        }
    }

    public void ajouterOrganisateur(int evenementId, int membreId, String roleOrganisation) {
        String sql = "INSERT INTO evenement_organisateur "
                   + "(evenement_id, membre_id, role_organisation) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, evenementId);
            ps.setInt(2, membreId);
            ps.setString(3, roleOrganisation != null ? roleOrganisation : "organisateur");
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[EvenementDAO] Erreur ajouterOrganisateur : " + e.getMessage());
        }
    }

    private Evenement mapEvenement(ResultSet rs) throws SQLException {
        Evenement evenement = new Evenement();

        evenement.setId(rs.getInt("id"));
        evenement.setTitre(rs.getString("titre"));
        evenement.setType(rs.getString("type"));
        evenement.setDescription(rs.getString("description"));
        evenement.setDateDebut(rs.getString("date_debut"));
        evenement.setDateFin(rs.getString("date_fin"));
        evenement.setLieu(rs.getString("lieu"));
        evenement.setEdition(rs.getInt("edition"));

        int createdBy = rs.getInt("created_by");
        if (rs.wasNull()) {
            evenement.setCreatedBy(null);
        } else {
            evenement.setCreatedBy(createdBy);
        }

        evenement.setCreatedAt(rs.getString("created_at"));

        return evenement;
    }
}