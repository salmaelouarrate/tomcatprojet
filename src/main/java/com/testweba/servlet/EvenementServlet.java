package com.testweba.servlet;

import com.testweba.dao.EvenementDAO;
import com.testweba.dao.MemberDAO;
import com.testweba.model.Evenement;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/evenements")
public class EvenementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EvenementDAO evenementDAO = new EvenementDAO();
    private MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.setAttribute("membres", memberDAO.findAll());
                request.getRequestDispatcher("/WEB-INF/views/ajouter-evenement.jsp")
                       .forward(request, response);
                break;

            case "edit":
                afficherFormModification(request, response);
                break;

            case "delete":
                supprimerEvenement(request, response);
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

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            modifierEvenement(request, response);
        } else {
            ajouterEvenement(request, response);
        }
    }

    private void afficherListe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Evenement> evenements = evenementDAO.findAll();
        request.setAttribute("evenements", evenements);

        request.getRequestDispatcher("/WEB-INF/views/evenements.jsp")
               .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Evenement evenement = evenementDAO.findById(id);

        if (evenement == null) {
            response.sendRedirect(request.getContextPath() + "/evenements");
            return;
        }

        request.setAttribute("evenement", evenement);
        request.setAttribute("membres", memberDAO.findAll());
        request.setAttribute("organisateurs", evenementDAO.getOrganisateurs(id));

        request.getRequestDispatcher("/WEB-INF/views/modifier-evenement.jsp")
               .forward(request, response);
    }

    private void ajouterEvenement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Membre membreConnecte = (Membre) session.getAttribute("membreConnecte");

        Evenement evenement = new Evenement();

        evenement.setTitre(request.getParameter("titre"));
        evenement.setType(request.getParameter("type"));
        evenement.setDescription(request.getParameter("description"));
        evenement.setDateDebut(request.getParameter("dateDebut"));
        evenement.setDateFin(request.getParameter("dateFin"));
        evenement.setLieu(request.getParameter("lieu"));

        String edition = request.getParameter("edition");
        if (edition == null || edition.trim().isEmpty()) {
            evenement.setEdition(1);
        } else {
            evenement.setEdition(Integer.parseInt(edition));
        }

        if (membreConnecte != null) {
            evenement.setCreatedBy(membreConnecte.getId());
        } else {
            evenement.setCreatedBy(null);
        }

        evenementDAO.ajouter(evenement);

        // Enregistrer les organisateurs sélectionnés
        String[] organisateurIds = request.getParameterValues("organisateurs");
        if (organisateurIds != null && evenement.getId() > 0) {
            for (String orgId : organisateurIds) {
                evenementDAO.ajouterOrganisateur(
                        evenement.getId(),
                        Integer.parseInt(orgId),
                        "organisateur"
                );
            }
        }

        response.sendRedirect(request.getContextPath() + "/evenements");
    }

    private void modifierEvenement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Membre membreConnecte = (Membre) session.getAttribute("membreConnecte");

        Evenement evenement = new Evenement();

        int id = Integer.parseInt(request.getParameter("id"));
        evenement.setId(id);
        evenement.setTitre(request.getParameter("titre"));
        evenement.setType(request.getParameter("type"));
        evenement.setDescription(request.getParameter("description"));
        evenement.setDateDebut(request.getParameter("dateDebut"));
        evenement.setDateFin(request.getParameter("dateFin"));
        evenement.setLieu(request.getParameter("lieu"));

        String edition = request.getParameter("edition");
        if (edition == null || edition.trim().isEmpty()) {
            evenement.setEdition(1);
        } else {
            evenement.setEdition(Integer.parseInt(edition));
        }

        if (membreConnecte != null) {
            evenement.setCreatedBy(membreConnecte.getId());
        } else {
            evenement.setCreatedBy(null);
        }

        evenementDAO.modifier(evenement);

        // Mettre à jour les organisateurs : on supprime puis on réinsère
        evenementDAO.supprimerOrganisateurs(id);
        String[] organisateurIds = request.getParameterValues("organisateurs");
        if (organisateurIds != null) {
            for (String orgId : organisateurIds) {
                evenementDAO.ajouterOrganisateur(
                        id,
                        Integer.parseInt(orgId),
                        "organisateur"
                );
            }
        }

        response.sendRedirect(request.getContextPath() + "/evenements");
    }

    private void supprimerEvenement(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        evenementDAO.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/evenements");
    }
}