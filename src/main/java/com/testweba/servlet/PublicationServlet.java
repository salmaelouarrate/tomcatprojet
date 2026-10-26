package com.testweba.servlet;

import com.testweba.dao.PublicationDAO;
import com.testweba.model.Publication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/publications")
public class PublicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PublicationDAO publicationDAO = new PublicationDAO();

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
                request.getRequestDispatcher("/WEB-INF/views/ajouter-publication.jsp")
                       .forward(request, response);
                break;

            case "edit":
                afficherFormModification(request, response);
                break;

            case "delete":
                supprimerPublication(request, response);
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
            modifierPublication(request, response);
        } else {
            ajouterPublication(request, response);
        }
    }

    private void afficherListe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Publication> publications = publicationDAO.findAll();
        request.setAttribute("publications", publications);

        request.getRequestDispatcher("/WEB-INF/views/publications.jsp")
               .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Publication publication = publicationDAO.findById(id);

        if (publication == null) {
            response.sendRedirect(request.getContextPath() + "/publications");
            return;
        }

        request.setAttribute("publication", publication);

        request.getRequestDispatcher("/WEB-INF/views/modifier-publication.jsp")
               .forward(request, response);
    }

    private void ajouterPublication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Publication publication = new Publication();

        publication.setTitre(request.getParameter("titre"));
        publication.setType(request.getParameter("type"));
        publication.setAnnee(Integer.parseInt(request.getParameter("annee")));
        publication.setJournal(request.getParameter("journal"));
        publication.setResume(request.getParameter("resume"));
        publication.setLien(request.getParameter("lien"));

        String equipeId = request.getParameter("equipeId");

        if (equipeId == null || equipeId.trim().isEmpty()) {
            publication.setEquipeId(null);
        } else {
            publication.setEquipeId(Integer.parseInt(equipeId));
        }

        publicationDAO.ajouter(publication);

        response.sendRedirect(request.getContextPath() + "/publications");
    }

    private void modifierPublication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Publication publication = new Publication();

        publication.setId(Integer.parseInt(request.getParameter("id")));
        publication.setTitre(request.getParameter("titre"));
        publication.setType(request.getParameter("type"));
        publication.setAnnee(Integer.parseInt(request.getParameter("annee")));
        publication.setJournal(request.getParameter("journal"));
        publication.setResume(request.getParameter("resume"));
        publication.setLien(request.getParameter("lien"));

        String equipeId = request.getParameter("equipeId");

        if (equipeId == null || equipeId.trim().isEmpty()) {
            publication.setEquipeId(null);
        } else {
            publication.setEquipeId(Integer.parseInt(equipeId));
        }

        publicationDAO.modifier(publication);

        response.sendRedirect(request.getContextPath() + "/publications");
    }

    private void supprimerPublication(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        publicationDAO.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/publications");
    }
}
