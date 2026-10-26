<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");
    if (membreConnecte == null)
        membreConnecte = (com.testweba.model.Membre) session.getAttribute("membre");
    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    int anneeActuelle = java.time.Year.now().getValue();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport annuel - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }

        .sidebar {
            width: 260px; min-height: 100vh; background: #0b2f57;
            position: fixed; left: 0; top: 0; color: white;
            padding: 24px 18px; overflow-y: auto;
        }
        .sidebar .brand { font-size: 22px; font-weight: 700; margin-bottom: 35px; }
        .sidebar a {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px; color: #dbeafe; text-decoration: none;
            border-radius: 10px; margin-bottom: 8px; transition: 0.2s;
        }
        .sidebar a:hover, .sidebar a.active { background: #174a7c; color: white; }

        .main { margin-left: 260px; padding: 28px; }

        .topbar {
            background: white; border-radius: 16px; padding: 18px 24px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06); margin-bottom: 28px;
        }

        .hero-card {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 100%);
            border-radius: 24px; padding: 48px; color: white;
            text-align: center; margin-bottom: 32px;
            box-shadow: 0 20px 60px rgba(11,47,87,0.3);
            position: relative; overflow: hidden;
        }
        .hero-card::before {
            content: '';
            position: absolute; top: -50px; right: -50px;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
        }
        .hero-card::after {
            content: '';
            position: absolute; bottom: -80px; left: -30px;
            width: 250px; height: 250px;
            background: rgba(255,255,255,0.03);
            border-radius: 50%;
        }
        .hero-icon {
            width: 80px; height: 80px; background: rgba(255,255,255,0.15);
            border-radius: 20px; display: flex; align-items: center;
            justify-content: center; margin: 0 auto 20px; font-size: 36px;
        }
        .hero-title { font-size: 32px; font-weight: 800; margin-bottom: 8px; }
        .hero-subtitle { font-size: 16px; opacity: 0.8; margin-bottom: 32px; }

        .year-selector {
            background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 16px; padding: 24px 32px;
            display: inline-block; backdrop-filter: blur(10px);
        }
        .year-selector label {
            font-size: 14px; font-weight: 600;
            opacity: 0.9; margin-bottom: 12px; display: block;
        }
        .year-input {
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.4);
            border-radius: 12px; padding: 10px 20px;
            color: white; font-size: 18px; font-weight: 700;
            width: 120px; text-align: center;
        }
        .year-input:focus {
            outline: none;
            border-color: rgba(255,255,255,0.8);
            background: rgba(255,255,255,0.3);
        }
        .year-input option { color: #0b2f57; background: white; }

        .btn-generate {
            background: white; color: #0b2f57;
            border: none; border-radius: 14px;
            padding: 14px 32px; font-size: 16px; font-weight: 700;
            transition: 0.2s; margin-top: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        .btn-generate:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.3);
            color: #0b2f57;
        }
        .btn-generate i { margin-right: 8px; }

        .info-cards { margin-bottom: 28px; }
        .info-card {
            background: white; border-radius: 18px; padding: 24px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            height: 100%; border-top: 4px solid;
            transition: 0.2s;
        }
        .info-card:hover { transform: translateY(-4px); }
        .info-card .icon {
            width: 48px; height: 48px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; margin-bottom: 14px;
        }
        .info-card h4 { font-size: 14px; color: #64748b; margin-bottom: 4px; }
        .info-card h2 { font-size: 28px; font-weight: 800; margin: 0; }

        .steps-card {
            background: white; border-radius: 18px; padding: 28px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
        }
        .step-item {
            display: flex; align-items: flex-start; gap: 16px;
            padding: 16px 0; border-bottom: 1px solid #f1f5f9;
        }
        .step-item:last-child { border-bottom: none; }
        .step-num {
            width: 36px; height: 36px; border-radius: 10px;
            background: #0b2f57; color: white;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 14px; flex-shrink: 0;
        }
        .step-text h6 { margin: 0 0 4px; font-weight: 700; color: #1e293b; }
        .step-text p { margin: 0; font-size: 13px; color: #64748b; }

        .badge-role {
            background: #e0f2fe; color: #075985;
            padding: 8px 12px; border-radius: 999px; font-weight: 600;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand"><i class="bi bi-diagram-3-fill"></i> LIAS</div>
    <a href="${pageContext.request.contextPath}/dashboard">
        <i class="bi bi-speedometer2"></i> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/membres">
        <i class="bi bi-people"></i> Membres
    </a>
    <a href="${pageContext.request.contextPath}/publications">
        <i class="bi bi-journal-text"></i> Publications
    </a>
    <a href="${pageContext.request.contextPath}/evenements">
        <i class="bi bi-calendar-event"></i> Événements
    </a>
    <a href="${pageContext.request.contextPath}/documents">
        <i class="bi bi-folder2-open"></i> Documents
    </a>
    <a href="${pageContext.request.contextPath}/materiel">
        <i class="bi bi-pc-display"></i> Matériel
    </a>
    <a href="${pageContext.request.contextPath}/conventions">
        <i class="bi bi-building"></i> Conventions
    </a>
    <a href="${pageContext.request.contextPath}/demandes-adhesion">
        <i class="bi bi-inbox"></i> Demandes d'adhésion
    </a>
    <a href="${pageContext.request.contextPath}/pv">
        <i class="bi bi-file-earmark-text"></i> Procès-verbaux
    </a>
    <a href="${pageContext.request.contextPath}/rapport" class="active">
        <i class="bi bi-file-earmark-pdf"></i> Rapport annuel
    </a>
    <a href="${pageContext.request.contextPath}/logout">
        <i class="bi bi-box-arrow-right"></i> Déconnexion
    </a>
</div>

<div class="main">

    <div class="topbar">
        <div>
            <h5 class="mb-0">Rapport d'activité annuel</h5>
            <small class="text-muted">Génération automatique du rapport PDF</small>
        </div>
        <div class="d-flex align-items-center gap-3">
            <span class="badge-role"><%= membreConnecte.getRole() %></span>
            <div class="text-end">
                <strong><%= membreConnecte.getNomComplet() %></strong><br>
                <small class="text-muted"><%= membreConnecte.getEmail() %></small>
            </div>
        </div>
    </div>

    <!-- Hero -->
    <div class="hero-card">
        <div class="hero-icon">
            <i class="bi bi-file-earmark-pdf"></i>
        </div>
        <div class="hero-title">Rapport annuel LIAS</div>
        <div class="hero-subtitle">
            Générez automatiquement le rapport d'activité complet du laboratoire
        </div>

        <div class="year-selector">
            <form action="${pageContext.request.contextPath}/rapport" method="get"
                  class="d-flex flex-column align-items-center gap-3">
                <label>Sélectionnez l'année</label>
                <select name="annee" class="year-input">
                    <% for (int y = anneeActuelle; y >= anneeActuelle - 5; y--) { %>
                        <option value="<%= y %>"><%= y %></option>
                    <% } %>
                </select>
                <button type="submit" class="btn btn-generate">
                    <i class="bi bi-download"></i> Télécharger le rapport PDF
                </button>
            </form>
        </div>
    </div>

    <div class="row g-4 info-cards">
        <div class="col-md-3">
            <div class="info-card" style="border-color:#3b82f6;">
                <div class="icon" style="background:#dbeafe;color:#1d4ed8;">
                    <i class="bi bi-people-fill"></i>
                </div>
                <h4>Membres actifs</h4>
                <h2 style="color:#1d4ed8;">inclus</h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="info-card" style="border-color:#22c55e;">
                <div class="icon" style="background:#dcfce7;color:#15803d;">
                    <i class="bi bi-journal-check"></i>
                </div>
                <h4>Publications</h4>
                <h2 style="color:#15803d;">inclus</h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="info-card" style="border-color:#f59e0b;">
                <div class="icon" style="background:#fef3c7;color:#b45309;">
                    <i class="bi bi-calendar-event"></i>
                </div>
                <h4>Événements</h4>
                <h2 style="color:#b45309;">inclus</h2>
            </div>
        </div>
        <div class="col-md-3">
            <div class="info-card" style="border-color:#8b5cf6;">
                <div class="icon" style="background:#f3e8ff;color:#7e22ce;">
                    <i class="bi bi-building"></i>
                </div>
                <h4>Conventions</h4>
                <h2 style="color:#7e22ce;">inclus</h2>
            </div>
        </div>
    </div>

    <div class="steps-card">
        <h5 class="mb-3 fw-bold" style="color:#0b2f57;">
            <i class="bi bi-info-circle me-2"></i>Contenu du rapport
        </h5>
        <div class="step-item">
            <div class="step-num">1</div>
            <div class="step-text">
                <h6>Statistiques générales</h6>
                <p>Nombre de membres, publications, événements, documents, conventions et matériels</p>
            </div>
        </div>
        <div class="step-item">
            <div class="step-num">2</div>
            <div class="step-text">
                <h6>Liste des membres actifs</h6>
                <p>Nom, email, statut et rôle de chaque membre du laboratoire</p>
            </div>
        </div>
        <div class="step-item">
            <div class="step-num">3</div>
            <div class="step-text">
                <h6>Publications de l'année</h6>
                <p>Titre, type et année de toutes les publications</p>
            </div>
        </div>
        <div class="step-item">
            <div class="step-num">4</div>
            <div class="step-text">
                <h6>Événements de l'année</h6>
                <p>Conférences, séminaires et workshops organisés</p>
            </div>
        </div>
    </div>

</div>

</body>
</html>