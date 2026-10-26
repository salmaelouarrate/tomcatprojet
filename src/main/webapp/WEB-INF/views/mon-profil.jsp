<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String photo = (membre.getPhoto() == null || membre.getPhoto().isEmpty())
            ? "https://ui-avatars.com/api/?name=" + membre.getPrenom() + "+" + membre.getNom() + "&background=0b2f57&color=fff"
            : membre.getPhoto();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon profil - LIAS</title>

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

        .profile-card {
            background: white;
            border-radius: 26px;
            box-shadow: 0 10px 40px rgba(15,23,42,0.08);
            overflow: hidden;
            border: 1px solid #edf2f7;
        }

        .profile-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 50%, #0ea5e9 100%);
            color: white;
            padding: 38px;
            display: flex;
            gap: 24px;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -8%;
            width: 280px;
            height: 280px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }

        .profile-header > * {
            position: relative;
            z-index: 2;
        }

        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid rgba(255,255,255,0.35);
            background: white;
            box-shadow: 0 8px 24px rgba(0,0,0,0.2);
        }

        .profile-header h2 {
            font-weight: 800;
            letter-spacing: -0.5px;
        }

        .profile-header p {
            color: rgba(255,255,255,0.8);
            font-weight: 500;
        }

        .badge.bg-light {
            background: rgba(255,255,255,0.9) !important;
            color: #0b2f57 !important;
            font-weight: 700;
            border-radius: 999px;
            padding: 7px 14px;
        }

        .badge.bg-info {
            background: rgba(255,255,255,0.18) !important;
            color: white !important;
            font-weight: 700;
            border-radius: 999px;
            padding: 7px 14px;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .info-label {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            margin-bottom: 5px;
        }

        .info-value {
            color: #0b2f57;
            font-weight: 700;
            margin-bottom: 20px;
            font-size: 15px;
        }

        .empty {
            color: #94a3b8;
            font-weight: 400;
        }

        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
            border-radius: 14px;
            font-weight: 600;
        }

        h4 {
            font-weight: 800;
            color: #0b2f57;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            font-weight: 700;
            border-radius: 12px;
            padding: 10px 22px;
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
            font-weight: 700;
            border-radius: 12px;
            padding: 10px 22px;
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
    <div class="profile-card mx-auto" style="max-width:950px;">

        <div class="profile-header">
            <img src="<%= photo %>" class="avatar" alt="Photo profil">

            <div>
                <h2 class="mb-1"><%= membre.getNomComplet() %></h2>
                <p class="mb-2"><%= membre.getEmail() %></p>
                <span class="badge bg-light text-dark"><%= membre.getRole() %></span>
                <span class="badge bg-info text-dark"><%= membre.getStatut() %></span>
            </div>
        </div>

        <div class="p-4">

            <% if ("1".equals(request.getParameter("success"))) { %>
                <div class="alert alert-success">
                    Profil modifié avec succès.
                </div>
            <% } %>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4 class="mb-0">Informations personnelles</h4>

                <a href="${pageContext.request.contextPath}/mon-profil?action=edit" class="btn btn-primary">
                    <i class="bi bi-pencil-square"></i> Modifier mon profil
                </a>
            </div>

            <div class="row">

                <div class="col-md-6">
                    <div class="info-label">Établissement</div>
                    <div class="info-value">
                        <%= (membre.getEtablissement() != null && !membre.getEtablissement().isEmpty())
                                ? membre.getEtablissement()
                                : "Non renseigné" %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-label">Laboratoire</div>
                    <div class="info-value">
                        <%= (membre.getLaboratoire() != null && !membre.getLaboratoire().isEmpty())
                                ? membre.getLaboratoire()
                                : "Non renseigné" %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-label">Laboratoire d'origine</div>
                    <div class="info-value">
                        <%= (membre.getLaboratoireOrigine() != null && !membre.getLaboratoireOrigine().isEmpty())
                                ? membre.getLaboratoireOrigine()
                                : "Non renseigné" %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-label">Équipe actuelle</div>
                    <div class="info-value">
                        <%= membre.getEquipeId() != null ? membre.getEquipeId() : "Non renseigné" %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-label">Date de naissance</div>
                    <div class="info-value">
                        <%= membre.getDateNaissance() != null ? membre.getDateNaissance() : "Non renseignée" %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="info-label">Date d'embauche</div>
                    <div class="info-value">
                        <%= membre.getDateEmbauche() != null ? membre.getDateEmbauche() : "Non renseignée" %>
                    </div>
                </div>

                <div class="col-12">
                    <div class="info-label">Centres d'intérêt</div>
                    <div class="info-value">
                        <%= (membre.getCentresInteret() != null && !membre.getCentresInteret().isEmpty())
                                ? membre.getCentresInteret()
                                : "Non renseigné" %>
                    </div>
                </div>

                <div class="col-12">
                    <div class="info-label">Biographie</div>
                    <div class="info-value">
                        <%= (membre.getBiographie() != null && !membre.getBiographie().isEmpty())
                                ? membre.getBiographie()
                                : "Non renseignée" %>
                    </div>
                </div>

            </div>

            <a href="${pageContext.request.contextPath}/espace-membre" class="btn btn-secondary mt-3">
                Retour
            </a>
        </div>
    </div>
</div>

</body>
</html>
