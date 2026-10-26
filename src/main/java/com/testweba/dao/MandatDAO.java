package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Mandat;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MandatDAO {

    public List<Mandat> findAll() {
        List<Mandat> mandats = new ArrayList<>();

        String sql = "SELECT ma.*, m.nom, m.prenom, m.email " +
                     "FROM mandat ma " +
                     "LEFT JOIN membre m ON ma.membre_id = m.id " +
                     "ORDER BY ma.date_debut DESC, ma.id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                mandats.add(mapMandat(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur findAll : " + e.getMessage());
        }

        return mandats;
    }

    public Mandat findById(int id) {
        String sql = "SELECT ma.*, m.nom, m.prenom, m.email " +
                     "FROM mandat ma " +
                     "LEFT JOIN membre m ON ma.membre_id = m.id " +
                     "WHERE ma.id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapMandat(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Mandat mandat) {
        String sql = "INSERT INTO mandat " +
                     "(directeur_id, vice_directeur_id, membre_id, type_mandat, date_debut, date_fin, actif, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, mandat.getDirecteurId());

            if (mandat.getViceDirecteurId() != null) {
                ps.setInt(2, mandat.getViceDirecteurId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            if (mandat.getMembreId() != null) {
                ps.setInt(3, mandat.getMembreId());
            } else {
                ps.setInt(3, mandat.getDirecteurId());
            }

            ps.setString(4, mandat.getTypeMandat());
            ps.setDate(5, mandat.getDateDebut());

            if (mandat.getDateFin() != null) {
                ps.setDate(6, mandat.getDateFin());
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setBoolean(7, mandat.isActif());
            ps.setString(8, mandat.getDescription());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Mandat mandat) {
        String sql = "UPDATE mandat SET " +
                     "directeur_id = ?, vice_directeur_id = ?, membre_id = ?, type_mandat = ?, " +
                     "date_debut = ?, date_fin = ?, actif = ?, description = ? " +
                     "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, mandat.getDirecteurId());

            if (mandat.getViceDirecteurId() != null) {
                ps.setInt(2, mandat.getViceDirecteurId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }

            if (mandat.getMembreId() != null) {
                ps.setInt(3, mandat.getMembreId());
            } else {
                ps.setInt(3, mandat.getDirecteurId());
            }

            ps.setString(4, mandat.getTypeMandat());
            ps.setDate(5, mandat.getDateDebut());

            if (mandat.getDateFin() != null) {
                ps.setDate(6, mandat.getDateFin());
            } else {
                ps.setNull(6, java.sql.Types.DATE);
            }

            ps.setBoolean(7, mandat.isActif());
            ps.setString(8, mandat.getDescription());
            ps.setInt(9, mandat.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean desactiver(int id) {
        String sql = "UPDATE mandat SET actif = FALSE, date_fin = COALESCE(date_fin, CURRENT_DATE) WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur desactiver : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM mandat WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    public boolean hasMandatActif(int membreId, String typeMandat) {
        String sql = "SELECT COUNT(*) FROM mandat " +
                     "WHERE membre_id = ? AND type_mandat = ? AND actif = TRUE " +
                     "AND date_debut <= CURRENT_DATE " +
                     "AND (date_fin IS NULL OR date_fin >= CURRENT_DATE)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);
            ps.setString(2, typeMandat);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            System.err.println("[MandatDAO] Erreur hasMandatActif : " + e.getMessage());
        }

        return false;
    }

    private Mandat mapMandat(ResultSet rs) throws SQLException {
        Mandat mandat = new Mandat();

        mandat.setId(rs.getInt("id"));
        mandat.setDirecteurId(rs.getInt("directeur_id"));

        int viceDirecteurId = rs.getInt("vice_directeur_id");
        if (rs.wasNull()) {
            mandat.setViceDirecteurId(null);
        } else {
            mandat.setViceDirecteurId(viceDirecteurId);
        }

        int membreId = rs.getInt("membre_id");
        if (rs.wasNull()) {
            mandat.setMembreId(null);
        } else {
            mandat.setMembreId(membreId);
        }

        mandat.setTypeMandat(rs.getString("type_mandat"));
        mandat.setDateDebut(rs.getDate("date_debut"));
        mandat.setDateFin(rs.getDate("date_fin"));
        mandat.setActif(rs.getBoolean("actif"));
        mandat.setDescription(rs.getString("description"));

        try {
            mandat.setNomMembre(rs.getString("nom"));
            mandat.setPrenomMembre(rs.getString("prenom"));
            mandat.setEmailMembre(rs.getString("email"));
        } catch (Exception e) {
            mandat.setNomMembre("");
            mandat.setPrenomMembre("");
            mandat.setEmailMembre("");
        }

        return mandat;
    }
}