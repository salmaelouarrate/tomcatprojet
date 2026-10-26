package com.testweba;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/JEE1")
public class JEE1 extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public JEE1() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        PrintWriter out = response.getWriter();

        String valeur;

        Cookie[] tabCookies = request.getCookies();

        boolean existe = false;

        if (tabCookies != null) {

            for (int i = 0; i < tabCookies.length; i++) {

                if (tabCookies[i].getName().equals("identifiant")) {

                    existe = true;
                }
            }
        }

        if (tabCookies == null || existe == false) {

            out.println("<h1>Bonjour le nouveau... mais plus maintenant</h1>");

            valeur = new java.rmi.server.UID().toString();

            Cookie monCookie = new Cookie("identifiant", valeur);

            monCookie.setMaxAge(60 * 60 * 24 * 365);

            response.addCookie(monCookie);

        } else {

            out.println("<h1>Encore vous</h1>");
        }

        out.close();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}