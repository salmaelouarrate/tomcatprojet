<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");
    if (membreConnecte == null)
        membreConnecte = (com.testweba.model.Membre) session.getAttribute("membre");
    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    boolean isDirecteur = "directeur".equalsIgnoreCase(membreConnecte.getRole())
                       || "admin".equalsIgnoreCase(membreConnecte.getRole());

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.DemandeMateriel> demandes =
        (java.util.List<com.testweba.model.DemandeMateriel>) request.getAttribute("demandes");

    int nbAttente = 0, nbValidees = 0, nbRefusees = 0;
    if (demandes != null) {
        for (com.testweba.model.DemandeMateriel d : demandes) {
            if ("en_attente".equals(d.getStatut())) nbAttente++;
            else if ("validee".equals(d.getStatut())) nbValidees++;
            else nbRefusees++;
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demandes matériel - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .main { margin-left: 260px; padding: 28px; }

        .hero-card {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border-radius: 22px; padding: 32px; margin-bottom: 24px;
            color: white; position: relative; overflow: hidden;
            box-shadow: 0 16px 40px rgba(11,47,87,0.22);
        }
        .hero-card::before {
            content: ''; position: absolute; top: -50px; right: -50px;
            width: 220px; height: 220px; background: rgba(255,255,255,0.06); border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 5; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; }
        .hero-title { font-size: 24px; font-weight: 800; margin-bottom: 6px; }
        .hero-sub { opacity: 0.8; font-size: 14px; margin: 0; }

        .btn-add-demande {
            background: white; color: #0b2f57; border: none;
            border-radius: 12px; padding: 12px 24px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s;
            text-decoration: none; box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-add-demande:hover { transform: translateY(-2px); color: #0b2f57; }

        .stats-row { display: flex; gap: 16px; margin-top: 20px; flex-wrap: wrap; }
        .stat-pill {
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
            border-radius: 14px; padding: 10px 18px;
            display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 600;
        }
        .stat-pill .num { font-size: 18px; font-weight: 900; }

        .user-info-row {
            display: flex; justify-content: flex-end; align-items: center; gap: 12px;
            margin-bottom: 16px;
        }
        .badge-role { background: #e0f2fe; color: #075985; padding: 8px 12px; border-radius: 999px; font-weight: 600; }

        .content-card {
            background: white; border-radius: 18px; padding: 8px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
        }
        .table thead th {
            background: #f1f5f9; color: #334155; font-weight: 700;
            padding: 14px 16px; border: none; text-transform: uppercase;
            font-size: 11.5px; letter-spacing: 0.04em;
        }
        .table tbody td { padding: 14px 16px; vertical-align: middle; }
        .table tbody tr:hover { background: #f8fafc; }

        .materiel-icon {
            width: 36px; height: 36px; border-radius: 10px;
            background: #dbeafe; color: #1d4ed8;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 15px; margin-right: 8px;
        }
        .qty-pill {
            background: #eff6ff; color: #1d4ed8; border-radius: 999px;
            padding: 5px 14px; font-size: 13px; font-weight: 700;
        }
        .justif-cell { max-width: 200px; white-space: normal; font-size: 13px; color: #64748b; }
        .date-cell { color: #64748b; font-size: 13px; }

        .status-badge {
            border-radius: 999px; padding: 6px 14px;
            font-size: 12.5px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .status-attente  { background: #fef3c7; color: #92400e; }
        .status-validee  { background: #dcfce7; color: #166534; }
        .status-refusee  { background: #fee2e2; color: #991b1b; }

        .action-btn {
            width: 34px; height: 34px; border-radius: 9px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-right: 6px; transition: 0.2s; border: none;
        }

        .empty-state { text-align: center; padding: 70px 20px; }
        .empty-state i { font-size: 56px; color: #cbd5e1; margin-bottom: 16px; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="hero-card">
        <div class="hero-content">
            <div>
                <div class="hero-title"><i class="bi bi-box-seam me-2"></i>Demandes de matériel</div>
                <p class="hero-sub">
                    <%= isDirecteur ? "Toutes les demandes reçues par le laboratoire" : "Mes demandes d'équipement" %>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/demandes-materiel?action=new" class="btn-add-demande">
                <i class="bi bi-plus-circle"></i> Nouvelle demande
            </a>
        </div>

        <div class="stats-row">
            <div class="stat-pill">
                <i class="bi bi-collection"></i>
                <span class="num"><%= demandes != null ? demandes.size() : 0 %></span> au total
            </div>
            <div class="stat-pill">
                <i class="bi bi-clock"></i>
                <span class="num"><%= nbAttente %></span> en attente
            </div>
            <div class="stat-pill">
                <i class="bi bi-check-circle"></i>
                <span class="num"><%= nbValidees %></span> validées
            </div>
            <div class="stat-pill">
                <i class="bi bi-x-circle"></i>
                <span class="num"><%= nbRefusees %></span> refusées
            </div>
        </div>
    </div>

    <div class="user-info-row">
        <span class="badge-role"><%= membreConnecte.getRole() %></span>
        <div class="text-end">
            <strong><%= membreConnecte.getNomComplet() %></strong><br>
            <small class="text-muted"><%= membreConnecte.getEmail() %></small>
        </div>
    </div>

    <div class="content-card">
        <% if (demandes != null && !demandes.isEmpty()) { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <% if (isDirecteur) { %><th>Membre</th><% } %>
                        <th>Matériel</th>
                        <th>Quantité</th>
                        <th>Justification</th>
                        <th>Statut</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <% for (com.testweba.model.DemandeMateriel d : demandes) { %>
                    <tr>
                        <td style="color:#94a3b8;font-weight:600;"><%= d.getId() %></td>
                        <% if (isDirecteur) { %>
                        <td><strong style="color:#0b2f57;"><%= d.getMembreNom() != null ? d.getMembreNom() : "" %></strong></td>
                        <% } %>
                        <td>
                            <span class="materiel-icon"><i class="bi bi-pc-display"></i></span>
                            <strong style="color:#0b2f57;"><%= d.getMaterielNom() %></strong>
                        </td>
                        <td><span class="qty-pill"><%= d.getQuantite() %></span></td>
                        <td class="justif-cell">
                            <%= d.getJustification() != null ? d.getJustification() : "" %>
                        </td>
                        <td>
                            <% if ("en_attente".equals(d.getStatut())) { %>
                                <span class="status-badge status-attente">
                                    <i class="bi bi-clock"></i> En attente
                                </span>
                            <% } else if ("validee".equals(d.getStatut())) { %>
                                <span class="status-badge status-validee">
                                    <i class="bi bi-check-circle"></i> Validée
                                </span>
                            <% } else { %>
                                <span class="status-badge status-refusee">
                                    <i class="bi bi-x-circle"></i> Refusée
                                </span>
                            <% } %>
                        </td>
                        <td class="date-cell">
                            <%= d.getDateDemande() != null ? d.getDateDemande().substring(0, 10) : "" %>
                        </td>
                        <td>
                            <% if (isDirecteur && "en_attente".equals(d.getStatut())) { %>
                                <a href="${pageContext.request.contextPath}/demandes-materiel?action=valider&id=<%= d.getId() %>"
                                   class="action-btn" style="background:#dcfce7;color:#166534;"
                                   onclick="return confirm('Valider cette demande ?');">
                                    <i class="bi bi-check-circle"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/demandes-materiel?action=refuser&id=<%= d.getId() %>"
                                   class="action-btn" style="background:#fee2e2;color:#991b1b;"
                                   onclick="return confirm('Refuser cette demande ?');">
                                    <i class="bi bi-x-circle"></i>
                                </a>
                            <% } else if (isDirecteur) { %>
                                <a href="${pageContext.request.contextPath}/demandes-materiel?action=supprimer&id=<%= d.getId() %>"
                                   class="action-btn" style="background:#fef2f2;color:#dc2626;"
                                   onclick="return confirm('Supprimer ?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            <% } else { %>
                                <span class="text-muted" style="font-size:13px;">—</span>
                            <% } %>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } else { %>
            <div class="empty-state">
                <i class="bi bi-box-seam d-block"></i>
                <h5 class="text-muted">Aucune demande de matériel</h5>
                <a href="${pageContext.request.contextPath}/demandes-materiel?action=new"
                   class="btn btn-primary mt-3" style="border-radius:12px;">
                    <i class="bi bi-plus-circle me-1"></i> Créer une demande
                </a>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>