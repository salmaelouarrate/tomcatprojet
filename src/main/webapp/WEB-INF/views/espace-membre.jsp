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
    <title>Espace membre - LIAS</title>

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

        .main {
            margin-left: 260px;
            padding: 30px 32px;
        }

        .topbar {
            background: white;
            border-radius: 20px;
            padding: 22px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            margin-bottom: 26px;
            border: 1px solid #edf2f7;
        }

        .topbar h5 {
            font-weight: 800;
            color: #0b2f57;
            font-size: 19px;
        }

        .badge-role {
            background: #e0f2fe;
            color: #075985;
            padding: 8px 16px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 13px;
        }

        .welcome-card {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%);
            color: white;
            border-radius: 22px;
            padding: 36px;
            margin-bottom: 26px;
            box-shadow: 0 16px 42px rgba(11,47,87,0.22);
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
            background: rgba(255, 255, 255, 0.07);
            border-radius: 999px;
        }

        .welcome-card h2 {
            font-weight: 800;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
            letter-spacing: -0.5px;
        }

        .welcome-card p {
            color: rgba(255,255,255,0.85);
            margin-bottom: 0;
            position: relative;
            z-index: 1;
            max-width: 760px;
            font-weight: 500;
        }

        .section-title {
            color: #0b2f57;
            font-weight: 800;
            margin-bottom: 18px;
        }

        .module-card {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            height: 100%;
            transition: 0.2s;
            border: 1px solid #edf2f7;
        }

        .module-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 45px rgba(15,23,42,0.12);
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
            color: #0b2f57;
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
            padding: 8px 16px;
            font-size: 13px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            box-shadow: 0 6px 16px rgba(11,47,87,0.25);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 8px 20px rgba(11,47,87,0.32);
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
            color: #0b2f57;
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
            <h5 class="mb-0">Espace membre</h5>
            <small class="text-muted">Consultation des activités scientifiques du laboratoire</small>
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
            Votre espace vous permet de consulter les publications, événements et documents du laboratoire LIAS.
        </p>
    </div>

    <h5 class="section-title">Modules principaux</h5>

    <div class="row g-4">

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#e0f2fe;color:#075985;">
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
                <div class="module-icon" style="background:#dcfce7;color:#15803d;">
                    <i class="bi bi-journal-text"></i>
                </div>

                <h5>Publications</h5>

                <p class="text-muted">
                    Consulter les publications scientifiques du laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/publications"
                   class="btn btn-success btn-modern">
                    Consulter
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
                    Consulter les événements scientifiques organisés par le laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/evenements"
                   class="btn btn-warning text-white btn-modern">
                    Consulter
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="module-card">
                <div class="module-icon" style="background:#fee2e2;color:#b91c1c;">
                    <i class="bi bi-folder2-open"></i>
                </div>

                <h5>Documents</h5>

                <p class="text-muted">
                    Consulter les documents disponibles du laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/documents"
                   class="btn btn-danger btn-modern">
                    Consulter
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
