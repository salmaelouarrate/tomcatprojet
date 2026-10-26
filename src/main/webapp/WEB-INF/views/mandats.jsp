<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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

    if (!isAdmin) {
        response.sendRedirect(request.getContextPath() + "/dashboard");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Mandat> mandats =
        (java.util.List<com.testweba.model.Mandat>) request.getAttribute("mandats");

    int nbActifs = 0;
    if (mandats != null) {
        for (com.testweba.model.Mandat m : mandats) {
            if (m.isActif()) nbActifs++;
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mandats - LIAS</title>
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

        .btn-add-mandat {
            background: white; color: #0b2f57; border: none;
            border-radius: 12px; padding: 12px 24px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s;
            text-decoration: none; box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-add-mandat:hover { transform: translateY(-2px); color: #0b2f57; }

        .stats-row { display: flex; gap: 16px; margin-top: 20px; flex-wrap: wrap; }
        .stat-pill {
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
            border-radius: 14px; padding: 10px 18px;
            display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 600;
        }
        .stat-pill .num { font-size: 18px; font-weight: 900; }

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

        .mandat-avatar {
            width: 36px; height: 36px; border-radius: 10px;
            background: #dbeafe; color: #1d4ed8;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 800; margin-right: 10px; flex-shrink: 0;
        }
        .type-badge {
            background: #e0f2fe; color: #075985;
            border-radius: 999px; padding: 6px 12px; font-size: 12.5px; font-weight: 700;
        }
        .status-badge {
            border-radius: 999px; padding: 6px 12px; font-size: 12.5px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .active-badge { background: #dcfce7; color: #166534; }
        .inactive-badge { background: #fee2e2; color: #991b1b; }
        .desc-cell { max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #64748b; font-size: 13px; }
        .date-cell { color: #64748b; font-size: 13px; }

        .action-btn {
            width: 34px; height: 34px; border-radius: 9px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-right: 6px; margin-bottom: 4px; transition: 0.2s; border: 1.5px solid;
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
                <div class="hero-title"><i class="bi bi-award me-2"></i>Gestion des mandats</div>
                <p class="hero-sub">Historique de la gouvernance du Laboratoire LIAS</p>
            </div>
            <a href="${pageContext.request.contextPath}/mandats?action=new" class="btn-add-mandat">
                <i class="bi bi-plus-circle"></i> Ajouter mandat
            </a>
        </div>

        <div class="stats-row">
            <div class="stat-pill">
                <i class="bi bi-collection"></i>
                <span class="num"><%= mandats != null ? mandats.size() : 0 %></span> mandats au total
            </div>
            <div class="stat-pill">
                <i class="bi bi-circle-fill" style="font-size:8px;color:#4ade80;"></i>
                <span class="num"><%= nbActifs %></span> actif<%= nbActifs != 1 ? "s" : "" %>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Membre</th>
                        <th>Email</th>
                        <th>Type</th>
                        <th>Date début</th>
                        <th>Date fin</th>
                        <th>État</th>
                        <th>Description</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                <% if (mandats != null && !mandats.isEmpty()) { %>
                    <% for (com.testweba.model.Mandat mandat : mandats) {
                        String initiales = "?";
                        if (mandat.getNomCompletMembre() != null && !mandat.getNomCompletMembre().isEmpty()) {
                            initiales = mandat.getNomCompletMembre().substring(0,1).toUpperCase();
                        }
                    %>
                        <tr>
                            <td style="color:#94a3b8;font-weight:600;"><%= mandat.getId() %></td>

                            <td>
                                <span class="mandat-avatar"><%= initiales %></span>
                                <strong style="color:#0b2f57;"><%= mandat.getNomCompletMembre() %></strong>
                            </td>

                            <td style="color:#64748b;font-size:13.5px;"><%= mandat.getEmailMembre() == null ? "-" : mandat.getEmailMembre() %></td>

                            <td><span class="type-badge"><i class="bi bi-award me-1"></i><%= mandat.getTypeMandat() %></span></td>

                            <td class="date-cell"><%= mandat.getDateDebut() == null ? "-" : mandat.getDateDebut() %></td>
                            <td class="date-cell"><%= mandat.getDateFin() == null ? "Mandat en cours" : mandat.getDateFin() %></td>

                            <td>
                                <% if (mandat.isActif()) { %>
                                    <span class="status-badge active-badge"><i class="bi bi-circle-fill" style="font-size:6px;"></i> Actif</span>
                                <% } else { %>
                                    <span class="status-badge inactive-badge"><i class="bi bi-circle-fill" style="font-size:6px;"></i> Inactif</span>
                                <% } %>
                            </td>

                            <td class="desc-cell"><%= mandat.getDescription() == null ? "-" : mandat.getDescription() %></td>

                            <td>
                                <a href="${pageContext.request.contextPath}/mandats?action=edit&id=<%= mandat.getId() %>"
                                   class="action-btn" style="border-color:#dbeafe;color:#1d4ed8;background:#eff6ff;"
                                   title="Modifier">
                                    <i class="bi bi-pencil-square"></i>
                                </a>

                                <% if (mandat.isActif()) { %>
                                    <a href="${pageContext.request.contextPath}/mandats?action=disable&id=<%= mandat.getId() %>"
                                       class="action-btn" style="border-color:#fef3c7;color:#b45309;background:#fffbeb;"
                                       title="Clôturer mandat"
                                       onclick="return confirm('Voulez-vous vraiment clôturer ce mandat ?');">
                                        <i class="bi bi-stop-circle"></i>
                                    </a>
                                <% } %>

                                <a href="${pageContext.request.contextPath}/mandats?action=delete&id=<%= mandat.getId() %>"
                                   class="action-btn" style="border-color:#fee2e2;color:#dc2626;background:#fef2f2;"
                                   title="Supprimer"
                                   onclick="return confirm('Supprimer définitivement ce mandat ?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="9">
                            <div class="empty-state">
                                <i class="bi bi-award d-block"></i>
                                <h5 class="text-muted">Aucun mandat enregistré</h5>
                                <a href="${pageContext.request.contextPath}/mandats?action=new"
                                   class="btn btn-primary mt-3" style="border-radius:12px;">
                                    <i class="bi bi-plus-circle me-1"></i> Créer un mandat
                                </a>
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