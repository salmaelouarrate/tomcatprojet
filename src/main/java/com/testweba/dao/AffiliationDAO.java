package com.testweba.dao;

import com.testweba.config.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AffiliationDAO {

    public void ajouterAffiliation(int membreId, Date dateDebut, Date dateFin,
                                   String typeAffiliation, String commentaire, Integer modifiePar) {

        String sql = """
            INSERT INTO historique_affiliation
            (membre_id, date_debut, date_fin, type_affiliation, commentaire, modifie_par)
            VALUES (?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);
            ps.setDate(2, dateDebut);

            if (dateFin != null) {
                ps.setDate(3, dateFin);
            } else {
                ps.setNull(3, java.sql.Types.DATE);
            }

            ps.setString(4, typeAffiliation);
            ps.setString(5, commentaire);

            if (modifiePar != null) {
                ps.setInt(6, modifiePar);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[AffiliationDAO] Erreur ajouterAffiliation : " + e.getMessage());
        }
    }

    public List<Map<String, String>> findByMembreId(int membreId) {
        String sql = """
            SELECT date_debut, date_fin, type_affiliation, commentaire, modifie_par, date_modification
            FROM historique_affiliation
            WHERE membre_id = ?
            ORDER BY date_debut DESC
        """;

        List<Map<String, String>> affiliations = new ArrayList<>();

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> ligne = new HashMap<>();

                    ligne.put("dateDebut", String.valueOf(rs.getDate("date_debut")));
                    ligne.put("dateFin", rs.getDate("date_fin") == null ? "En cours" : String.valueOf(rs.getDate("date_fin")));
                    ligne.put("typeAffiliation", rs.getString("type_affiliation"));
                    ligne.put("commentaire", rs.getString("commentaire"));
                    ligne.put("modifiePar", rs.getString("modifie_par"));
                    ligne.put("dateModification", rs.getString("date_modification"));

                    affiliations.add(ligne);
                }
            }

        } catch (SQLException e) {
            System.err.println("[AffiliationDAO] Erreur findByMembreId : " + e.getMessage());
        }

        return affiliations;
    }
}