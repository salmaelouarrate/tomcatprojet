package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.PV;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PVDAO {

    public List<PV> findAll() {
        List<PV> list = new ArrayList<>();
        String sql = "SELECT * FROM pv ORDER BY date_reunion DESC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (SQLException e) {
            System.err.println("[PVDAO] Erreur findAll : " + e.getMessage());
        }
        return list;
    }

    public PV findById(int id) {
        String sql = "SELECT * FROM pv WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);

        } catch (SQLException e) {
            System.err.println("[PVDAO] Erreur findById : " + e.getMessage());
        }
        return null;
    }

    public boolean ajouter(PV pv) {
        String sql = "INSERT INTO pv (titre, date_reunion, ordre_du_jour, pv_path, created_by) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pv.getTitre());
            ps.setString(2, pv.getDateReunion());
            ps.setString(3, pv.getOrdreDuJour());
            ps.setString(4, pv.getPvPath());
            if (pv.getCreatedBy() != null)
                ps.setInt(5, pv.getCreatedBy());
            else
                ps.setNull(5, Types.INTEGER);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PVDAO] Erreur ajouter : " + e.getMessage());
        }
        return false;
    }

    public boolean modifier(PV pv) {
        String sql = "UPDATE pv SET titre=?, date_reunion=?, ordre_du_jour=?, pv_path=? WHERE id=?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, pv.getTitre());
            ps.setString(2, pv.getDateReunion());
            ps.setString(3, pv.getOrdreDuJour());
            ps.setString(4, pv.getPvPath());
            ps.setInt(5, pv.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PVDAO] Erreur modifier : " + e.getMessage());
        }
        return false;
    }

    public boolean supprimer(int id) {
        String sql = "DELETE FROM pv WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[PVDAO] Erreur supprimer : " + e.getMessage());
        }
        return false;
    }

    private PV map(ResultSet rs) throws SQLException {
        PV pv = new PV();
        pv.setId(rs.getInt("id"));
        pv.setTitre(rs.getString("titre"));
        pv.setDateReunion(rs.getString("date_reunion"));
        pv.setOrdreDuJour(rs.getString("ordre_du_jour"));
        pv.setPvPath(rs.getString("pv_path"));
        pv.setCreatedBy((Integer) rs.getObject("created_by"));
        pv.setCreatedAt(rs.getString("created_at"));
        return pv;
    }
}