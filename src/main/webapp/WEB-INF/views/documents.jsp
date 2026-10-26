<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String role = membreConnecte.getRole();
    if (role == null) role = "";
    role = role.toLowerCase();

    boolean isAdmin = "admin".equals(role) || "directeur".equals(role);
    boolean isChef = "chef_equipe".equals(role);
    boolean isDoctorant = "doctorant".equals(role);
    boolean isMembre = "membre".equals(role);

    if (isDoctorant) {
        response.sendRedirect(request.getContextPath() + "/espace-doctorant");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Document> documents =
        (java.util.List<com.testweba.model.Document>) request.getAttribute("documents");

    com.testweba.dao.DocumentDAO documentDAOJsp = new com.testweba.dao.DocumentDAO();

    java.util.Map<String, Integer> compteParType = new java.util.LinkedHashMap<>();
    if (documents != null) {
        for (com.testweba.model.Document d : documents) {
            String t = d.getType() != null ? d.getType() : "autre";
            compteParType.put(t, compteParType.getOrDefault(t, 0) + 1);
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Documents - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .main { margin-left: 260px; padding: 28px; }

        .hero-card {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border-radius: 22px; padding: 32px; margin-bottom: 24px;
            color: white; position: relative; overflow: hidden;
            box-shadow: 0 16px 40px rgba(11,47,87,0.22);
        }
        .hero-card::before {
            content: ''; position: absolute; top: -50px; right: -50px;
            width: 220px; height: 220px; background: rgba(255,255,255,0.06); border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 5; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; }
        .hero-title { font-size: 24px; font-weight: 800; margin-bottom: 6px; }
        .hero-sub { opacity: 0.8; font-size: 14px; margin: 0; }

        .btn-add-doc {
            background: white; color: #0b2f57; border: none;
            border-radius: 12px; padding: 12px 24px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.2s;
            text-decoration: none; box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-add-doc:hover { transform: translateY(-2px); color: #0b2f57; }

        .stats-row { display: flex; gap: 16px; margin-top: 20px; flex-wrap: wrap; }
        .stat-pill {
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
            border-radius: 14px; padding: 10px 18px;
            display: flex; align-items: center; gap: 10px; font-size: 13px; font-weight: 600;
        }
        .stat-pill .num { font-size: 18px; font-weight: 900; }

        .content-card {
            background: white; border-radius: 18px; padding: 8px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
        }
        .table thead th {
            background: #f1f5f9; color: #334155; font-weight: 700;
            padding: 14px 16px; border: none; text-transform: uppercase;
            font-size: 11.5px; letter-spacing: 0.04em;
        }
        .table tbody td { padding: 14px 16px; vertical-align: middle; }
        .table tbody tr:hover { background: #f8fafc; }

        .doc-icon {
            width: 38px; height: 38px; border-radius: 10px;
            background: #fee2e2; color: #b91c1c;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 16px; margin-right: 10px; flex-shrink: 0;
        }
        .type-badge {
            background: #fee2e2; color: #991b1b; border-radius: 999px;
            padding: 6px 12px; font-size: 12.5px; font-weight: 700;
        }
        .path-cell {
            max-width: 240px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .path-cell a { color: #1d6fa5; font-size: 13px; text-decoration: none; }
        .path-cell a:hover { text-decoration: underline; }

        .event-badge {
            background: #e0f2fe; color: #075985; border-radius: 999px;
            padding: 6px 12px; font-size: 12px; font-weight: 600;
            display: inline-flex; align-items: center; gap: 5px;
        }
        .no-event { color: #94a3b8; font-size: 12.5px; }
        .meta-cell { color: #64748b; font-size: 13px; }

        .action-btn {
            width: 34px; height: 34px; border-radius: 9px;
            display: inline-flex; align-items: center; justify-content: center;
            transition: 0.2s; border: 1.5px solid;
        }

        .empty-state { text-align: center; padding: 70px 20px; }
        .empty-state i { font-size: 56px; color: #cbd5e1; margin-bottom: 16px; }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="hero-card">
        <div class="hero-content">
            <div>
                <div class="hero-title"><i class="bi bi-folder2-open me-2"></i>Gestion des documents</div>
                <p class="hero-sub">Archivage des fichiers du laboratoire LIAS</p>
            </div>
            <% if (isAdmin || isChef) { %>
            <a href="${pageContext.request.contextPath}/documents?action=new" class="btn-add-doc">
                <i class="bi bi-plus-circle"></i> Ajouter document
            </a>
            <% } %>
        </div>

        <div class="stats-row">
            <div class="stat-pill">
                <i class="bi bi-files"></i>
                <span class="num"><%= documents != null ? documents.size() : 0 %></span> documents
            </div>
            <% for (Map.Entry<String, Integer> entry : compteParType.entrySet()) { %>
            <div class="stat-pill">
                <i class="bi bi-file-earmark"></i>
                <span class="num"><%= entry.getValue() %></span> <%= entry.getKey() %>
            </div>
            <% } %>
        </div>
    </div>

    <div class="content-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Nom</th>
                        <th>Type</th>
                        <th>Chemin / Lien</th>
                        <th>Événement</th>
                        <th>Ajouté par</th>
                        <th>Date ajout</th>
                        <% if (isAdmin || isChef) { %>
                            <th>Actions</th>
                        <% } %>
                    </tr>
                </thead>

                <tbody>
                <% if (documents != null && !documents.isEmpty()) { %>
                    <% for (com.testweba.model.Document d : documents) {
                        String nomEvenement = documentDAOJsp.getNomEvenement(d.getEvenementId());
                    %>
                        <tr>
                            <td style="color:#94a3b8;font-weight:600;"><%= d.getId() %></td>

                            <td>
                                <span class="doc-icon"><i class="bi bi-file-earmark-text"></i></span>
                                <strong style="color:#0b2f57;"><%= d.getNom() %></strong>
                            </td>

                            <td><span class="type-badge"><%= d.getType() %></span></td>

                            <td class="path-cell">
                                <% if (d.getChemin() != null && !d.getChemin().isEmpty()) { %>
                                    <a href="<%= d.getChemin() %>" target="_blank">
                                        <i class="bi bi-box-arrow-up-right me-1"></i><%= d.getChemin() %>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">-</span>
                                <% } %>
                            </td>

                            <td>
                                <% if (nomEvenement != null) { %>
                                    <span class="event-badge">
                                        <i class="bi bi-calendar-event"></i> <%= nomEvenement %>
                                    </span>
                                <% } else { %>
                                    <span class="no-event">Aucun</span>
                                <% } %>
                            </td>

                            <td class="meta-cell"><%= d.getUploadedBy() != null ? d.getUploadedBy() : "-" %></td>
                            <td class="meta-cell"><%= d.getUploadedAt() != null ? d.getUploadedAt() : "-" %></td>

                            <% if (isAdmin || isChef) { %>
                                <td>
                                    <a href="${pageContext.request.contextPath}/documents?action=delete&id=<%= d.getId() %>"
                                       class="action-btn" style="border-color:#fee2e2;color:#dc2626;background:#fef2f2;"
                                       onclick="return confirm('Voulez-vous vraiment supprimer ce document ?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            <% } %>
                        </tr>
                    <% } %>
                <% } else { %>
                    <tr>
                        <td colspan="<%= (isAdmin || isChef) ? 8 : 7 %>">
                            <div class="empty-state">
                                <i class="bi bi-folder2-open d-block"></i>
                                <h5 class="text-muted">Aucun document archivé</h5>
                                <% if (isAdmin || isChef) { %>
                                <a href="${pageContext.request.contextPath}/documents?action=new"
                                   class="btn btn-primary mt-3" style="border-radius:12px;">
                                    <i class="bi bi-plus-circle me-1"></i> Ajouter un document
                                </a>
                                <% } %>
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