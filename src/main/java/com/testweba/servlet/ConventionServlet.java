package com.testweba.servlet;

import com.testweba.dao.ConventionDAO;
import com.testweba.model.Convention;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ConventionDAO conventionDAO;

    @Override
    public void init() {
        conventionDAO = new ConventionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membreConnecte = getMembreConnecte(request, response);

        if (membreConnecte == null) {
            return;
        }

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
                request.getRequestDispatcher("/WEB-INF/views/ajouter-convention.jsp")
                        .forward(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteConvention(request, response);
                break;

            default:
                listConventions(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        Membre membreConnecte = getMembreConnecte(request, response);

        if (membreConnecte == null) {
            return;
        }

        if (!hasAnyRole(membreConnecte, "directeur", "admin")) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            updateConvention(request, response);
        } else {
            insertConvention(request, response);
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

    private void listConventions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Convention> conventions = conventionDAO.findAll();
        request.setAttribute("conventions", conventions);

        request.getRequestDispatcher("/WEB-INF/views/conventions.jsp")
                .forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Convention convention = conventionDAO.findById(id);

        request.setAttribute("convention", convention);

        request.getRequestDispatcher("/WEB-INF/views/modifier-convention.jsp")
                .forward(request, response);
    }

    private void insertConvention(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Convention convention = buildConventionFromRequest(request);
        conventionDAO.insert(convention);

        response.sendRedirect(request.getContextPath() + "/conventions");
    }

    private void updateConvention(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Convention convention = buildConventionFromRequest(request);
        convention.setId(Integer.parseInt(request.getParameter("id")));

        conventionDAO.update(convention);

        response.sendRedirect(request.getContextPath() + "/conventions");
    }

    private void deleteConvention(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        conventionDAO.delete(id);

        response.sendRedirect(request.getContextPath() + "/conventions");
    }

    private Convention buildConventionFromRequest(HttpServletRequest request) {
        String partenaire = request.getParameter("partenaire");
        String pays = request.getParameter("pays");
        String objet = request.getParameter("objet");
        String statut = request.getParameter("statut");

        Date dateDebut = parseDate(request.getParameter("dateDebut"));
        Date dateFin = parseDate(request.getParameter("dateFin"));

        return new Convention(partenaire, pays, objet, dateDebut, dateFin, statut);
    }

    private Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return Date.valueOf(value);
    }
}