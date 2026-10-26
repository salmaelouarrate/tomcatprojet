package com.testweba.servlet;

import com.testweba.config.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/calendrier")
public class CalendrierServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String format = request.getParameter("format");

        if ("json".equals(format)) {
            response.setContentType("application/json;charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.print(getEvenementsJson());
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/calendrier.jsp")
               .forward(request, response);
    }

    private String getEvenementsJson() {
        StringBuilder json = new StringBuilder("[");
        boolean first = true;

        String sql = "SELECT id, titre, type, date_debut, date_fin, lieu " +
                     "FROM evenement ORDER BY date_debut";

        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                String type = rs.getString("type");
                String color = getColor(type);
                String dateFin = rs.getString("date_fin");

                json.append("{");
                json.append("\"id\":").append(rs.getInt("id")).append(",");
                json.append("\"title\":\"").append(escape(rs.getString("titre"))).append("\",");
                json.append("\"start\":\"").append(rs.getString("date_debut")).append("\",");

                if (dateFin != null && !dateFin.isEmpty()) {
                    json.append("\"end\":\"").append(dateFin).append("\",");
                }

                json.append("\"color\":\"").append(color).append("\",");
                json.append("\"extendedProps\":{");
                json.append("\"type\":\"").append(escape(type)).append("\",");
                json.append("\"lieu\":\"").append(escape(rs.getString("lieu"))).append("\"");
                json.append("}");
                json.append("}");
            }

        } catch (SQLException e) {
            System.err.println("[CalendrierServlet] Erreur : " + e.getMessage());
        }

        json.append("]");
        return json.toString();
    }

    private String getColor(String type) {
        if (type == null) return "#1d6fa5";

        switch (type.toLowerCase()) {
            case "conference": return "#3b82f6";
            case "seminaire":  return "#10b981";
            case "workshop":   return "#f59e0b";
            default:           return "#1d6fa5";
        }
    }

    private String escape(String s) {
        if (s == null) return "";

        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }
}