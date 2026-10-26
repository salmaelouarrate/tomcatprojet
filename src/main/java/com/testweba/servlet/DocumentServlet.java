package com.testweba.servlet;

import com.testweba.dao.DocumentDAO;
import com.testweba.model.Document;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/documents")
public class DocumentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DocumentDAO documentDAO = new DocumentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("membreConnecte") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
        case "new":
            request.setAttribute("evenements", new com.testweba.dao.EvenementDAO().findAll());
            request.getRequestDispatcher("/WEB-INF/views/ajouter-document.jsp")
                   .forward(request, response);
            break;

            case "delete":
                supprimerDocument(request, response);
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

        request.setCharacterEncoding("UTF-8");

        ajouterDocument(request, response);
    }

    private void afficherListe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Document> documents = documentDAO.findAll();
        request.setAttribute("documents", documents);

        request.getRequestDispatcher("/WEB-INF/views/documents.jsp")
               .forward(request, response);
    }

    private void ajouterDocument(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Membre membreConnecte = (Membre) session.getAttribute("membreConnecte");

        Document document = new Document();

        document.setNom(request.getParameter("nom"));
        document.setType(request.getParameter("type"));
        document.setChemin(request.getParameter("chemin"));

        String evenementId = request.getParameter("evenementId");

        if (evenementId == null || evenementId.trim().isEmpty()) {
            document.setEvenementId(null);
        } else {
            document.setEvenementId(Integer.parseInt(evenementId));
        }

        if (membreConnecte != null) {
            document.setUploadedBy(membreConnecte.getId());
        } else {
            document.setUploadedBy(null);
        }

        documentDAO.ajouter(document);

        response.sendRedirect(request.getContextPath() + "/documents");
    }

    private void supprimerDocument(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        documentDAO.supprimer(id);

        response.sendRedirect(request.getContextPath() + "/documents");
    }
}
