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
    java.util.List<com.testweba.model.Equipe> equipes =
        (java.util.List<com.testweba.model.Equipe>) request.getAttribute("equipes");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Équipes - LIAS</title>
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
        .equipe-card {
            background: white; border-radius: 18px; padding: 24px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            height: 100%; transition: 0.2s; border-top: 4px solid #3b82f6;
        }
        .equipe-card:hover { transform: translateY(-4px); box-shadow: 0 16px 36px rgba(15,23,42,0.12); }
        .equipe-icon {
            width: 52px; height: 52px; border-radius: 14px;
            background: #dbeafe; color: #1d4ed8;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; margin-bottom: 14px;
        }
        .equipe-name { font-weight: 800; color: #0b2f57; font-size: 17px; margin-bottom: 6px; }
        .equipe-desc { color: #64748b; font-size: 13.5px; line-height: 1.5; min-height: 40px; margin-bottom: 14px; }
        .equipe-stats {
            display: flex; align-items: center; gap: 6px;
            font-size: 13px; color: #1d6fa5; font-weight: 700;
            margin-bottom: 16px;
        }
        .actions-row { display: flex; gap: 8px; }
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 18px; box-shadow: 0 8px 24px rgba(15,23,42,0.06); }
        .empty-state i { font-size: 64px; color: #cbd5e1; margin-bottom: 16px; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <div>
            <h5 class="mb-0">Équipes de recherche</h5>
            <small class="text-muted">Organisation des équipes du laboratoire LIAS</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <% if (isDirecteur) { %>
            <a href="${pageContext.request.contextPath}/equipes?action=assigner"
               class="btn btn-outline-primary" style="border-radius:12px;">
                <i class="bi bi-person-gear me-1"></i> Assigner membres
            </a>
            <a href="${pageContext.request.contextPath}/equipes?action=new"
               class="btn btn-primary" style="border-radius:12px;">
                <i class="bi bi-plus-circle me-1"></i> Nouvelle équipe
            </a>
            <% } %>
            <span class="badge-role"><%= membreConnecte.getRole() %></span>
        </div>
    </div>

    <% if (equipes != null && !equipes.isEmpty()) { %>
    <div class="row g-4">
        <% for (com.testweba.model.Equipe e : equipes) { %>
        <div class="col-md-4">
            <div class="equipe-card">
                <div class="equipe-icon"><i class="bi bi-diagram-3"></i></div>
                <div class="equipe-name"><%= e.getNom() %></div>
                <div class="equipe-desc">
                    <%= e.getDescription() != null ? e.getDescription() : "Aucune description" %>
                </div>
                <div class="equipe-stats">
                    <i class="bi bi-people-fill"></i> <%= e.getNombreMembres() %> membre<%= e.getNombreMembres() > 1 ? "s" : "" %>
                </div>
                <div class="actions-row">
                    <a href="${pageContext.request.contextPath}/equipes?action=voir&id=<%= e.getId() %>"
                       class="btn btn-sm btn-outline-primary" style="border-radius:8px;">
                        <i class="bi bi-eye"></i> Voir
                    </a>
                    <% if (isDirecteur) { %>
                    <a href="${pageContext.request.contextPath}/equipes?action=edit&id=<%= e.getId() %>"
                       class="btn btn-sm btn-outline-secondary" style="border-radius:8px;">
                        <i class="bi bi-pencil-square"></i>
                    </a>
                    <a href="${pageContext.request.contextPath}/equipes?action=supprimer&id=<%= e.getId() %>"
                       class="btn btn-sm btn-outline-danger" style="border-radius:8px;"
                       onclick="return confirm('Supprimer cette équipe ? Les membres seront détachés.');">
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
        <i class="bi bi-diagram-3 d-block"></i>
        <h5 class="text-muted">Aucune équipe créée</h5>
        <% if (isDirecteur) { %>
        <a href="${pageContext.request.contextPath}/equipes?action=new"
           class="btn btn-primary mt-3" style="border-radius:12px;">
            <i class="bi bi-plus-circle me-1"></i> Créer une équipe
        </a>
        <% } %>
    </div>
    <% } %>
</div>

</body>
</html>