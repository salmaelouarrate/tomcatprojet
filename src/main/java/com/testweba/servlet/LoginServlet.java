package com.testweba.servlet;

import com.testweba.dao.MemberDAO;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("membreConnecte") != null) {
            Membre membre = (Membre) session.getAttribute("membreConnecte");

            if (!isCompteAutorise(membre)) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            response.sendRedirect(getRedirectPath(request, membre));
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/login.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        if (email != null) {
            email = email.trim();
        }

        if (motDePasse != null) {
            motDePasse = motDePasse.trim();
        }

        if (email == null || email.isEmpty() || motDePasse == null || motDePasse.isEmpty()) {
            request.setAttribute("erreur", "Veuillez remplir tous les champs.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }

        Membre membre = memberDAO.authentifier(email, motDePasse);

        if (membre == null) {
            request.setAttribute("erreur", "Email ou mot de passe incorrect.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }

        if (!isCompteAutorise(membre)) {
            request.setAttribute("erreur", "Votre compte est désactivé ou gelé.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp")
                   .forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("membreConnecte", membre);
        session.setAttribute("role", membre.getRole());
        session.setMaxInactiveInterval(30 * 60);

        response.sendRedirect(getRedirectPath(request, membre));
    }

    private boolean isCompteAutorise(Membre membre) {
        if (membre == null) {
            return false;
        }

        if (!membre.isActif()) {
            return false;
        }

        String statut = membre.getStatut();

        if (statut == null) {
            return true;
        }

        return !"retraite".equalsIgnoreCase(statut)
                && !"ancien".equalsIgnoreCase(statut);
    }

    private String getRedirectPath(HttpServletRequest request, Membre membre) {
        if (!isCompteAutorise(membre)) {
            return request.getContextPath() + "/login";
        }

        String role = membre.getRole();

        if (role == null) {
            return request.getContextPath() + "/espace-membre";
        }

        role = role.toLowerCase();

        switch (role) {
            case "directeur":
            case "admin":
                return request.getContextPath() + "/dashboard";

            case "chef_equipe":
                return request.getContextPath() + "/espace-chef-equipe";

            case "doctorant":
                return request.getContextPath() + "/espace-doctorant";

            case "vice_doyen":
                return request.getContextPath() + "/espace-vice-doyen";

            case "vice_directeur":
                return request.getContextPath() + "/espace-vice-directeur";

            case "membre":
            default:
                return request.getContextPath() + "/espace-membre";
        }
    }

}