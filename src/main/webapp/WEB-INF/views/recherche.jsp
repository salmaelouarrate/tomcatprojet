<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) request.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        membreConnecte =
            (com.testweba.model.Membre) session.getAttribute("membreConnecte");
    }

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String query = (String) request.getAttribute("query");
    if (query == null) {
        query = "";
    }

    @SuppressWarnings("unchecked")
    List<Map<String, String>> membres =
        (List<Map<String, String>>) request.getAttribute("membres");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> publications =
        (List<Map<String, String>>) request.getAttribute("publications");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> evenements =
        (List<Map<String, String>>) request.getAttribute("evenements");

    @SuppressWarnings("unchecked")
    List<Map<String, String>> documents =
        (List<Map<String, String>>) request.getAttribute("documents");

    Object totalObj = request.getAttribute("total");
    int total = 0;
    if (totalObj instanceof Integer) total = (Integer) totalObj;

    if (membres == null) membres = new ArrayList<>();
    if (publications == null) publications = new ArrayList<>();
    if (evenements == null) evenements = new ArrayList<>();
    if (documents == null) documents = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Recherche - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }
        .main { margin-left: 260px; padding: 28px; }

        .hero-search {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 100%);
            border-radius: 24px; padding: 40px;
            margin-bottom: 28px; color: white;
            position: relative; overflow: hidden;
            box-shadow: 0 16px 40px rgba(11,47,87,0.25);
        }
        .hero-search::before {
            content: ''; position: absolute; top: -60px; right: -60px;
            width: 260px; height: 260px;
            background: rgba(255,255,255,0.06); border-radius: 50%;
        }
        .hero-search::after {
            content: ''; position: absolute; bottom: -80px; left: 30%;
            width: 200px; height: 200px;
            background: rgba(255,255,255,0.04); border-radius: 50%;
        }
        .hero-content { position: relative; z-index: 5; }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            padding: 6px 16px; border-radius: 999px;
            font-size: 13px; font-weight: 600; margin-bottom: 16px;
        }
        .hero-title { font-size: 28px; font-weight: 900; margin-bottom: 6px; }
        .hero-sub { opacity: 0.8; font-size: 14px; margin-bottom: 24px; }

        .search-form-row { display: flex; gap: 12px; }
        .search-input {
            border: none; border-radius: 14px;
            padding: 16px 20px 16px 50px; font-size: 16px;
            width: 100%; outline: none;
            background: rgba(255,255,255,0.95);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .search-input:focus { box-shadow: 0 0 0 4px rgba(255,255,255,0.25); }
        .btn-search {
            background: white; color: #0b2f57;
            border: none; border-radius: 14px;
            padding: 16px 32px; font-weight: 800; font-size: 15px;
            transition: 0.2s; white-space: nowrap;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }
        .btn-search:hover { transform: translateY(-2px); box-shadow: 0 12px 30px rgba(0,0,0,0.2); }

        .stats-strip {
            display: flex; gap: 16px; margin-top: 24px; flex-wrap: wrap;
        }
        .stat-pill {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 14px; padding: 10px 18px;
            display: flex; align-items: center; gap: 10px;
            font-size: 13px; font-weight: 600;
        }
        .stat-pill .num { font-size: 18px; font-weight: 900; }

        .badge-role { background: #e0f2fe; color: #075985; padding: 8px 12px; border-radius: 999px; font-weight: 600; }

        .result-section {
            background: white; border-radius: 18px; padding: 24px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06); margin-bottom: 20px;
        }
        .section-header {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 16px; padding-bottom: 12px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-icon {
            width: 36px; height: 36px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 16px;
        }
        .section-title { font-weight: 700; color: #0b2f57; font-size: 16px; }
        .count-badge {
            background: #e0f2fe; color: #075985;
            padding: 2px 10px; border-radius: 999px;
            font-size: 12px; font-weight: 700; margin-left: auto;
        }

        .result-item {
            display: flex; align-items: center; gap: 14px;
            padding: 12px 10px; border-radius: 12px;
            transition: 0.2s;
        }
        .result-item:hover { background: #f8fafc; }
        .result-avatar {
            width: 42px; height: 42px; border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; flex-shrink: 0;
        }
        .result-info { flex: 1; }
        .result-info strong { display: block; color: #1e293b; font-size: 14.5px; }
        .result-info span { color: #64748b; font-size: 12.5px; }
        .result-badge { font-size: 11px; padding: 3px 10px; border-radius: 999px; font-weight: 600; }

        .empty-state {
            text-align: center; padding: 70px 20px;
            background: white; border-radius: 20px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
        }
        .empty-state i { font-size: 60px; color: #cbd5e1; margin-bottom: 16px; }

        .view-btn {
            background: #eff6ff; color: #1d6fa5;
            border-radius: 8px; padding: 6px 12px;
            transition: 0.2s; border: none;
        }
        .view-btn:hover { background: #1d6fa5; color: white; }

        @media (max-width: 900px) { .main { margin-left: 230px; } }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="d-flex justify-content-end mb-3">
        <span class="badge-role"><%= membreConnecte.getRole() %></span>
    </div>

    <div class="hero-search">
        <div class="hero-content">
            <div class="hero-badge">
                <i class="bi bi-search"></i> Recherche globale
            </div>
            <div class="hero-title">Trouvez ce que vous cherchez</div>
            <p class="hero-sub">Membres, publications, événements et documents en un seul endroit</p>

            <form action="${pageContext.request.contextPath}/recherche" method="get">
                <div class="search-form-row">
                    <div style="position:relative;flex:1;">
                        <i class="bi bi-search"
                           style="position:absolute;left:18px;top:50%;transform:translateY(-50%);color:#94a3b8;font-size:18px;"></i>
                        <input type="text" name="q" value="<%= query %>"
                               class="search-input"
                               placeholder="Rechercher un membre, publication, événement..."
                               autofocus>
                    </div>
                    <button type="submit" class="btn-search">
                        <i class="bi bi-search me-1"></i> Rechercher
                    </button>
                </div>
            </form>

            <% if (!query.isEmpty() && total > 0) { %>
            <div class="stats-strip">
                <div class="stat-pill"><span class="num"><%= total %></span> résultat<%= total > 1 ? "s" : "" %></div>
                <% if (!membres.isEmpty()) { %><div class="stat-pill"><i class="bi bi-people-fill"></i> <span class="num"><%= membres.size() %></span> membres</div><% } %>
                <% if (!publications.isEmpty()) { %><div class="stat-pill"><i class="bi bi-journal-text"></i> <span class="num"><%= publications.size() %></span> publications</div><% } %>
                <% if (!evenements.isEmpty()) { %><div class="stat-pill"><i class="bi bi-calendar-event"></i> <span class="num"><%= evenements.size() %></span> événements</div><% } %>
                <% if (!documents.isEmpty()) { %><div class="stat-pill"><i class="bi bi-folder2-open"></i> <span class="num"><%= documents.size() %></span> documents</div><% } %>
            </div>
            <% } %>
        </div>
    </div>

    <% if (query.isEmpty()) { %>
        <div class="empty-state">
            <i class="bi bi-search d-block"></i>
            <h5 class="text-muted">Tapez un mot-clé pour rechercher</h5>
            <p class="text-muted" style="font-size:14px;">
                Vous pouvez rechercher dans les membres, publications, événements et documents.
            </p>
        </div>

    <% } else if (total == 0) { %>
        <div class="empty-state">
            <i class="bi bi-emoji-frown d-block"></i>
            <h5 class="text-muted">Aucun résultat pour "<%= query %>"</h5>
            <p class="text-muted" style="font-size:14px;">Essayez avec d'autres mots-clés.</p>
        </div>

    <% } else { %>

        <% if (!membres.isEmpty()) { %>
            <div class="result-section">
                <div class="section-header">
                    <div class="section-icon" style="background:#dbeafe;color:#1d4ed8;"><i class="bi bi-people-fill"></i></div>
                    <span class="section-title">Membres</span>
                    <span class="count-badge"><%= membres.size() %></span>
                </div>
                <% for (Map<String, String> m : membres) { %>
                    <div class="result-item">
                        <div class="result-avatar" style="background:#dbeafe;color:#1d4ed8;"><i class="bi bi-person-fill"></i></div>
                        <div class="result-info">
                            <strong><%= m.get("nom") %></strong>
                            <span><%= m.get("email") %></span>
                        </div>
                        <span class="result-badge" style="background:#e0f2fe;color:#075985;"><%= m.get("role") %></span>
                        <a href="${pageContext.request.contextPath}/membres?action=edit&id=<%= m.get("id") %>" class="btn btn-sm view-btn ms-2">
                            <i class="bi bi-eye"></i>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

        <% if (!publications.isEmpty()) { %>
            <div class="result-section">
                <div class="section-header">
                    <div class="section-icon" style="background:#dcfce7;color:#15803d;"><i class="bi bi-journal-text"></i></div>
                    <span class="section-title">Publications</span>
                    <span class="count-badge"><%= publications.size() %></span>
                </div>
                <% for (Map<String, String> p : publications) { %>
                    <div class="result-item">
                        <div class="result-avatar" style="background:#dcfce7;color:#15803d;"><i class="bi bi-journal-text"></i></div>
                        <div class="result-info">
                            <strong><%= p.get("titre") %></strong>
                            <span><%= p.get("type") %> · <%= p.get("annee") %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/publications" class="btn btn-sm view-btn ms-2">
                            <i class="bi bi-eye"></i>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

        <% if (!evenements.isEmpty()) { %>
            <div class="result-section">
                <div class="section-header">
                    <div class="section-icon" style="background:#fef3c7;color:#b45309;"><i class="bi bi-calendar-event"></i></div>
                    <span class="section-title">Événements</span>
                    <span class="count-badge"><%= evenements.size() %></span>
                </div>
                <% for (Map<String, String> e : evenements) { %>
                    <div class="result-item">
                        <div class="result-avatar" style="background:#fef3c7;color:#b45309;"><i class="bi bi-calendar-event"></i></div>
                        <div class="result-info">
                            <strong><%= e.get("titre") %></strong>
                            <span><%= e.get("type") %> · <%= e.get("date") %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/evenements" class="btn btn-sm view-btn ms-2">
                            <i class="bi bi-eye"></i>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

        <% if (!documents.isEmpty()) { %>
            <div class="result-section">
                <div class="section-header">
                    <div class="section-icon" style="background:#fee2e2;color:#b91c1c;"><i class="bi bi-folder2-open"></i></div>
                    <span class="section-title">Documents</span>
                    <span class="count-badge"><%= documents.size() %></span>
                </div>
                <% for (Map<String, String> d : documents) { %>
                    <div class="result-item">
                        <div class="result-avatar" style="background:#fee2e2;color:#b91c1c;"><i class="bi bi-file-earmark-text"></i></div>
                        <div class="result-info">
                            <strong><%= d.get("titre") %></strong>
                            <span><%= d.get("type") %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/documents" class="btn btn-sm view-btn ms-2">
                            <i class="bi bi-eye"></i>
                        </a>
                    </div>
                <% } %>
            </div>
        <% } %>

    <% } %>

</div>

</body>
</html>