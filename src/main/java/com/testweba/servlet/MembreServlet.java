package com.testweba.servlet;

import com.testweba.dao.AffiliationDAO;
import com.testweba.dao.HistoriqueDAO;
import com.testweba.dao.MemberDAO;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

@WebServlet("/membres")
public class MembreServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MemberDAO memberDAO = new MemberDAO();
    private HistoriqueDAO historiqueDAO = new HistoriqueDAO();
    private AffiliationDAO affiliationDAO = new AffiliationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membreConnecte = getMembreConnecte(request, response);
        if (membreConnecte == null) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("list".equals(action)) {
            if (!hasAnyRole(membreConnecte, "directeur", "admin", "chef_equipe")) {
                response.sendRedirect(getRedirectPath(request, membreConnecte));
                return;
            }
        } else {
            if (!hasAnyRole(membreConnecte, "directeur", "admin")) {
                response.sendRedirect(getRedirectPath(request, membreConnecte));
                return;
            }
        }

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/ajouter-membre.jsp")
                        .forward(request, response);
                break;

            case "edit":
                afficherFormModification(request, response);
                break;

            case "delete":
                desactiverMembre(request, response, membreConnecte);
                break;

            case "ancien":
                mettreAncien(request, response, membreConnecte);
                break;

            case "retraite":
                mettreRetraite(request, response, membreConnecte);
                break;

            case "reactiver":
                reactiverMembre(request, response, membreConnecte);
                break;

            case "historique":
                afficherHistorique(request, response);
                break;

            case "newAffiliation":
                afficherFormAffiliation(request, response);
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

        if (!hasAnyRole(membreConnecte, "directeur", "admin")) {
            response.sendRedirect(getRedirectPath(request, membreConnecte));
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            modifierMembre(request, response, membreConnecte);
        } else if ("addAffiliation".equals(action)) {
            ajouterAffiliation(request, response, membreConnecte);
        } else {
            ajouterMembre(request, response);
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

        for (String r : roles) {
            if (r.equalsIgnoreCase(role)) {
                return true;
            }
        }

        return false;
    }

    private String getRedirectPath(HttpServletRequest request, Membre membre) {

        if (membre == null || membre.getRole() == null) {
            return request.getContextPath() + "/login";
        }

        switch (membre.getRole().toLowerCase()) {
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

        List<Membre> membres = memberDAO.findAll();
        request.setAttribute("membres", membres);

        request.getRequestDispatcher("/WEB-INF/views/membres.jsp")
                .forward(request, response);
    }

    private void afficherFormModification(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre membre = memberDAO.findById(id);

        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/membres");
            return;
        }

        request.setAttribute("membre", membre);

        request.getRequestDispatcher("/WEB-INF/views/modifier-membre.jsp")
                .forward(request, response);
    }

    private void afficherHistorique(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre membre = memberDAO.findById(id);

        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/membres");
            return;
        }

        request.setAttribute("membre", membre);
        request.setAttribute("historiqueRoles", enrichirModifiePar(historiqueDAO.findRolesByMembreId(id)));
        request.setAttribute("historiqueStatuts", enrichirModifiePar(historiqueDAO.findStatutsByMembreId(id)));
        request.setAttribute("historiqueAffiliations", enrichirModifiePar(affiliationDAO.findByMembreId(id)));

        request.getRequestDispatcher("/WEB-INF/views/historique-membre.jsp")
                .forward(request, response);
    }

    private void afficherFormAffiliation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre membre = memberDAO.findById(id);

        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/membres");
            return;
        }

        request.setAttribute("membre", membre);

        request.getRequestDispatcher("/WEB-INF/views/ajouter-affiliation.jsp")
                .forward(request, response);
    }

    private List<Map<String, String>> enrichirModifiePar(List<Map<String, String>> historiques) {

        if (historiques == null) {
            return historiques;
        }

        for (Map<String, String> h : historiques) {
            String modifiePar = h.get("modifiePar");

            if (modifiePar == null || modifiePar.trim().isEmpty()) {
                h.put("modifiePar", "Non défini");
                continue;
            }

            try {
                int modifieParId = Integer.parseInt(modifiePar);
                Membre responsable = memberDAO.findById(modifieParId);

                if (responsable != null) {
                    h.put("modifiePar", responsable.getNom() + " " + responsable.getPrenom());
                } else {
                    h.put("modifiePar", "Utilisateur #" + modifieParId);
                }

            } catch (NumberFormatException e) {
                h.put("modifiePar", modifiePar);
            }
        }

        return historiques;
    }

    private void ajouterMembre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Membre m = new Membre();

        m.setNom(request.getParameter("nom"));
        m.setPrenom(request.getParameter("prenom"));
        m.setEmail(request.getParameter("email"));
        m.setMotDePasse(request.getParameter("motDePasse"));
        m.setStatut(request.getParameter("statut"));
        m.setRole(request.getParameter("role"));
        m.setEtablissement(request.getParameter("etablissement"));
        m.setLaboratoire(request.getParameter("laboratoire"));
        m.setLaboratoireOrigine(request.getParameter("laboratoireOrigine"));
        m.setBiographie(request.getParameter("biographie"));
        m.setCentresInteret(request.getParameter("centresInteret"));
        m.setPhoto(request.getParameter("photo"));
        m.setDateNaissance(parseDate(request.getParameter("dateNaissance")));
        m.setDateEmbauche(parseDate(request.getParameter("dateEmbauche")));
        m.setEquipeId(parseInteger(request.getParameter("equipeId")));
        m.setActif(true);

        memberDAO.ajouter(m);

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private void modifierMembre(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre ancien = memberDAO.findById(id);

        Membre m = new Membre();

        m.setId(id);
        m.setNom(request.getParameter("nom"));
        m.setPrenom(request.getParameter("prenom"));
        m.setEmail(request.getParameter("email"));
        m.setStatut(request.getParameter("statut"));
        m.setRole(request.getParameter("role"));
        m.setEtablissement(request.getParameter("etablissement"));
        m.setLaboratoire(request.getParameter("laboratoire"));
        m.setLaboratoireOrigine(request.getParameter("laboratoireOrigine"));
        m.setBiographie(request.getParameter("biographie"));
        m.setCentresInteret(request.getParameter("centresInteret"));
        m.setPhoto(request.getParameter("photo"));
        m.setDateNaissance(parseDate(request.getParameter("dateNaissance")));
        m.setDateEmbauche(parseDate(request.getParameter("dateEmbauche")));
        m.setEquipeId(parseInteger(request.getParameter("equipeId")));
        m.setActif("true".equals(request.getParameter("actif")));

        memberDAO.modifier(m);

        if (ancien != null && isDifferent(ancien.getRole(), m.getRole())) {
            historiqueDAO.enregistrerRole(
                    id,
                    ancien.getRole(),
                    m.getRole(),
                    membreConnecte.getId()
            );
        }

        if (ancien != null && isDifferent(ancien.getStatut(), m.getStatut())) {
            historiqueDAO.enregistrerStatut(
                    id,
                    ancien.getStatut(),
                    m.getStatut(),
                    membreConnecte.getId()
            );
        }

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private void ajouterAffiliation(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int membreId = Integer.parseInt(request.getParameter("membreId"));

        Date dateDebut = parseDate(request.getParameter("dateDebut"));
        Date dateFin = parseDate(request.getParameter("dateFin"));
        String typeAffiliation = request.getParameter("typeAffiliation");
        String commentaire = request.getParameter("commentaire");

        affiliationDAO.ajouterAffiliation(
                membreId,
                dateDebut,
                dateFin,
                typeAffiliation,
                commentaire,
                membreConnecte.getId()
        );

        response.sendRedirect(request.getContextPath() + "/membres?action=historique&id=" + membreId);
    }

    private void desactiverMembre(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre ancien = memberDAO.findById(id);

        memberDAO.desactiver(id);

        if (ancien != null && !"ancien".equalsIgnoreCase(ancien.getStatut())) {
            historiqueDAO.enregistrerStatut(
                    id,
                    ancien.getStatut(),
                    "ancien",
                    membreConnecte.getId()
            );
        }

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private void mettreAncien(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre ancien = memberDAO.findById(id);

        memberDAO.mettreAncien(id);

        if (ancien != null && !"ancien".equalsIgnoreCase(ancien.getStatut())) {
            historiqueDAO.enregistrerStatut(
                    id,
                    ancien.getStatut(),
                    "ancien",
                    membreConnecte.getId()
            );
        }

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private void mettreRetraite(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Membre ancien = memberDAO.findById(id);

        memberDAO.mettreRetraite(id);

        if (ancien != null && !"retraite".equalsIgnoreCase(ancien.getStatut())) {
            historiqueDAO.enregistrerStatut(
                    id,
                    ancien.getStatut(),
                    "retraite",
                    membreConnecte.getId()
            );
        }

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private void reactiverMembre(HttpServletRequest request, HttpServletResponse response, Membre membreConnecte)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        String statut = request.getParameter("statut");
        String role = request.getParameter("role");

        if (statut == null || statut.trim().isEmpty()
                || "ancien".equalsIgnoreCase(statut)
                || "retraite".equalsIgnoreCase(statut)) {
            statut = "permanent";
        }

        if (role == null || role.trim().isEmpty()) {
            role = "membre";
        }

        Membre ancien = memberDAO.findById(id);

        memberDAO.reactiver(id, statut, role);

        if (ancien != null && isDifferent(ancien.getStatut(), statut)) {
            historiqueDAO.enregistrerStatut(
                    id,
                    ancien.getStatut(),
                    statut,
                    membreConnecte.getId()
            );
        }

        if (ancien != null && isDifferent(ancien.getRole(), role)) {
            historiqueDAO.enregistrerRole(
                    id,
                    ancien.getRole(),
                    role,
                    membreConnecte.getId()
            );
        }

        response.sendRedirect(request.getContextPath() + "/membres");
    }

    private boolean isDifferent(String oldValue, String newValue) {
        if (oldValue == null && newValue == null) {
            return false;
        }

        if (oldValue == null || newValue == null) {
            return true;
        }

        return !oldValue.equalsIgnoreCase(newValue);
    }

    private Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Date.valueOf(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.parseInt(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}