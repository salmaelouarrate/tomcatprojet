package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Equipe;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EquipeDAO {

    public List<Equipe> findAll() {
        List<Equipe> equipes = new ArrayList<>();

        String sql = "SELECT e.*, " +
                     "(SELECT COUNT(*) FROM membre m WHERE m.equipe_id = e.id) as nb_membres " +
                     "FROM equipe e ORDER BY e.nom";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                equipes.add(map(rs));
            }

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur findAll : " + e.getMessage());
        }

        return equipes;
    }

    public Equipe findById(int id) {
        String sql = "SELECT e.*, " +
                     "(SELECT COUNT(*) FROM membre m WHERE m.equipe_id = e.id) as nb_membres " +
                     "FROM equipe e WHERE e.id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Equipe equipe) {
        String sql = "INSERT INTO equipe (nom, description) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, equipe.getNom());
            ps.setString(2, equipe.getDescription());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Equipe equipe) {
        String sql = "UPDATE equipe SET nom = ?, description = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, equipe.getNom());
            ps.setString(2, equipe.getDescription());
            ps.setInt(3, equipe.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        // D'abord détacher les membres de cette équipe
        String sqlDetach = "UPDATE membre SET equipe_id = NULL WHERE equipe_id = ?";
        String sqlDelete = "DELETE FROM equipe WHERE id = ?";

        try (Connection conn = DBConnection.getConn()) {

            try (PreparedStatement psDetach = conn.prepareStatement(sqlDetach)) {
                psDetach.setInt(1, id);
                psDetach.executeUpdate();
            }

            try (PreparedStatement psDelete = conn.prepareStatement(sqlDelete)) {
                psDelete.setInt(1, id);
                return psDelete.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    public boolean assignerMembre(int membreId, Integer equipeId) {
        String sql = "UPDATE membre SET equipe_id = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (equipeId == null) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, equipeId);
            }
            ps.setInt(2, membreId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur assignerMembre : " + e.getMessage());
        }

        return false;
    }

    public List<java.util.Map<String, String>> getMembresEquipe(int equipeId) {
        List<java.util.Map<String, String>> membres = new ArrayList<>();

        String sql = "SELECT id, nom, prenom, email, role FROM membre WHERE equipe_id = ? ORDER BY nom";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, equipeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                java.util.Map<String, String> m = new java.util.LinkedHashMap<>();
                m.put("id", String.valueOf(rs.getInt("id")));
                m.put("nom", rs.getString("prenom") + " " + rs.getString("nom"));
                m.put("email", rs.getString("email"));
                m.put("role", rs.getString("role"));
                membres.add(m);
            }

        } catch (SQLException e) {
            System.err.println("[EquipeDAO] Erreur getMembresEquipe : " + e.getMessage());
        }

        return membres;
    }

    private Equipe map(ResultSet rs) throws SQLException {
        Equipe e = new Equipe();
        e.setId(rs.getInt("id"));
        e.setNom(rs.getString("nom"));
        e.setDescription(rs.getString("description"));
        e.setCreatedAt(rs.getString("created_at"));
        e.setNombreMembres(rs.getInt("nb_membres"));
        return e;
    }
}