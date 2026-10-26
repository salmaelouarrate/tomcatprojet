package com.testweba.dao;

import com.testweba.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HistoriqueDAO {

    public void enregistrerRole(int membreId, String ancienRole, String nouveauRole, Integer modifiePar) {
        String sql = """
            INSERT INTO historique_role
            (membre_id, ancien_role, nouveau_role, modifie_par)
            VALUES (?, ?, ?, ?)
        """;

        executerUpdate(sql, membreId, ancienRole, nouveauRole, modifiePar);
    }

    public void enregistrerStatut(int membreId, String ancienStatut, String nouveauStatut, Integer modifiePar) {
        String sql = """
            INSERT INTO historique_statut
            (membre_id, ancien_statut, nouveau_statut, modifie_par)
            VALUES (?, ?, ?, ?)
        """;

        executerUpdate(sql, membreId, ancienStatut, nouveauStatut, modifiePar);
    }

    public List<Map<String, String>> findRolesByMembreId(int membreId) {
        String sql = """
            SELECT ancien_role, nouveau_role, modifie_par, date_modification
            FROM historique_role
            WHERE membre_id = ?
            ORDER BY date_modification DESC
        """;

        List<Map<String, String>> historiques = new ArrayList<>();

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> ligne = new HashMap<>();
                    ligne.put("ancien", rs.getString("ancien_role"));
                    ligne.put("nouveau", rs.getString("nouveau_role"));
                    ligne.put("modifiePar", rs.getString("modifie_par"));
                    ligne.put("dateModification", rs.getString("date_modification"));
                    historiques.add(ligne);
                }
            }

        } catch (SQLException e) {
            System.err.println("[HistoriqueDAO] Erreur findRolesByMembreId : " + e.getMessage());
        }

        return historiques;
    }

    public List<Map<String, String>> findStatutsByMembreId(int membreId) {
        String sql = """
            SELECT ancien_statut, nouveau_statut, modifie_par, date_modification
            FROM historique_statut
            WHERE membre_id = ?
            ORDER BY date_modification DESC
        """;

        List<Map<String, String>> historiques = new ArrayList<>();

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> ligne = new HashMap<>();
                    ligne.put("ancien", rs.getString("ancien_statut"));
                    ligne.put("nouveau", rs.getString("nouveau_statut"));
                    ligne.put("modifiePar", rs.getString("modifie_par"));
                    ligne.put("dateModification", rs.getString("date_modification"));
                    historiques.add(ligne);
                }
            }

        } catch (SQLException e) {
            System.err.println("[HistoriqueDAO] Erreur findStatutsByMembreId : " + e.getMessage());
        }

        return historiques;
    }

    private void executerUpdate(String sql, int membreId, String ancien, String nouveau, Integer modifiePar) {

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);
            ps.setString(2, ancien);
            ps.setString(3, nouveau);

            if (modifiePar != null) {
                ps.setInt(4, modifiePar);
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[HistoriqueDAO] SQL Error : " + e.getMessage());
        }
    }
}