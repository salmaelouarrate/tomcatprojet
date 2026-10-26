<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Nouvelle demande matériel - LIAS</title>
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
            font-size: 14px; color: #1e40af;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1">
                <i class="bi bi-box-seam me-2"></i>Nouvelle demande de matériel
            </h4>
            <small>Soumettre une demande d'équipement au laboratoire</small>
        </div>

        <div class="info-box">
            <i class="bi bi-info-circle me-2"></i>
            Votre demande sera examinée par le directeur du laboratoire.
            Vous serez notifié de la décision.
        </div>

        <form action="${pageContext.request.contextPath}/demandes-materiel"
              method="post">
            <input type="hidden" name="action" value="insert">

            <div class="row g-3">

                <div class="col-md-8">
                    <label class="form-label">
                        Nom du matériel <span class="text-danger">*</span>
                    </label>
                    <input type="text" name="materielNom" class="form-control"
                           placeholder="Ex: Ordinateur Dell, Projecteur Epson..."
                           required>
                </div>

                <div class="col-md-4">
                    <label class="form-label">
                        Quantité <span class="text-danger">*</span>
                    </label>
                    <input type="number" name="quantite" class="form-control"
                           min="1" value="1" required>
                </div>

                <div class="col-12">
                    <label class="form-label">
                        Justification <span class="text-danger">*</span>
                    </label>
                    <textarea name="justification" class="form-control" rows="3"
                        placeholder="Pourquoi avez-vous besoin de ce matériel ?"
                        required></textarea>
                </div>

                <div class="col-12">
                    <label class="form-label">Description (optionnel)</label>
                    <textarea name="description" class="form-control" rows="3"
                        placeholder="Spécifications techniques, modèle préféré...">
                    </textarea>
                </div>

                <div class="col-12 d-flex gap-3 mt-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-send me-2"></i> Envoyer la demande
                    </button>
                    <a href="${pageContext.request.contextPath}/demandes-materiel"
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