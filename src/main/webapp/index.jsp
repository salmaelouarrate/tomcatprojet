<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.testweba.config.DBConnection" %>

<%
    String laboratoireNom = "Laboratoire LIAS";
    String laboratoireDateCreation = "-";
    String laboratoireDescription = "Laboratoire d'Informatique et d'Intelligence Artificielle";

    String directeurNom = "Non défini";
    String directeurEmail = "";
    String mandatDateDebut = "-";

    int totalMembres = 0;
    int totalPublications = 0;
    int totalEvenements = 0;
    int totalConventions = 0;

    try (Connection conn = DBConnection.getConn()) {

        String sqlLaboratoire = "SELECT nom, date_creation, description FROM laboratoire ORDER BY id ASC LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(sqlLaboratoire);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                if (rs.getString("nom") != null) {
                    laboratoireNom = rs.getString("nom");
                }

                if (rs.getString("date_creation") != null) {
                    laboratoireDateCreation = rs.getString("date_creation");
                }

                if (rs.getString("description") != null) {
                    laboratoireDescription = rs.getString("description");
                }
            }
        }

        String sqlMandat =
                "SELECT m.nom, m.prenom, m.email, ma.date_debut " +
                "FROM mandat ma " +
                "LEFT JOIN membre m ON ma.membre_id = m.id " +
                "WHERE ma.actif = 1 " +
                "AND ma.type_mandat = 'directeur' " +
                "AND ma.date_debut <= CURRENT_DATE " +
                "AND (ma.date_fin IS NULL OR ma.date_fin >= CURRENT_DATE) " +
                "ORDER BY ma.date_debut DESC " +
                "LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(sqlMandat);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                String prenom = rs.getString("prenom") != null ? rs.getString("prenom") : "";
                String nom = rs.getString("nom") != null ? rs.getString("nom") : "";
                directeurNom = (prenom + " " + nom).trim();

                if (directeurNom.isEmpty()) {
                    directeurNom = "Non défini";
                }

                if (rs.getString("email") != null) {
                    directeurEmail = rs.getString("email");
                }

                if (rs.getString("date_debut") != null) {
                    mandatDateDebut = rs.getString("date_debut");
                }
            }
        }

        String sqlCounts =
                "SELECT " +
                "(SELECT COUNT(*) FROM membre WHERE actif = 1) AS total_membres, " +
                "(SELECT COUNT(*) FROM publication) AS total_publications, " +
                "(SELECT COUNT(*) FROM evenement) AS total_evenements, " +
                "(SELECT COUNT(*) FROM convention) AS total_conventions";

        try (PreparedStatement ps = conn.prepareStatement(sqlCounts);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalMembres = rs.getInt("total_membres");
                totalPublications = rs.getInt("total_publications");
                totalEvenements = rs.getInt("total_evenements");
                totalConventions = rs.getInt("total_conventions");
            }
        }

    } catch (SQLException e) {
        System.err.println("[index.jsp] Erreur chargement infos publiques : " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Laboratoire LIAS - IA & Big Data</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8faff;
            color: #1e293b;
            overflow-x: hidden;
        }

        .navbar {
            background: white;
            box-shadow: 0 2px 20px rgba(0,0,0,0.06);
            padding: 14px 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 20px;
            color: #0b2f57 !important;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .brand-icon {
            width: 38px;
            height: 38px;
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
        }

        .btn-connexion {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white !important;
            border: none;
            padding: 10px 24px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            transition: 0.2s;
            box-shadow: 0 4px 15px rgba(11,47,87,0.25);
            text-decoration: none;
        }

        .btn-connexion:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(11,47,87,0.35);
        }

        .hero {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 50%, #0ea5e9 100%);
            padding: 90px 0 80px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 600px;
            height: 600px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }

        .hero::after {
            content: '';
            position: absolute;
            bottom: -30%;
            left: -5%;
            width: 400px;
            height: 400px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            padding: 8px 18px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 600;
            color: white;
            margin-bottom: 28px;
        }

        .hero-title {
            font-size: 58px;
            font-weight: 900;
            color: white;
            line-height: 1.08;
            margin-bottom: 20px;
            letter-spacing: -1px;
        }

        .hero-title span {
            color: #bae6fd;
        }

        .hero-subtitle {
            font-size: 18px;
            color: rgba(255,255,255,0.8);
            line-height: 1.7;
            margin-bottom: 40px;
            max-width: 580px;
        }

        .btn-hero-primary {
            background: white;
            color: #0b2f57;
            border: none;
            padding: 14px 30px;
            border-radius: 14px;
            font-weight: 800;
            font-size: 15px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.2);
        }

        .btn-hero-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 14px 40px rgba(0,0,0,0.3);
            color: #0b2f57;
        }

        .btn-hero-secondary {
            background: rgba(255,255,255,0.15);
            color: white;
            border: 2px solid rgba(255,255,255,0.4);
            padding: 14px 30px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 15px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            backdrop-filter: blur(10px);
        }

        .btn-hero-secondary:hover {
            background: rgba(255,255,255,0.25);
            border-color: white;
            transform: translateY(-3px);
            color: white;
        }

        .stats-bar {
            background: white;
            border-radius: 20px;
            padding: 24px 32px;
            margin-top: 50px;
            display: flex;
            gap: 0;
            box-shadow: 0 10px 40px rgba(11,47,87,0.15);
            position: relative;
            z-index: 10;
        }

        .stat-item {
            flex: 1;
            text-align: center;
            padding: 0 20px;
            border-right: 1px solid #e2e8f0;
        }

        .stat-item:last-child {
            border-right: none;
        }

        .stat-num {
            font-size: 32px;
            font-weight: 900;
            color: #0b2f57;
            display: block;
        }

        .stat-label {
            font-size: 13px;
            color: #64748b;
            font-weight: 600;
        }

        .public-info-section {
            padding: 70px 0 20px;
            background: #f8faff;
        }

        .info-card {
            background: white;
            border-radius: 22px;
            padding: 28px;
            height: 100%;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
        }

        .info-icon {
            width: 54px;
            height: 54px;
            border-radius: 16px;
            background: #e0f2fe;
            color: #075985;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 23px;
            margin-bottom: 16px;
        }

        .info-card h5 {
            color: #0b2f57;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .info-card p {
            color: #64748b;
            margin-bottom: 0;
            font-size: 14px;
            line-height: 1.6;
        }

        .info-value {
            font-size: 22px;
            font-weight: 900;
            color: #0b2f57;
            margin-bottom: 6px;
        }

        .public-links {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 18px;
        }

        .public-link-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            border-radius: 12px;
            padding: 10px 16px;
            font-weight: 700;
            font-size: 14px;
            background: #eff6ff;
            color: #1d4ed8;
            transition: 0.2s;
        }

        .public-link-btn:hover {
            background: #dbeafe;
            color: #1e40af;
            transform: translateY(-2px);
        }

        .section {
            padding: 80px 0;
        }

        .section-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #eff6ff;
            color: #1d6fa5;
            padding: 6px 14px;
            border-radius: 999px;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 16px;
        }

        .section-title {
            font-size: 38px;
            font-weight: 900;
            color: #0b2f57;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        .section-subtitle {
            color: #64748b;
            font-size: 16px;
            max-width: 500px;
        }

        .feature-card {
            background: white;
            border-radius: 20px;
            padding: 28px;
            height: 100%;
            box-shadow: 0 4px 20px rgba(15,23,42,0.06);
            border: 1px solid #f1f5f9;
            transition: 0.3s;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            border-radius: 20px 20px 0 0;
        }

        .feature-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(15,23,42,0.12);
            border-color: #e0f2fe;
        }

        .feature-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            margin-bottom: 18px;
        }

        .feature-card h5 {
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 10px;
            font-size: 17px;
        }

        .feature-card p {
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
            margin: 0;
        }

        .cta-section {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border-radius: 28px;
            padding: 60px;
            text-align: center;
            position: relative;
            overflow: hidden;
            margin: 0 0 80px;
        }

        .cta-section::before {
            content: '';
            position: absolute;
            top: -40%;
            right: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }

        .cta-section h2 {
            font-size: 36px;
            font-weight: 900;
            color: white;
            margin-bottom: 14px;
        }

        .cta-section p {
            color: rgba(255,255,255,0.75);
            font-size: 16px;
            margin-bottom: 32px;
        }

        .footer {
            background: #0b2f57;
            color: rgba(255,255,255,0.6);
            text-align: center;
            padding: 24px;
            font-size: 14px;
        }

        .footer strong {
            color: white;
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 36px;
            }

            .stats-bar {
                flex-direction: column;
                gap: 20px;
            }

            .stat-item {
                border-right: none;
                border-bottom: 1px solid #e2e8f0;
                padding-bottom: 16px;
            }

            .stat-item:last-child {
                border-bottom: none;
            }

            .cta-section {
                padding: 40px 24px;
            }

            .cta-section h2 {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <div class="brand-icon">
                <i class="bi bi-diagram-3-fill"></i>
            </div>
            Laboratoire LIAS
        </a>

        <a href="${pageContext.request.contextPath}/login" class="btn-connexion">
            <i class="bi bi-box-arrow-in-right me-1"></i> Connexion membres
        </a>
    </div>
</nav>

<section class="hero">
    <div class="container" style="position:relative;z-index:10;">
        <div class="row align-items-center g-5">
            <div class="col-lg-8">

                <div class="hero-badge">
                    <i class="bi bi-mortarboard-fill"></i>
                    Faculté des Sciences Ben M'Sik - Casablanca
                </div>

                <h1 class="hero-title">
                    Bienvenue au<br>
                    Laboratoire <span>LIAS</span>
                </h1>

                <p class="hero-subtitle">
                    Plateforme de gestion scientifique et administrative du laboratoire :
                    membres, publications, événements, documents, conventions et demandes d'adhésion.
                </p>

                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/espace-public"
                       class="btn-hero-primary">
                        <i class="bi bi-box-arrow-in-right"></i> Espace membres
                    </a>

                    <a href="${pageContext.request.contextPath}/demandes-adhesion?action=new"
                       class="btn-hero-secondary">
                        <i class="bi bi-person-plus"></i> Demande d'adhésion
                    </a>
                </div>

                <div class="stats-bar">
                    <div class="stat-item">
                        <span class="stat-num">+<%= totalMembres %></span>
                        <span class="stat-label">Membres</span>
                    </div>

                    <div class="stat-item">
                        <span class="stat-num">+<%= totalPublications %></span>
                        <span class="stat-label">Publications</span>
                    </div>

                    <div class="stat-item">
                        <span class="stat-num">+<%= totalEvenements %></span>
                        <span class="stat-label">Événements</span>
                    </div>

                    <div class="stat-item">
                        <span class="stat-num">+<%= totalConventions %></span>
                        <span class="stat-label">Conventions</span>
                    </div>
                </div>

            </div>
        </div>
    </div>
</section>

<section class="public-info-section">
    <div class="container">

        <div class="text-center mb-5">
            <div class="section-badge">
                <i class="bi bi-info-circle"></i> Informations publiques
            </div>

            <h2 class="section-title">Présentation du laboratoire</h2>

            <p class="section-subtitle mx-auto">
                Informations générales accessibles aux visiteurs sans authentification.
            </p>
        </div>

        <div class="row g-4">

            <div class="col-md-4">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="bi bi-building"></i>
                    </div>

                    <h5><%= laboratoireNom %></h5>

                    <p>
                        <%= laboratoireDescription %>
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="bi bi-calendar-check"></i>
                    </div>

                    <h5>Date de création</h5>

                    <div class="info-value"><%= laboratoireDateCreation %></div>

                    <p>
                        Cette date représente la création officielle du laboratoire dans le système.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="info-card">
                    <div class="info-icon">
                        <i class="bi bi-person-badge"></i>
                    </div>

                    <h5>Directeur actuel</h5>

                    <div class="info-value"><%= directeurNom %></div>

                    <p>
                        Mandat actif depuis : <strong><%= mandatDateDebut %></strong><br>
                        <% if (directeurEmail != null && !directeurEmail.isEmpty()) { %>
                            Contact : <%= directeurEmail %>
                        <% } else { %>
                            Contact non disponible.
                        <% } %>
                    </p>
                </div>
            </div>

        </div>

        <div class="row g-4 mt-2">
            <div class="col-12">
                <div class="info-card">
                    <h5>Accès public</h5>

                    <p>
                        Les visiteurs peuvent consulter les productions scientifiques et les activités
                        du laboratoire sans compte membre.
                    </p>

                    <div class="public-links">
                        <a href="${pageContext.request.contextPath}/public-publications" class="public-link-btn">
                            <i class="bi bi-journal-text"></i> Publications publiques
                        </a>

                        <a href="${pageContext.request.contextPath}/public-evenements" class="public-link-btn">
                            <i class="bi bi-calendar-event"></i> Événements publics
                        </a>

                        <a href="${pageContext.request.contextPath}/demandes-adhesion?action=new" class="public-link-btn">
                            <i class="bi bi-person-plus"></i> Demande d'adhésion
                        </a>
                    </div>
                </div>
            </div>
        </div>

    </div>
</section>

<section class="section">
    <div class="container">

        <div class="text-center mb-5">
            <div class="section-badge">
                <i class="bi bi-stars"></i> Nos modules
            </div>

            <h2 class="section-title">Tout ce dont vous avez besoin</h2>

            <p class="section-subtitle mx-auto">
                Une plateforme complète pour gérer toutes les activités du laboratoire LIAS.
            </p>
        </div>

        <div class="row g-4">

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #3b82f6;">
                    <div class="feature-icon" style="background:#eff6ff;color:#3b82f6;">
                        <i class="bi bi-people-fill"></i>
                    </div>

                    <h5>Gestion des membres</h5>

                    <p>
                        Suivi complet des profils, rôles, statuts et historique des affiliations des membres.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #10b981;">
                    <div class="feature-icon" style="background:#f0fdf4;color:#10b981;">
                        <i class="bi bi-journal-text"></i>
                    </div>

                    <h5>Publications scientifiques</h5>

                    <p>
                        Ajout, consultation et classement des publications par auteur, année et équipe.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #f59e0b;">
                    <div class="feature-icon" style="background:#fffbeb;color:#f59e0b;">
                        <i class="bi bi-calendar-event"></i>
                    </div>

                    <h5>Événements scientifiques</h5>

                    <p>
                        Organisation et archivage des conférences, séminaires et workshops du laboratoire.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #8b5cf6;">
                    <div class="feature-icon" style="background:#f5f3ff;color:#8b5cf6;">
                        <i class="bi bi-folder2-open"></i>
                    </div>

                    <h5>Archivage documentaire</h5>

                    <p>
                        Upload, téléchargement et recherche de tous les documents administratifs et scientifiques.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #ec4899;">
                    <div class="feature-icon" style="background:#fdf2f8;color:#ec4899;">
                        <i class="bi bi-building"></i>
                    </div>

                    <h5>Conventions & Collaborations</h5>

                    <p>
                        Gestion des partenariats, conventions et collaborations avec universités et entreprises.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card" style="border-top: 4px solid #0ea5e9;">
                    <div class="feature-icon" style="background:#f0f9ff;color:#0ea5e9;">
                        <i class="bi bi-file-earmark-pdf"></i>
                    </div>

                    <h5>Rapport annuel PDF</h5>

                    <p>
                        Génération automatique du rapport d'activité annuel, condition pour le budget annuel.
                    </p>
                </div>
            </div>

        </div>
    </div>
</section>

<div class="container">
    <div class="cta-section">
        <div style="position:relative;z-index:10;">
            <h2>Rejoignez le Laboratoire LIAS</h2>

            <p>
                Soumettez votre demande d'adhésion en ligne et rejoignez notre équipe de recherche.
            </p>

            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="${pageContext.request.contextPath}/espace-public"
                   class="btn-hero-primary">
                    <i class="bi bi-box-arrow-in-right"></i> Espace membres
                </a>

                <a href="${pageContext.request.contextPath}/demandes-adhesion?action=new"
                   class="btn-hero-secondary">
                    <i class="bi bi-person-plus"></i> Demande d'adhésion
                </a>
            </div>
        </div>
    </div>
</div>

<footer class="footer">
    <strong>Laboratoire LIAS</strong> - Faculté des Sciences Ben M'Sik, Casablanca
    &nbsp;|&nbsp; Master Data Science & Big Data 2025-2026
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>