<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> historiqueRoles =
        (List<Map<String, String>>) request.getAttribute("historiqueRoles");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> historiqueStatuts =
        (List<Map<String, String>>) request.getAttribute("historiqueStatuts");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> historiqueAffiliations =
        (List<Map<String, String>>) request.getAttribute("historiqueAffiliations");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/membres");
        return;
    }

    int nbRoles = historiqueRoles == null ? 0 : historiqueRoles.size();
    int nbStatuts = historiqueStatuts == null ? 0 : historiqueStatuts.size();
    int nbAffiliations = historiqueAffiliations == null ? 0 : historiqueAffiliations.size();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Historique - <%= membre.getPrenom() %> <%= membre.getNom() %> - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; color: #172033; }

        .page { max-width: 1180px; margin: 0 auto; padding: 36px 18px; }

        .hero {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border-radius: 22px; padding: 34px;
            box-shadow: 0 18px 45px rgba(11,47,87,0.22);
            margin-bottom: 24px; position: relative; overflow: hidden;
        }
        .hero::before {
            content: ''; position: absolute; top: -60px; right: -60px;
            width: 260px; height: 260px; background: rgba(255,255,255,0.06); border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 5; }

        .member-avatar {
            width: 60px; height: 60px; border-radius: 16px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.25);
            display: flex; align-items: center; justify-content: center;
            font-size: 26px; font-weight: 800; flex-shrink: 0;
        }
        .hero h2 { font-weight: 800; margin: 0; font-size: 24px; }
        .hero-info { margin-top: 6px; color: rgba(255,255,255,.8); font-size: 14px; }
        .role-chip-hero {
            background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.3);
            padding: 4px 12px; border-radius: 999px; font-size: 12px; font-weight: 700;
        }

        .btn-back {
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.25);
            color: white; border-radius: 12px; padding: 10px 18px;
            font-weight: 650; text-decoration: none;
            display: inline-flex; align-items: center; gap: 7px; transition: 0.2s;
        }
        .btn-back:hover { background: rgba(255,255,255,0.22); color: white; }
        .btn-add { background: white; color: #0b2f57; border: none; }
        .btn-add:hover { background: #eef4fb; color: #0b2f57; }

        .stat-card {
            background: white; border-radius: 18px; padding: 22px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            height: 100%; transition: 0.2s; border-top: 4px solid #3b82f6;
        }
        .stat-card:hover { transform: translateY(-4px); box-shadow: 0 16px 36px rgba(15,23,42,0.12); }
        .stat-icon {
            width: 46px; height: 46px; border-radius: 14px;
            display: inline-flex; align-items: center; justify-content: center;
            background: #eaf2fb; color: #0b2f57; font-size: 21px; margin-bottom: 14px;
        }
        .stat-label { color: #64748b; font-size: 12.5px; text-transform: uppercase; letter-spacing: 0.4px; font-weight: 700; }
        .stat-value { font-size: 30px; font-weight: 800; color: #0b2f57; margin-top: 4px; }

        .history-card {
            background: white; border-radius: 18px; overflow: hidden;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06); margin-top: 24px;
        }
        .history-head {
            padding: 20px 24px; border-bottom: 1px solid #f1f5f9;
            display: flex; justify-content: space-between; align-items: center; gap: 14px;
        }
        .history-title {
            display: flex; align-items: center; gap: 10px;
            margin: 0; color: #0b2f57; font-weight: 750; font-size: 16px;
        }
        .history-icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 16px;
        }
        .count {
            background: #eaf2fb; color: #0b2f57; padding: 6px 14px;
            border-radius: 999px; font-size: 13px; font-weight: 750; white-space: nowrap;
        }

        .table { margin: 0; }
        .table thead th {
            background: #f8fafc; color: #334155; border-bottom: 1px solid #e5eaf2;
            padding: 14px 18px; font-size: 12px; text-transform: uppercase; letter-spacing: 0.35px; font-weight: 700;
        }
        .table tbody td { padding: 15px 18px; vertical-align: middle; color: #243041; font-size: 14px; }
        .table tbody tr:hover { background: #f8fafc; }

        .pill {
            display: inline-block; background: #f1f5f9; border: 1px solid #e2e8f0;
            color: #0f172a; padding: 6px 12px; border-radius: 999px; font-weight: 650; font-size: 13px;
        }
        .pill-new { background: #ecfdf5; border-color: #bbf7d0; color: #166534; }
        .pill-arrow { color: #94a3b8; margin: 0 6px; }

        .empty { padding: 40px 24px; text-align: center; color: #64748b; }
        .empty i { display: block; font-size: 32px; color: #cbd5e1; margin-bottom: 10px; }
        .empty strong { display: block; color: #1e293b; margin-bottom: 4px; }

        @media (max-width: 768px) {
            .hero { padding: 24px; }
            .history-head { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>

<body>

<div class="page">

    <div class="hero">
        <div class="hero-content d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="member-avatar">
                    <%= membre.getPrenom().substring(0,1).toUpperCase() %><%= membre.getNom().substring(0,1).toUpperCase() %>
                </div>
                <div>
                    <h2>Historique du membre</h2>
                    <div class="hero-info">
                        <strong style="color:white;"><%= membre.getPrenom() %> <%= membre.getNom() %></strong>
                        &nbsp;·&nbsp; ID : <%= membre.getId() %>
                    </div>
                    <div class="mt-2">
                        <span class="role-chip-hero"><i class="bi bi-person-badge me-1"></i><%= membre.getRole() %></span>
                    </div>
                </div>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/membres?action=newAffiliation&id=<%= membre.getId() %>"
                   class="btn-back btn-add">
                    <i class="bi bi-plus-circle"></i> Ajouter affiliation
                </a>
                <a href="${pageContext.request.contextPath}/membres" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Retour aux membres
                </a>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-icon"><i class="bi bi-person-badge"></i></div>
                <div class="stat-label">Changements de rôle</div>
                <div class="stat-value"><%= nbRoles %></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card" style="border-top-color:#10b981;">
                <div class="stat-icon" style="background:#dcfce7;color:#15803d;"><i class="bi bi-toggle-on"></i></div>
                <div class="stat-label">Changements de statut</div>
                <div class="stat-value"><%= nbStatuts %></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card" style="border-top-color:#8b5cf6;">
                <div class="stat-icon" style="background:#f3e8ff;color:#7e22ce;"><i class="bi bi-diagram-3"></i></div>
                <div class="stat-label">Affiliations</div>
                <div class="stat-value"><%= nbAffiliations %></div>
            </div>
        </div>
    </div>

    <div class="history-card">
        <div class="history-head">
            <h5 class="history-title">
                <span class="history-icon" style="background:#dbeafe;color:#1d4ed8;"><i class="bi bi-person-badge"></i></span>
                Historique des rôles
            </h5>
            <span class="count"><%= nbRoles %> modification<%= nbRoles != 1 ? "s" : "" %></span>
        </div>

        <% if (historiqueRoles == null || historiqueRoles.isEmpty()) { %>
            <div class="empty">
                <i class="bi bi-inbox"></i>
                <strong>Aucun changement de rôle</strong>
                Aucun historique de rôle n'a encore été enregistré.
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Évolution</th>
                            <th>Modifié par</th>
                            <th>Date modification</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> h : historiqueRoles) { %>
                            <tr>
                                <td>
                                    <span class="pill"><%= h.get("ancien") %></span>
                                    <i class="bi bi-arrow-right pill-arrow"></i>
                                    <span class="pill pill-new"><%= h.get("nouveau") %></span>
                                </td>
                                <td><%= h.get("modifiePar") %></td>
                                <td><%= h.get("dateModification") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <div class="history-card">
        <div class="history-head">
            <h5 class="history-title">
                <span class="history-icon" style="background:#dcfce7;color:#15803d;"><i class="bi bi-toggle-on"></i></span>
                Historique des statuts
            </h5>
            <span class="count"><%= nbStatuts %> modification<%= nbStatuts != 1 ? "s" : "" %></span>
        </div>

        <% if (historiqueStatuts == null || historiqueStatuts.isEmpty()) { %>
            <div class="empty">
                <i class="bi bi-inbox"></i>
                <strong>Aucun changement de statut</strong>
                Aucun historique de statut n'a encore été enregistré.
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Évolution</th>
                            <th>Modifié par</th>
                            <th>Date modification</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> h : historiqueStatuts) { %>
                            <tr>
                                <td>
                                    <span class="pill"><%= h.get("ancien") %></span>
                                    <i class="bi bi-arrow-right pill-arrow"></i>
                                    <span class="pill pill-new"><%= h.get("nouveau") %></span>
                                </td>
                                <td><%= h.get("modifiePar") %></td>
                                <td><%= h.get("dateModification") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

    <div class="history-card">
        <div class="history-head">
            <h5 class="history-title">
                <span class="history-icon" style="background:#f3e8ff;color:#7e22ce;"><i class="bi bi-diagram-3"></i></span>
                Historique des affiliations
            </h5>
            <span class="count"><%= nbAffiliations %> période<%= nbAffiliations != 1 ? "s" : "" %></span>
        </div>

        <% if (historiqueAffiliations == null || historiqueAffiliations.isEmpty()) { %>
            <div class="empty">
                <i class="bi bi-inbox"></i>
                <strong>Aucune affiliation enregistrée</strong>
                Aucun historique d'affiliation n'a encore été enregistré pour ce membre.
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>Date début</th>
                            <th>Date fin</th>
                            <th>Type</th>
                            <th>Commentaire</th>
                            <th>Modifié par</th>
                            <th>Date modification</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Map<String, String> h : historiqueAffiliations) { %>
                            <tr>
                                <td><%= h.get("dateDebut") %></td>
                                <td>
                                    <% String dateFin = h.get("dateFin"); %>
                                    <% if (dateFin == null || dateFin.isEmpty() || "null".equals(dateFin)) { %>
                                        <span class="pill pill-new"><i class="bi bi-circle-fill" style="font-size:6px;"></i> En cours</span>
                                    <% } else { %>
                                        <span class="pill"><%= dateFin %></span>
                                    <% } %>
                                </td>
                                <td><span class="pill"><%= h.get("typeAffiliation") %></span></td>
                                <td><%= h.get("commentaire") == null ? "-" : h.get("commentaire") %></td>
                                <td><%= h.get("modifiePar") %></td>
                                <td><%= h.get("dateModification") %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>

</div>

</body>
</html>