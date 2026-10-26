package com.testweba.servlet;

import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/espace-membre")
public class EspaceMembreServlet extends HttpServlet {

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

        if (!"membre".equalsIgnoreCase(membre.getRole())) {
            response.sendRedirect(getRedirectPath(request, membre));
            return;
        }

        request.setAttribute("membre", membre);

        request.getRequestDispatcher("/WEB-INF/views/espace-membre.jsp")
               .forward(request, response);
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
}