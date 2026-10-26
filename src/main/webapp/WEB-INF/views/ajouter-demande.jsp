<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Demande d'adhésion - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .form-card {
            background: white;
            border-radius: 24px;
            padding: 40px;
            width: 100%;
            max-width: 650px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
        }

        .logo {
            font-size: 28px;
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 6px;
        }

        .form-label {
            font-weight: 600;
            color: #334155;
        }

        .form-control,
        .form-select {
            border-radius: 10px;
            padding: 10px 14px;
            border: 1.5px solid #e2e8f0;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 3px rgba(29,111,165,0.1);
        }

        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
        }

        .btn-submit:hover {
            opacity: 0.9;
            color: white;
        }

        .alert-success-box {
            background: #dcfce7;
            color: #166534;
            border-radius: 12px;
            padding: 14px 18px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .hint-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 14px;
            font-size: 13px;
            color: #475569;
        }
    </style>
</head>
<body>

<div class="form-card">

    <div class="logo">
        <i class="bi bi-diagram-3-fill text-primary"></i> LIAS
    </div>

    <p class="text-muted mb-4" style="font-size:14px;">
        Laboratoire d'Informatique et d'Intelligence Artificielle
    </p>

    <h4 class="mb-1 fw-bold">Demande d'adhésion</h4>

    <p class="text-muted mb-4" style="font-size:14px;">
        Remplissez ce formulaire pour soumettre votre candidature.
    </p>

    <%
        String success = request.getParameter("success");
        if ("ok".equals(success)) {
    %>
        <div class="alert-success-box">
            <i class="bi bi-check-circle-fill me-2"></i>
            Votre demande a été envoyée avec succès !
        </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/demandes-adhesion" method="post">
        <input type="hidden" name="action" value="insert">

        <div class="row g-3">

            <div class="col-md-6">
                <label class="form-label">Nom <span class="text-danger">*</span></label>
                <input type="text" name="nom" class="form-control"
                       placeholder="Ex: Alaoui" required>
            </div>

            <div class="col-md-6">
                <label class="form-label">Prénom <span class="text-danger">*</span></label>
                <input type="text" name="prenom" class="form-control"
                       placeholder="Ex: Mohamed" required>
            </div>

            <div class="col-12">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" name="email" class="form-control"
                       placeholder="Ex: m.alaoui@gmail.com" required>
            </div>

            <div class="col-12">
                <label class="form-label">Type de candidature <span class="text-danger">*</span></label>
                <select name="statutMembre" id="statutMembre" class="form-select" required onchange="syncRoleMembre()">
                    <option value="doctorant">Doctorant</option>
                    <option value="associe">Membre associé</option>
                    <option value="permanent">Membre permanent</option>
                </select>
            </div>

            <input type="hidden" name="roleMembre" id="roleMembre" value="doctorant">

            <div class="col-12">
                <div class="hint-box" id="typeHint">
                    Doctorant : accès limité à l'ajout et à la consultation des publications.
                </div>
            </div>

            <div class="col-12">
                <label class="form-label">Lien du CV</label>
                <input type="text" name="cvPath" class="form-control"
                       placeholder="Ex: lien Google Drive ou nom du fichier CV">
            </div>

            <div class="col-12">
                <label class="form-label">Motivation <span class="text-danger">*</span></label>
                <textarea name="motivation" class="form-control" rows="5"
                          placeholder="Expliquez pourquoi vous souhaitez rejoindre le laboratoire LIAS..."
                          required></textarea>
            </div>

            <div class="col-12">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-send-fill me-2"></i> Envoyer ma demande
                </button>
            </div>

        </div>
    </form>

    <div class="text-center mt-3">
        <a href="${pageContext.request.contextPath}/"
           class="text-muted" style="font-size:13px;">
            <i class="bi bi-arrow-left"></i> Retour à l'accueil
        </a>
    </div>

</div>

<script>
    function syncRoleMembre() {
        const statut = document.getElementById("statutMembre").value;
        const role = document.getElementById("roleMembre");
        const hint = document.getElementById("typeHint");

        if (statut === "doctorant") {
            role.value = "doctorant";
            hint.textContent = "Doctorant : accès limité à l'ajout et à la consultation des publications.";
        } else if (statut === "associe") {
            role.value = "membre";
            hint.textContent = "Membre associé : accès limité à la consultation, aux événements et aux publications selon les droits.";
        } else {
            role.value = "membre";
            hint.textContent = "Membre permanent : appartient officiellement au laboratoire LIAS, avec accès selon le rôle attribué.";
        }
    }

    syncRoleMembre();
</script>

</body>
</html>