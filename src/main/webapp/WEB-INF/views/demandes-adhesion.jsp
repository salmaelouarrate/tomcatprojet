<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        membreConnecte = (com.testweba.model.Membre) session.getAttribute("membre");
    }

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.DemandeAdhesion> demandes =
        (java.util.List<com.testweba.model.DemandeAdhesion>) request.getAttribute("demandes");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demandes d'adhésion - LIAS</title>
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

        .status-badge {
            border-radius: 999px;
            padding: 6px 14px;
            font-size: 12px;
            font-weight: 700;
            display: inline-block;
        }

        .status-attente  { background: #fef3c7; color: #92400e; }
        .status-acceptee { background: #dcfce7; color: #166534; }
        .status-refusee  { background: #fee2e2; color: #991b1b; }

        .motivation-cell {
            max-width: 250px;
            white-space: normal;
            font-size: 13px;
            color: #64748b;
        }

        .btn-success {
            border-radius: 10px;
            font-weight: 700;
        }

        .btn-danger {
            border-radius: 10px;
            font-weight: 700;
        }

        .btn-outline-danger {
            border-radius: 10px;
        }

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
            <h5 class="mb-0">Demandes d'adhésion</h5>
            <small class="text-muted">Validation des demandes reçues par le laboratoire LIAS</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span style="background:#e0f2fe;color:#075985;padding:8px 16px;border-radius:999px;font-weight:700;font-size:13px;">
                <%= membreConnecte.getRole() %>
            </span>
            <div class="text-end">
                <strong><%= membreConnecte.getNomComplet() %></strong><br>
                <small class="text-muted"><%= membreConnecte.getEmail() %></small>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Nom complet</th>
                        <th>Email</th>
                        <th>Motivation</th>
                        <th>Statut</th>
                        <th>Date demande</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% if (demandes != null && !demandes.isEmpty()) { %>
                    <% for (com.testweba.model.DemandeAdhesion d : demandes) { %>
                        <tr>
                            <td><%= d.getId() %></td>
                            <td><strong><%= d.getPrenom() %> <%= d.getNom() %></strong></td>
                            <td><%= d.getEmail() %></td>
                            <td class="motivation-cell">
                                <%= d.getMotivation() != null ? d.getMotivation() : "" %>
                            </td>
                            <td>
                                <% if ("en_attente".equals(d.getStatut())) { %>
                                    <span class="status-badge status-attente">En attente</span>
                                <% } else if ("acceptee".equals(d.getStatut())) { %>
                                    <span class="status-badge status-acceptee">Acceptée</span>
                                <% } else { %>
                                    <span class="status-badge status-refusee">Refusée</span>
                                <% } %>
                            </td>
                            <td><%= d.getDateDemande() != null ? d.getDateDemande() : "" %></td>
                            <td>
                                <% if ("en_attente".equals(d.getStatut())) { %>
                                    <a href="${pageContext.request.contextPath}/demandes-adhesion?action=accept&id=<%= d.getId() %>"
                                       class="btn btn-sm btn-success me-1"
                                       onclick="return confirm('Accepter cette demande ?');">
                                        <i class="bi bi-check-circle"></i> Accepter
                                    </a>
                                    <a href="${pageContext.request.contextPath}/demandes-adhesion?action=reject&id=<%= d.getId() %>"
                                       class="btn btn-sm btn-danger"
                                       onclick="return confirm('Refuser cette demande ?');">
                                        <i class="bi bi-x-circle"></i> Refuser
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">Traitée</span>
                                    <a href="${pageContext.request.contextPath}/demandes-adhesion?action=supprimer&id=<%= d.getId() %>"
                                       class="btn btn-sm btn-outline-danger ms-2"
                                       onclick="return confirm('Supprimer ?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                Aucune demande d'adhésion trouvée.
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
