<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    Object totalMembres = request.getAttribute("totalMembres");
    Object totalPublications = request.getAttribute("totalPublications");
    Object totalEvenements = request.getAttribute("totalEvenements");
    Object totalDocuments = request.getAttribute("totalDocuments");
    Object totalMateriels = request.getAttribute("totalMateriels");
    Object totalConventions = request.getAttribute("totalConventions");
    Object totalNotifications = request.getAttribute("totalNotifications");

    Object laboratoireNom = request.getAttribute("laboratoireNom");
    Object laboratoireDateCreation = request.getAttribute("laboratoireDateCreation");
    Object laboratoireDescription = request.getAttribute("laboratoireDescription");

    Object mandatActifNom = request.getAttribute("mandatActifNom");
    Object mandatActifEmail = request.getAttribute("mandatActifEmail");
    Object mandatActifType = request.getAttribute("mandatActifType");
    Object mandatActifDateDebut = request.getAttribute("mandatActifDateDebut");
    Object mandatActifDateFin = request.getAttribute("mandatActifDateFin");

    List<Map<String, String>> activites =
        (List<Map<String, String>>) request.getAttribute("activites");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard LIAS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg: #f8faff;
            --sidebar-bg: #0b2f57;
            --sidebar-hover: rgba(29,111,165,0.18);
            --sidebar-active: rgba(29,111,165,0.28);
            --accent: #1d6fa5;
            --accent2: #0ea5e9;
            --text: #1e293b;
            --muted: #64748b;
            --card-bg: #ffffff;
            --border: rgba(15,23,42,0.07);
            --sidebar-width: 72px;
            --sidebar-expanded: 260px;
            --transition: 0.32s cubic-bezier(0.4,0,0.2,1);
        }

        *, *::before, *::after { box-sizing: border-box; }

        body {
            margin: 0;
            background: var(--bg);
            font-family: 'Inter', sans-serif;
            color: var(--text);
            overflow-x: hidden;
        }

        .sidebar {
            position: fixed;
            left: 0; top: 0;
            height: 100vh;
            width: var(--sidebar-width);
            background: linear-gradient(180deg, #0b2f57 0%, #123f73 100%);
            display: flex;
            flex-direction: column;
            padding: 20px 10px 16px;
            z-index: 200;
            transition: width var(--transition);
            overflow-y: auto;
            overflow-x: hidden;
            box-shadow: 4px 0 32px rgba(11,47,87,0.18);
        }

        .sidebar::-webkit-scrollbar {
            width: 5px;
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.15);
            border-radius: 999px;
        }

        .sidebar.open {
            width: var(--sidebar-expanded);
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 8px 10px 24px;
            white-space: nowrap;
            overflow: hidden;
        }

        .brand-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
            flex-shrink: 0;
            cursor: pointer;
        }

        .brand-text {
            font-family: 'Inter', sans-serif;
            font-size: 18px;
            font-weight: 800;
            color: white;
            letter-spacing: -0.3px;
            opacity: 0;
            transform: translateX(-6px);
            transition: opacity var(--transition), transform var(--transition);
        }

        .sidebar.open .brand-text {
            opacity: 1;
            transform: translateX(0);
        }

        .nav-section {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.1em;
            color: rgba(186,230,253,0.55);
            padding: 16px 14px 8px;
            white-space: nowrap;
            text-transform: uppercase;
        }

        .nav-link-item {
            display: flex;
            align-items: center;
            gap: 13px;
            padding: 11px 14px;
            color: rgba(219,234,254,0.75);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 3px;
            white-space: nowrap;
            overflow: hidden;
            transition: background var(--transition), color 0.2s;
            position: relative;
        }

        .nav-link-item i {
            font-size: 18px;
            flex-shrink: 0;
            width: 22px;
            text-align: center;
        }

        .nav-link-text {
            font-size: 13.5px;
            font-weight: 600;
            opacity: 0;
            transform: translateX(-8px);
            transition: opacity var(--transition), transform var(--transition);
        }

        .sidebar.open .nav-link-text {
            opacity: 1;
            transform: translateX(0);
        }

        .nav-link-item:hover {
            background: var(--sidebar-hover);
            color: #dbeafe;
        }

        .nav-link-item.active {
            background: var(--sidebar-active);
            color: #bae6fd;
        }

        .nav-link-item.active::before {
            content: '';
            position: absolute;
            left: 0; top: 8px; bottom: 8px;
            width: 3px;
            background: #0ea5e9;
            border-radius: 0 3px 3px 0;
        }

        .nav-divider {
            height: 1px;
            background: rgba(255,255,255,0.07);
            margin: 8px 12px;
        }

        .sidebar-footer { margin-top: auto; }

        /* Overlay quand sidebar ouverte */
        .sidebar-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 199;
            background: rgba(0,0,0,0.3);
        }

        .sidebar-overlay.show {
            display: block;
        }

        .main {
            margin-left: var(--sidebar-width);
            padding: 24px 28px;
            min-height: 100vh;
        }

        .topbar {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 16px var(--border);
            margin-bottom: 24px;
            border: 1px solid var(--border);
        }

        .topbar-title {
            font-family: 'Inter', sans-serif;
            font-size: 20px;
            font-weight: 800;
            color: var(--text);
            margin: 0;
            letter-spacing: -0.3px;
        }

        .topbar-sub {
            font-size: 12.5px;
            color: var(--muted);
            margin-top: 2px;
        }

        .role-chip {
            background: #e0f2fe;
            color: #075985;
            font-size: 12px;
            font-weight: 700;
            padding: 5px 14px;
            border-radius: 999px;
            letter-spacing: 0.03em;
        }

        .notif-btn {
            position: relative;
            width: 40px; height: 40px;
            background: #f1f5f9;
            border: none;
            border-radius: 12px;
            color: var(--muted);
            font-size: 17px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
            text-decoration: none;
        }

        .notif-btn:hover { background: #e2e8f0; color: var(--accent); }

        .welcome-hero {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%);
            border-radius: 22px;
            padding: 36px 40px;
            margin-bottom: 24px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 12px 40px rgba(11,47,87,0.22);
        }

        .welcome-hero::before {
            content: '';
            position: absolute;
            right: -60px; top: -60px;
            width: 300px; height: 300px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
            pointer-events: none;
        }

        .welcome-hero::after {
            content: '';
            position: absolute;
            right: 100px; bottom: -80px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            pointer-events: none;
        }

        .hero-greeting {
            font-family: 'Inter', sans-serif;
            font-size: 30px;
            font-weight: 800;
            color: white;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .hero-sub {
            color: rgba(255,255,255,0.8);
            font-size: 14.5px;
            max-width: 540px;
            line-height: 1.6;
            margin: 0;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            color: rgba(255,255,255,0.9);
            font-size: 12px;
            font-weight: 600;
            padding: 5px 14px;
            border-radius: 999px;
            margin-bottom: 16px;
            backdrop-filter: blur(4px);
        }

        .info-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 16px var(--border);
            height: 100%;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .info-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 32px rgba(15,23,42,0.1);
        }

        .info-icon-wrap {
            width: 48px; height: 48px;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px;
            margin-bottom: 16px;
        }

        .info-label { font-size: 12px; font-weight: 700; color: var(--muted); letter-spacing: 0.05em; text-transform: uppercase; margin-bottom: 6px; }
        .info-value { font-family: 'Inter', sans-serif; font-size: 22px; font-weight: 800; color: var(--text); margin-bottom: 8px; }

        .stat-card {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 22px 20px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 16px var(--border);
            height: 100%;
            display: flex;
            align-items: center;
            gap: 18px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(15,23,42,0.1);
        }

        .stat-icon {
            width: 52px; height: 52px;
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .stat-num {
            font-family: 'Inter', sans-serif;
            font-size: 28px;
            font-weight: 800;
            color: var(--text);
            line-height: 1;
            margin-bottom: 4px;
        }

        .stat-label { font-size: 12.5px; color: var(--muted); font-weight: 600; }

        .module-card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 22px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 16px var(--border);
            height: 100%;
            transition: transform 0.22s, box-shadow 0.22s;
        }

        .module-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 40px rgba(15,23,42,0.11);
        }

        .module-icon-wrap {
            width: 44px; height: 44px;
            border-radius: 13px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
        }

        .module-title {
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            font-weight: 800;
            margin-bottom: 6px;
            color: var(--text);
        }

        .module-desc {
            font-size: 13px;
            color: var(--muted);
            line-height: 1.5;
            margin-bottom: 16px;
        }

        .btn-module {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 16px;
            border-radius: 10px;
            font-size: 12.5px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            transition: opacity 0.2s, transform 0.2s;
        }

        .btn-module:hover { opacity: 0.88; transform: translateX(2px); }

        .activity-box {
            background: var(--card-bg);
            border-radius: 20px;
            padding: 24px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 16px var(--border);
        }

        .section-title {
            font-family: 'Inter', sans-serif;
            font-size: 16px;
            font-weight: 800;
            color: var(--text);
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            padding: 14px 0;
            border-bottom: 1px solid var(--border);
        }

        .activity-item:last-child { border-bottom: none; padding-bottom: 0; }

        .activity-dot {
            width: 36px; height: 36px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .activity-label {
            font-size: 14px;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 2px;
        }

        .activity-time {
            font-size: 12px;
            color: var(--muted);
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .animate { animation: fadeUp 0.45s ease both; }
        .d1 { animation-delay: 0.05s; }
        .d2 { animation-delay: 0.10s; }
        .d3 { animation-delay: 0.15s; }
        .d4 { animation-delay: 0.20s; }
        .d5 { animation-delay: 0.25s; }

        @media (max-width: 768px) {
            .main { margin-left: var(--sidebar-width); padding: 16px; }
            .welcome-hero { padding: 24px 22px; }
            .hero-greeting { font-size: 22px; }
        }
    </style>
</head>
<body>

<!-- OVERLAY -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- SIDEBAR -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon" id="sidebarToggle">
            <i class="bi bi-diagram-3-fill"></i>
        </div>
        <span class="brand-text">LIAS Lab</span>
    </div>

    <div class="nav-section">PRINCIPAL</div>

    <a href="${pageContext.request.contextPath}/dashboard" class="nav-link-item active">
        <i class="bi bi-speedometer2"></i>
        <span class="nav-link-text">Dashboard</span>
    </a>

    <a href="${pageContext.request.contextPath}/mon-profil" class="nav-link-item">
        <i class="bi bi-person-circle"></i>
        <span class="nav-link-text">Mon profil</span>
    </a>

    <div class="nav-section">GESTION</div>

    <a href="${pageContext.request.contextPath}/membres" class="nav-link-item">
        <i class="bi bi-people"></i>
        <span class="nav-link-text">Membres</span>
    </a>

    <a href="${pageContext.request.contextPath}/publications" class="nav-link-item">
        <i class="bi bi-journal-text"></i>
        <span class="nav-link-text">Publications</span>
    </a>

    <a href="${pageContext.request.contextPath}/evenements" class="nav-link-item">
        <i class="bi bi-calendar-event"></i>
        <span class="nav-link-text">Événements</span>
    </a>

    <a href="${pageContext.request.contextPath}/documents" class="nav-link-item">
        <i class="bi bi-folder2-open"></i>
        <span class="nav-link-text">Documents</span>
    </a>

    <a href="${pageContext.request.contextPath}/materiel" class="nav-link-item">
        <i class="bi bi-pc-display"></i>
        <span class="nav-link-text">Matériel</span>
    </a>

    <a href="${pageContext.request.contextPath}/conventions" class="nav-link-item">
        <i class="bi bi-building"></i>
        <span class="nav-link-text">Conventions</span>
    </a>

    <div class="nav-section">ADMINISTRATION</div>

    <a href="${pageContext.request.contextPath}/demandes-adhesion" class="nav-link-item">
        <i class="bi bi-inbox"></i>
        <span class="nav-link-text">Demandes adhésion</span>
    </a>

    <a href="${pageContext.request.contextPath}/demandes-materiel" class="nav-link-item">
        <i class="bi bi-box-seam"></i>
        <span class="nav-link-text">Demandes matériel</span>
    </a>

    <a href="${pageContext.request.contextPath}/pv" class="nav-link-item">
        <i class="bi bi-file-earmark-text"></i>
        <span class="nav-link-text">Procès-verbaux</span>
    </a>

    <a href="${pageContext.request.contextPath}/mandats" class="nav-link-item">
        <i class="bi bi-award"></i>
        <span class="nav-link-text">Mandats</span>
    </a>

    <div class="nav-section">OUTILS</div>

    <a href="${pageContext.request.contextPath}/rapport" class="nav-link-item">
        <i class="bi bi-file-earmark-pdf"></i>
        <span class="nav-link-text">Rapport annuel</span>
    </a>

    <a href="${pageContext.request.contextPath}/recherche" class="nav-link-item">
        <i class="bi bi-search"></i>
        <span class="nav-link-text">Recherche</span>
    </a>

    <a href="${pageContext.request.contextPath}/calendrier" class="nav-link-item">
        <i class="bi bi-calendar3"></i>
        <span class="nav-link-text">Calendrier</span>
    </a>

    <a href="${pageContext.request.contextPath}/notifications" class="nav-link-item">
        <i class="bi bi-bell"></i>
        <span class="nav-link-text">Notifications</span>
    </a>
    
   <a href="${pageContext.request.contextPath}/messages" class="nav-link-item">
        <i class="bi bi-chat-dots"></i>
        <span class="nav-link-text">Messagerie</span>
    </a>

    <a href="${pageContext.request.contextPath}/equipes" class="nav-link-item">
        <i class="bi bi-diagram-3"></i>
        <span class="nav-link-text">Équipes</span>
    </a>

    <div class="nav-divider"></div>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link-item" style="color:rgba(252,165,165,0.8);">
            <i class="bi bi-box-arrow-right"></i>
            <span class="nav-link-text">Déconnexion</span>
        </a>
    </div>
</nav>

<!-- MAIN -->
<div class="main">

    <div class="topbar animate d1">
        <div>
            <h1 class="topbar-title">Tableau de bord</h1>
            <div class="topbar-sub">Gestion du Laboratoire LIAS</div>
        </div>
        <div class="d-flex align-items-center gap-3">
            <a href="${pageContext.request.contextPath}/notifications" class="notif-btn">
                <i class="bi bi-bell"></i>
            </a>
            <span class="role-chip"><%= membre.getRole() %></span>
            <div class="text-end">
                <div style="font-weight:700;font-size:14px;"><%= membre.getNomComplet() %></div>
                <div style="font-size:12px;color:var(--muted);"><%= membre.getEmail() %></div>
            </div>
        </div>
    </div>

    <div class="welcome-hero animate d2">
        <div class="hero-badge"><i class="bi bi-circle-fill" style="font-size:7px;color:#4ade80;"></i> Connecté</div>
        <div class="hero-greeting">Bonjour, <%= membre.getPrenom() %> 👋</div>
        <p class="hero-sub">
            Bienvenue dans votre espace de gestion du laboratoire LIAS.
            Suivez les membres, publications, événements, documents et bien plus.
        </p>
    </div>

    <div class="row g-4 mb-4 animate d3">
        <div class="col-md-6">
            <div class="info-card">
                <div class="info-icon-wrap" style="background:#e0f2fe;color:#075985;">
                    <i class="bi bi-diagram-3-fill"></i>
                </div>
                <div class="info-label">Laboratoire</div>
                <div class="info-value"><%= laboratoireNom != null ? laboratoireNom : "Laboratoire LIAS" %></div>
                <p class="text-muted mb-1" style="font-size:13px;">
                    Créé le : <strong><%= laboratoireDateCreation != null ? laboratoireDateCreation : "—" %></strong>
                </p>
                <p class="text-muted mb-0" style="font-size:13px;">
                    <%= laboratoireDescription != null ? laboratoireDescription : "" %>
                </p>
            </div>
        </div>

        <div class="col-md-6">
            <div class="info-card">
                <div class="info-icon-wrap" style="background:#dcfce7;color:#16a34a;">
                    <i class="bi bi-award-fill"></i>
                </div>
                <div class="info-label">Mandat actif</div>
                <div class="info-value"><%= mandatActifNom != null ? mandatActifNom : "Aucun mandat actif" %></div>
                <p class="text-muted mb-1" style="font-size:13px;">
                    Type : <strong><%= mandatActifType != null ? mandatActifType : "—" %></strong>
                    &nbsp;·&nbsp;
                    Début : <strong><%= mandatActifDateDebut != null ? mandatActifDateDebut : "—" %></strong>
                </p>
                <p class="text-muted mb-0" style="font-size:13px;">
                    Fin : <strong><%= mandatActifDateFin != null ? mandatActifDateFin : "Mandat en cours" %></strong>
                    <% if (mandatActifEmail != null && !"".equals(mandatActifEmail)) { %>
                        &nbsp;·&nbsp;<%= mandatActifEmail %>
                    <% } %>
                </p>
            </div>
        </div>
    </div>

    <div class="row g-3 mb-4 animate d4">
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#e0f2fe;color:#075985;"><i class="bi bi-people-fill"></i></div>
                <div>
                    <div class="stat-num"><%= totalMembres != null ? totalMembres : 0 %></div>
                    <div class="stat-label">Membres actifs</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#dcfce7;color:#16a34a;"><i class="bi bi-journal-check"></i></div>
                <div>
                    <div class="stat-num"><%= totalPublications != null ? totalPublications : 0 %></div>
                    <div class="stat-label">Publications</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fef3c7;color:#b45309;"><i class="bi bi-calendar2-week"></i></div>
                <div>
                    <div class="stat-num"><%= totalEvenements != null ? totalEvenements : 0 %></div>
                    <div class="stat-label">Événements</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-file-earmark-text"></i></div>
                <div>
                    <div class="stat-num"><%= totalDocuments != null ? totalDocuments : 0 %></div>
                    <div class="stat-label">Documents</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#e0f2fe;color:#0284c7;"><i class="bi bi-pc-display"></i></div>
                <div>
                    <div class="stat-num"><%= totalMateriels != null ? totalMateriels : 0 %></div>
                    <div class="stat-label">Matériels</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#f3e8ff;color:#9333ea;"><i class="bi bi-building"></i></div>
                <div>
                    <div class="stat-num"><%= totalConventions != null ? totalConventions : 0 %></div>
                    <div class="stat-label">Conventions</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="stat-card">
                <div class="stat-icon" style="background:#fff7ed;color:#ea580c;"><i class="bi bi-bell-fill"></i></div>
                <div>
                    <div class="stat-num"><%= totalNotifications != null ? totalNotifications : 0 %></div>
                    <div class="stat-label">Notifications</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 animate d5">
        <div class="col-lg-8">
            <div class="section-title"><i class="bi bi-grid-1x2" style="color:var(--accent);"></i> Modules principaux</div>
            <div class="row g-3">

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-person-circle"></i></div>
                        <div class="module-title">Mon profil</div>
                        <div class="module-desc">Consulter et modifier mes informations personnelles.</div>
                        <a href="${pageContext.request.contextPath}/mon-profil" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0e7ff;color:#4f46e5;"><i class="bi bi-diagram-3"></i></div>
                        <div class="module-title">Équipes</div>
                        <div class="module-desc">Gérer les équipes de recherche et assigner les membres.</div>
                        <a href="${pageContext.request.contextPath}/equipes" class="btn-module" style="background:#e0e7ff;color:#4338ca;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-people"></i></div>
                        <div class="module-title">Gestion des membres</div>
                        <div class="module-desc">Ajouter, modifier et consulter les membres.</div>
                        <a href="${pageContext.request.contextPath}/membres" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#dcfce7;color:#16a34a;"><i class="bi bi-journal-text"></i></div>
                        <div class="module-title">Publications</div>
                        <div class="module-desc">Suivre les travaux scientifiques publiés.</div>
                        <a href="${pageContext.request.contextPath}/publications" class="btn-module" style="background:#dcfce7;color:#15803d;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#fef3c7;color:#b45309;"><i class="bi bi-calendar-event"></i></div>
                        <div class="module-title">Événements</div>
                        <div class="module-desc">Gérer séminaires et conférences.</div>
                        <a href="${pageContext.request.contextPath}/evenements" class="btn-module" style="background:#fef3c7;color:#b45309;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-folder2-open"></i></div>
                        <div class="module-title">Documents</div>
                        <div class="module-desc">Archiver les fichiers importants.</div>
                        <a href="${pageContext.request.contextPath}/documents" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#0284c7;"><i class="bi bi-pc-display"></i></div>
                        <div class="module-title">Matériel</div>
                        <div class="module-desc">Gérer les équipements du laboratoire.</div>
                        <a href="${pageContext.request.contextPath}/materiel" class="btn-module" style="background:#e0f2fe;color:#0369a1;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#f3e8ff;color:#9333ea;"><i class="bi bi-building"></i></div>
                        <div class="module-title">Conventions</div>
                        <div class="module-desc">Gérer les partenariats et conventions.</div>
                        <a href="${pageContext.request.contextPath}/conventions" class="btn-module" style="background:#f3e8ff;color:#7e22ce;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#fef3c7;color:#b45309;"><i class="bi bi-inbox"></i></div>
                        <div class="module-title">Demandes d'adhésion</div>
                        <div class="module-desc">Consulter et traiter les demandes reçues.</div>
                        <a href="${pageContext.request.contextPath}/demandes-adhesion" class="btn-module" style="background:#fef3c7;color:#b45309;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#0284c7;"><i class="bi bi-box-seam"></i></div>
                        <div class="module-title">Demandes matériel</div>
                        <div class="module-desc">Soumettre et gérer les demandes d'équipement.</div>
                        <a href="${pageContext.request.contextPath}/demandes-materiel" class="btn-module" style="background:#e0f2fe;color:#0369a1;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#f1f5f9;color:#334155;"><i class="bi bi-file-earmark-text"></i></div>
                        <div class="module-title">Procès-verbaux</div>
                        <div class="module-desc">Créer et archiver les PV de réunions.</div>
                        <a href="${pageContext.request.contextPath}/pv" class="btn-module" style="background:#f1f5f9;color:#334155;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-award"></i></div>
                        <div class="module-title">Mandats</div>
                        <div class="module-desc">Gérer les mandats du directeur et chefs d'équipe.</div>
                        <a href="${pageContext.request.contextPath}/mandats" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-file-earmark-pdf"></i></div>
                        <div class="module-title">Rapport annuel</div>
                        <div class="module-desc">Générer le rapport d'activité annuel en PDF.</div>
                        <a href="${pageContext.request.contextPath}/rapport" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-search"></i></div>
                        <div class="module-title">Recherche globale</div>
                        <div class="module-desc">Rechercher dans membres, publications, événements.</div>
                        <a href="${pageContext.request.contextPath}/recherche" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#dcfce7;color:#16a34a;"><i class="bi bi-calendar3"></i></div>
                        <div class="module-title">Calendrier</div>
                        <div class="module-desc">Visualiser les événements dans un calendrier.</div>
                        <a href="${pageContext.request.contextPath}/calendrier" class="btn-module" style="background:#dcfce7;color:#15803d;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

                <div class="col-sm-6">
                    <div class="module-card">
                        <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-bell"></i></div>
                        <div class="module-title">Notifications</div>
                        <div class="module-desc">Consulter les alertes et informations importantes.</div>
                        <a href="${pageContext.request.contextPath}/notifications" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                    </div>
                </div>

            </div>
        </div>

        <!-- ACTIVITY - DYNAMIQUE -->
        <div class="col-lg-4">
            <div class="section-title"><i class="bi bi-activity" style="color:var(--accent);"></i> Activités récentes</div>
            <div class="activity-box">
                <% if (activites != null && !activites.isEmpty()) {
                    for (Map<String, String> act : activites) { %>
                <div class="activity-item">
                    <div class="activity-dot" style="background:<%= act.get("bg") %>;color:<%= act.get("color") %>;">
                        <i class="bi <%= act.get("icon") %>"></i>
                    </div>
                    <div>
                        <div class="activity-label"><%= act.get("type") %></div>
                        <div class="activity-time"><%= act.get("date") != null ? act.get("date").substring(0, 10) : "—" %></div>
                    </div>
                </div>
                <% } } else { %>
                <div style="color:var(--muted);font-size:13px;text-align:center;padding:20px 0;">
                    Aucune activité récente.
                </div>
                <% } %>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    const toggle = document.getElementById('sidebarToggle');

    function openSidebar() {
        sidebar.classList.add('open');
        overlay.classList.add('show');
    }

    function closeSidebar() {
        sidebar.classList.remove('open');
        overlay.classList.remove('show');
    }

    // Click sur l'icône brand → toggle
    toggle.addEventListener('click', function(e) {
        e.stopPropagation();
        if (sidebar.classList.contains('open')) {
            closeSidebar();
        } else {
            openSidebar();
        }
    });

    // Click sur overlay → ferme
    overlay.addEventListener('click', closeSidebar);

    // Les links dans sidebar fonctionnent normalement (pas de stopPropagation)
</script>
</body>
</html>
