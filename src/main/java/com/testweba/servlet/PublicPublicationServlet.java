package com.testweba.servlet;

import com.testweba.dao.PublicationDAO;
import com.testweba.model.Publication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/public-publications")
public class PublicPublicationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PublicationDAO publicationDAO = new PublicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Publication> publications = publicationDAO.findAll();

        request.setAttribute("publications", publications);

        request.getRequestDispatcher("/WEB-INF/views/public-publications.jsp")
               .forward(request, response);
    }
}