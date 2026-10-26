package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Notification;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public List<Notification> findByMembreId(int membreId) {
        List<Notification> notifications = new ArrayList<>();

        String sql = "SELECT * FROM notification WHERE membre_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    notifications.add(mapNotification(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur findByMembreId : " + e.getMessage());
        }

        return notifications;
    }

    public int countNonLues(int membreId) {
        String sql = "SELECT COUNT(*) FROM notification WHERE membre_id = ? AND lue = 0";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur countNonLues : " + e.getMessage());
        }

        return 0;
    }

    public void ajouter(Notification notification) {
        String sql = "INSERT INTO notification (membre_id, message, lue) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notification.getMembreId());
            ps.setString(2, notification.getMessage());
            ps.setBoolean(3, notification.isLue());

            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur ajouter : " + e.getMessage());
        }
    }

    public void marquerCommeLue(int id, int membreId) {
        String sql = "UPDATE notification SET lue = 1 WHERE id = ? AND membre_id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, membreId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur marquerCommeLue : " + e.getMessage());
        }
    }

    public void toutMarquerCommeLu(int membreId) {
        String sql = "UPDATE notification SET lue = 1 WHERE membre_id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, membreId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur toutMarquerCommeLu : " + e.getMessage());
        }
    }

    public void supprimer(int id, int membreId) {
        String sql = "DELETE FROM notification WHERE id = ? AND membre_id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setInt(2, membreId);
            ps.executeUpdate();

        } catch (SQLException e) {
            System.err.println("[NotificationDAO] Erreur supprimer : " + e.getMessage());
        }
    }

    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification notification = new Notification();

        notification.setId(rs.getInt("id"));
        notification.setMembreId(rs.getInt("membre_id"));
        notification.setMessage(rs.getString("message"));
        notification.setLue(rs.getBoolean("lue"));
        notification.setCreatedAt(rs.getTimestamp("created_at"));

        return notification;
    }
}