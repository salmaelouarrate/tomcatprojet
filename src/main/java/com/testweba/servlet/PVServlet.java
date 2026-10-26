package com.testweba.servlet;

import com.testweba.dao.PVDAO;
import com.testweba.model.Membre;
import com.testweba.model.PV;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/pv")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024)
public class PVServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final PVDAO dao = new PVDAO();
    private static final String UPLOAD_DIR = "uploads/pv";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {

            case "new":
                if (!isDirecteur(request, response)) return;
                request.getRequestDispatcher("/WEB-INF/views/ajouter-pv.jsp")
                       .forward(request, response);
                break;

            case "edit": {
                if (!isDirecteur(request, response)) return;
                int id = Integer.parseInt(request.getParameter("id"));
                PV pv = dao.findById(id);
                request.setAttribute("pv", pv);
                request.getRequestDispatcher("/WEB-INF/views/modifier-pv.jsp")
                       .forward(request, response);
                break;
            }

            case "supprimer": {
                if (!isDirecteur(request, response)) return;
                int id = Integer.parseInt(request.getParameter("id"));
                dao.supprimer(id);
                response.sendRedirect(request.getContextPath() + "/pv");
                break;
            }

            default: {
                Membre membre = getMembreConnecte(request);
                if (membre == null) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                List<PV> pvList = dao.findAll();
                request.setAttribute("pvList", pvList);
                request.getRequestDispatcher("/WEB-INF/views/pv.jsp")
                       .forward(request, response);
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        if (!isDirecteur(request, response)) return;

        String action = request.getParameter("action");
        Membre membre = getMembreConnecte(request);

        // Dossier upload
        String uploadPath = getServletContext().getRealPath("") 
                          + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        // Traiter fichier PDF
        String pvPath = null;
        try {
            Part filePart = request.getPart("pvFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + getFileName(filePart);
                filePart.write(uploadPath + File.separator + fileName);
                pvPath = request.getContextPath() + "/" + UPLOAD_DIR + "/" + fileName;
            }
        } catch (Exception e) {
            System.err.println("[PVServlet] Erreur upload : " + e.getMessage());
        }

        if ("insert".equals(action)) {
            PV pv = new PV();
            pv.setTitre(request.getParameter("titre"));
            pv.setDateReunion(request.getParameter("dateReunion"));
            pv.setOrdreDuJour(request.getParameter("ordreDuJour"));
            pv.setPvPath(pvPath);
            pv.setCreatedBy(membre != null ? membre.getId() : null);
            dao.ajouter(pv);

        } else if ("update".equals(action)) {
            PV pv = new PV();
            pv.setId(Integer.parseInt(request.getParameter("id")));
            pv.setTitre(request.getParameter("titre"));
            pv.setDateReunion(request.getParameter("dateReunion"));
            pv.setOrdreDuJour(request.getParameter("ordreDuJour"));
            if (pvPath != null) {
                pv.setPvPath(pvPath);
            } else {
                pv.setPvPath(request.getParameter("pvPathActuel"));
            }
            dao.modifier(pv);
        }

        response.sendRedirect(request.getContextPath() + "/pv");
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "file.pdf";
    }

    private Membre getMembreConnecte(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Membre m = (Membre) session.getAttribute("membreConnecte");
        if (m == null) m = (Membre) session.getAttribute("membre");
        return m;
    }

    private boolean isDirecteur(HttpServletRequest request,
                                  HttpServletResponse response) throws IOException {
        Membre membre = getMembreConnecte(request);
        if (membre == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        String role = membre.getRole();
        if (!"directeur".equalsIgnoreCase(role) && !"admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }
        return true;
    }
}