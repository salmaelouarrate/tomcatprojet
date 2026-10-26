<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/membres");
        return;
    }

    String laboratoire = membre.getLaboratoire() == null ? "" : membre.getLaboratoire();
    String laboratoireOrigine = membre.getLaboratoireOrigine() == null ? "" : membre.getLaboratoireOrigine();
    String biographie = membre.getBiographie() == null ? "" : membre.getBiographie();
    String centresInteret = membre.getCentresInteret() == null ? "" : membre.getCentresInteret();
    String photo = membre.getPhoto() == null ? "" : membre.getPhoto();
    String dateNaissance = membre.getDateNaissance() == null ? "" : membre.getDateNaissance().toString();
    String dateEmbauche = membre.getDateEmbauche() == null ? "" : membre.getDateEmbauche().toString();
    String equipeId = membre.getEquipeId() == null ? "" : membre.getEquipeId().toString();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier membre - LIAS</title>

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

        .card {
            border: 1px solid #edf2f7;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(15,23,42,0.08);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%) !important;
            border: none;
            padding: 26px 28px;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .card-header h4 {
            font-weight: 800;
            letter-spacing: -0.3px;
            position: relative;
            z-index: 2;
        }

        .card-body {
            padding: 32px;
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
    </style>
</head>

<body class="bg-light">

<div class="container py-5">
    <div class="card shadow mx-auto" style="max-width:900px;">
        <div class="card-header text-white" style="background:#0b2f57;">
            <h4 class="mb-0">Modifier membre</h4>
        </div>

        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/membres">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= membre.getId() %>">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Nom</label>
                        <input type="text" name="nom" class="form-control"
                               value="<%= membre.getNom() %>" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Prénom</label>
                        <input type="text" name="prenom" class="form-control"
                               value="<%= membre.getPrenom() %>" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control"
                           value="<%= membre.getEmail() %>" required>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Statut</label>
                        <select name="statut" class="form-select" required>
                            <option value="permanent" <%= "permanent".equals(membre.getStatut()) ? "selected" : "" %>>Permanent</option>
                            <option value="doctorant" <%= "doctorant".equals(membre.getStatut()) ? "selected" : "" %>>Doctorant</option>
                            <option value="associe" <%= "associe".equals(membre.getStatut()) ? "selected" : "" %>>Associé</option>
                            <option value="retraite" <%= "retraite".equals(membre.getStatut()) ? "selected" : "" %>>Retraité</option>
                            <option value="ancien" <%= "ancien".equals(membre.getStatut()) ? "selected" : "" %>>Ancien</option>
                        </select>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Rôle</label>
                        <select name="role" class="form-select" required>
                            <option value="membre" <%= "membre".equals(membre.getRole()) ? "selected" : "" %>>Membre</option>
                            <option value="doctorant" <%= "doctorant".equals(membre.getRole()) ? "selected" : "" %>>Doctorant</option>
                            <option value="chef_equipe" <%= "chef_equipe".equals(membre.getRole()) ? "selected" : "" %>>Chef équipe</option>
                            <option value="vice_directeur" <%= "vice_directeur".equals(membre.getRole()) ? "selected" : "" %>>Vice-directeur</option>
                            <option value="directeur" <%= "directeur".equals(membre.getRole()) ? "selected" : "" %>>Directeur</option>
                            <option value="admin" <%= "admin".equals(membre.getRole()) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Établissement</label>
                    <input type="text" name="etablissement" class="form-control"
                           value="<%= membre.getEtablissement() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Laboratoire</label>
                    <input type="text" name="laboratoire" class="form-control"
                           value="<%= laboratoire %>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Laboratoire d'origine</label>
                    <input type="text" name="laboratoireOrigine" class="form-control"
                           value="<%= laboratoireOrigine %>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Photo</label>
                    <input type="text" name="photo" class="form-control"
                           value="<%= photo %>">
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date de naissance</label>
                        <input type="date" name="dateNaissance" class="form-control"
                               value="<%= dateNaissance %>">
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Date d'embauche</label>
                        <input type="date" name="dateEmbauche" class="form-control"
                               value="<%= dateEmbauche %>">
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Équipe actuelle</label>
                    <input type="number" name="equipeId" class="form-control"
                           value="<%= equipeId %>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Centres d'intérêt</label>
                    <textarea name="centresInteret" class="form-control" rows="3"><%= centresInteret %></textarea>
                </div>

                <div class="mb-3">
                    <label class="form-label">Biographie</label>
                    <textarea name="biographie" class="form-control" rows="4"><%= biographie %></textarea>
                </div>

                <div class="mb-4">
                    <label class="form-label">État</label>
                    <select name="actif" class="form-select">
                        <option value="true" <%= membre.isActif() ? "selected" : "" %>>Actif</option>
                        <option value="false" <%= !membre.isActif() ? "selected" : "" %>>Inactif</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Enregistrer</button>

                <a href="${pageContext.request.contextPath}/membres" class="btn btn-secondary">
                    Annuler
                </a>
            </form>
        </div>
    </div>
</div>

</body>
</html>
