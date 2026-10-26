package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Materiel;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MaterielDAO {

    public List<Materiel> findAll() {
        List<Materiel> materiels = new ArrayList<>();

        String sql = "SELECT * FROM materiel ORDER BY id DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                materiels.add(mapMateriel(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MaterielDAO] Erreur findAll : " + e.getMessage());
        }

        return materiels;
    }

    public Materiel findById(int id) {
        String sql = "SELECT * FROM materiel WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapMateriel(rs);
            }

        } catch (SQLException e) {
            System.err.println("[MaterielDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Materiel materiel) {
        String sql = "INSERT INTO materiel "
                   + "(nom, description, quantite, date_arrivee) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, materiel.getNom());
            ps.setString(2, materiel.getDescription());
            ps.setInt(3, materiel.getQuantite());

            if (materiel.getDateArrivee() == null || materiel.getDateArrivee().trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setString(4, materiel.getDateArrivee());
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MaterielDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Materiel materiel) {
        String sql = "UPDATE materiel "
                   + "SET nom = ?, description = ?, quantite = ?, date_arrivee = ? "
                   + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, materiel.getNom());
            ps.setString(2, materiel.getDescription());
            ps.setInt(3, materiel.getQuantite());

            if (materiel.getDateArrivee() == null || materiel.getDateArrivee().trim().isEmpty()) {
                ps.setNull(4, java.sql.Types.DATE);
            } else {
                ps.setString(4, materiel.getDateArrivee());
            }

            ps.setInt(5, materiel.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MaterielDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM materiel WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MaterielDAO] Erreur supprimer : " + e.getMessage());
        }

        return false;
    }

    private Materiel mapMateriel(ResultSet rs) throws SQLException {
        Materiel materiel = new Materiel();

        materiel.setId(rs.getInt("id"));
        materiel.setNom(rs.getString("nom"));
        materiel.setDescription(rs.getString("description"));
        materiel.setQuantite(rs.getInt("quantite"));
        materiel.setDateArrivee(rs.getString("date_arrivee"));
        materiel.setCreatedAt(rs.getString("created_at"));

        return materiel;
    }
}
