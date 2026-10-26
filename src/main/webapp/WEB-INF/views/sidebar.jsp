<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre sidebarMembre =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    String sidebarRole = "";

    if (sidebarMembre != null && sidebarMembre.getRole() != null) {
        sidebarRole = sidebarMembre.getRole().toLowerCase();
    }
    boolean sidebarIsViceDoyen = "vice_doyen".equals(sidebarRole);
    boolean sidebarIsAdmin = "admin".equals(sidebarRole) || "directeur".equals(sidebarRole);
    boolean sidebarIsChef = "chef_equipe".equals(sidebarRole);
    boolean sidebarIsDoctorant = "doctorant".equals(sidebarRole);
    boolean sidebarIsMembre = "membre".equals(sidebarRole);

    String currentUri = request.getRequestURI();

    boolean activeDashboard = currentUri.endsWith("/dashboard");
    boolean activeProfil = currentUri.endsWith("/profil") || currentUri.endsWith("/mon-profil");
    boolean activeMembres = currentUri.endsWith("/membres");
    boolean activePublications = currentUri.endsWith("/publications");
    boolean activeEvenements = currentUri.endsWith("/evenements");
    boolean activeDocuments = currentUri.endsWith("/documents");
    boolean activeMateriel = currentUri.endsWith("/materiel");
    boolean activeConventions = currentUri.endsWith("/conventions");
    boolean activeDemandesAdhesion = currentUri.endsWith("/demandes-adhesion");
    boolean activeDemandesMateriel = currentUri.endsWith("/demandes-materiel");
    boolean activePv = currentUri.endsWith("/pv");
    boolean activeMandats = currentUri.endsWith("/mandats");
    boolean activeRapport = currentUri.endsWith("/rapport");
    boolean activeRecherche = currentUri.endsWith("/recherche");
    boolean activeNotifications = currentUri.endsWith("/notifications");
    boolean activeCalendrier = currentUri.endsWith("/calendrier");
    boolean activeEspaceChef = currentUri.endsWith("/espace-chef-equipe");
    boolean activeEspaceDoctorant = currentUri.endsWith("/espace-doctorant");
    boolean activeEspaceMembre = currentUri.endsWith("/espace-membre");
    boolean activeEspaceViceDoyen = currentUri.endsWith("/espace-vice-doyen");
    boolean activeMessages = currentUri.endsWith("/messages");
%>

