<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Evenement> evenements =
        (java.util.List<com.testweba.model.Evenement>) request.getAttribute("evenements");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter document - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .form-card {
            background: white; border-radius: 20px; padding: 36px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.08);
            max-width: 700px; margin: 40px auto;
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
        .info-box {
            background: #eff6ff; border-left: 4px solid #1d6fa5;
            border-radius: 10px; padding: 14px 18px; margin-bottom: 24px;
            font-size: 13px; color: #1e40af;
        }
    </style>
</head>

<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1">
                <i class="bi bi-file-earmark-plus me-2"></i>Ajouter un document
            </h4>
            <small>Archiver un document du laboratoire</small>
        </div>

        <div class="info-box">
            <i class="bi bi-info-circle me-2"></i>
            Vous pouvez lier ce document à un événement spécifique pour faciliter
            l'organisation et la recherche par édition et par date.
        </div>

        <form method="post" action="${pageContext.request.contextPath}/documents">

            <div class="row g-3">

                <div class="col-12">
                    <label class="form-label">Nom du document <span class="text-danger">*</span></label>
                    <input type="text" name="nom" class="form-control"
                           placeholder="Ex: Rapport annuel 2026" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Type <span class="text-danger">*</span></label>
                    <select name="type" class="form-select" required>
                        <option value="financement">Financement</option>
                        <option value="programme">Programme</option>
                        <option value="attestation">Attestation</option>
                        <option value="rapport">Rapport</option>
                        <option value="administratif">Administratif</option>
                        <option value="autre">Autre</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Événement lié</label>
                    <select name="evenementId" class="form-select">
                        <option value="">— Aucun événement —</option>
                        <% if (evenements != null) {
                            for (com.testweba.model.Evenement e : evenements) { %>
                                <option value="<%= e.getId() %>">
                                    <%= e.getTitre() %> (<%= e.getDateDebut() %>)
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Chemin ou lien du fichier <span class="text-danger">*</span></label>
                    <input type="text" name="chemin" class="form-control"
                           placeholder="Ex: https://example.com/document.pdf ou /uploads/rapport.pdf"
                           required>
                </div>

                <div class="col-12 d-flex gap-3 mt-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-check-circle me-2"></i> Enregistrer
                    </button>
                    <a href="${pageContext.request.contextPath}/documents"
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