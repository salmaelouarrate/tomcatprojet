<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Evenement> evenements =
        (java.util.List<com.testweba.model.Evenement>) request.getAttribute("evenements");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Événements publics - LIAS</title>
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

        .event-card {
            background: white; border-radius: 18px; padding: 26px;
            box-shadow: 0 12px 36px rgba(11,47,87,0.1);
            height: 100%; transition: 0.2s;
            border-top: 4px solid #3b82f6;
        }
        .event-card:hover { transform: translateY(-5px); box-shadow: 0 20px 50px rgba(11,47,87,0.15); }

        .event-type-badge {
            display: inline-flex; align-items: center; gap: 6px;
            border-radius: 999px; padding: 6px 14px;
            font-size: 12.5px; font-weight: 700; margin-bottom: 14px;
        }
        .type-conference { background: #dbeafe; color: #1d4ed8; }
        .type-seminaire { background: #dcfce7; color: #15803d; }
        .type-workshop { background: #fef3c7; color: #b45309; }
        .type-default { background: #f1f5f9; color: #334155; }

        .event-title { font-weight: 800; color: #0b2f57; font-size: 18px; margin-bottom: 10px; }
        .event-desc { color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 18px; }

        .event-detail {
            display: flex; align-items: center; gap: 10px;
            font-size: 13.5px; color: #475569;
            padding: 8px 0; border-top: 1px solid #f1f5f9;
        }
        .event-detail:first-of-type { border-top: none; padding-top: 0; }
        .event-detail i { color: #1d6fa5; width: 16px; }

        .empty-state {
            text-align: center; padding: 70px 20px;
            background: white; border-radius: 20px;
            box-shadow: 0 12px 36px rgba(11,47,87,0.08);
        }
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
            <i class="bi bi-calendar-event"></i> Accès public
        </div>
        <h1 class="hero-title">Événements du laboratoire</h1>
        <p class="hero-sub">Conférences, séminaires et workshops organisés par le laboratoire LIAS</p>
    </div>
</div>

<div class="container content-wrapper">
    <div class="row g-4">
        <% if (evenements != null && !evenements.isEmpty()) { %>
            <% for (com.testweba.model.Evenement e : evenements) {
                String type = e.getType() != null ? e.getType() : "";
                String badgeClass = "type-default";
                String icon = "bi-calendar3";
                if ("conference".equalsIgnoreCase(type)) { badgeClass = "type-conference"; icon = "bi-mic"; }
                else if ("seminaire".equalsIgnoreCase(type)) { badgeClass = "type-seminaire"; icon = "bi-easel"; }
                else if ("workshop".equalsIgnoreCase(type)) { badgeClass = "type-workshop"; icon = "bi-tools"; }
            %>
                <div class="col-md-6">
                    <div class="event-card">
                        <span class="event-type-badge <%= badgeClass %>">
                            <i class="bi <%= icon %>"></i> <%= e.getType() %>
                        </span>

                        <div class="event-title"><%= e.getTitre() %></div>

                        <% if (e.getDescription() != null && !e.getDescription().isEmpty()) { %>
                        <p class="event-desc"><%= e.getDescription() %></p>
                        <% } %>

                        <div class="event-detail">
                            <i class="bi bi-calendar3"></i>
                            <span><strong>Date début :</strong> <%= e.getDateDebut() %></span>
                        </div>
                        <div class="event-detail">
                            <i class="bi bi-calendar-check"></i>
                            <span><strong>Date fin :</strong> <%= e.getDateFin() != null ? e.getDateFin() : "-" %></span>
                        </div>
                        <div class="event-detail">
                            <i class="bi bi-geo-alt"></i>
                            <span><strong>Lieu :</strong> <%= e.getLieu() != null ? e.getLieu() : "-" %></span>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="col-12">
                <div class="empty-state">
                    <i class="bi bi-calendar-x d-block"></i>
                    <h5 class="text-muted">Aucun événement disponible</h5>
                </div>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>