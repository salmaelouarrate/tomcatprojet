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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Vice-Directeur - LIAS</title>

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
            overflow: hidden;
            box-shadow: 4px 0 32px rgba(11,47,87,0.18);
        }

        .sidebar:hover,
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

        .sidebar:hover .brand-text,
        .sidebar.open .brand-text {
            opacity: 1;
            transform: translateX(0);
        }

        .nav-section {
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.1em;
            color: rgba(255,255,255,0.3);
            padding: 14px 14px 6px;
            white-space: nowrap;
            overflow: hidden;
            opacity: 0;
            height: 0;
            transition: opacity var(--transition), height var(--transition);
        }

        .sidebar:hover .nav-section,
        .sidebar.open .nav-section {
            opacity: 1;
            height: 32px;
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

        .sidebar:hover .nav-link-text,
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

        .sidebar-footer {
            margin-top: auto;
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

        .info-banner {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            border-radius: 16px;
            padding: 18px 22px;
            margin-bottom: 24px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            color: #0b2f57;
            font-size: 13.5px;
            line-height: 1.6;
        }

        .info-banner i {
            font-size: 20px;
            color: #1d6fa5;
            margin-top: 2px;
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

        @media (max-width: 768px) {
            .main { margin-left: var(--sidebar-width); padding: 16px; }
            .welcome-hero { padding: 24px 22px; }
            .hero-greeting { font-size: 22px; }
        }
    </style>
</head>
<body>

<!-- ═══════════════════════════════ SIDEBAR ═══════════════════════════════ -->
<nav class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="bi bi-diagram-3-fill"></i></div>
        <span class="brand-text">LIAS Lab</span>
    </div>

    <div class="nav-section">PRINCIPAL</div>

    <a href="${pageContext.request.contextPath}/espace-vice-doyen" class="nav-link-item active">
        <i class="bi bi-speedometer2"></i>
        <span class="nav-link-text">Tableau de bord</span>
    </a>

    <a href="${pageContext.request.contextPath}/mon-profil" class="nav-link-item">
        <i class="bi bi-person-circle"></i>
        <span class="nav-link-text">Mon profil</span>
    </a>

    <div class="nav-section">CONSULTATION</div>

    <a href="${pageContext.request.contextPath}/membres" class="nav-link-item">
        <i class="bi bi-people"></i>
        <span class="nav-link-text">Membres</span>
    </a>

    <a href="${pageContext.request.contextPath}/publications" class="nav-link-item">
        <i class="bi bi-journal-text"></i>
        <span class="nav-link-text">Publications</span>
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

    <div class="nav-section">SUPERVISION</div>

    <a href="${pageContext.request.contextPath}/evenements" class="nav-link-item">
        <i class="bi bi-calendar-event"></i>
        <span class="nav-link-text">Événements</span>
    </a>

    <a href="${pageContext.request.contextPath}/pv" class="nav-link-item">
        <i class="bi bi-file-earmark-text"></i>
        <span class="nav-link-text">Procès-verbaux</span>
    </a>

    <a href="${pageContext.request.contextPath}/rapport" class="nav-link-item">
        <i class="bi bi-file-earmark-pdf"></i>
        <span class="nav-link-text">Rapport annuel</span>
    </a>

    <div class="nav-section">OUTILS</div>

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

    <div class="nav-divider"></div>

    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link-item" style="color:rgba(252,165,165,0.8);">
            <i class="bi bi-box-arrow-right"></i>
            <span class="nav-link-text">Déconnexion</span>
        </a>
    </div>
</nav>

<!-- ═══════════════════════════════ MAIN ════════════════════════════════ -->
<div class="main">

    <!-- TOPBAR -->
    <div class="topbar animate d1">
        <div>
            <h1 class="topbar-title">Espace Vice-Directeur</h1>
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
            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#e0e7ff;color:#4f46e5;"><i class="bi bi-chat-dots"></i></div>
                    <div class="module-title">Messagerie</div>
                    <div class="module-desc">Échanger avec les membres du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/messages" class="btn-module" style="background:#e0e7ff;color:#4338ca;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>

    <!-- HERO -->
    <div class="welcome-hero animate d2">
        <div class="hero-badge"><i class="bi bi-circle-fill" style="font-size:7px;color:#4ade80;"></i> Connecté</div>
        <div class="hero-greeting">Bonjour, <%= membre.getPrenom() %> 👋</div>
        <p class="hero-sub">
            Bienvenue dans votre espace Vice-Directeur. Vous assistez le directeur dans la
            supervision des événements, des publications, des conventions et du rapport annuel
            du laboratoire LIAS.
        </p>
    </div>

    <!-- INFO BANNER -->
    <div class="info-banner animate d3">
        <i class="bi bi-info-circle-fill"></i>
        <div>
            La validation des demandes d'adhésion et des demandes de matériel reste réservée
            au <strong>Directeur en mandat</strong>. Votre rôle se concentre sur la
            consultation, la supervision des événements et l'appui à la production du
            rapport annuel.
        </div>
    </div>

    <!-- MODULES -->
    <div class="animate d4">
        <div class="section-title"><i class="bi bi-grid-1x2" style="color:var(--accent);"></i> Modules disponibles</div>
        <div class="row g-3">

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-person-circle"></i></div>
                    <div class="module-title">Mon profil</div>
                    <div class="module-desc">Consulter et modifier mes informations personnelles.</div>
                    <a href="${pageContext.request.contextPath}/mon-profil" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-people"></i></div>
                    <div class="module-title">Membres</div>
                    <div class="module-desc">Consulter les profils et le statut des membres du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/membres" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#dcfce7;color:#16a34a;"><i class="bi bi-journal-text"></i></div>
                    <div class="module-title">Publications</div>
                    <div class="module-desc">Consulter les publications scientifiques du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/publications" class="btn-module" style="background:#dcfce7;color:#15803d;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#fef3c7;color:#b45309;"><i class="bi bi-calendar-event"></i></div>
                    <div class="module-title">Événements</div>
                    <div class="module-desc">Superviser l'organisation des conférences, séminaires et workshops.</div>
                    <a href="${pageContext.request.contextPath}/evenements" class="btn-module" style="background:#fef3c7;color:#b45309;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-folder2-open"></i></div>
                    <div class="module-title">Documents</div>
                    <div class="module-desc">Consulter les documents et archives du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/documents" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#e0f2fe;color:#0284c7;"><i class="bi bi-pc-display"></i></div>
                    <div class="module-title">Matériel</div>
                    <div class="module-desc">Consulter l'état et la distribution du matériel du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/materiel" class="btn-module" style="background:#e0f2fe;color:#0369a1;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#f3e8ff;color:#9333ea;"><i class="bi bi-building"></i></div>
                    <div class="module-title">Conventions</div>
                    <div class="module-desc">Consulter les conventions et partenariats du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/conventions" class="btn-module" style="background:#f3e8ff;color:#7e22ce;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#f1f5f9;color:#334155;"><i class="bi bi-file-earmark-text"></i></div>
                    <div class="module-title">Procès-verbaux</div>
                    <div class="module-desc">Consulter et archiver les PV de réunions.</div>
                    <a href="${pageContext.request.contextPath}/pv" class="btn-module" style="background:#f1f5f9;color:#334155;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-file-earmark-pdf"></i></div>
                    <div class="module-title">Rapport annuel</div>
                    <div class="module-desc">Appuyer le directeur dans la production du rapport d'activité annuel.</div>
                    <a href="${pageContext.request.contextPath}/rapport" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#e0f2fe;color:#075985;"><i class="bi bi-search"></i></div>
                    <div class="module-title">Recherche globale</div>
                    <div class="module-desc">Rechercher dans membres, publications, documents et événements.</div>
                    <a href="${pageContext.request.contextPath}/recherche" class="btn-module" style="background:#e0f2fe;color:#075985;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#dcfce7;color:#16a34a;"><i class="bi bi-calendar3"></i></div>
                    <div class="module-title">Calendrier</div>
                    <div class="module-desc">Visualiser le calendrier des événements du laboratoire.</div>
                    <a href="${pageContext.request.contextPath}/calendrier" class="btn-module" style="background:#dcfce7;color:#15803d;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

            <div class="col-sm-6 col-lg-3">
                <div class="module-card">
                    <div class="module-icon-wrap" style="background:#fee2e2;color:#dc2626;"><i class="bi bi-bell"></i></div>
                    <div class="module-title">Notifications</div>
                    <div class="module-desc">Consulter les alertes et informations importantes.</div>
                    <a href="${pageContext.request.contextPath}/notifications" class="btn-module" style="background:#fee2e2;color:#b91c1c;">Ouvrir <i class="bi bi-arrow-right"></i></a>
                </div>
            </div>

        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const sidebar = document.getElementById('sidebar');
    sidebar.addEventListener('mouseenter', () => sidebar.classList.add('open'));
    sidebar.addEventListener('mouseleave', () => sidebar.classList.remove('open'));
</script>
</body>
</html>
