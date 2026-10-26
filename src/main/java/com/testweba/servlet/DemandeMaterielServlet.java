package com.testweba.servlet;

import com.testweba.dao.DemandeMaterielDAO;
import com.testweba.model.DemandeMateriel;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/demandes-materiel")
public class DemandeMaterielServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final DemandeMaterielDAO dao = new DemandeMaterielDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membre = getMembreConnecte(request);
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "new":
                request.getRequestDispatcher("/WEB-INF/views/ajouter-demande-materiel.jsp")
                       .forward(request, response);
                break;

            case "valider": {
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                dao.changerStatut(id, "validee", membre.getId());
                response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                break;
            }

            case "refuser": {
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                dao.changerStatut(id, "refusee", membre.getId());
                response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                break;
            }

            case "supprimer": {
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                dao.supprimer(id);
                response.sendRedirect(request.getContextPath() + "/demandes-materiel");
                break;
            }

            default: {
                List<DemandeMateriel> demandes;
                if (isDirecteur(membre)) {
                    demandes = dao.findAll();
                } else {
                    demandes = dao.findByMembre(membre.getId());
                }
                request.setAttribute("demandes", demandes);
                request.setAttribute("membre", membre);
                request.getRequestDispatcher("/WEB-INF/views/demandes-materiel.jsp")
                       .forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Membre membre = getMembreConnecte(request);
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            DemandeMateriel d = new DemandeMateriel();
            d.setMembreId(membre.getId());
            d.setMaterielNom(request.getParameter("materielNom"));
            d.setQuantite(Integer.parseInt(request.getParameter("quantite")));
            d.setJustification(request.getParameter("justification"));
            d.setDescription(request.getParameter("description"));
            dao.ajouter(d);
        }

        response.sendRedirect(request.getContextPath() + "/demandes-materiel");
    }

    private Membre getMembreConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Membre m = (Membre) session.getAttribute("membreConnecte");
        if (m == null) m = (Membre) session.getAttribute("membre");
        return m;
    }

    private boolean isDirecteur(Membre membre) {
        if (membre == null || membre.getRole() == null) return false;
        String role = membre.getRole().toLowerCase();
        return "directeur".equals(role) || "admin".equals(role);
    }
}