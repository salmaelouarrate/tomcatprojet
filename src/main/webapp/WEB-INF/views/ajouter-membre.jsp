<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    java.util.List<com.testweba.model.Equipe> equipes =
        new com.testweba.dao.EquipeDAO().findAll();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter membre - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .form-card {
            background: white; border-radius: 20px; padding: 36px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.08);
            max-width: 900px; margin: 40px auto;
        }
        .form-header {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border-radius: 14px; padding: 24px;
            margin-bottom: 28px;
        }
        .section-label {
            display: flex; align-items: center; gap: 8px;
            font-weight: 700; color: #0b2f57; font-size: 14px;
            margin: 24px 0 14px; padding-bottom: 8px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-label:first-of-type { margin-top: 0; }
        .form-label { font-weight: 600; color: #334155; }
        .form-control, .form-select {
            border-radius: 10px; border: 1.5px solid #e2e8f0;
            padding: 10px 14px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 3px rgba(29,111,165,0.1);
        }
        .info-box {
            background: #eff6ff; border-left: 4px solid #1d6fa5;
            border-radius: 10px; padding: 12px 16px; margin-top: 8px;
            font-size: 13px; color: #1e40af;
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
                <i class="bi bi-person-plus me-2"></i>Ajouter un membre
            </h4>
            <small>Créer un nouveau compte membre du laboratoire</small>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/membres">

            <div class="section-label"><i class="bi bi-person"></i> Informations personnelles</div>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Nom <span class="text-danger">*</span></label>
                    <input type="text" name="nom" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Prénom <span class="text-danger">*</span></label>
                    <input type="text" name="prenom" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Mot de passe</label>
                    <input type="password" name="motDePasse" class="form-control"
                           placeholder="Laisser vide pour admin123">
                </div>
            </div>
            <div class="info-box">
                <i class="bi bi-info-circle me-1"></i>
                Si le mot de passe est laissé vide, le mot de passe par défaut sera <strong>admin123</strong>.
            </div>

            <div class="section-label"><i class="bi bi-briefcase"></i> Statut et rôle</div>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Statut <span class="text-danger">*</span></label>
                    <select name="statut" class="form-select" required>
                        <option value="permanent">Permanent</option>
                        <option value="doctorant">Doctorant</option>
                        <option value="associe">Associé</option>
                        <option value="retraite">Retraité</option>
                        <option value="ancien">Ancien</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Rôle <span class="text-danger">*</span></label>
                    <select name="role" class="form-select" required>
                        <option value="membre">Membre</option>
                        <option value="doctorant">Doctorant</option>
                        <option value="chef_equipe">Chef équipe</option>
                        <option value="vice_directeur">Vice-directeur</option>
                        <option value="directeur">Directeur</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Équipe actuelle</label>
                    <select name="equipeId" class="form-select">
                        <option value="">— Aucune équipe —</option>
                        <% if (equipes != null) {
                            for (com.testweba.model.Equipe e : equipes) { %>
                                <option value="<%= e.getId() %>"><%= e.getNom() %></option>
                        <%  }
                        } %>
                    </select>
                </div>
            </div>

            <div class="section-label"><i class="bi bi-building"></i> Établissement</div>

            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label">Établissement <span class="text-danger">*</span></label>
                    <input type="text" name="etablissement" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Laboratoire</label>
                    <input type="text" name="laboratoire" class="form-control" placeholder="Exemple : LIAS">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Laboratoire d'origine</label>
                    <input type="text" name="laboratoireOrigine" class="form-control"
                           placeholder="Si membre associé">
                </div>
            </div>

            <div class="section-label"><i class="bi bi-card-text"></i> Informations complémentaires</div>

            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label">Photo</label>
                    <input type="text" name="photo" class="form-control"
                           placeholder="Lien ou nom du fichier photo">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date de naissance</label>
                    <input type="date" name="dateNaissance" class="form-control">
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date d'embauche</label>
                    <input type="date" name="dateEmbauche" class="form-control">
                </div>

                <div class="col-12">
                    <label class="form-label">Centres d'intérêt</label>
                    <textarea name="centresInteret" class="form-control" rows="3"
                              placeholder="IA, Big Data, Data Mining..."></textarea>
                </div>

                <div class="col-12">
                    <label class="form-label">Biographie</label>
                    <textarea name="biographie" class="form-control" rows="4"
                              placeholder="Présentation courte du membre"></textarea>
                </div>
            </div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-check-circle me-2"></i> Enregistrer
                </button>
                <a href="${pageContext.request.contextPath}/membres"
                   class="btn btn-outline-secondary" style="border-radius:12px;padding:12px 28px;">
                    <i class="bi bi-arrow-left me-2"></i> Annuler
                </a>
            </div>
        </form>

    </div>
</div>

</body>
</html>