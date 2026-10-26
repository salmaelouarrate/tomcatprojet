package com.testweba.servlet;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import com.testweba.config.DBConnection;
import com.testweba.model.Membre;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/rapport")
public class RapportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Vérifier directeur
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Membre membre = (Membre) session.getAttribute("membreConnecte");
        if (membre == null) membre = (Membre) session.getAttribute("membre");
        if (membre == null || (!"directeur".equalsIgnoreCase(membre.getRole())
                && !"admin".equalsIgnoreCase(membre.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }

        String annee = request.getParameter("annee");
        if (annee == null || annee.isEmpty()) {
            annee = String.valueOf(java.time.Year.now().getValue());
        }

        // Générer PDF
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition",
            "attachment; filename=rapport_lias_" + annee + ".pdf");

        try {
            Document document = new Document(PageSize.A4, 50, 50, 60, 60);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            // Couleurs
            BaseColor bleuLias = new BaseColor(11, 47, 87);
            BaseColor bleuClair = new BaseColor(29, 111, 165);
            BaseColor gris = new BaseColor(100, 116, 139);

            // Fonts
            Font fontTitre = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD,
                BaseColor.WHITE);
            Font fontSousTitre = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL,
                BaseColor.WHITE);
            Font fontSection = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD,
                bleuLias);
            Font fontNormal = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL,
                BaseColor.BLACK);
            Font fontGris = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, gris);
            Font fontTableHeader = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD,
                BaseColor.WHITE);

            // ===== EN-TÊTE =====
            PdfPTable header = new PdfPTable(1);
            header.setWidthPercentage(100);
            PdfPCell headerCell = new PdfPCell();
            headerCell.setBackgroundColor(bleuLias);
            headerCell.setPadding(30);
            headerCell.setBorder(Rectangle.NO_BORDER);

            Paragraph titre = new Paragraph("Laboratoire LIAS", fontTitre);
            titre.setAlignment(Element.ALIGN_CENTER);
            headerCell.addElement(titre);

            Paragraph sousTitre = new Paragraph(
                "Rapport d'activité annuel — " + annee, fontSousTitre);
            sousTitre.setAlignment(Element.ALIGN_CENTER);
            headerCell.addElement(sousTitre);

            Paragraph faculte = new Paragraph(
                "Faculté des Sciences Ben M'Sik — Casablanca", fontSousTitre);
            faculte.setAlignment(Element.ALIGN_CENTER);
            headerCell.addElement(faculte);

            header.addCell(headerCell);
            document.add(header);
            document.add(Chunk.NEWLINE);

            // ===== STATISTIQUES GÉNÉRALES =====
            addSectionTitle(document, "Statistiques générales", fontSection, bleuClair);

            PdfPTable statsTable = new PdfPTable(2);
            statsTable.setWidthPercentage(100);
            statsTable.setSpacingBefore(10);

            addStatRow(statsTable, "Membres actifs",
                getCount("SELECT COUNT(*) FROM membre WHERE actif = 1"), bleuLias);
            addStatRow(statsTable, "Publications " + annee,
                getCount("SELECT COUNT(*) FROM publication WHERE annee = " + annee),
                bleuClair);
            addStatRow(statsTable, "Événements " + annee,
                getCount("SELECT COUNT(*) FROM evenement WHERE YEAR(date_debut) = "
                    + annee), bleuLias);
            addStatRow(statsTable, "Documents",
                getCount("SELECT COUNT(*) FROM document"), bleuClair);
            addStatRow(statsTable, "Conventions actives",
                getCount("SELECT COUNT(*) FROM convention WHERE statut = 'active'"),
                bleuLias);
            addStatRow(statsTable, "Matériels",
                getCount("SELECT COUNT(*) FROM materiel"), bleuClair);

            document.add(statsTable);
            document.add(Chunk.NEWLINE);

            // ===== MEMBRES =====
            addSectionTitle(document, "Membres actifs", fontSection, bleuClair);

            PdfPTable membresTable = new PdfPTable(4);
            membresTable.setWidthPercentage(100);
            membresTable.setWidths(new float[]{3, 3, 2, 2});
            membresTable.setSpacingBefore(10);

            addTableHeader(membresTable, fontTableHeader, bleuLias,
                "Nom complet", "Email", "Statut", "Rôle");

            try (Connection conn = DBConnection.getConn();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT nom, prenom, email, statut, role FROM membre " +
                     "WHERE actif = 1 ORDER BY nom");
                 ResultSet rs = ps.executeQuery()) {

                boolean alt = false;
                while (rs.next()) {
                    BaseColor bg = alt ? new BaseColor(241, 245, 249) : BaseColor.WHITE;
                    addTableRow(membresTable, fontNormal, bg,
                        rs.getString("prenom") + " " + rs.getString("nom"),
                        rs.getString("email"),
                        rs.getString("statut"),
                        rs.getString("role"));
                    alt = !alt;
                }
            } catch (SQLException e) {
                System.err.println("[Rapport] Erreur membres : " + e.getMessage());
            }
            document.add(membresTable);
            document.add(Chunk.NEWLINE);

            // ===== PUBLICATIONS =====
            addSectionTitle(document, "Publications " + annee, fontSection, bleuClair);

            PdfPTable pubTable = new PdfPTable(3);
            pubTable.setWidthPercentage(100);
            pubTable.setWidths(new float[]{5, 2, 2});
            pubTable.setSpacingBefore(10);

            addTableHeader(pubTable, fontTableHeader, bleuLias,
                "Titre", "Type", "Année");

            try (Connection conn = DBConnection.getConn();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT titre, type, annee FROM publication " +
                     "WHERE annee = ? ORDER BY titre");) {
                ps.setString(1, annee);
                ResultSet rs = ps.executeQuery();
                boolean alt = false;
                while (rs.next()) {
                    BaseColor bg = alt ? new BaseColor(241, 245, 249) : BaseColor.WHITE;
                    addTableRow(pubTable, fontNormal, bg,
                        rs.getString("titre"),
                        rs.getString("type"),
                        rs.getString("annee"));
                    alt = !alt;
                }
            } catch (SQLException e) {
                System.err.println("[Rapport] Erreur publications : " + e.getMessage());
            }
            document.add(pubTable);
            document.add(Chunk.NEWLINE);

            // ===== ÉVÉNEMENTS =====
            addSectionTitle(document, "Événements " + annee, fontSection, bleuClair);

            PdfPTable evtTable = new PdfPTable(3);
            evtTable.setWidthPercentage(100);
            evtTable.setWidths(new float[]{4, 2, 2});
            evtTable.setSpacingBefore(10);

            addTableHeader(evtTable, fontTableHeader, bleuLias,
                "Titre", "Type", "Date");

            try (Connection conn = DBConnection.getConn();
                 PreparedStatement ps = conn.prepareStatement(
                     "SELECT titre, type, date_debut FROM evenement " +
                     "WHERE YEAR(date_debut) = ? ORDER BY date_debut");) {
                ps.setString(1, annee);
                ResultSet rs = ps.executeQuery();
                boolean alt = false;
                while (rs.next()) {
                    BaseColor bg = alt ? new BaseColor(241, 245, 249) : BaseColor.WHITE;
                    addTableRow(evtTable, fontNormal, bg,
                        rs.getString("titre"),
                        rs.getString("type"),
                        rs.getString("date_debut"));
                    alt = !alt;
                }
            } catch (SQLException e) {
                System.err.println("[Rapport] Erreur événements : " + e.getMessage());
            }
            document.add(evtTable);
            document.add(Chunk.NEWLINE);

            // ===== PIED DE PAGE =====
            document.add(Chunk.NEWLINE);
            Paragraph footer = new Paragraph(
                "Généré le " + new java.util.Date() +
                " — Laboratoire LIAS, Faculté des Sciences Ben M'Sik", fontGris);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);

            document.close();

        } catch (DocumentException e) {
            throw new ServletException("Erreur génération PDF : " + e.getMessage(), e);
        }
    }

    private void addSectionTitle(Document doc, String titre, Font font,
                                  BaseColor color) throws DocumentException {
        Paragraph p = new Paragraph(titre, font);
        p.setSpacingBefore(15);
        p.setSpacingAfter(5);

        PdfPTable line = new PdfPTable(1);
        line.setWidthPercentage(100);
        PdfPCell cell = new PdfPCell(new Phrase(titre, font));
        cell.setBackgroundColor(new BaseColor(239, 246, 255));
        cell.setBorderColor(color);
        cell.setBorderWidthLeft(4);
        cell.setBorderWidthTop(0);
        cell.setBorderWidthRight(0);
        cell.setBorderWidthBottom(0);
        cell.setPadding(10);
        line.addCell(cell);
        doc.add(line);
    }

    private void addStatRow(PdfPTable table, String label, int value,
                             BaseColor color) {
        Font fontLabel = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL,
            BaseColor.BLACK);
        Font fontValue = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, color);

        PdfPCell labelCell = new PdfPCell(new Phrase(label, fontLabel));
        labelCell.setPadding(12);
        labelCell.setBorderColor(new BaseColor(226, 232, 240));
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(String.valueOf(value), fontValue));
        valueCell.setPadding(12);
        valueCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        valueCell.setBorderColor(new BaseColor(226, 232, 240));
        table.addCell(valueCell);
    }

    private void addTableHeader(PdfPTable table, Font font, BaseColor bg,
                                 String... headers) {
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, font));
            cell.setBackgroundColor(bg);
            cell.setPadding(8);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }
    }

    private void addTableRow(PdfPTable table, Font font, BaseColor bg,
                              String... values) {
        for (String v : values) {
            PdfPCell cell = new PdfPCell(new Phrase(v != null ? v : "", font));
            cell.setBackgroundColor(bg);
            cell.setPadding(7);
            cell.setBorderColor(new BaseColor(226, 232, 240));
            table.addCell(cell);
        }
    }

    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConn();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[Rapport] Erreur count : " + e.getMessage());
        }
        return 0;
    }
}