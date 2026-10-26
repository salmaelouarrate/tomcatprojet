<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Membre> membres =
        (java.util.List<com.testweba.model.Membre>) request.getAttribute("membres");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter événement - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .form-card {
            background: white; border-radius: 20px; padding: 36px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.08);
            max-width: 800px; margin: 40px auto;
        }
        .form-header {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border-radius: 14px; padding: 24px;
            margin-bottom: 28px;
        }
        .form-label { font-weight: 600; color: #334155; }
        .form-control, .form-select {
            border-radius: 10px; border: 1.5px solid #e2e8f0;
            padding: 10px 14px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 3px rgba(29,111,165,0.1);
        }
        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border: none; border-radius: 12px;
            padding: 12px 28px; font-weight: 600; font-size: 15px;
        }
        .btn-submit:hover { opacity: 0.9; color: white; }
        .organisateurs-box {
            background: #f8fafc; border: 1.5px solid #e2e8f0;
            border-radius: 14px; padding: 18px;
            max-height: 220px; overflow-y: auto;
        }
        .organisateur-item {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 10px; border-radius: 8px;
            transition: 0.2s; cursor: pointer;
        }
        .organisateur-item:hover { background: #eff6ff; }
        .organisateur-item input { cursor: pointer; }
        .organisateur-item label { cursor: pointer; margin: 0; flex: 1; font-size: 14px; }
        .section-label {
            display: flex; align-items: center; gap: 8px;
            font-weight: 700; color: #0b2f57; margin-bottom: 10px;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1">
                <i class="bi bi-calendar-plus me-2"></i>Ajouter un événement
            </h4>
            <small>Créer une nouvelle activité scientifique</small>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/evenements">

            <div class="row g-3">

                <div class="col-12">
                    <label class="form-label">Titre <span class="text-danger">*</span></label>
                    <input type="text" name="titre" class="form-control"
                           placeholder="Ex: Séminaire sur l'intelligence artificielle" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type <span class="text-danger">*</span></label>
                    <select name="type" class="form-select" required>
                        <option value="conference">Conférence</option>
                        <option value="seminaire">Séminaire</option>
                        <option value="workshop">Workshop</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Édition <span class="text-danger">*</span></label>
                    <input type="number" name="edition" class="form-control"
                           min="1" value="1" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date début <span class="text-danger">*</span></label>
                    <input type="date" name="dateDebut" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date fin</label>
                    <input type="date" name="dateFin" class="form-control">
                </div>

                <div class="col-12">
                    <label class="form-label">Lieu</label>
                    <input type="text" name="lieu" class="form-control"
                           placeholder="Ex: Faculté des Sciences Ben M'Sik">
                </div>

                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4"
                              placeholder="Décrivez l'événement..."></textarea>
                </div>

                <div class="col-12">
                    <div class="section-label">
                        <i class="bi bi-people-fill"></i> Organisateurs
                    </div>
                    <div class="organisateurs-box">
                        <% if (membres != null && !membres.isEmpty()) { %>
                            <% for (com.testweba.model.Membre m : membres) { %>
                                <div class="organisateur-item">
                                    <input type="checkbox" name="organisateurs"
                                           value="<%= m.getId() %>"
                                           id="org<%= m.getId() %>"
                                           class="form-check-input">
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
                       class="btn btn-outline-secondary"
                       style="border-radius:12px;padding:12px 28px;">
                        <i class="bi bi-arrow-left me-2"></i> Annuler
                    </a>
                </div>

            </div>
        </form>

    </div>
</div>

</body>
</html>