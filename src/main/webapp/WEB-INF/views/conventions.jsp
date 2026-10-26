<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Convention> conventions =
            (java.util.List<com.testweba.model.Convention>)
                    request.getAttribute("conventions");

    int nbActives = 0, nbExpirees = 0, nbSuspendues = 0;
    if (conventions != null) {
        for (com.testweba.model.Convention c : conventions) {
            if ("active".equals(c.getStatut())) nbActives++;
            else if ("expiree".equals(c.getStatut())) nbExpirees++;
            else nbSuspendues++;
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Conventions - LIAS</title>
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

        .btn-add-convention {
            background: white; color: #0b2f57; border: none;
            border-radius: 12px; padding: 12px 24px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s;
            text-decoration: none; box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-add-convention:hover { transform: translateY(-2px); color: #0b2f57; }

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

        .partner-icon {
            width: 38px; height: 38px; border-radius: 10px;
            background: #f3e8ff; color: #7e22ce;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 16px; margin-right: 10px;
        }
        .country-badge {
            background: #f1f5f9; color: #334155; border-radius: 8px;
            padding: 5px 12px; font-size: 13px; font-weight: 600;
        }
        .objet-cell { max-width: 240px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #64748b; font-size: 13.5px; }
        .date-cell { color: #64748b; font-size: 13px; }

        .status-badge {
            border-radius: 999px; padding: 6px 14px;
            font-size: 12.5px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .status-active { background: #dcfce7; color: #166534; }
        .status-expiree { background: #fee2e2; color: #991b1b; }
        .status-suspendue { background: #fef3c7; color: #92400e; }

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
                <div class="hero-title"><i class="bi bi-building me-2"></i>Gestion des conventions</div>
                <p class="hero-sub">Partenariats et collaborations du laboratoire LIAS</p>
            </div>
            <a href="${pageContext.request.contextPath}/conventions?action=new" class="btn-add-convention">
                <i class="bi bi-plus-circle"></i> Ajouter convention
            </a>
        </div>

        <div class="stats-row">
            <div class="stat-pill">
                <i class="bi bi-collection"></i>
                <span class="num"><%= conventions != null ? conventions.size() : 0 %></span> au total
            </div>
            <div class="stat-pill">
                <i class="bi bi-circle-fill" style="font-size:8px;color:#4ade80;"></i>
                <span class="num"><%= nbActives %></span> active<%= nbActives != 1 ? "s" : "" %>
            </div>
            <div class="stat-pill">
                <i class="bi bi-exclamation-circle"></i>
                <span class="num"><%= nbExpirees %></span> expirée<%= nbExpirees != 1 ? "s" : "" %>
            </div>
            <div class="stat-pill">
                <i class="bi bi-pause-circle"></i>
                <span class="num"><%= nbSuspendues %></span> suspendue<%= nbSuspendues != 1 ? "s" : "" %>
            </div>
        </div>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Partenaire</th>
                    <th>Pays</th>
                    <th>Objet</th>
                    <th>Date début</th>
                    <th>Date fin</th>
                    <th>Statut</th>
                    <th>Actions</th>
                </tr>
                </thead>

                <tbody>
                <%
                    if (conventions != null && !conventions.isEmpty()) {
                        for (com.testweba.model.Convention c : conventions) {
                %>

                <tr>
                    <td style="color:#94a3b8;font-weight:600;"><%= c.getId() %></td>
                    <td>
                        <span class="partner-icon"><i class="bi bi-building"></i></span>
                        <strong style="color:#0b2f57;"><%= c.getPartenaire() %></strong>
                    </td>
                    <td><span class="country-badge"><i class="bi bi-geo-alt me-1"></i><%= c.getPays() %></span></td>
                    <td class="objet-cell"><%= c.getObjet() %></td>
                    <td class="date-cell"><%= c.getDateDebut() %></td>
                    <td class="date-cell"><%= c.getDateFin() %></td>

                    <td>
                        <%
                            if ("active".equals(c.getStatut())) {
                        %>
                        <span class="status-badge status-active"><i class="bi bi-check-circle"></i> Active</span>
                        <%
                            } else if ("expiree".equals(c.getStatut())) {
                        %>
                        <span class="status-badge status-expiree"><i class="bi bi-x-circle"></i> Expirée</span>
                        <%
                            } else {
                        %>
                        <span class="status-badge status-suspendue"><i class="bi bi-pause-circle"></i> Suspendue</span>
                        <%
                            }
                        %>
                    </td>

                    <td>
                        <a href="${pageContext.request.contextPath}/conventions?action=edit&id=<%= c.getId() %>"
                           class="action-btn" style="border-color:#dbeafe;color:#1d4ed8;background:#eff6ff;">
                            <i class="bi bi-pencil-square"></i>
                        </a>

                        <a href="${pageContext.request.contextPath}/conventions?action=delete&id=<%= c.getId() %>"
                           class="action-btn" style="border-color:#fee2e2;color:#dc2626;background:#fef2f2;"
                           onclick="return confirm('Supprimer cette convention ?');">
                            <i class="bi bi-trash"></i>
                        </a>
                    </td>
                </tr>

                <%
                        }
                    } else {
                %>

                <tr>
                    <td colspan="8">
                        <div class="empty-state">
                            <i class="bi bi-building d-block"></i>
                            <h5 class="text-muted">Aucune convention enregistrée</h5>
                            <a href="${pageContext.request.contextPath}/conventions?action=new"
                               class="btn btn-primary mt-3" style="border-radius:12px;">
                                <i class="bi bi-plus-circle me-1"></i> Ajouter une convention
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