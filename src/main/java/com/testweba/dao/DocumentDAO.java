package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Document;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    public List<Document> findAll() {
        List<Document> documents = new ArrayList<>();

        String sql = "SELECT * FROM document ORDER BY uploaded_at DESC, id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                documents.add(mapDocument(rs));
            }

        } catch (SQLException e) {
            System.err.println("[DocumentDAO] Erreur findAll : " + e.getMessage());
        }

        return documents;
    }

    public Document findById(int id) {
        String sql = "SELECT * FROM document WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapDocument(rs);
            }

        } catch (SQLException e) {
            System.err.println("[DocumentDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Document document) {
        String sql = "INSERT INTO document "
                   + "(nom, type, chemin, evenement_id, uploaded_by) "
                   + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, document.getNom());
            ps.setString(2, document.getType());
            ps.setString(3, document.getChemin());

            if (document.getEvenementId() == null) {
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(4, document.getEvenementId());
            }

            if (document.getUploadedBy() == null) {
                ps.setNull(5, java.sql.Types.INTEGER);
            } else {
                ps.setInt(5, document.getUploadedBy());
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DocumentDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM document WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[DocumentDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }
    public String getNomEvenement(Integer evenementId) {
        if (evenementId == null) return null;
        String sql = "SELECT titre FROM evenement WHERE id = ?";
        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("titre");
            }
        } catch (SQLException e) {
            System.err.println("[DocumentDAO] Erreur getNomEvenement : " + e.getMessage());
        }
        return null;
    }
    private Document mapDocument(ResultSet rs) throws SQLException {
        Document document = new Document();

        document.setId(rs.getInt("id"));
        document.setNom(rs.getString("nom"));
        document.setType(rs.getString("type"));
        document.setChemin(rs.getString("chemin"));

        int evenementId = rs.getInt("evenement_id");
        if (rs.wasNull()) {
            document.setEvenementId(null);
        } else {
            document.setEvenementId(evenementId);
        }

        int uploadedBy = rs.getInt("uploaded_by");
        if (rs.wasNull()) {
            document.setUploadedBy(null);
        } else {
            document.setUploadedBy(uploadedBy);
        }

        document.setUploadedAt(rs.getString("uploaded_at"));

        return document;
    }
}
