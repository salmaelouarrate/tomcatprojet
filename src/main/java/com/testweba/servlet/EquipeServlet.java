package com.testweba.servlet;

import com.testweba.dao.EquipeDAO;
import com.testweba.dao.MemberDAO;
import com.testweba.model.Equipe;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/equipes")
public class EquipeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final EquipeDAO equipeDAO = new EquipeDAO();
    private final MemberDAO memberDAO = new MemberDAO();

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

        // Seul le directeur/admin peut gérer les équipes
        if (!isDirecteur(membre) && !"list".equals(action) && !"voir".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/equipes");
            return;
        }

        switch (action) {

            case "new":
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/equipes");
                    return;
                }
                request.getRequestDispatcher("/WEB-INF/views/ajouter-equipe.jsp")
                       .forward(request, response);
                break;

            case "edit":
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/equipes");
                    return;
                }
                afficherFormModification(request, response);
                break;

            case "voir":
                afficherDetailEquipe(request, response);
                break;

            case "assigner":
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/equipes");
                    return;
                }
                afficherAssignation(request, response);
                break;

            case "supprimer": {
                if (!isDirecteur(membre)) {
                    response.sendRedirect(request.getContextPath() + "/equipes");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                equipeDAO.supprimer(id);
                response.sendRedirect(request.getContextPath() + "/equipes");
                break;
            }

            default:
                afficherListe(request, response);
                break;
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

        if (!isDirecteur(membre)) {
            response.sendRedirect(request.getContextPath() + "/equipes");
            return;
        }

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            Equipe e = new Equipe();
            e.setNom(request.getParameter("nom"));
            e.setDescription(request.getParameter("description"));
            equipeDAO.ajouter(e);
            response.sendRedirect(request.getContextPath() + "/equipes");

        } else if ("update".equals(action)) {
            Equipe e = new Equipe();
            e.setId(Integer.parseInt(request.getParameter("id")));
            e.setNom(request.getParameter("nom"));
            e.setDescription(request.getParameter("description"));
            equipeDAO.modifier(e);
            response.sendRedirect(request.getContextPath() + "/equipes");

        } else if ("assignerMembre".equals(action)) {
            int membreId = Integer.parseInt(request.getParameter("membreId"));
            String equipeIdParam = request.getParameter("equipeId");
            Integer equipeId = (equipeIdParam != null && !equipeIdParam.trim().isEmpty())
                    ? Integer.parseInt(equipeIdParam) : null;
            equipeDAO.assignerMembre(membreId, equipeId);
            response.sendRedirect(request.getContextPath() + "/equipes?action=assigner");

        } else {
            response.sendRedirect(request.getContextPath() + "/equipes");
        }
    }

    private void afficherListe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Equipe> equipes = equipeDAO.findAll();
        request.setAttribute("equipes", equipes);
        request.getRequestDispatcher("/WEB-INF/views/equipes.jsp")
               .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Equipe equipe = equipeDAO.findById(id);
        if (equipe == null) {
            response.sendRedirect(request.getContextPath() + "/equipes");
            return;
        }
        request.setAttribute("equipe", equipe);
        request.getRequestDispatcher("/WEB-INF/views/modifier-equipe.jsp")
               .forward(request, response);
    }

    private void afficherDetailEquipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Equipe equipe = equipeDAO.findById(id);
        if (equipe == null) {
            response.sendRedirect(request.getContextPath() + "/equipes");
            return;
        }
        request.setAttribute("equipe", equipe);
        request.setAttribute("membresEquipe", equipeDAO.getMembresEquipe(id));
        request.getRequestDispatcher("/WEB-INF/views/detail-equipe.jsp")
               .forward(request, response);
    }

    private void afficherAssignation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Equipe> equipes = equipeDAO.findAll();
        List<Membre> membres = memberDAO.findAll();
        request.setAttribute("equipes", equipes);
        request.setAttribute("membres", membres);
        request.getRequestDispatcher("/WEB-INF/views/assigner-equipe.jsp")
               .forward(request, response);
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