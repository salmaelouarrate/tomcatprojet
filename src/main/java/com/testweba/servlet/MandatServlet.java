package com.testweba.servlet;

import com.testweba.dao.MandatDAO;
import com.testweba.dao.MemberDAO;
import com.testweba.model.Mandat;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/mandats")
public class MandatServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MandatDAO mandatDAO = new MandatDAO();
    private MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membreConnecte = getMembreConnecte(request, response);

        if (membreConnecte == null) {
            return;
        }

        if (!isAdminOuDirecteur(membreConnecte)) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                afficherFormAjout(request, response);
                break;

            case "edit":
                afficherFormModification(request, response);
                break;

            case "disable":
                desactiverMandat(request, response);
                break;

            case "delete":
                supprimerMandat(request, response);
                break;

            case "list":
            default:
                afficherListe(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membreConnecte = getMembreConnecte(request, response);

        if (membreConnecte == null) {
            return;
        }

        if (!isAdminOuDirecteur(membreConnecte)) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            modifierMandat(request, response);
        } else {
            ajouterMandat(request, response);
        }
    }

    private Membre getMembreConnecte(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        return (Membre) session.getAttribute("membreConnecte");
    }

    private boolean isAdminOuDirecteur(Membre membre) {
        if (membre == null || membre.getRole() == null) {
            return false;
        }

        String role = membre.getRole().toLowerCase();

        return "admin".equals(role) || "directeur".equals(role);
    }

    private String getRedirectPath(HttpServletRequest request, Membre membre) {
        if (membre == null || membre.getRole() == null) {
            return request.getContextPath() + "/login";
        }

        String role = membre.getRole().toLowerCase();

        switch (role) {
            case "directeur":
            case "admin":
                return request.getContextPath() + "/dashboard";

            case "chef_equipe":
                return request.getContextPath() + "/espace-chef-equipe";

            case "doctorant":
                return request.getContextPath() + "/espace-doctorant";

            case "membre":
            default:
                return request.getContextPath() + "/espace-membre";
        }
    }

    private void afficherListe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Mandat> mandats = mandatDAO.findAll();

        request.setAttribute("mandats", mandats);

        request.getRequestDispatcher("/WEB-INF/views/mandats.jsp")
               .forward(request, response);
    }

    private void afficherFormAjout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Membre> membres = memberDAO.findAll();

        request.setAttribute("membres", membres);

        request.getRequestDispatcher("/WEB-INF/views/ajouter-mandat.jsp")
               .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Mandat mandat = mandatDAO.findById(id);

        if (mandat == null) {
            response.sendRedirect(request.getContextPath() + "/mandats");
            return;
        }

        List<Membre> membres = memberDAO.findAll();

        request.setAttribute("mandat", mandat);
        request.setAttribute("membres", membres);

        request.getRequestDispatcher("/WEB-INF/views/modifier-mandat.jsp")
               .forward(request, response);
    }

    private void ajouterMandat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Mandat mandat = lireMandatDepuisRequest(request);

        mandatDAO.ajouter(mandat);

        response.sendRedirect(request.getContextPath() + "/mandats");
    }

    private void modifierMandat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Mandat mandat = lireMandatDepuisRequest(request);

        mandat.setId(Integer.parseInt(request.getParameter("id")));

        mandatDAO.modifier(mandat);

        response.sendRedirect(request.getContextPath() + "/mandats");
    }

    private void desactiverMandat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        mandatDAO.desactiver(id);

        response.sendRedirect(request.getContextPath() + "/mandats");
    }

    private void supprimerMandat(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        mandatDAO.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/mandats");
    }

    private Mandat lireMandatDepuisRequest(HttpServletRequest request) {
        Mandat mandat = new Mandat();

        Integer membreId = parseInteger(request.getParameter("membreId"));
        Integer directeurId = parseInteger(request.getParameter("directeurId"));
        Integer viceDirecteurId = parseInteger(request.getParameter("viceDirecteurId"));

        String typeMandat = request.getParameter("typeMandat");

        if (typeMandat == null || typeMandat.trim().isEmpty()) {
            typeMandat = "directeur";
        }

        if (membreId == null) {
            membreId = directeurId;
        }

        if (directeurId == null) {
            directeurId = membreId;
        }

        mandat.setMembreId(membreId);
        mandat.setDirecteurId(directeurId == null ? 0 : directeurId);
        mandat.setViceDirecteurId(viceDirecteurId);
        mandat.setTypeMandat(typeMandat);
        mandat.setDateDebut(parseDate(request.getParameter("dateDebut")));
        mandat.setDateFin(parseDate(request.getParameter("dateFin")));
        mandat.setActif("true".equals(request.getParameter("actif")));
        mandat.setDescription(request.getParameter("description"));

        return mandat;
    }

    private Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Date.valueOf(value.trim());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}