<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    com.testweba.model.Equipe equipe =
        (com.testweba.model.Equipe) request.getAttribute("equipe");
    if (equipe == null) {
        response.sendRedirect(request.getContextPath() + "/equipes");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Map<String, String>> membresEquipe =
        (List<Map<String, String>>) request.getAttribute("membresEquipe");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title><%= equipe.getNom() %> - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .main { margin-left: 260px; padding: 28px; }
        .hero-card {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border-radius: 20px; padding: 32px; margin-bottom: 28px;
        }
        .content-card { background: white; border-radius: 18px; padding: 24px; box-shadow: 0 8px 24px rgba(15,23,42,0.06); }
        .member-item {
            display: flex; align-items: center; gap: 14px;
            padding: 14px; border-radius: 12px; transition: 0.2s;
            border: 1px solid #f1f5f9; margin-bottom: 10px;
        }
        .member-item:hover { background: #f8fafc; }
        .member-avatar {
            width: 42px; height: 42px; border-radius: 12px;
            background: #dbeafe; color: #1d4ed8;
            display: flex; align-items: center; justify-content: center; font-size: 18px;
        }
        .role-badge { background: #e0f2fe; color: #075985; border-radius: 999px; padding: 4px 10px; font-size: 12px; font-weight: 600; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">
    <a href="${pageContext.request.contextPath}/equipes" class="btn btn-outline-secondary mb-3" style="border-radius:12px;">
        <i class="bi bi-arrow-left me-1"></i> Retour aux équipes
    </a>

    <div class="hero-card">
        <h2 class="mb-2"><i class="bi bi-diagram-3 me-2"></i><%= equipe.getNom() %></h2>
        <p class="mb-0" style="opacity:0.85;">
            <%= equipe.getDescription() != null ? equipe.getDescription() : "Aucune description disponible." %>
        </p>
    </div>

    <div class="content-card">
        <h5 class="mb-3"><i class="bi bi-people-fill me-2"></i>Membres de l'équipe (<%= membresEquipe != null ? membresEquipe.size() : 0 %>)</h5>

        <% if (membresEquipe != null && !membresEquipe.isEmpty()) {
            for (Map<String, String> m : membresEquipe) { %>
            <div class="member-item">
                <div class="member-avatar"><i class="bi bi-person-fill"></i></div>
                <div class="flex-grow-1">
                    <strong><%= m.get("nom") %></strong><br>
                    <small class="text-muted"><%= m.get("email") %></small>
                </div>
                <span class="role-badge"><%= m.get("role") %></span>
            </div>
        <%  }
        } else { %>
            <p class="text-muted text-center py-4">Aucun membre dans cette équipe.</p>
        <% } %>
    </div>
</div>

</body>
</html>