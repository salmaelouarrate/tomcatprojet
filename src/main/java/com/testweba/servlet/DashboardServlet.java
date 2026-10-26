package com.testweba.servlet;

import com.testweba.model.Membre;
import com.testweba.config.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Membre membre = (Membre) session.getAttribute("membreConnecte");

        if (!isDirecteurOrAdmin(membre)) {
            response.sendRedirect(getRedirectPath(request, membre));
            return;
        }

        request.setAttribute("membre", membre);
        request.getSession().setAttribute("membreConnecte", membre);

        request.setAttribute("totalMembres",
                count("SELECT COUNT(*) FROM membre WHERE actif = 1"));

        request.setAttribute("totalPublications",
                count("SELECT COUNT(*) FROM publication"));

        request.setAttribute("totalEvenements",
                count("SELECT COUNT(*) FROM evenement"));

        request.setAttribute("totalDocuments",
                count("SELECT COUNT(*) FROM document"));

        request.setAttribute("totalMateriels",
                count("SELECT COUNT(*) FROM materiel"));

        request.setAttribute("totalConventions",
                count("SELECT COUNT(*) FROM convention"));

        request.setAttribute("totalNotifications",
                count("SELECT COUNT(*) FROM notification"));

        request.setAttribute("totalDemandesAdhesion",
                count("SELECT COUNT(*) FROM demande_adhesion WHERE statut = 'en_attente'"));

        request.setAttribute("totalDemandesMateriel",
                count("SELECT COUNT(*) FROM demande_materiel"));

        chargerInfosLaboratoire(request);
        chargerMandatActif(request);
        chargerActivitesRecentes(request);

        request.getRequestDispatcher("/WEB-INF/views/dashboard.jsp")
                .forward(request, response);
    }

    private boolean isDirecteurOrAdmin(Membre membre) {
        if (membre == null || membre.getRole() == null) {
            return false;
        }

        String role = membre.getRole().toLowerCase();

        return "directeur".equals(role) || "admin".equals(role);
    }

    private String getRedirectPath(HttpServletRequest request, Membre membre) {
        if (membre == null || membre.getRole() == null) {
            return request.getContextPath() + "/login";
        }

        String role = membre.getRole().toLowerCase();

        switch (role) {
            case "chef_equipe":
                return request.getContextPath() + "/espace-chef-equipe";

            case "doctorant":
                return request.getContextPath() + "/espace-doctorant";

            case "membre":
                return request.getContextPath() + "/espace-membre";

            default:
                return request.getContextPath() + "/login";
        }
    }

    private int count(String sql) {
        int total = 0;

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                total = resultSet.getInt(1);
            }

        } catch (SQLException e) {
            System.err.println("[DashboardServlet] Erreur count : " + e.getMessage());
        }

        return total;
    }

    private void chargerInfosLaboratoire(HttpServletRequest request) {
        String sql = "SELECT nom, date_creation, description FROM laboratoire ORDER BY id ASC LIMIT 1";

        request.setAttribute("laboratoireNom", "Laboratoire LIAS");
        request.setAttribute("laboratoireDateCreation", "-");
        request.setAttribute("laboratoireDescription", "Laboratoire d'Informatique et d'Intelligence Artificielle");

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                request.setAttribute("laboratoireNom", resultSet.getString("nom"));
                request.setAttribute("laboratoireDateCreation", resultSet.getString("date_creation"));
                request.setAttribute("laboratoireDescription", resultSet.getString("description"));
            }

        } catch (SQLException e) {
            System.err.println("[DashboardServlet] Erreur laboratoire : " + e.getMessage());
        }
    }

    private void chargerMandatActif(HttpServletRequest request) {
        String sql = "SELECT ma.type_mandat, ma.date_debut, ma.date_fin, m.nom, m.prenom, m.email " +
                     "FROM mandat ma " +
                     "LEFT JOIN membre m ON ma.membre_id = m.id " +
                     "WHERE ma.actif = 1 " +
                     "AND ma.type_mandat = 'directeur' " +
                     "AND ma.date_debut <= CURRENT_DATE " +
                     "AND (ma.date_fin IS NULL OR ma.date_fin >= CURRENT_DATE) " +
                     "ORDER BY ma.date_debut DESC " +
                     "LIMIT 1";

        request.setAttribute("mandatActifNom", "Aucun mandat actif");
        request.setAttribute("mandatActifEmail", "");
        request.setAttribute("mandatActifType", "-");
        request.setAttribute("mandatActifDateDebut", "-");
        request.setAttribute("mandatActifDateFin", "Mandat en cours");

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            if (resultSet.next()) {
                String prenom = resultSet.getString("prenom") == null ? "" : resultSet.getString("prenom");
                String nom = resultSet.getString("nom") == null ? "" : resultSet.getString("nom");

                request.setAttribute("mandatActifNom", (prenom + " " + nom).trim());
                request.setAttribute("mandatActifEmail", resultSet.getString("email"));
                request.setAttribute("mandatActifType", resultSet.getString("type_mandat"));
                request.setAttribute("mandatActifDateDebut", resultSet.getString("date_debut"));

                if (resultSet.getString("date_fin") != null) {
                    request.setAttribute("mandatActifDateFin", resultSet.getString("date_fin"));
                }
            }

        } catch (SQLException e) {
            System.err.println("[DashboardServlet] Erreur mandat actif : " + e.getMessage());
        }
    }

    private void chargerActivitesRecentes(HttpServletRequest request) {
        List<Map<String, String>> activites = new ArrayList<>();

        String sql =
            "SELECT type, icon, bg, color, date FROM (" +
            "  SELECT 'Nouveau membre' as type, 'bi-person-plus' as icon, '#dbeafe' as bg, '#2563eb' as color, created_at as date FROM membre " +
            "  UNION ALL " +
            "  SELECT 'Publication ajoutée', 'bi-journal-plus', '#dcfce7', '#16a34a', created_at FROM publication " +
            "  UNION ALL " +
            "  SELECT 'Événement créé', 'bi-calendar-plus', '#fef3c7', '#b45309', created_at FROM evenement " +
            "  UNION ALL " +
            "  SELECT 'Document archivé', 'bi-file-earmark-arrow-up', '#f3e8ff', '#9333ea', uploaded_at FROM document " +
            "  UNION ALL " +
            "  SELECT 'Notification', 'bi-bell', '#fff7ed', '#ea580c', created_at FROM notification " +
            ") AS all_activites " +
            "ORDER BY date DESC LIMIT 5";

        try (Connection connection = DBConnection.getConn();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Map<String, String> act = new HashMap<>();
                act.put("type", resultSet.getString("type"));
                act.put("icon", resultSet.getString("icon"));
                act.put("bg", resultSet.getString("bg"));
                act.put("color", resultSet.getString("color"));
                act.put("date", resultSet.getString("date"));
                activites.add(act);
            }

        } catch (SQLException e) {
            System.err.println("[DashboardServlet] Erreur activites : " + e.getMessage());
        }

        request.setAttribute("activites", activites);
    }
}