<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouvelle équipe - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .form-card {
            background: white; border-radius: 20px; padding: 36px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.08);
            max-width: 600px; margin: 40px auto;
        }
        .form-header {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border-radius: 14px; padding: 24px; margin-bottom: 28px;
        }
        .form-label { font-weight: 600; color: #334155; }
        .form-control { border-radius: 10px; border: 1.5px solid #e2e8f0; padding: 10px 14px; }
        .form-control:focus { border-color: #1d6fa5; box-shadow: 0 0 0 3px rgba(29,111,165,0.1); }
        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border: none; border-radius: 12px;
            padding: 12px 28px; font-weight: 600;
        }
        .btn-submit:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body>
<div class="container">
    <div class="form-card">
        <div class="form-header">
            <h4 class="mb-1"><i class="bi bi-diagram-3 me-2"></i>Nouvelle équipe</h4>
            <small>Créer une équipe de recherche</small>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/equipes">
            <input type="hidden" name="action" value="insert">
            <div class="mb-3">
                <label class="form-label">Nom de l'équipe <span class="text-danger">*</span></label>
                <input type="text" name="nom" class="form-control"
                       placeholder="Ex: Intelligence Artificielle" required>
            </div>
            <div class="mb-4">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3"
                          placeholder="Domaine de recherche de l'équipe..."></textarea>
            </div>
            <div class="d-flex gap-3">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-check-circle me-2"></i> Enregistrer
                </button>
                <a href="${pageContext.request.contextPath}/equipes"
                   class="btn btn-outline-secondary" style="border-radius:12px;padding:12px 28px;">
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>
</body>
</html>