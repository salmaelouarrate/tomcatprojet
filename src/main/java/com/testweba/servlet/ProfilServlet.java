package com.testweba.servlet;

import com.testweba.dao.MemberDAO;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/mon-profil")
public class ProfilServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MemberDAO memberDAO = new MemberDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Membre membreSession = (Membre) session.getAttribute("membreConnecte");
        Membre profil = memberDAO.findById(membreSession.getId());

        request.setAttribute("membre", profil);

        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/modifier-profil.jsp")
                   .forward(request, response);
        } else {
            request.getRequestDispatcher("/WEB-INF/views/mon-profil.jsp")
                   .forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Membre membreSession = (Membre) session.getAttribute("membreConnecte");

        Membre membre = new Membre();
        membre.setId(membreSession.getId());
        membre.setNom(request.getParameter("nom"));
        membre.setPrenom(request.getParameter("prenom"));
        membre.setEmail(request.getParameter("email"));
        membre.setEtablissement(request.getParameter("etablissement"));
        membre.setLaboratoire(request.getParameter("laboratoire"));
        membre.setLaboratoireOrigine(request.getParameter("laboratoireOrigine"));
        membre.setBiographie(request.getParameter("biographie"));
        membre.setCentresInteret(request.getParameter("centresInteret"));
        membre.setPhoto(request.getParameter("photo"));
        membre.setDateNaissance(parseDate(request.getParameter("dateNaissance")));
        membre.setDateEmbauche(parseDate(request.getParameter("dateEmbauche")));
        membre.setEquipeId(parseInteger(request.getParameter("equipeId")));

        memberDAO.modifierProfil(membre);

        Membre membreMaj = memberDAO.findById(membreSession.getId());
        session.setAttribute("membreConnecte", membreMaj);

        response.sendRedirect(request.getContextPath() + "/mon-profil?success=1");
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