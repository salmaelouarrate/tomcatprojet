package com.testweba.servlet;

import com.testweba.config.DBConnection;
import com.testweba.dao.DemandeAdhesionDAO;
import com.testweba.dao.MandatDAO;
import com.testweba.model.DemandeAdhesion;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

@WebServlet("/demandes-adhesion")
public class DemandeAdhesionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final DemandeAdhesionDAO dao = new DemandeAdhesionDAO();
    private final MandatDAO mandatDAO = new MandatDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        Membre membre = getMembreConnecte(request);

        switch (action) {
            case "new":
                request.getRequestDispatcher("/WEB-INF/views/ajouter-demande.jsp")
                       .forward(request, response);
                break;

            case "accept":
                if (membre == null || !isResponsableAvecMandatActif(membre)) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                accepterDemande(request, response, membre);
                break;

            case "reject":
                if (membre == null || !isResponsableAvecMandatActif(membre)) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                refuserDemande(request, response, membre);
                break;

            case "supprimer":
                if (membre == null || !isResponsableAvecMandatActif(membre)) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }

                supprimerDemande(request, response);
                break;

            case "list":
            default:
                if (membre != null && isResponsableAvecMandatActif(membre)) {
                    List<DemandeAdhesion> demandes = dao.findAll();
                    request.setAttribute("demandes", demandes);
                    request.getRequestDispatcher("/WEB-INF/views/demandes-adhesion.jsp")
                           .forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/demandes-adhesion?action=new");
                }
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            DemandeAdhesion demande = new DemandeAdhesion();

            String statutMembre = request.getParameter("statutMembre");
            String roleMembre = request.getParameter("roleMembre");

            if (statutMembre == null || statutMembre.trim().isEmpty()) {
                statutMembre = "doctorant";
            }

            if (roleMembre == null || roleMembre.trim().isEmpty()) {
                roleMembre = choisirRoleParStatut(statutMembre);
            }

            demande.setNom(request.getParameter("nom"));
            demande.setPrenom(request.getParameter("prenom"));
            demande.setEmail(request.getParameter("email"));
            demande.setMotivation(request.getParameter("motivation"));
            demande.setCvPath(request.getParameter("cvPath"));
            demande.setStatutMembre(statutMembre);
            demande.setRoleMembre(roleMembre);

            dao.ajouter(demande);

            response.sendRedirect(request.getContextPath()
                    + "/demandes-adhesion?action=new&success=ok");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/demandes-adhesion");
    }

    private void accepterDemande(HttpServletRequest request, HttpServletResponse response, Membre membre)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        DemandeAdhesion demande = dao.findById(id);

        if (demande != null && "en_attente".equals(demande.getStatut())) {
            boolean compteCree = creerCompteMembre(demande);

            if (compteCree) {
                dao.changerStatut(id, "acceptee", membre.getId());
            }
        }

        response.sendRedirect(request.getContextPath() + "/demandes-adhesion");
    }

    private void refuserDemande(HttpServletRequest request, HttpServletResponse response, Membre membre)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        dao.changerStatut(id, "refusee", membre.getId());

        response.sendRedirect(request.getContextPath() + "/demandes-adhesion");
    }

    private void supprimerDemande(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        dao.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/demandes-adhesion");
    }

    private boolean creerCompteMembre(DemandeAdhesion demande) {
        String email = demande.getEmail() != null ? demande.getEmail().toLowerCase().trim() : "";
        String prenom = demande.getPrenom() != null ? demande.getPrenom().toLowerCase().trim() : "";
        String nom = demande.getNom() != null ? demande.getNom().toLowerCase().trim() : "";

        String statutMembre = demande.getStatutMembre();
        String roleMembre = demande.getRoleMembre();

        if (statutMembre == null || statutMembre.trim().isEmpty()) {
            statutMembre = "doctorant";
        }

        if (roleMembre == null || roleMembre.trim().isEmpty()) {
            roleMembre = choisirRoleParStatut(statutMembre);
        }

        statutMembre = statutMembre.toLowerCase().trim();
        roleMembre = roleMembre.toLowerCase().trim();

        String motDePasseTemporaire = prenom + nom + "123";

        if (motDePasseTemporaire.trim().equals("123")) {
            motDePasseTemporaire = "admin123";
        }

        String hash = BCrypt.hashpw(motDePasseTemporaire, BCrypt.gensalt());

        String sql = "INSERT INTO membre "
                   + "(nom, prenom, email, mot_de_passe, statut, role, laboratoire_origine, actif) "
                   + "VALUES (?, ?, ?, ?, ?, ?, 'Demande d adhésion publique', TRUE)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, demande.getNom());
            ps.setString(2, demande.getPrenom());
            ps.setString(3, email);
            ps.setString(4, hash);
            ps.setString(5, statutMembre);
            ps.setString(6, roleMembre);

            ps.executeUpdate();

            System.out.println("[DemandeAdhesion] Compte créé : " + email
                    + " | Statut : " + statutMembre
                    + " | Rôle : " + roleMembre
                    + " | Mot de passe temporaire : " + motDePasseTemporaire);

            return true;

        } catch (Exception e) {
            System.err.println("[DemandeAdhesion] Erreur création compte : " + e.getMessage());
        }

        return false;
    }

    private String choisirRoleParStatut(String statutMembre) {
        if (statutMembre == null) {
            return "doctorant";
        }

        String statut = statutMembre.toLowerCase().trim();

        switch (statut) {
            case "doctorant":
                return "doctorant";

            case "associe":
                return "membre";

            case "permanent":
                return "membre";

            default:
                return "membre";
        }
    }

    private Membre getMembreConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        return (Membre) session.getAttribute("membreConnecte");
    }

    private boolean isResponsableAvecMandatActif(Membre membre) {
        if (membre == null || membre.getRole() == null) {
            return false;
        }

        String role = membre.getRole().toLowerCase();

        if ("admin".equals(role)) {
            return true;
        }

        if ("directeur".equals(role)) {
            return mandatDAO.hasMandatActif(membre.getId(), "directeur");
        }

        return false;
    }
}