<style>
    .sidebar {
        width: 260px;
        height: 100vh;
        background: #071426;
        position: fixed;
        left: 0;
        top: 0;
        color: white;
        padding: 24px 16px;
        overflow-y: auto;
        z-index: 1000;
        box-shadow: 8px 0 30px rgba(15, 23, 42, 0.12);
    }

    .sidebar::-webkit-scrollbar {
        width: 6px;
    }

    .sidebar::-webkit-scrollbar-track {
        background: transparent;
    }

    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(148, 163, 184, 0.35);
        border-radius: 999px;
    }

    .sidebar .brand {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 18px;
        font-weight: 800;
        margin-bottom: 34px;
        color: #ffffff;
        letter-spacing: 0;
    }

    .sidebar .brand i {
        width: 38px;
        height: 38px;
        border-radius: 12px;
        background: linear-gradient(135deg, #4f7cff, #2563eb);
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        box-shadow: 0 10px 25px rgba(37, 99, 235, 0.35);
    }

    .sidebar-section {
        color: #64748b;
        font-size: 11px;
        font-weight: 800;
        text-transform: uppercase;
        margin: 22px 10px 8px;
        letter-spacing: 0;
    }

    .sidebar a {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 12px;
        color: #aebbd0;
        text-decoration: none;
        border-radius: 12px;
        margin-bottom: 6px;
        transition: 0.2s ease;
        font-size: 14px;
        font-weight: 700;
        white-space: nowrap;
    }

    .sidebar a i {
        width: 18px;
        text-align: center;
        font-size: 15px;
        color: #9fb0c7;
        transition: 0.2s ease;
    }

    .sidebar a:hover {
        background: rgba(37, 99, 235, 0.14);
        color: #ffffff;
        transform: translateX(2px);
    }

    .sidebar a:hover i {
        color: #ffffff;
    }

    .sidebar a.active {
        background: #17395d;
        color: #ffffff;
        box-shadow: inset 3px 0 0 #60a5fa;
    }

    .sidebar a.active i {
        color: #bfdbfe;
    }

    .sidebar-divider {
        height: 1px;
        background: rgba(148, 163, 184, 0.16);
        margin: 18px 10px;
    }

    .sidebar .logout-link {
        margin-top: 8px;
    }

    .sidebar .logout-link:hover {
        background: rgba(239, 68, 68, 0.14);
    }

    .main {
        margin-left: 260px;
    }

    @media (max-width: 900px) {
        .sidebar {
            width: 230px;
        }

        .main {
            margin-left: 230px;
        }
    }
</style>

<div class="sidebar">
    <div class="brand">
        <i class="bi bi-diagram-3-fill"></i>
        <span>LIAS Lab</span>
    </div>

    <% if (sidebarIsAdmin) { %>
        <div class="sidebar-section">Principal</div>

        <a href="${pageContext.request.contextPath}/dashboard" class="<%= activeDashboard ? "active" : "" %>">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/mon-profil" class="<%= activeProfil ? "active" : "" %>">
            <i class="bi bi-person-circle"></i> Mon profil
        </a>

        <div class="sidebar-section">Gestion</div>

        <a href="${pageContext.request.contextPath}/membres" class="<%= activeMembres ? "active" : "" %>">
            <i class="bi bi-people"></i> Membres
        </a>

        <a href="${pageContext.request.contextPath}/publications" class="<%= activePublications ? "active" : "" %>">
            <i class="bi bi-journal-text"></i> Publications
        </a>

        <a href="${pageContext.request.contextPath}/evenements" class="<%= activeEvenements ? "active" : "" %>">
            <i class="bi bi-calendar-event"></i> Événements
        </a>

        <a href="${pageContext.request.contextPath}/documents" class="<%= activeDocuments ? "active" : "" %>">
            <i class="bi bi-folder2-open"></i> Documents
        </a>

        <a href="${pageContext.request.contextPath}/materiel" class="<%= activeMateriel ? "active" : "" %>">
            <i class="bi bi-pc-display"></i> Matériel
        </a>

        <a href="${pageContext.request.contextPath}/conventions" class="<%= activeConventions ? "active" : "" %>">
            <i class="bi bi-building"></i> Conventions
        </a>

        <div class="sidebar-section">Administration</div>

        <a href="${pageContext.request.contextPath}/demandes-adhesion" class="<%= activeDemandesAdhesion ? "active" : "" %>">
            <i class="bi bi-inbox"></i> Demandes adhésion
        </a>

        <a href="${pageContext.request.contextPath}/demandes-materiel" class="<%= activeDemandesMateriel ? "active" : "" %>">
            <i class="bi bi-box-seam"></i> Demandes matériel
        </a>

        <a href="${pageContext.request.contextPath}/pv" class="<%= activePv ? "active" : "" %>">
            <i class="bi bi-file-earmark-text"></i> Procès-verbaux
        </a>

        <a href="${pageContext.request.contextPath}/mandats" class="<%= activeMandats ? "active" : "" %>">
            <i class="bi bi-award"></i> Mandats
        </a>

        <div class="sidebar-section">Outils</div>

        <a href="${pageContext.request.contextPath}/rapport" class="<%= activeRapport ? "active" : "" %>">
            <i class="bi bi-file-earmark-pdf"></i> Rapport annuel
        </a>

        <a href="${pageContext.request.contextPath}/recherche" class="<%= activeRecherche ? "active" : "" %>">
            <i class="bi bi-search"></i> Recherche
        </a>

        <a href="${pageContext.request.contextPath}/notifications" class="<%= activeNotifications ? "active" : "" %>">
            <i class="bi bi-bell"></i> Notifications
        </a>

        <a href="${pageContext.request.contextPath}/calendrier" class="<%= activeCalendrier ? "active" : "" %>">
            <i class="bi bi-calendar3"></i> Calendrier
        </a>

        <a href="${pageContext.request.contextPath}/messages" class="<%= activeMessages ? "active" : "" %>">
            <i class="bi bi-chat-dots"></i> Messagerie
        </a>
    <% } %>

    <% if (sidebarIsChef) { %>
        <div class="sidebar-section">Principal</div>

        <a href="${pageContext.request.contextPath}/espace-chef-equipe" class="<%= activeEspaceChef ? "active" : "" %>">
            <i class="bi bi-speedometer2"></i> Espace chef
        </a>

        <a href="${pageContext.request.contextPath}/mon-profil" class="<%= activeProfil ? "active" : "" %>">
            <i class="bi bi-person-circle"></i> Mon profil
        </a>

        <div class="sidebar-section">Gestion</div>

        <a href="${pageContext.request.contextPath}/membres" class="<%= activeMembres ? "active" : "" %>">
            <i class="bi bi-people"></i> Membres
        </a>

        <a href="${pageContext.request.contextPath}/publications" class="<%= activePublications ? "active" : "" %>">
            <i class="bi bi-journal-text"></i> Publications
        </a>

        <a href="${pageContext.request.contextPath}/publications?action=new">
            <i class="bi bi-plus-circle"></i> Ajouter publication
        </a>

        <a href="${pageContext.request.contextPath}/evenements" class="<%= activeEvenements ? "active" : "" %>">
            <i class="bi bi-calendar-event"></i> Événements
        </a>

        <a href="${pageContext.request.contextPath}/documents" class="<%= activeDocuments ? "active" : "" %>">
            <i class="bi bi-folder2-open"></i> Documents
        </a>

        <div class="sidebar-section">Outils</div>

        <a href="${pageContext.request.contextPath}/notifications" class="<%= activeNotifications ? "active" : "" %>">
            <i class="bi bi-bell"></i> Notifications
        </a>

        <a href="${pageContext.request.contextPath}/calendrier" class="<%= activeCalendrier ? "active" : "" %>">
            <i class="bi bi-calendar3"></i> Calendrier
        </a>

        <a href="${pageContext.request.contextPath}/messages" class="<%= activeMessages ? "active" : "" %>">
            <i class="bi bi-chat-dots"></i> Messagerie
        </a>
    <% } %>

    <% if (sidebarIsDoctorant) { %>
        <div class="sidebar-section">Principal</div>

        <a href="${pageContext.request.contextPath}/espace-doctorant" class="<%= activeEspaceDoctorant ? "active" : "" %>">
            <i class="bi bi-mortarboard"></i> Espace doctorant
        </a>

        <a href="${pageContext.request.contextPath}/mon-profil" class="<%= activeProfil ? "active" : "" %>">
            <i class="bi bi-person-circle"></i> Mon profil
        </a>

        <div class="sidebar-section">Publications</div>

        <a href="${pageContext.request.contextPath}/publications" class="<%= activePublications ? "active" : "" %>">
            <i class="bi bi-journal-text"></i> Publications
        </a>

        <a href="${pageContext.request.contextPath}/publications?action=new">
            <i class="bi bi-plus-circle"></i> Ajouter publication
        </a>

        <div class="sidebar-section">Outils</div>

        <a href="${pageContext.request.contextPath}/notifications" class="<%= activeNotifications ? "active" : "" %>">
            <i class="bi bi-bell"></i> Notifications
        </a>

        <a href="${pageContext.request.contextPath}/messages" class="<%= activeMessages ? "active" : "" %>">
            <i class="bi bi-chat-dots"></i> Messagerie
        </a>
    <% } %>

    <% if (sidebarIsViceDoyen) { %>
        <div class="sidebar-section">Principal</div>

        <a href="${pageContext.request.contextPath}/espace-vice-doyen" class="<%= activeEspaceViceDoyen ? "active" : "" %>">
            <i class="bi bi-person-badge"></i> Espace Vice-Doyen
        </a>

        <a href="${pageContext.request.contextPath}/mon-profil" class="<%= activeProfil ? "active" : "" %>">
            <i class="bi bi-person-circle"></i> Mon profil
        </a>

        <div class="sidebar-section">Consultation</div>

        <a href="${pageContext.request.contextPath}/membres" class="<%= activeMembres ? "active" : "" %>">
            <i class="bi bi-people"></i> Membres
        </a>

        <a href="${pageContext.request.contextPath}/publications" class="<%= activePublications ? "active" : "" %>">
            <i class="bi bi-journal-text"></i> Publications
        </a>

        <a href="${pageContext.request.contextPath}/evenements" class="<%= activeEvenements ? "active" : "" %>">
            <i class="bi bi-calendar-event"></i> Événements
        </a>

        <a href="${pageContext.request.contextPath}/documents" class="<%= activeDocuments ? "active" : "" %>">
            <i class="bi bi-folder2-open"></i> Documents
        </a>

        <a href="${pageContext.request.contextPath}/conventions" class="<%= activeConventions ? "active" : "" %>">
            <i class="bi bi-building"></i> Conventions
        </a>

        <div class="sidebar-section">Outils</div>

        <a href="${pageContext.request.contextPath}/recherche" class="<%= activeRecherche ? "active" : "" %>">
            <i class="bi bi-search"></i> Recherche
        </a>

        <a href="${pageContext.request.contextPath}/calendrier" class="<%= activeCalendrier ? "active" : "" %>">
            <i class="bi bi-calendar3"></i> Calendrier
        </a>

        <a href="${pageContext.request.contextPath}/messages" class="<%= activeMessages ? "active" : "" %>">
            <i class="bi bi-chat-dots"></i> Messagerie
        </a>
    <% } %>

    <% if (sidebarIsMembre || (!sidebarIsAdmin && !sidebarIsChef && !sidebarIsDoctorant && !sidebarIsViceDoyen)) { %>
        <div class="sidebar-section">Principal</div>

        <a href="${pageContext.request.contextPath}/espace-membre" class="<%= activeEspaceMembre ? "active" : "" %>">
            <i class="bi bi-house"></i> Espace membre
        </a>

        <a href="${pageContext.request.contextPath}/mon-profil" class="<%= activeProfil ? "active" : "" %>">
            <i class="bi bi-person-circle"></i> Mon profil
        </a>

        <div class="sidebar-section">Consultation</div>

        <a href="${pageContext.request.contextPath}/publications" class="<%= activePublications ? "active" : "" %>">
            <i class="bi bi-journal-text"></i> Publications
        </a>

        <a href="${pageContext.request.contextPath}/evenements" class="<%= activeEvenements ? "active" : "" %>">
            <i class="bi bi-calendar-event"></i> Événements
        </a>

        <a href="${pageContext.request.contextPath}/documents" class="<%= activeDocuments ? "active" : "" %>">
            <i class="bi bi-folder2-open"></i> Documents
        </a>

        <div class="sidebar-section">Outils</div>

        <a href="${pageContext.request.contextPath}/notifications" class="<%= activeNotifications ? "active" : "" %>">
            <i class="bi bi-bell"></i> Notifications
        </a>

        <a href="${pageContext.request.contextPath}/calendrier" class="<%= activeCalendrier ? "active" : "" %>">
            <i class="bi bi-calendar3"></i> Calendrier
        </a>

        <a href="${pageContext.request.contextPath}/equipes" class="<%= currentUri.endsWith("/equipes") ? "active" : "" %>">
            <i class="bi bi-diagram-3"></i> Équipes
        </a>
        <a href="${pageContext.request.contextPath}/messages" class="<%= activeMessages ? "active" : "" %>">
            <i class="bi bi-chat-dots"></i> Messagerie
        </a>
    <% } %>

    <div class="sidebar-divider"></div>

    <a href="${pageContext.request.contextPath}/logout" class="logout-link">
        <i class="bi bi-box-arrow-right"></i> Déconnexion
    </a>
</div>