package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Publication;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PublicationDAO {

    public List<Publication> findAll() {
        List<Publication> publications = new ArrayList<>();

        String sql = "SELECT * FROM publication ORDER BY annee DESC, id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                publications.add(mapPublication(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PublicationDAO] Erreur findAll : " + e.getMessage());
        }

        return publications;
    }

    public Publication findById(int id) {
        String sql = "SELECT * FROM publication WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapPublication(rs);
            }

        } catch (SQLException e) {
            System.err.println("[PublicationDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Publication publication) {
        String sql = "INSERT INTO publication "
                   + "(titre, type, annee, journal, resume, lien, equipe_id) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, publication.getTitre());
            ps.setString(2, publication.getType());
            ps.setInt(3, publication.getAnnee());
            ps.setString(4, publication.getJournal());
            ps.setString(5, publication.getResume());
            ps.setString(6, publication.getLien());

            if (publication.getEquipeId() == null) {
                ps.setNull(7, java.sql.Types.INTEGER);
            } else {
                ps.setInt(7, publication.getEquipeId());
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PublicationDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Publication publication) {
        String sql = "UPDATE publication "
                   + "SET titre = ?, type = ?, annee = ?, journal = ?, resume = ?, lien = ?, equipe_id = ? "
                   + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, publication.getTitre());
            ps.setString(2, publication.getType());
            ps.setInt(3, publication.getAnnee());
            ps.setString(4, publication.getJournal());
            ps.setString(5, publication.getResume());
            ps.setString(6, publication.getLien());

            if (publication.getEquipeId() == null) {
                ps.setNull(7, java.sql.Types.INTEGER);
            } else {
                ps.setInt(7, publication.getEquipeId());
            }

            ps.setInt(8, publication.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PublicationDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM publication WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PublicationDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    private Publication mapPublication(ResultSet rs) throws SQLException {
        Publication publication = new Publication();

        publication.setId(rs.getInt("id"));
        publication.setTitre(rs.getString("titre"));
        publication.setType(rs.getString("type"));
        publication.setAnnee(rs.getInt("annee"));
        publication.setJournal(rs.getString("journal"));
        publication.setResume(rs.getString("resume"));
        publication.setLien(rs.getString("lien"));

        int equipeId = rs.getInt("equipe_id");
        if (rs.wasNull()) {
            publication.setEquipeId(null);
        } else {
            publication.setEquipeId(equipeId);
        }

        publication.setCreatedAt(rs.getString("created_at"));

        return publication;
    }
}
