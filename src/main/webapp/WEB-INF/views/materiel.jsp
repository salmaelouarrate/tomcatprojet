<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Materiel> materiels =
        (java.util.List<com.testweba.model.Materiel>) request.getAttribute("materiels");

    int totalQuantite = 0;
    if (materiels != null) {
        for (com.testweba.model.Materiel m : materiels) {
            totalQuantite += m.getQuantite();
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Matériel - LIAS</title>
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

        .btn-add-materiel {
            background: white; color: #0b2f57; border: none;
            border-radius: 12px; padding: 12px 24px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s;
            text-decoration: none; box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-add-materiel:hover { transform: translateY(-2px); color: #0b2f57; }

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

        .materiel-icon {
            width: 38px; height: 38px; border-radius: 10px;
            background: #e0f2fe; color: #0369a1;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 16px; margin-right: 10px;
        }
        .qty-badge {
            background: #dcfce7; color: #166534;
            border-radius: 999px; padding: 6px 14px;
            font-size: 13px; font-weight: 700;
        }
        .description-cell {
            max-width: 320px; white-space: nowrap;
            overflow: hidden; text-overflow: ellipsis; color: #64748b; font-size: 13.5px;
        }
        .date-cell { color: #64748b; font-size: 13px; }

        .action-btn {
            width: 34px; height: 34px; border-radius: 9px;
            display: inline-flex; align-items: center; justify-content: center;
            margin-right: 6px; transition: 0.2s; border: 1.5px solid;
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
                <div class="hero-title"><i class="bi bi-pc-display me-2"></i>Gestion du matériel</div>
                <p class="hero-sub">Équipements et ressources du laboratoire LIAS</p>
            </div>
            <a href="${pageContext.request.contextPath}/materiel?action=new" class="btn-add-materiel">
                <i class="bi bi-plus-circle"></i> Ajouter matériel
            </a>
        </div>

        <div class="stats-row">
            <div class="stat-pill">
                <i class="bi bi-box-seam"></i>
                <span class="num"><%= materiels != null ? materiels.size() : 0 %></span> références
            </div>
            <div class="stat-pill">
                <i class="bi bi-collection"></i>
                <span class="num"><%= totalQuantite %></span> unités au total
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Nom</th>
                        <th>Description</th>
                        <th>Quantité</th>
                        <th>Date arrivée</th>
                        <th>Date création</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                <% if (materiels != null && !materiels.isEmpty()) { %>
                    <% for (com.testweba.model.Materiel m : materiels) { %>
                        <tr>
                            <td style="color:#94a3b8;font-weight:600;"><%= m.getId() %></td>

                            <td>
                                <span class="materiel-icon"><i class="bi bi-pc-display"></i></span>
                                <strong style="color:#0b2f57;"><%= m.getNom() %></strong>
                            </td>

                            <td class="description-cell">
                                <%= m.getDescription() != null ? m.getDescription() : "-" %>
                            </td>

                            <td>
                                <span class="qty-badge"><i class="bi bi-boxes me-1"></i><%= m.getQuantite() %></span>
                            </td>

                            <td class="date-cell">
                                <%= m.getDateArrivee() != null ? m.getDateArrivee() : "-" %>
                            </td>

                            <td class="date-cell">
                                <%= m.getCreatedAt() != null ? m.getCreatedAt() : "-" %>
                            </td>

                            <td>
                                <a href="${pageContext.request.contextPath}/materiel?action=edit&id=<%= m.getId() %>"
                                   class="action-btn" style="border-color:#dbeafe;color:#1d4ed8;background:#eff6ff;">
                                    <i class="bi bi-pencil-square"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/materiel?action=delete&id=<%= m.getId() %>"
                                   class="action-btn" style="border-color:#fee2e2;color:#dc2626;background:#fef2f2;"
                                   onclick="return confirm('Voulez-vous vraiment supprimer ce matériel ?');">
                                    <i class="bi bi-trash"></i>
                                </a>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <i class="bi bi-pc-display d-block"></i>
                                <h5 class="text-muted">Aucun matériel enregistré</h5>
                                <a href="${pageContext.request.contextPath}/materiel?action=new"
                                   class="btn btn-primary mt-3" style="border-radius:12px;">
                                    <i class="bi bi-plus-circle me-1"></i> Ajouter un matériel
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