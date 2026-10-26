<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    com.testweba.model.Mandat mandat =
        (com.testweba.model.Mandat) request.getAttribute("mandat");

    if (mandat == null) {
        response.sendRedirect(request.getContextPath() + "/mandats");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Membre> membres =
        (java.util.List<com.testweba.model.Membre>) request.getAttribute("membres");

    String dateDebut = mandat.getDateDebut() == null ? "" : mandat.getDateDebut().toString();
    String dateFin = mandat.getDateFin() == null ? "" : mandat.getDateFin().toString();
    String description = mandat.getDescription() == null ? "" : mandat.getDescription();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier mandat - LIAS</title>

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
            overflow-y: auto;
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

        .form-card {
            background: white;
            border-radius: 22px;
            padding: 30px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
            max-width: 850px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 6px;
        }

        .form-control,
        .form-select {
            border-radius: 12px;
            border: 1.5px solid #e2e8f0;
            padding: 11px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: 0.2s;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 4px rgba(29,111,165,0.1);
        }

        .form-text {
            color: #94a3b8;
            font-weight: 500;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            margin-left: 10px;
            transition: 0.2s;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #334155;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main {
                margin-left: 0;
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="topbar">
        <h5 class="mb-0">Modifier mandat</h5>
        <small class="text-muted">Mettre à jour une responsabilité de gouvernance</small>
    </div>

    <div class="form-card">
        <form method="post" action="${pageContext.request.contextPath}/mandats">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= mandat.getId() %>">

            <div class="mb-3">
                <label class="form-label">Membre concerné</label>
                <select name="membreId" class="form-select" required>
                    <option value="">-- Choisir un membre --</option>
                    <% if (membres != null) { %>
                        <% for (com.testweba.model.Membre m : membres) { %>
                            <option value="<%= m.getId() %>"
                                <%= mandat.getMembreId() != null && mandat.getMembreId() == m.getId() ? "selected" : "" %>>
                                <%= m.getNomComplet() %> - <%= m.getEmail() %> (<%= m.getRole() %>)
                            </option>
                        <% } %>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Directeur associé</label>
                <select name="directeurId" class="form-select" required>
                    <option value="">-- Choisir le directeur --</option>
                    <% if (membres != null) { %>
                        <% for (com.testweba.model.Membre m : membres) { %>
                            <option value="<%= m.getId() %>"
                                <%= mandat.getDirecteurId() == m.getId() ? "selected" : "" %>>
                                <%= m.getNomComplet() %> - <%= m.getEmail() %>
                            </option>
                        <% } %>
                    <% } %>
                </select>
                <small class="text-muted">
                    Pour un mandat de directeur, choisissez le même membre.
                </small>
            </div>

            <div class="mb-3">
                <label class="form-label">Vice-directeur</label>
                <select name="viceDirecteurId" class="form-select">
                    <option value="">Aucun</option>
                    <% if (membres != null) { %>
                        <% for (com.testweba.model.Membre m : membres) { %>
                            <option value="<%= m.getId() %>"
                                <%= mandat.getViceDirecteurId() != null && mandat.getViceDirecteurId() == m.getId() ? "selected" : "" %>>
                                <%= m.getNomComplet() %> - <%= m.getEmail() %>
                            </option>
                        <% } %>
                    <% } %>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Type de mandat</label>
                <select name="typeMandat" class="form-select" required>
                    <option value="directeur" <%= "directeur".equals(mandat.getTypeMandat()) ? "selected" : "" %>>
                        Directeur
                    </option>

                    <option value="vice_directeur" <%= "vice_directeur".equals(mandat.getTypeMandat()) ? "selected" : "" %>>
                        Vice-directeur
                    </option>

                    <option value="chef_equipe" <%= "chef_equipe".equals(mandat.getTypeMandat()) ? "selected" : "" %>>
                        Chef d'équipe
                    </option>
                </select>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Date début</label>
                    <input type="date" name="dateDebut" class="form-control"
                           value="<%= dateDebut %>" required>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Date fin</label>
                    <input type="date" name="dateFin" class="form-control"
                           value="<%= dateFin %>">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">État</label>
                <select name="actif" class="form-select">
                    <option value="true" <%= mandat.isActif() ? "selected" : "" %>>Actif</option>
                    <option value="false" <%= !mandat.isActif() ? "selected" : "" %>>Inactif</option>
                </select>
            </div>

            <div class="mb-4">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="4"><%= description %></textarea>
            </div>

            <button type="submit" class="btn btn-primary">
                <i class="bi bi-check-circle"></i> Enregistrer
            </button>

            <a href="${pageContext.request.contextPath}/mandats" class="btn btn-secondary">
                Annuler
            </a>

        </form>
    </div>

</div>

</body>
</html>
