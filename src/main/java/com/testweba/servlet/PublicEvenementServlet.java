package com.testweba.servlet;

import com.testweba.dao.EvenementDAO;
import com.testweba.model.Evenement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/public-evenements")
public class PublicEvenementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EvenementDAO evenementDAO = new EvenementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Evenement> evenements = evenementDAO.findAll();

        request.setAttribute("evenements", evenements);

        request.getRequestDispatcher("/WEB-INF/views/public-evenements.jsp")
               .forward(request, response);
    }
}