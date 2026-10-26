package com.testweba.dao;

import com.testweba.config.DBConnection;
import com.testweba.model.Membre;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MemberDAO {

    public Membre authentifier(String email, String motDePasse) {
    	String sql = "SELECT * FROM membre WHERE email = ?";
        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String motDePasseBD = rs.getString("mot_de_passe");

                boolean correct;

                if (motDePasseBD != null && motDePasseBD.startsWith("$2")) {
                    correct = BCrypt.checkpw(motDePasse, motDePasseBD);
                } else {
                    correct = motDePasse.equals(motDePasseBD);
                }

                if (correct) {
                    return mapMembre(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur authentification : " + e.getMessage());
        }

        return null;
    }

    public List<Membre> findAll() {
        List<Membre> membres = new ArrayList<>();

        String sql = "SELECT * FROM membre ORDER BY nom ASC, prenom ASC";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                membres.add(mapMembre(rs));
            }

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur findAll : " + e.getMessage());
        }

        return membres;
    }

    public Membre findById(int id) {
        String sql = "SELECT * FROM membre WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapMembre(rs);
            }

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur findById : " + e.getMessage());
        }

        return null;
    }

    public boolean ajouter(Membre membre) {
        String sql = "INSERT INTO membre "
                   + "(nom, prenom, email, mot_de_passe, statut, role, etablissement, laboratoire, "
                   + "laboratoire_origine, biographie, centres_interet, photo, date_naissance, "
                   + "date_embauche, equipe_id, actif) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TRUE)";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, membre.getNom());
            ps.setString(2, membre.getPrenom());
            ps.setString(3, membre.getEmail());

            String motDePasse = membre.getMotDePasse();
            if (motDePasse == null || motDePasse.trim().isEmpty()) {
                motDePasse = "admin123";
            }

            String motDePasseHash = BCrypt.hashpw(motDePasse, BCrypt.gensalt());
            ps.setString(4, motDePasseHash);

            ps.setString(5, membre.getStatut());
            ps.setString(6, membre.getRole());
            ps.setString(7, membre.getEtablissement());
            ps.setString(8, membre.getLaboratoire());
            ps.setString(9, membre.getLaboratoireOrigine());
            ps.setString(10, membre.getBiographie());
            ps.setString(11, membre.getCentresInteret());
            ps.setString(12, membre.getPhoto());

            if (membre.getDateNaissance() != null) {
                ps.setDate(13, membre.getDateNaissance());
            } else {
                ps.setNull(13, java.sql.Types.DATE);
            }

            if (membre.getDateEmbauche() != null) {
                ps.setDate(14, membre.getDateEmbauche());
            } else {
                ps.setNull(14, java.sql.Types.DATE);
            }

            if (membre.getEquipeId() != null) {
                ps.setInt(15, membre.getEquipeId());
            } else {
                ps.setNull(15, java.sql.Types.INTEGER);
            }

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur ajouter : " + e.getMessage());
        }

        return false;
    }

    public boolean modifier(Membre membre) {
        String sql = "UPDATE membre "
                   + "SET nom = ?, prenom = ?, email = ?, statut = ?, role = ?, etablissement = ?, "
                   + "laboratoire = ?, laboratoire_origine = ?, biographie = ?, centres_interet = ?, "
                   + "photo = ?, date_naissance = ?, date_embauche = ?, equipe_id = ?, actif = ? "
                   + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, membre.getNom());
            ps.setString(2, membre.getPrenom());
            ps.setString(3, membre.getEmail());
            ps.setString(4, membre.getStatut());
            ps.setString(5, membre.getRole());
            ps.setString(6, membre.getEtablissement());
            ps.setString(7, membre.getLaboratoire());
            ps.setString(8, membre.getLaboratoireOrigine());
            ps.setString(9, membre.getBiographie());
            ps.setString(10, membre.getCentresInteret());
            ps.setString(11, membre.getPhoto());

            if (membre.getDateNaissance() != null) {
                ps.setDate(12, membre.getDateNaissance());
            } else {
                ps.setNull(12, java.sql.Types.DATE);
            }

            if (membre.getDateEmbauche() != null) {
                ps.setDate(13, membre.getDateEmbauche());
            } else {
                ps.setNull(13, java.sql.Types.DATE);
            }

            if (membre.getEquipeId() != null) {
                ps.setInt(14, membre.getEquipeId());
            } else {
                ps.setNull(14, java.sql.Types.INTEGER);
            }

            ps.setBoolean(15, membre.isActif());
            ps.setInt(16, membre.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur modifier : " + e.getMessage());
        }

        return false;
    }

    public boolean modifierMotDePasse(int id, String nouveauMotDePasse) {
        String sql = "UPDATE membre SET mot_de_passe = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String motDePasseHash = BCrypt.hashpw(nouveauMotDePasse, BCrypt.gensalt());

            ps.setString(1, motDePasseHash);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur modifierMotDePasse : " + e.getMessage());
        }

        return false;
    }

    public boolean modifierProfil(Membre membre) {
        String sql = "UPDATE membre "
                   + "SET nom = ?, prenom = ?, email = ?, etablissement = ?, laboratoire = ?, "
                   + "laboratoire_origine = ?, biographie = ?, centres_interet = ?, photo = ?, "
                   + "date_naissance = ?, date_embauche = ?, equipe_id = ? "
                   + "WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, membre.getNom());
            ps.setString(2, membre.getPrenom());
            ps.setString(3, membre.getEmail());
            ps.setString(4, membre.getEtablissement());
            ps.setString(5, membre.getLaboratoire());
            ps.setString(6, membre.getLaboratoireOrigine());
            ps.setString(7, membre.getBiographie());
            ps.setString(8, membre.getCentresInteret());
            ps.setString(9, membre.getPhoto());

            if (membre.getDateNaissance() != null) {
                ps.setDate(10, membre.getDateNaissance());
            } else {
                ps.setNull(10, java.sql.Types.DATE);
            }

            if (membre.getDateEmbauche() != null) {
                ps.setDate(11, membre.getDateEmbauche());
            } else {
                ps.setNull(11, java.sql.Types.DATE);
            }

            if (membre.getEquipeId() != null) {
                ps.setInt(12, membre.getEquipeId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }

            ps.setInt(13, membre.getId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur modifierProfil : " + e.getMessage());
        }

        return false;
    }

    public boolean desactiver(int id) {
        return mettreAncien(id);
    }

    public boolean mettreAncien(int id) {
        String sql = "UPDATE membre SET actif = FALSE, statut = 'ancien' WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur mettreAncien : " + e.getMessage());
        }

        return false;
    }

    public boolean mettreRetraite(int id) {
        String sql = "UPDATE membre SET actif = FALSE, statut = 'retraite' WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur mettreRetraite : " + e.getMessage());
        }

        return false;
    }

    public boolean reactiver(int id, String statut, String role) {
        String sql = "UPDATE membre SET actif = TRUE, statut = ?, role = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (statut == null || statut.trim().isEmpty()
                    || "ancien".equalsIgnoreCase(statut)
                    || "retraite".equalsIgnoreCase(statut)) {
                statut = "permanent";
            }

            if (role == null || role.trim().isEmpty()) {
                role = "membre";
            }

            ps.setString(1, statut);
            ps.setString(2, role);
            ps.setInt(3, id);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[MemberDAO] Erreur reactiver : " + e.getMessage());
        }

        return false;
    }

    private Membre mapMembre(ResultSet rs) throws SQLException {
        Membre m = new Membre();

        m.setId(rs.getInt("id"));
        m.setNom(rs.getString("nom"));
        m.setPrenom(rs.getString("prenom"));
        m.setEmail(rs.getString("email"));
        m.setMotDePasse(rs.getString("mot_de_passe"));
        m.setStatut(rs.getString("statut"));
        m.setRole(rs.getString("role"));
        m.setEtablissement(rs.getString("etablissement"));
        m.setLaboratoire(rs.getString("laboratoire"));
        m.setLaboratoireOrigine(rs.getString("laboratoire_origine"));
        m.setBiographie(rs.getString("biographie"));
        m.setCentresInteret(rs.getString("centres_interet"));
        m.setPhoto(rs.getString("photo"));
        m.setDateNaissance(rs.getDate("date_naissance"));
        m.setDateEmbauche(rs.getDate("date_embauche"));

        int equipeId = rs.getInt("equipe_id");
        if (rs.wasNull()) {
            m.setEquipeId(null);
        } else {
            m.setEquipeId(equipeId);
        }

        m.setActif(rs.getBoolean("actif"));

        return m;
    }
}