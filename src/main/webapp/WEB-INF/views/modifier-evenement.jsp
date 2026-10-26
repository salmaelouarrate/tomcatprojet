<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    com.testweba.model.Evenement evenement =
        (com.testweba.model.Evenement) request.getAttribute("evenement");

    if (evenement == null) {
        response.sendRedirect(request.getContextPath() + "/evenements");
        return;
    }

    @SuppressWarnings("unchecked")
    List<com.testweba.model.Membre> membres =
        (List<com.testweba.model.Membre>) request.getAttribute("membres");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> organisateurs =
        (List<Map<String, String>>) request.getAttribute("organisateurs");

    Set<String> organisateurIds = new HashSet<>();
    if (organisateurs != null) {
        for (Map<String, String> org : organisateurs) {
            organisateurIds.add(org.get("id"));
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier événement - LIAS</title>
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

        .form-card {
            background: white;
            border-radius: 24px;
            padding: 38px;
            box-shadow: 0 10px 40px rgba(15,23,42,0.08);
            border: 1px solid #edf2f7;
            max-width: 800px;
            margin: 50px auto;
        }

        .form-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%);
            color: white;
            border-radius: 16px;
            padding: 26px 28px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .form-header h4 {
            font-weight: 800;
            position: relative;
            z-index: 2;
            letter-spacing: -0.3px;
        }

        .form-header small {
            color: rgba(255,255,255,0.8);
            position: relative;
            z-index: 2;
            font-weight: 500;
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

        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
            color: white;
        }

        .btn-outline-secondary {
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            border: 1.5px solid #e2e8f0;
            color: #475569;
            transition: 0.2s;
        }

        .btn-outline-secondary:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
            color: #334155;
        }

        .organisateurs-box {
            background: #f8faff;
            border: 1.5px solid #e2e8f0;
            border-radius: 16px;
            padding: 18px;
            max-height: 220px;
            overflow-y: auto;
        }

        .organisateur-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 9px 10px;
            border-radius: 10px;
            transition: 0.2s;
            cursor: pointer;
        }

        .organisateur-item:hover {
            background: #eff6ff;
        }

        .organisateur-item input {
            cursor: pointer;
        }

        .organisateur-item label {
            cursor: pointer;
            margin: 0;
            flex: 1;
            font-size: 14px;
            font-weight: 500;
            color: #334155;
        }

        .section-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1">
                <i class="bi bi-pencil-square me-2"></i>Modifier événement
            </h4>
            <small>Mettre à jour les informations de l'événement</small>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/evenements">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= evenement.getId() %>">

            <div class="row g-3">

                <div class="col-12">
                    <label class="form-label">Titre <span class="text-danger">*</span></label>
                    <input type="text" name="titre" class="form-control"
                           value="<%= evenement.getTitre() %>" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type <span class="text-danger">*</span></label>
                    <select name="type" class="form-select" required>
                        <option value="conference" <%= "conference".equals(evenement.getType()) ? "selected" : "" %>>Conférence</option>
                        <option value="seminaire" <%= "seminaire".equals(evenement.getType()) ? "selected" : "" %>>Séminaire</option>
                        <option value="workshop" <%= "workshop".equals(evenement.getType()) ? "selected" : "" %>>Workshop</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Édition <span class="text-danger">*</span></label>
                    <input type="number" name="edition" class="form-control"
                           min="1" value="<%= evenement.getEdition() %>" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date début <span class="text-danger">*</span></label>
                    <input type="date" name="dateDebut" class="form-control"
                           value="<%= evenement.getDateDebut() %>" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date fin</label>
                    <input type="date" name="dateFin" class="form-control"
                           value="<%= evenement.getDateFin() != null ? evenement.getDateFin() : "" %>">
                </div>

                <div class="col-12">
                    <label class="form-label">Lieu</label>
                    <input type="text" name="lieu" class="form-control"
                           value="<%= evenement.getLieu() != null ? evenement.getLieu() : "" %>">
                </div>

                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4"><%= evenement.getDescription() != null ? evenement.getDescription() : "" %></textarea>
                </div>

                <div class="col-12">
                    <div class="section-label">
                        <i class="bi bi-people-fill"></i> Organisateurs
                    </div>
                    <div class="organisateurs-box">
                        <% if (membres != null && !membres.isEmpty()) { %>
                            <% for (com.testweba.model.Membre m : membres) {
                                boolean checked = organisateurIds.contains(String.valueOf(m.getId()));
                            %>
                                <div class="organisateur-item">
                                    <input type="checkbox" name="organisateurs"
                                           value="<%= m.getId() %>"
                                           id="org<%= m.getId() %>"
                                           class="form-check-input"
                                           <%= checked ? "checked" : "" %>>
                                    <label for="org<%= m.getId() %>">
                                        <%= m.getPrenom() %> <%= m.getNom() %>
                                        <span class="text-muted">(<%= m.getRole() %>)</span>
                                    </label>
                                </div>
                            <% } %>
                        <% } else { %>
                            <p class="text-muted mb-0">Aucun membre disponible.</p>
                        <% } %>
                    </div>
                </div>

                <div class="col-12 d-flex gap-3 mt-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-check-circle me-2"></i> Enregistrer
                    </button>
                    <a href="${pageContext.request.contextPath}/evenements"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i> Annuler
                    </a>
                </div>

            </div>
        </form>

    </div>
</div>

</body>
</html>
