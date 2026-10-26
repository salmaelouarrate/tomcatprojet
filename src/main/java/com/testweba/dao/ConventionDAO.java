package com.testweba.dao;

import com.testweba.model.Convention;
import com.testweba.config.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConventionDAO {

    public List<Convention> findAll() {
        List<Convention> conventions = new ArrayList<>();

        String sql = "SELECT * FROM convention ORDER BY id DESC";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Convention convention = mapResultSetToConvention(resultSet);
                conventions.add(convention);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return conventions;
    }

    public Convention findById(int id) {

        String sql = "SELECT * FROM convention WHERE id = ?";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToConvention(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insert(Convention convention) {

        String sql = "INSERT INTO convention (partenaire, pays, objet, date_debut, date_fin, statut) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, convention.getPartenaire());
            statement.setString(2, convention.getPays());
            statement.setString(3, convention.getObjet());
            statement.setDate(4, convention.getDateDebut());
            statement.setDate(5, convention.getDateFin());
            statement.setString(6, convention.getStatut());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Convention convention) {

        String sql = "UPDATE convention SET partenaire = ?, pays = ?, objet = ?, " +
                     "date_debut = ?, date_fin = ?, statut = ? WHERE id = ?";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, convention.getPartenaire());
            statement.setString(2, convention.getPays());
            statement.setString(3, convention.getObjet());
            statement.setDate(4, convention.getDateDebut());
            statement.setDate(5, convention.getDateFin());
            statement.setString(6, convention.getStatut());
            statement.setInt(7, convention.getId());

            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {

        String sql = "DELETE FROM convention WHERE id = ?";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);
            statement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Convention mapResultSetToConvention(ResultSet resultSet) throws SQLException {

        Convention convention = new Convention();

        convention.setId(resultSet.getInt("id"));
        convention.setPartenaire(resultSet.getString("partenaire"));
        convention.setPays(resultSet.getString("pays"));
        convention.setObjet(resultSet.getString("objet"));
        convention.setDateDebut(resultSet.getDate("date_debut"));
        convention.setDateFin(resultSet.getDate("date_fin"));
        convention.setStatut(resultSet.getString("statut"));
        convention.setCreatedAt(resultSet.getTimestamp("created_at"));

        return convention;
    }
}