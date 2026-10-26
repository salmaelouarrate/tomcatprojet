package com.testweba.servlet;

import com.testweba.dao.NotificationDAO;
import com.testweba.model.Membre;
import com.testweba.model.Notification;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationDAO notificationDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Membre membre = (Membre) session.getAttribute("membreConnecte");

        String action = request.getParameter("action");

        if ("read".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            notificationDAO.marquerCommeLue(id, membre.getId());
            response.sendRedirect(request.getContextPath() + "/notifications");
            return;
        }

        if ("readAll".equals(action)) {
            notificationDAO.toutMarquerCommeLu(membre.getId());
            response.sendRedirect(request.getContextPath() + "/notifications");
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            notificationDAO.supprimer(id, membre.getId());
            response.sendRedirect(request.getContextPath() + "/notifications");
            return;
        }

        List<Notification> notifications = notificationDAO.findByMembreId(membre.getId());
        int nonLues = notificationDAO.countNonLues(membre.getId());

        request.setAttribute("membre", membre);
        request.setAttribute("notifications", notifications);
        request.setAttribute("nonLues", nonLues);

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp")
               .forward(request, response);
    }
}