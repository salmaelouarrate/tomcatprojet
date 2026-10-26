<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Notification> notifications =
        (java.util.List<com.testweba.model.Notification>) request.getAttribute("notifications");

    Integer nonLues = (Integer) request.getAttribute("nonLues");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String role = membre.getRole() == null ? "" : membre.getRole().toLowerCase();
    boolean isAdmin = role.equals("directeur") || role.equals("admin");
    boolean isChef = role.equals("chef_equipe");
    boolean isDoctorant = role.equals("doctorant");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Notifications - LIAS</title>

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

        .sidebar {
            width: 260px;
            min-height: 100vh;
            background: linear-gradient(180deg, #0b2f57 0%, #123f73 100%);
            position: fixed;
            left: 0;
            top: 0;
            color: white;
            padding: 26px 18px;
            overflow-y: auto;
            box-shadow: 4px 0 24px rgba(11,47,87,0.15);
        }

        .sidebar .brand {
            font-size: 21px;
            font-weight: 800;
            margin-bottom: 36px;
            letter-spacing: -0.5px;
        }

        .sidebar a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 14px;
            color: rgba(255,255,255,0.75);
            text-decoration: none;
            border-radius: 12px;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 14px;
            transition: 0.2s;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.08);
            color: white;
        }

        .sidebar a.active {
            background: linear-gradient(135deg, #1d6fa5, #0ea5e9);
            color: white;
            box-shadow: 0 6px 18px rgba(14,165,233,0.35);
        }

        .main {
            margin-left: 260px;
            padding: 30px 32px;
        }

        .topbar {
            background: white;
            border-radius: 20px;
            padding: 22px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            margin-bottom: 26px;
            border: 1px solid #edf2f7;
        }

        .topbar h5 {
            font-weight: 800;
            color: #0b2f57;
            margin-bottom: 4px;
            font-size: 19px;
        }

        .topbar small {
            color: #64748b;
            font-weight: 500;
        }

        .badge-role {
            background: #e0f2fe;
            color: #075985;
            padding: 8px 16px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 13px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            font-weight: 700;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 26px;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
        }

        .stat-card h3 {
            font-weight: 900;
            color: #0b2f57;
            font-size: 28px;
            margin-bottom: 2px;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            background: #dbeafe;
            color: #1d4ed8;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            margin-bottom: 14px;
        }

        .content-card {
            background: white;
            border-radius: 22px;
            padding: 26px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
        }

        .notification-item {
            border: 1px solid #edf2f7;
            border-radius: 18px;
            padding: 18px 20px;
            margin-bottom: 14px;
            display: flex;
            justify-content: space-between;
            gap: 18px;
            background: #ffffff;
            transition: 0.2s;
        }

        .notification-item:hover {
            box-shadow: 0 6px 20px rgba(15,23,42,0.07);
        }

        .notification-item.unread {
            border-color: #bae6fd;
            background: linear-gradient(135deg, #f0f9ff, #eff6ff);
        }

        .notification-icon {
            width: 44px;
            height: 44px;
            border-radius: 14px;
            background: #e0f2fe;
            color: #075985;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 20px;
        }

        .notification-body {
            display: flex;
            gap: 14px;
            flex: 1;
        }

        .notification-message {
            font-weight: 700;
            color: #0b2f57;
            margin-bottom: 5px;
            font-size: 15px;
        }

        .notification-date {
            color: #64748b;
            font-size: 13px;
            font-weight: 500;
        }

        .badge.bg-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5) !important;
            border-radius: 999px;
            font-weight: 600;
        }

        .badge.bg-secondary {
            background: #e2e8f0 !important;
            color: #475569;
            border-radius: 999px;
            font-weight: 600;
        }

        .notification-actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-shrink: 0;
        }

        .btn-outline-primary {
            border-color: #c7e0f4;
            color: #1d6fa5;
            border-radius: 10px;
        }

        .btn-outline-primary:hover {
            background: #1d6fa5;
            border-color: #1d6fa5;
        }

        .btn-outline-danger {
            border-radius: 10px;
        }

        .empty-box {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }

        .empty-box i {
            font-size: 48px;
            color: #cbd5e1;
            margin-bottom: 14px;
            display: block;
        }

        .empty-box h5 {
            color: #0b2f57;
            font-weight: 800;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main {
                margin-left: 0;
                padding: 18px;
            }

            .topbar {
                flex-direction: column;
                align-items: flex-start;
                gap: 14px;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            .notification-item {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="topbar">
        <div>
            <h5 class="mb-0">Notifications</h5>
            <small class="text-muted">Vos alertes et informations importantes</small>
        </div>

        <div class="d-flex align-items-center gap-3">
            <% if (nonLues != null && nonLues > 0) { %>
                <a href="${pageContext.request.contextPath}/notifications?action=readAll"
                   class="btn btn-sm btn-primary">
                    <i class="bi bi-check2-all"></i> Tout marquer comme lu
                </a>
            <% } %>

            <span class="badge-role"><%= membre.getRole() %></span>
        </div>
    </div>

    <div class="stats-row">
        <div class="stat-card">
            <div class="stat-icon">
                <i class="bi bi-bell-fill"></i>
            </div>
            <h3><%= notifications == null ? 0 : notifications.size() %></h3>
            <p class="text-muted mb-0">Notifications totales</p>
        </div>

        <div class="stat-card">
            <div class="stat-icon" style="background:#fee2e2;color:#b91c1c;">
                <i class="bi bi-envelope-exclamation"></i>
            </div>
            <h3><%= nonLues == null ? 0 : nonLues %></h3>
            <p class="text-muted mb-0">Non lues</p>
        </div>
    </div>

    <div class="content-card">

        <% if (notifications != null && !notifications.isEmpty()) { %>

            <% for (com.testweba.model.Notification n : notifications) { %>
                <div class="notification-item <%= n.isLue() ? "" : "unread" %>">
                    <div class="notification-body">
                        <div class="notification-icon">
                            <% if (n.isLue()) { %>
                                <i class="bi bi-bell"></i>
                            <% } else { %>
                                <i class="bi bi-bell-fill"></i>
                            <% } %>
                        </div>

                        <div>
                            <div class="notification-message">
                                <%= n.getMessage() %>
                            </div>

                            <div class="notification-date">
                                <i class="bi bi-clock"></i>
                                <%= n.getCreatedAt() %>

                                <% if (!n.isLue()) { %>
                                    <span class="badge bg-primary ms-2">Nouvelle</span>
                                <% } else { %>
                                    <span class="badge bg-secondary ms-2">Lue</span>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="notification-actions">
                        <% if (!n.isLue()) { %>
                            <a href="${pageContext.request.contextPath}/notifications?action=read&id=<%= n.getId() %>"
                               class="btn btn-sm btn-outline-primary">
                                <i class="bi bi-check2"></i>
                            </a>
                        <% } %>

                        <a href="${pageContext.request.contextPath}/notifications?action=delete&id=<%= n.getId() %>"
                           class="btn btn-sm btn-outline-danger"
                           onclick="return confirm('Supprimer cette notification ?');">
                            <i class="bi bi-trash"></i>
                        </a>
                    </div>
                </div>
            <% } %>

        <% } else { %>

            <div class="empty-box">
                <i class="bi bi-bell-slash"></i>
                <h5>Aucune notification</h5>
                <p class="mb-0">Vous n’avez pas encore de notification.</p>
            </div>

        <% } %>

    </div>

</div>

</body>
</html>
