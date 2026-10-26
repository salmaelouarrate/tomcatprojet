<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Equipe> equipes =
        (java.util.List<com.testweba.model.Equipe>) request.getAttribute("equipes");

    if (equipes == null) {
        equipes = new com.testweba.dao.EquipeDAO().findAll();
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter publication - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .form-card {
            background: white; border-radius: 20px; padding: 36px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.08);
            max-width: 760px; margin: 40px auto;
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
    </style>
</head>

<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1">
                <i class="bi bi-journal-plus me-2"></i>Ajouter une publication
            </h4>
            <small>Enregistrer un nouveau travail scientifique</small>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/publications">

            <div class="row g-3">

                <div class="col-12">
                    <label class="form-label">Titre <span class="text-danger">*</span></label>
                    <input type="text" name="titre" class="form-control"
                           placeholder="Titre de la publication" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type <span class="text-danger">*</span></label>
                    <select name="type" class="form-select" required>
                        <option value="article">Article</option>
                        <option value="these">Thèse</option>
                        <option value="rapport">Rapport</option>
                        <option value="communication">Communication</option>
                        <option value="ouvrage">Ouvrage</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Année <span class="text-danger">*</span></label>
                    <input type="number" name="annee" class="form-control"
                           min="2000" max="2100" value="2026" required>
                </div>

                <div class="col-12">
                    <label class="form-label">Journal / Conférence</label>
                    <input type="text" name="journal" class="form-control"
                           placeholder="Ex: IEEE Access, International Conference on...">
                </div>

                <div class="col-12">
                    <label class="form-label">Résumé</label>
                    <textarea name="resume" class="form-control" rows="4"
                              placeholder="Résumé de la publication..."></textarea>
                </div>

                <div class="col-md-8">
                    <label class="form-label">Lien</label>
                    <input type="url" name="lien" class="form-control"
                           placeholder="https://example.com/publication">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Équipe</label>
                    <select name="equipeId" class="form-select">
                        <option value="">— Aucune —</option>
                        <% if (equipes != null) {
                            for (com.testweba.model.Equipe e : equipes) { %>
                                <option value="<%= e.getId() %>"><%= e.getNom() %></option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div class="col-12 d-flex gap-3 mt-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-check-circle me-2"></i> Enregistrer
                    </button>
                    <a href="${pageContext.request.contextPath}/publications"
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