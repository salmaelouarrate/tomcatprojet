<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    @SuppressWarnings("unchecked")
    List<com.testweba.model.Equipe> equipes =
        (List<com.testweba.model.Equipe>) request.getAttribute("equipes");

    @SuppressWarnings("unchecked")
    List<com.testweba.model.Membre> membres =
        (List<com.testweba.model.Membre>) request.getAttribute("membres");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Assigner membres - LIAS</title>
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
        .content-card { background: white; border-radius: 18px; padding: 24px; box-shadow: 0 8px 24px rgba(15,23,42,0.06); }
        .table thead th { background: #f1f5f9; color: #334155; font-weight: 700; }
        .form-select { border-radius: 8px; border: 1.5px solid #e2e8f0; padding: 6px 10px; font-size: 13px; }
        .role-badge { background: #e0f2fe; color: #075985; border-radius: 999px; padding: 4px 10px; font-size: 12px; font-weight: 600; }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">
    <div class="topbar">
        <div>
            <h5 class="mb-0">Assigner les membres aux équipes</h5>
            <small class="text-muted">Organiser les membres du laboratoire par équipe</small>
        </div>
        <a href="${pageContext.request.contextPath}/equipes" class="btn btn-outline-secondary" style="border-radius:12px;">
            <i class="bi bi-arrow-left me-1"></i> Retour
        </a>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Membre</th>
                        <th>Email</th>
                        <th>Rôle</th>
                        <th>Équipe actuelle</th>
                        <th style="width:260px;">Assigner</th>
                    </tr>
                </thead>
                <tbody>
                <% if (membres != null) {
                    for (com.testweba.model.Membre m : membres) { %>
                    <tr>
                        <td><strong><%= m.getPrenom() %> <%= m.getNom() %></strong></td>
                        <td><%= m.getEmail() %></td>
                        <td><span class="role-badge"><%= m.getRole() %></span></td>
                        <td>
                            <%
                                String equipeActuelle = "Aucune";
                                if (equipes != null) {
                                    for (com.testweba.model.Equipe eq : equipes) {
                                        if (m.getEquipeId() != null && eq.getId() == m.getEquipeId()) {
                                            equipeActuelle = eq.getNom();
                                        }
                                    }
                                }
                            %>
                            <%= equipeActuelle %>
                        </td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/equipes"
                                  class="d-flex gap-2">
                                <input type="hidden" name="action" value="assignerMembre">
                                <input type="hidden" name="membreId" value="<%= m.getId() %>">
                                <select name="equipeId" class="form-select form-select-sm">
                                    <option value="">— Aucune équipe —</option>
                                    <% if (equipes != null) {
                                        for (com.testweba.model.Equipe eq : equipes) {
                                            boolean selected = m.getEquipeId() != null && eq.getId() == m.getEquipeId();
                                    %>
                                        <option value="<%= eq.getId() %>" <%= selected ? "selected" : "" %>>
                                            <%= eq.getNom() %>
                                        </option>
                                    <%  }
                                    } %>
                                </select>
                                <button type="submit" class="btn btn-sm btn-primary" style="border-radius:8px;">
                                    <i class="bi bi-check2"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                <%  }
                } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>