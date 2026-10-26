package com.testweba.servlet;

import com.testweba.dao.MessageDAO;
import com.testweba.model.Membre;
import com.testweba.model.Message;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final MessageDAO messageDAO = new MessageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Membre membre = getMembreConnecte(request);
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String contexte = request.getParameter("contexte");
        if (contexte == null) contexte = "general";

        Integer contexteId = null;
        String contexteIdParam = request.getParameter("contexteId");
        if (contexteIdParam != null && !contexteIdParam.trim().isEmpty()) {
            contexteId = Integer.parseInt(contexteIdParam);
        } else if ("equipe".equals(contexte)) {
            contexteId = getEquipeIdMembre(membre.getId());
        }

        List<Message> messages = messageDAO.findByContexte(contexte, contexteId);

        request.setAttribute("messages", messages);
        request.setAttribute("contexte", contexte);
        request.setAttribute("contexteId", contexteId);
        request.setAttribute("membreConnecte", membre);

        // Titre dynamique selon le contexte
        if ("evenement".equals(contexte) && contexteId != null) {
            com.testweba.dao.EvenementDAO evDao = new com.testweba.dao.EvenementDAO();
            request.setAttribute("evenement", evDao.findById(contexteId));
        }

        request.getRequestDispatcher("/WEB-INF/views/messages.jsp")
               .forward(request, response);
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
        String contexte = request.getParameter("contexte");
        if (contexte == null) contexte = "general";

        String contexteIdParam = request.getParameter("contexteId");
        Integer contexteId = (contexteIdParam != null && !contexteIdParam.trim().isEmpty())
                ? Integer.parseInt(contexteIdParam) : null;

        if (contexteId == null && "equipe".equals(contexte)) {
            contexteId = getEquipeIdMembre(membre.getId());
        }

        if ("envoyer".equals(action)) {
            String contenu = request.getParameter("contenu");
            if (contenu != null && !contenu.trim().isEmpty()) {
                Message m = new Message();
                m.setContexte(contexte);
                m.setContexteId(contexteId);
                m.setMembreId(membre.getId());
                m.setContenu(contenu.trim());
                messageDAO.ajouter(m);
            }
        } else if ("supprimer".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            messageDAO.supprimer(id);
        }

        StringBuilder redirect = new StringBuilder(request.getContextPath());
        redirect.append("/messages?contexte=").append(contexte);
        if (contexteId != null) {
            redirect.append("&contexteId=").append(contexteId);
        }

        response.sendRedirect(redirect.toString());
    }

    private Integer getEquipeIdMembre(int membreId) {
        String sql = "SELECT equipe_id FROM membre WHERE id = ?";
        try (java.sql.Connection conn = com.testweba.config.DBConnection.getConn();
             java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, membreId);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int equipeId = rs.getInt("equipe_id");
                return rs.wasNull() ? null : equipeId;
            }
        } catch (java.sql.SQLException e) {
            System.err.println("[MessageServlet] Erreur getEquipeIdMembre : " + e.getMessage());
        }
        return null;
    }

    private Membre getMembreConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Membre m = (Membre) session.getAttribute("membreConnecte");
        if (m == null) m = (Membre) session.getAttribute("membre");
        return m;
    }
}