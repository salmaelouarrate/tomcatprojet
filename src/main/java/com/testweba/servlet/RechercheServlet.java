package com.testweba.servlet;

import com.testweba.config.DBConnection;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/recherche")
public class RechercheServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier connexion
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        if (membre == null) membre = (Membre) session.getAttribute("membre");
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String query = request.getParameter("q");
        if (query == null) query = "";
        query = query.trim();

        List<Map<String, String>> membres = new ArrayList<>();
        List<Map<String, String>> publications = new ArrayList<>();
        List<Map<String, String>> evenements = new ArrayList<>();
        List<Map<String, String>> documents = new ArrayList<>();

        if (!query.isEmpty()) {
            String like = "%" + query + "%";

            try (Connection conn = DBConnection.getConn()) {

                // Recherche membres
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id, nom, prenom, email, role, statut FROM membre " +
                        "WHERE (nom LIKE ? OR prenom LIKE ? OR email LIKE ?) AND actif = 1")) {
                    ps.setString(1, like);
                    ps.setString(2, like);
                    ps.setString(3, like);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, String> m = new LinkedHashMap<>();
                        m.put("id", rs.getString("id"));
                        m.put("nom", rs.getString("prenom") + " " + rs.getString("nom"));
                        m.put("email", rs.getString("email"));
                        m.put("role", rs.getString("role"));
                        m.put("statut", rs.getString("statut"));
                        membres.add(m);
                    }
                }

                // Recherche publications
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id, titre, type, annee FROM publication " +
                        "WHERE titre LIKE ? OR type LIKE ?")) {
                    ps.setString(1, like);
                    ps.setString(2, like);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, String> p = new LinkedHashMap<>();
                        p.put("id", rs.getString("id"));
                        p.put("titre", rs.getString("titre"));
                        p.put("type", rs.getString("type"));
                        p.put("annee", rs.getString("annee"));
                        publications.add(p);
                    }
                }

                // Recherche événements
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id, titre, type, date_debut FROM evenement " +
                        "WHERE titre LIKE ? OR type LIKE ? OR lieu LIKE ?")) {
                    ps.setString(1, like);
                    ps.setString(2, like);
                    ps.setString(3, like);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, String> e = new LinkedHashMap<>();
                        e.put("id", rs.getString("id"));
                        e.put("titre", rs.getString("titre"));
                        e.put("type", rs.getString("type"));
                        e.put("date", rs.getString("date_debut"));
                        evenements.add(e);
                    }
                }

                // Recherche documents
                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT id, titre, type FROM document " +
                        "WHERE titre LIKE ? OR type LIKE ?")) {
                    ps.setString(1, like);
                    ps.setString(2, like);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Map<String, String> d = new LinkedHashMap<>();
                        d.put("id", rs.getString("id"));
                        d.put("titre", rs.getString("titre"));
                        d.put("type", rs.getString("type"));
                        documents.add(d);
                    }
                }

            } catch (SQLException e) {
                System.err.println("[Recherche] Erreur : " + e.getMessage());
            }
        }

        request.setAttribute("query", query);
        request.setAttribute("membres", membres);
        request.setAttribute("publications", publications);
        request.setAttribute("evenements", evenements);
        request.setAttribute("documents", documents);
        request.setAttribute("membreConnecte", membre);

        int total = membres.size() + publications.size()
                  + evenements.size() + documents.size();
        request.setAttribute("total", total);

        request.getRequestDispatcher("/WEB-INF/views/recherche.jsp")
               .forward(request, response);
    }
}