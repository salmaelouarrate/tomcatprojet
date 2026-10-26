<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Publication> publications =
        (java.util.List<com.testweba.model.Publication>) request.getAttribute("publications");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Publications publiques - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }

        .navbar {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5) !important;
            padding: 16px 0;
            box-shadow: 0 4px 20px rgba(11,47,87,0.15);
        }
        .navbar-brand {
            font-weight: 800; font-size: 19px;
            display: flex; align-items: center; gap: 10px;
        }
        .btn-connexion {
            background: rgba(255,255,255,0.15);
            border: 1.5px solid rgba(255,255,255,0.4);
            color: white; border-radius: 10px;
            padding: 8px 18px; font-weight: 600; font-size: 14px;
            transition: 0.2s;
        }
        .btn-connexion:hover { background: white; color: #0b2f57; }

        .hero-section {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            padding: 50px 0 70px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .hero-section::before {
            content: '';
            position: absolute; top: -50px; right: -50px;
            width: 250px; height: 250px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            padding: 6px 16px; border-radius: 999px;
            font-size: 13px; font-weight: 600; margin-bottom: 16px;
        }
        .hero-title { font-size: 34px; font-weight: 900; margin-bottom: 8px; }
        .hero-sub { opacity: 0.85; font-size: 15px; margin: 0; }

        .content-wrapper { margin-top: -40px; position: relative; z-index: 10; padding-bottom: 60px; }

        .content-card {
            background: white; border-radius: 20px; padding: 8px;
            box-shadow: 0 16px 50px rgba(11,47,87,0.12);
        }

        .table thead th {
            background: #f1f5f9; color: #334155; font-weight: 700;
            border: none; padding: 16px;
            text-transform: uppercase; font-size: 12px; letter-spacing: 0.04em;
        }
        .table tbody td { padding: 16px; vertical-align: middle; border-color: #f1f5f9; }
        .table tbody tr:hover { background: #f8fafc; }

        .type-badge {
            background: #e0f2fe; color: #075985;
            border-radius: 999px; padding: 5px 12px;
            font-size: 12.5px; font-weight: 600;
        }
        .year-badge {
            background: #f1f5f9; color: #334155;
            border-radius: 8px; padding: 4px 10px;
            font-size: 13px; font-weight: 700;
        }
        .link-btn {
            background: #eff6ff; color: #1d6fa5;
            border-radius: 8px; padding: 6px 12px;
            font-size: 13px; font-weight: 600; text-decoration: none;
            display: inline-flex; align-items: center; gap: 5px;
            transition: 0.2s;
        }
        .link-btn:hover { background: #1d6fa5; color: white; }

        .empty-state { text-align: center; padding: 70px 20px; }
        .empty-state i { font-size: 56px; color: #cbd5e1; margin-bottom: 16px; }
    </style>
</head>

<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a href="${pageContext.request.contextPath}/espace-public" class="navbar-brand">
            <i class="bi bi-diagram-3-fill"></i> Laboratoire LIAS
        </a>
        <a href="${pageContext.request.contextPath}/login" class="btn-connexion">
            <i class="bi bi-box-arrow-in-right me-1"></i> Connexion membres
        </a>
    </div>
</nav>

<div class="hero-section">
    <div class="container" style="position:relative;z-index:5;">
        <div class="hero-badge">
            <i class="bi bi-journal-text"></i> Accès public
        </div>
        <h1 class="hero-title">Publications du laboratoire</h1>
        <p class="hero-sub">Liste publique des productions scientifiques du laboratoire LIAS</p>
    </div>
</div>

<div class="container content-wrapper">
    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>Titre</th>
                        <th>Type</th>
                        <th>Année</th>
                        <th>Journal</th>
                        <th>Lien</th>
                    </tr>
                </thead>
                <tbody>
                <% if (publications != null && !publications.isEmpty()) { %>
                    <% for (com.testweba.model.Publication p : publications) { %>
                        <tr>
                            <td><strong style="color:#0b2f57;"><%= p.getTitre() %></strong></td>
                            <td><span class="type-badge"><%= p.getType() %></span></td>
                            <td><span class="year-badge"><%= p.getAnnee() %></span></td>
                            <td style="color:#64748b;"><%= p.getJournal() != null ? p.getJournal() : "-" %></td>
                            <td>
                                <% if (p.getLien() != null && !p.getLien().isEmpty()) { %>
                                    <a href="<%= p.getLien() %>" target="_blank" class="link-btn">
                                        <i class="bi bi-box-arrow-up-right"></i> Voir
                                    </a>
                                <% } else { %>
                                    <span class="text-muted" style="font-size:13px;">-</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="5">
                            <div class="empty-state">
                                <i class="bi bi-journal-x d-block"></i>
                                <h5 class="text-muted">Aucune publication disponible</h5>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>