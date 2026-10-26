package com.testweba.servlet;

import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/espace-doctorant")
public class EspaceDoctorantServlet extends HttpServlet {

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

        if (!"doctorant".equalsIgnoreCase(membre.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("membre", membre);

        request.getRequestDispatcher("/WEB-INF/views/espace-doctorant.jsp")
               .forward(request, response);
    }
}