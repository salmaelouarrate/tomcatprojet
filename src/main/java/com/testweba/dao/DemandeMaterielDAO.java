package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.DemandeMateriel;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DemandeMaterielDAO {

    public List<DemandeMateriel> findAll() {
        List<DemandeMateriel> list = new ArrayList<>();
        String sql = "SELECT dm.*, CONCAT(m.prenom, ' ', m.nom) as membre_nom " +
                     "FROM demande_materiel dm " +
                     "LEFT JOIN membre m ON dm.membre_id = m.id " +
                     "ORDER BY dm.date_demande DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur findAll : " + e.getMessage());
        }
        return list;
    }

    public List<DemandeMateriel> findByMembre(int membreId) {
        List<DemandeMateriel> list = new ArrayList<>();
        String sql = "SELECT dm.*, CONCAT(m.prenom, ' ', m.nom) as membre_nom " +
                     "FROM demande_materiel dm " +
                     "LEFT JOIN membre m ON dm.membre_id = m.id " +
                     "WHERE dm.membre_id = ? ORDER BY dm.date_demande DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur findByMembre : " + e.getMessage());
        }
        return list;
    }

    public DemandeMateriel findById(int id) {
        String sql = "SELECT dm.*, CONCAT(m.prenom, ' ', m.nom) as membre_nom " +
                     "FROM demande_materiel dm " +
                     "LEFT JOIN membre m ON dm.membre_id = m.id " +
                     "WHERE dm.id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur findById : " + e.getMessage());
        }
        return null;
    }

    public boolean ajouter(DemandeMateriel d) {
        String sql = "INSERT INTO demande_materiel " +
                     "(membre_id, materiel_nom, quantite, justification, description, statut) " +
                     "VALUES (?, ?, ?, ?, ?, 'en_attente')";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, d.getMembreId());
            ps.setString(2, d.getMaterielNom());
            ps.setInt(3, d.getQuantite());
            ps.setString(4, d.getJustification());
            ps.setString(5, d.getDescription());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur ajouter : " + e.getMessage());
        }
        return false;
    }

    public boolean changerStatut(int id, String statut, int traitePar) {
        String sql = "UPDATE demande_materiel " +
                     "SET statut = ?, traite_par = ?, date_decision = CURRENT_TIMESTAMP " +
                     "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, statut);
            ps.setInt(2, traitePar);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur changerStatut : " + e.getMessage());
        }
        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM demande_materiel WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DemandeMaterielDAO] Erreur supprimer : " + e.getMessage());
        }
        return false;
    }

    private DemandeMateriel map(ResultSet rs) throws SQLException {
        DemandeMateriel d = new DemandeMateriel();
        d.setId(rs.getInt("id"));
        d.setMembreId(rs.getInt("membre_id"));
        d.setMaterielNom(rs.getString("materiel_nom"));
        d.setQuantite(rs.getInt("quantite"));
        d.setJustification(rs.getString("justification"));
        d.setDescription(rs.getString("description"));
        d.setStatut(rs.getString("statut"));
        d.setDateDemande(rs.getString("date_demande"));
        d.setTraitePar((Integer) rs.getObject("traite_par"));
        d.setDateDecision(rs.getString("date_decision"));
        d.setMembreNom(rs.getString("membre_nom"));
        return d;
    }
}