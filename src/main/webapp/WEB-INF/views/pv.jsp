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
    boolean isDirecteur = "directeur".equals(role) || "admin".equals(role);

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.PV> pvList =
        (java.util.List<com.testweba.model.PV>) request.getAttribute("pvList");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Procès-verbaux - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .main { margin-left: 260px; padding: 28px; }
        .topbar {
            background: white; border-radius: 16px; padding: 18px 24px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06); margin-bottom: 28px;
        }
        .badge-role { background: #e0f2fe; color: #075985; padding: 8px 12px; border-radius: 999px; font-weight: 600; }
        .pv-card {
            background: white; border-radius: 18px; padding: 22px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            height: 100%; transition: 0.2s; border-top: 4px solid #334155;
        }
        .pv-card:hover { transform: translateY(-4px); box-shadow: 0 16px 36px rgba(15,23,42,0.12); }
        .pv-icon {
            width: 48px; height: 48px; border-radius: 14px;
            background: #f1f5f9; color: #334155;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; margin-bottom: 14px;
        }
        .pv-title { font-weight: 800; color: #0b2f57; font-size: 16px; margin-bottom: 6px; }
        .pv-date {
            display: flex; align-items: center; gap: 6px;
            font-size: 13px; color: #64748b; margin-bottom: 10px;
        }
        .pv-ordre {
            font-size: 13px; color: #475569; line-height: 1.5;
            background: #f8fafc; padding: 10px 12px; border-radius: 10px;
            margin-bottom: 16px; min-height: 50px;
        }
        .actions-row { display: flex; gap: 8px; }
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 18px; box-shadow: 0 8px 24px rgba(15,23,42,0.06); }
        .empty-state i { font-size: 64px; color: #cbd5e1; margin-bottom: 16px; }
        .no-pdf-badge { font-size: 12px; color: #94a3b8; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <div>
            <h5 class="mb-0">Procès-verbaux</h5>
            <small class="text-muted">Réunions, ordre du jour et archives PDF</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <% if (isDirecteur) { %>
            <a href="${pageContext.request.contextPath}/pv?action=new"
               class="btn btn-primary" style="border-radius:12px;">
                <i class="bi bi-plus-circle me-1"></i> Nouveau PV
            </a>
            <% } %>
            <span class="badge-role"><%= membreConnecte.getRole() %></span>
        </div>
    </div>

    <% if (pvList != null && !pvList.isEmpty()) { %>
    <div class="row g-4">
        <% for (com.testweba.model.PV pv : pvList) { %>
        <div class="col-md-4">
            <div class="pv-card">
                <div class="pv-icon"><i class="bi bi-file-earmark-text"></i></div>
                <div class="pv-title"><%= pv.getTitre() %></div>
                <div class="pv-date">
                    <i class="bi bi-calendar3"></i>
                    Réunion du <%= pv.getDateReunion() %>
                </div>
                <div class="pv-ordre">
                    <strong>Ordre du jour :</strong><br>
                    <%= pv.getOrdreDuJour() != null ? pv.getOrdreDuJour() : "Non précisé" %>
                </div>
                <div class="actions-row">
                    <% if (pv.getPvPath() != null && !pv.getPvPath().isEmpty()) { %>
                    <a href="<%= pv.getPvPath() %>" target="_blank"
                       class="btn btn-sm btn-dark" style="border-radius:8px;">
                        <i class="bi bi-download"></i> Télécharger PV
                    </a>
                    <% } else { %>
                    <span class="no-pdf-badge"><i class="bi bi-file-earmark-x"></i> Aucun PDF</span>
                    <% } %>
                    <% if (isDirecteur) { %>
                    <a href="${pageContext.request.contextPath}/pv?action=edit&id=<%= pv.getId() %>"
                       class="btn btn-sm btn-outline-primary" style="border-radius:8px;">
                        <i class="bi bi-pencil-square"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/pv?action=supprimer&id=<%= pv.getId() %>"
                       class="btn btn-sm btn-outline-danger" style="border-radius:8px;"
                       onclick="return confirm('Supprimer ce PV ?');">
                        <i class="bi bi-trash"></i>
                    </a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } else { %>
    <div class="empty-state">
        <i class="bi bi-file-earmark-text d-block"></i>
        <h5 class="text-muted">Aucun procès-verbal disponible</h5>
        <% if (isDirecteur) { %>
        <a href="${pageContext.request.contextPath}/pv?action=new"
           class="btn btn-primary mt-3" style="border-radius:12px;">
            <i class="bi bi-plus-circle me-1"></i> Créer un PV
        </a>
        <% } %>
    </div>
    <% } %>
</div>

</body>
</html>