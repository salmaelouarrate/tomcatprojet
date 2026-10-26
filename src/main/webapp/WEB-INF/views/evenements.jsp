<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String role = membreConnecte.getRole();
    if (role == null) role = "";
    role = role.toLowerCase();

    boolean isAdmin = "admin".equals(role) || "directeur".equals(role);
    boolean isChef = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isMembre = "membre".equals(role);

    if (isDoctorant) {
        response.sendRedirect(request.getContextPath() + "/espace-doctorant");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Evenement> evenements =
        (java.util.List<com.testweba.model.Evenement>) request.getAttribute("evenements");

    com.testweba.dao.EvenementDAO evenementDAOJsp = new com.testweba.dao.EvenementDAO();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Événements - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; }

        body {
            background: #f8faff;
            font-family: 'Inter', sans-serif;
            color: #1e293b;
        }

        .sidebar {
            width: 260px;
            min-height: 100vh;
            background: linear-gradient(180deg, #0b2f57 0%, #123f73 100%);
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 26px 18px;
            box-shadow: 4px 0 24px rgba(11,47,87,0.15);
        }

        .sidebar .brand {
            font-size: 21px;
            font-weight: 800;
            margin-bottom: 36px;
            letter-spacing: -0.5px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 14px;
            transition: 0.2s;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.08);
            color: white;
        }

        .sidebar a.active {
            background: linear-gradient(135deg, #1d6fa5, #0ea5e9);
            color: white;
            box-shadow: 0 6px 18px rgba(14,165,233,0.35);
        }

        .main {
            margin-left: 260px;
            padding: 30px 32px;
        }

        .topbar {
            background: white;
            border-radius: 20px;
            padding: 22px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            margin-bottom: 26px;
            border: 1px solid #edf2f7;
        }

        .topbar h5 {
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 4px;
            font-size: 19px;
        }

        .topbar small {
            color: #64748b;
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            font-weight: 700;
            font-size: 14px;
            padding: 11px 22px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
        }

        .content-card {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            background: #f1f6fb;
            color: #0b2f57;
            font-weight: 800;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            border-bottom: none;
            padding: 14px 16px;
        }

        .table thead th:first-child {
            border-radius: 12px 0 0 12px;
        }

        .table thead th:last-child {
            border-radius: 0 12px 12px 0;
        }

        .table tbody td {
            padding: 14px 16px;
            font-size: 14px;
            color: #334155;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .table tbody tr {
            transition: 0.2s;
        }

        .table tbody tr:hover {
            background: #f8faff;
        }

        .type-badge {
            background: #fef3c7;
            color: #92400e;
            border-radius: 999px;
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 700;
            display: inline-block;
        }

        .action-btn {
            margin-right: 6px;
            border-radius: 10px;
        }

        .description-cell {
            max-width: 220px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #64748b;
        }

        .organisateurs-cell {
            max-width: 200px;
        }

        .org-chip {
            display: inline-block;
            background: #e0f2fe;
            color: #075985;
            border-radius: 999px;
            padding: 4px 12px;
            font-size: 11px;
            font-weight: 700;
            margin: 2px;
        }

        .btn-outline-primary { border-color: #c7e0f4; color: #1d6fa5; }
        .btn-outline-primary:hover { background: #1d6fa5; border-color: #1d6fa5; }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 40px;
            color: #cbd5e1;
            display: block;
            margin-bottom: 12px;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main { margin-left: 0; padding: 18px; }
            .topbar { flex-direction: column; align-items: flex-start; gap: 14px; }
        }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>
<div class="main">

    <div class="topbar">
        <div>
            <h5 class="mb-0">Gestion des événements</h5>
            <small class="text-muted">Conférences, séminaires et workshops</small>
        </div>

        <% if (isAdmin || isChef) { %>
            <a href="${pageContext.request.contextPath}/evenements?action=new" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> Ajouter événement
            </a>
        <% } %>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Titre</th>
                        <th>Type</th>
                        <th>Date début</th>
                        <th>Date fin</th>
                        <th>Lieu</th>
                        <th>Édition</th>
                        <th>Description</th>
                        <th>Organisateurs</th>
                        <% if (isAdmin || isChef) { %>
                            <th>Actions</th>
                        <% } %>
                    </tr>
                </thead>

                <tbody>
                <% if (evenements != null && !evenements.isEmpty()) { %>
                    <% for (com.testweba.model.Evenement e : evenements) {
                        List<Map<String, String>> orgs = evenementDAOJsp.getOrganisateurs(e.getId());
                    %>
                        <tr>
                            <td><%= e.getId() %></td>
                            <td><strong><%= e.getTitre() %></strong></td>
                            <td><span class="type-badge"><%= e.getType() %></span></td>
                            <td><%= e.getDateDebut() %></td>
                            <td><%= e.getDateFin() != null ? e.getDateFin() : "-" %></td>
                            <td><%= e.getLieu() != null ? e.getLieu() : "-" %></td>
                            <td><%= e.getEdition() %></td>
                            <td class="description-cell">
                                <%= e.getDescription() != null ? e.getDescription() : "-" %>
                            </td>
                            <td class="organisateurs-cell">
                                <% if (orgs != null && !orgs.isEmpty()) {
                                    for (Map<String, String> org : orgs) { %>
                                        <span class="org-chip"><%= org.get("nom") %></span>
                                <%  }
                                } else { %>
                                    <span class="text-muted" style="font-size:12px;">Aucun</span>
                                <% } %>
                            </td>
                            <% if (isAdmin || isChef) { %>
                                <td>
                                    <a href="${pageContext.request.contextPath}/evenements?action=edit&id=<%= e.getId() %>"
                                       class="btn btn-sm btn-outline-primary action-btn">
                                        <i class="bi bi-pencil-square"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/evenements?action=delete&id=<%= e.getId() %>"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Voulez-vous vraiment supprimer cet événement ?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            <% } %>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="<%= (isAdmin || isChef) ? 10 : 9 %>">
                            <div class="empty-state">
                                <i class="bi bi-calendar-event"></i>
                                Aucun événement trouvé.
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>
