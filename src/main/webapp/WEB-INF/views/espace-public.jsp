<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Espace public - LIAS</title>

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

        .public-navbar {
            background: white;
            padding: 16px 0;
            box-shadow: 0 2px 20px rgba(0,0,0,0.06);
            position: sticky;
            top: 0;
            z-index: 20;
        }

        .navbar-brand {
            color: #0b2f57 !important;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 800;
            font-size: 20px;
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border-radius: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 12px 30px rgba(11,47,87,0.25);
        }

        .btn-login {
            border-radius: 12px;
            font-weight: 700;
            padding: 9px 18px;
        }

        .hero {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 50%, #0ea5e9 100%);
            color: white;
            padding: 74px 0;
            position: relative;
            overflow: hidden;
        }

        .hero::after {
            content: "";
            position: absolute;
            width: 360px;
            height: 360px;
            border-radius: 999px;
            right: -120px;
            top: -150px;
            background: rgba(255, 255, 255, 0.06);
        }

        .hero::before {
            content: "";
            position: absolute;
            width: 240px;
            height: 240px;
            border-radius: 999px;
            left: -90px;
            bottom: -120px;
            background: rgba(255, 255, 255, 0.05);
        }

        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 820px;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 999px;
            padding: 8px 16px;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .hero h1 {
            font-weight: 900;
            font-size: 44px;
            line-height: 1.12;
            margin-bottom: 16px;
            letter-spacing: -1px;
        }

        .hero p {
            color: rgba(255,255,255,0.85);
            font-size: 18px;
            line-height: 1.7;
            margin-bottom: 0;
        }

        .content-wrap {
            padding: 48px 0;
        }

        .section-title {
            font-weight: 900;
            color: #0b2f57;
            margin-bottom: 10px;
            letter-spacing: -0.5px;
        }

        .section-subtitle {
            color: #64748b;
            margin-bottom: 26px;
        }

        .card-box {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            height: 100%;
            transition: 0.2s;
            border: 1px solid #edf2f7;
        }

        .card-box:hover {
            transform: translateY(-4px);
            box-shadow: 0 18px 45px rgba(15,23,42,0.12);
        }

        .icon-box {
            width: 50px;
            height: 50px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin-bottom: 16px;
        }

        .card-box h5 {
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 10px;
        }

        .card-box p {
            font-size: 14px;
            line-height: 1.6;
            min-height: 66px;
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

        @media (max-width: 768px) {
            .hero {
                padding: 54px 0;
            }

            .hero h1 {
                font-size: 34px;
            }

            .hero p {
                font-size: 16px;
            }
        }
    </style>
</head>

<body>

<nav class="public-navbar">
    <div class="container d-flex align-items-center justify-content-between">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <span class="brand-icon">
                <i class="bi bi-diagram-3-fill"></i>
            </span>
            Laboratoire LIAS
        </a>

        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary btn-login">
            <i class="bi bi-box-arrow-in-right me-1"></i> Connexion membres
        </a>
    </div>
</nav>

<section class="hero">
    <div class="container">
        <div class="hero-content">
            <div class="hero-badge">
                <i class="bi bi-globe2"></i>
                Accès public
            </div>

            <h1>Espace public du Laboratoire LIAS</h1>

            <p>
                Découvrez les activités scientifiques, les publications, les événements,
                le calendrier et les informations générales du laboratoire.
            </p>
        </div>
    </div>
</section>

<div class="container content-wrap">

    <div class="mb-4">
        <h4 class="section-title">Services publics</h4>
        <p class="section-subtitle">
            Ces rubriques sont accessibles sans authentification.
        </p>
    </div>

    <div class="row g-4">

        <div class="col-md-3">
            <div class="card-box">
                <div class="icon-box" style="background:#dcfce7;color:#15803d;">
                    <i class="bi bi-journal-text"></i>
                </div>

                <h5>Publications</h5>

                <p class="text-muted">
                    Consulter les productions scientifiques du laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/public-publications"
                   class="btn btn-success btn-modern">
                    Consulter
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="icon-box" style="background:#fef3c7;color:#b45309;">
                    <i class="bi bi-calendar-event"></i>
                </div>

                <h5>Événements</h5>

                <p class="text-muted">
                    Suivre les conférences, séminaires et workshops organisés.
                </p>

                <a href="${pageContext.request.contextPath}/public-evenements"
                   class="btn btn-warning text-white btn-modern">
                    Consulter
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="icon-box" style="background:#e0f2fe;color:#075985;">
                    <i class="bi bi-calendar3"></i>
                </div>

                <h5>Calendrier</h5>

                <p class="text-muted">
                    Visualiser les événements du laboratoire par mois ou semaine.
                </p>

                <a href="${pageContext.request.contextPath}/calendrier"
                   class="btn btn-primary btn-modern">
                    Voir calendrier
                </a>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <div class="icon-box" style="background:#f3e8ff;color:#7e22ce;">
                    <i class="bi bi-person-plus"></i>
                </div>

                <h5>Demande d'adhésion</h5>

                <p class="text-muted">
                    Soumettre une demande pour rejoindre ou collaborer avec le laboratoire.
                </p>

                <a href="${pageContext.request.contextPath}/demandes-adhesion?action=new"
                   class="btn btn-secondary btn-modern">
                    Faire une demande
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
