package com.testweba.servlet;

import com.testweba.dao.MaterielDAO;
import com.testweba.model.Materiel;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/materiel")
public class MaterielServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MaterielDAO materielDAO = new MaterielDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membreConnecte = getMembreConnecte(request, response);

        if (membreConnecte == null) {
            return;
        }

        System.out.println("ROLE MATERIEL = " + membreConnecte.getRole());

        if (!hasAnyRole(membreConnecte, "directeur", "admin")) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/ajouter-materiel.jsp")
                       .forward(request, response);
                break;

            case "edit":
                afficherFormModification(request, response);
                break;

            case "delete":
                supprimerMateriel(request, response);
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

        System.out.println("ROLE MATERIEL POST = " + membreConnecte.getRole());

        if (!hasAnyRole(membreConnecte, "directeur", "admin")) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            modifierMateriel(request, response);
        } else {
            ajouterMateriel(request, response);
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

    private boolean hasAnyRole(Membre membre, String... roles) {
        if (membre == null || membre.getRole() == null) {
            return false;
        }

        String role = membre.getRole().toLowerCase();

        for (String allowedRole : roles) {
            if (allowedRole.equalsIgnoreCase(role)) {
                return true;
            }
        }

        return false;
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

        List<Materiel> materiels = materielDAO.findAll();
        request.setAttribute("materiels", materiels);

        request.getRequestDispatcher("/WEB-INF/views/materiel.jsp")
               .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Materiel materiel = materielDAO.findById(id);

        if (materiel == null) {
            response.sendRedirect(request.getContextPath() + "/materiel");
            return;
        }

        request.setAttribute("materiel", materiel);

        request.getRequestDispatcher("/WEB-INF/views/modifier-materiel.jsp")
               .forward(request, response);
    }

    private void ajouterMateriel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Materiel materiel = new Materiel();

        materiel.setNom(request.getParameter("nom"));
        materiel.setDescription(request.getParameter("description"));

        String quantite = request.getParameter("quantite");
        if (quantite == null || quantite.trim().isEmpty()) {
            materiel.setQuantite(1);
        } else {
            materiel.setQuantite(Integer.parseInt(quantite));
        }

        materiel.setDateArrivee(request.getParameter("dateArrivee"));

        materielDAO.ajouter(materiel);

        response.sendRedirect(request.getContextPath() + "/materiel");
    }

    private void modifierMateriel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Materiel materiel = new Materiel();

        materiel.setId(Integer.parseInt(request.getParameter("id")));
        materiel.setNom(request.getParameter("nom"));
        materiel.setDescription(request.getParameter("description"));

        String quantite = request.getParameter("quantite");
        if (quantite == null || quantite.trim().isEmpty()) {
            materiel.setQuantite(1);
        } else {
            materiel.setQuantite(Integer.parseInt(quantite));
        }

        materiel.setDateArrivee(request.getParameter("dateArrivee"));

        materielDAO.modifier(materiel);

        response.sendRedirect(request.getContextPath() + "/materiel");
    }

    private void supprimerMateriel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        materielDAO.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/materiel");
    }
}