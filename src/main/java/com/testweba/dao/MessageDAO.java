package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public List<Message> findByContexte(String contexte, Integer contexteId) {
        List<Message> messages = new ArrayList<>();

        String sql;
        boolean hasContexteId = (contexteId != null);

        if (hasContexteId) {
            sql = "SELECT msg.*, CONCAT(m.prenom, ' ', m.nom) as membre_nom " +
                  "FROM message msg " +
                  "JOIN membre m ON msg.membre_id = m.id " +
                  "WHERE msg.contexte = ? AND msg.contexte_id = ? " +
                  "ORDER BY msg.date_envoi ASC";
        } else {
            sql = "SELECT msg.*, CONCAT(m.prenom, ' ', m.nom) as membre_nom " +
                  "FROM message msg " +
                  "JOIN membre m ON msg.membre_id = m.id " +
                  "WHERE msg.contexte = ? AND msg.contexte_id IS NULL " +
                  "ORDER BY msg.date_envoi ASC";
        }

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, contexte);
            if (hasContexteId) {
                ps.setInt(2, contexteId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                messages.add(map(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MessageDAO] Erreur findByContexte : " + e.getMessage());
        }

        return messages;
    }

    public boolean ajouter(Message message) {
        String sql = "INSERT INTO message (contexte, contexte_id, membre_id, contenu) " +
                     "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, message.getContexte());

            if (message.getContexteId() == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, message.getContexteId());
            }

            ps.setInt(3, message.getMembreId());
            ps.setString(4, message.getContenu());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MessageDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM message WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MessageDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    private Message map(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getInt("id"));
        m.setContexte(rs.getString("contexte"));

        int contexteId = rs.getInt("contexte_id");
        m.setContexteId(rs.wasNull() ? null : contexteId);

        m.setMembreId(rs.getInt("membre_id"));
        m.setContenu(rs.getString("contenu"));
        m.setDateEnvoi(rs.getString("date_envoi"));
        m.setMembreNom(rs.getString("membre_nom"));
        return m;
    }
}