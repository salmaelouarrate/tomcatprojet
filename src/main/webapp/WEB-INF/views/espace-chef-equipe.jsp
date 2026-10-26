<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Espace chef d'équipe - LIAS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #f4f7fb;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .main {
            margin-left: 260px;
            padding: 28px;
        }

        .topbar {
            background: white;
            border-radius: 18px;
            padding: 18px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            margin-bottom: 28px;
        }

        .topbar h5 {
            font-weight: 800;
            color: #0f172a;
        }

        .badge-role {
            background: #e0f2fe;
            color: #075985;
            padding: 8px 14px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 13px;
        }

        .welcome-card {
            background: linear-gradient(135deg, #102a4c, #2454e8);
            color: white;
            border-radius: 22px;
            padding: 34px;
            margin-bottom: 28px;
            box-shadow: 0 16px 42px rgba(37, 99, 235, 0.22);
            overflow: hidden;
            position: relative;
        }

        .welcome-card::after {
            content: "";
            position: absolute;
            width: 260px;
            height: 260px;
            right: -80px;
            top: -110px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 999px;
        }

        .welcome-card h2 {
            font-weight: 900;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .welcome-card p {
            color: #dbeafe;
            margin-bottom: 0;
            position: relative;
            z-index: 1;
            max-width: 760px;
        }

        .section-title {
            color: #0f172a;
            font-weight: 800;
            margin-bottom: 18px;
        }

        .module-card {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            height: 100%;
            transition: 0.2s;
            border: 1px solid rgba(226, 232, 240, 0.8);
        }

        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
        }

        .module-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 21px;
            margin-bottom: 16px;
        }

        .module-card h5 {
            color: #0f172a;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .module-card p {
            font-size: 14px;
            line-height: 1.6;
            min-height: 44px;
        }

        .btn-modern {
            border-radius: 10px;
            font-weight: 700;
            padding: 7px 14px;
            font-size: 13px;
        }

        .user-box {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .user-info {
            text-align: right;
        }

        .user-info strong {
            display: block;
            color: #0f172a;
            font-size: 14px;
        }

        .user-info small {
            color: #64748b;
        }

        @media (max-width: 900px) {
            .main {
                margin-left: 230px;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 14px;
            }

            .user-info {
                text-align: left;
            }
        }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="topbar">
        <div>
            <h5 class="mb-0">Espace chef d'équipe</h5>
            <small class="text-muted">Suivi des activités scientifiques de votre équipe</small>
        </div>

        <div class="user-box">
            <span class="badge-role"><%= membre.getRole() %></span>

            <div class="user-info">
                <strong><%= membre.getNomComplet() %></strong>
                <small><%= membre.getEmail() %></small>
            </div>
        </div>
    </div>

    <div class="welcome-card">
        <h2>Bonjour, <%= membre.getPrenom() %> 👋</h2>
        <p>
            Vous pouvez suivre les publications, événements et documents liés à votre équipe.
        </p>
    </div>

    <h5 class="section-title">Modules principaux</h5>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#dbeafe;color:#2563eb;">
                    <i class="bi bi-person-circle"></i>
                </div>

                <h5>Mon profil</h5>

                <p class="text-muted">
                    Consulter et modifier mes informations personnelles.
                </p>

                <a href="${pageContext.request.contextPath}/mon-profil"
                   class="btn btn-primary btn-modern">
                    Ouvrir
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#e0f2fe;color:#0369a1;">
                    <i class="bi bi-people"></i>
                </div>

                <h5>Membres</h5>

                <p class="text-muted">
                    Consulter les membres du laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/membres"
                   class="btn btn-primary btn-modern">
                    Ouvrir
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#dcfce7;color:#15803d;">
                    <i class="bi bi-journal-text"></i>
                </div>

                <h5>Publications</h5>

                <p class="text-muted">
                    Suivre les publications scientifiques.
                </p>

                <a href="${pageContext.request.contextPath}/publications"
                   class="btn btn-success btn-modern">
                    Ouvrir
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#fef3c7;color:#b45309;">
                    <i class="bi bi-calendar-event"></i>
                </div>

                <h5>Événements</h5>

                <p class="text-muted">
                    Consulter les événements scientifiques.
                </p>

                <a href="${pageContext.request.contextPath}/evenements"
                   class="btn btn-warning text-white btn-modern">
                    Ouvrir
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#cffafe;color:#0891b2;">
                    <i class="bi bi-box-seam"></i>
                </div>

                <h5>Demandes matériel</h5>

                <p class="text-muted">
                    Soumettre une demande d'équipement au laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/demandes-materiel"
                   class="btn btn-info text-white btn-modern">
                    Ouvrir
                </a>
            </div>
        </div>

    </div>

</div>

</body>
</html>