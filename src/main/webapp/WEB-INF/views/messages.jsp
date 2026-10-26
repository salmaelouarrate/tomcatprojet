<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) request.getAttribute("membreConnecte");
    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String contexte = (String) request.getAttribute("contexte");
    Integer contexteId = (Integer) request.getAttribute("contexteId");
    List<com.testweba.model.Message> messages =
        (List<com.testweba.model.Message>) request.getAttribute("messages");
    com.testweba.model.Evenement evenement =
        (com.testweba.model.Evenement) request.getAttribute("evenement");

    if (messages == null) messages = new ArrayList<>();

    String titre;
    String sousTitre;
    if ("evenement".equals(contexte) && evenement != null) {
        titre = "Discussion : " + evenement.getTitre();
        sousTitre = "Échanges liés à cet événement";
    } else if ("equipe".equals(contexte)) {
        titre = "Discussion d'équipe";
        sousTitre = "Échanges entre membres de l'équipe";
    } else {
        titre = "Discussion générale";
        sousTitre = "Échanges entre tous les membres du laboratoire";
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Communication - LIAS</title>
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
            margin-bottom: 24px;
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

        .tabs-row {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .tab-link {
            background: white;
            color: #334155;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 14px;
            box-shadow: 0 4px 14px rgba(15,23,42,0.06);
            border: 1px solid #edf2f7;
            transition: 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tab-link:hover {
            background: #eff6ff;
            color: #1d6fa5;
        }

        .tab-link.active {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border-color: transparent;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
        }

        .chat-container {
            background: white;
            border-radius: 22px;
            box-shadow: 0 8px 28px rgba(15,23,42,0.07);
            border: 1px solid #edf2f7;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: calc(100vh - 280px);
            min-height: 400px;
        }

        .chat-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%);
            color: white;
            padding: 20px 26px;
            position: relative;
            overflow: hidden;
        }

        .chat-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -8%;
            width: 180px;
            height: 180px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .chat-header h6 {
            margin: 0;
            font-weight: 800;
            position: relative;
            z-index: 2;
            font-size: 16px;
        }

        .chat-header small {
            opacity: 0.85;
            position: relative;
            z-index: 2;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 26px;
            display: flex;
            flex-direction: column;
            gap: 16px;
            background: #f8faff;
        }

        .message-bubble {
            max-width: 65%;
            padding: 12px 16px;
            border-radius: 18px;
            position: relative;
            animation: slideIn 0.2s ease;
        }

        @keyframes slideIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .message-bubble.mine {
            align-self: flex-end;
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border-bottom-right-radius: 5px;
            box-shadow: 0 6px 16px rgba(11,47,87,0.2);
        }

        .message-bubble.other {
            align-self: flex-start;
            background: white;
            border: 1px solid #edf2f7;
            border-bottom-left-radius: 5px;
            box-shadow: 0 4px 14px rgba(15,23,42,0.05);
        }

        .message-author {
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 4px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .message-bubble.mine .message-author { color: #bae6fd; }
        .message-bubble.other .message-author { color: #1d6fa5; }

        .message-content {
            font-size: 14px;
            line-height: 1.5;
            word-wrap: break-word;
            font-weight: 500;
        }

        .message-time {
            font-size: 11px;
            margin-top: 6px;
            opacity: 0.7;
            display: flex;
            align-items: center;
            gap: 6px;
            justify-content: space-between;
        }

        .delete-btn {
            background: none;
            border: none;
            opacity: 0.6;
            cursor: pointer;
            font-size: 12px;
            padding: 0;
        }

        .delete-btn:hover { opacity: 1; }
        .message-bubble.mine .delete-btn { color: white; }
        .message-bubble.other .delete-btn { color: #ef4444; }

        .chat-input-area {
            padding: 18px 26px;
            background: white;
            border-top: 1px solid #f1f5f9;
        }

        .chat-input-row {
            display: flex;
            gap: 12px;
        }

        .chat-input {
            flex: 1;
            border: 1.5px solid #e2e8f0;
            border-radius: 14px;
            padding: 12px 18px;
            font-size: 14px;
            font-weight: 500;
            resize: none;
            outline: none;
            transition: 0.2s;
        }

        .chat-input:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 4px rgba(29,111,165,0.1);
        }

        .btn-send {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border: none;
            border-radius: 14px;
            padding: 0 26px;
            font-weight: 700;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-send:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(11,47,87,0.35);
            color: white;
        }

        .empty-chat {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #94a3b8;
        }

        .empty-chat i {
            font-size: 56px;
            margin-bottom: 12px;
            color: #cbd5e1;
        }

        .avatar-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: #e0f2fe;
            color: #075985;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
        }

        @media (max-width: 768px) {
            .sidebar { display: none; }
            .main { margin-left: 0; padding: 18px; }
            .message-bubble { max-width: 85%; }
        }
    </style>
</head>
<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="topbar">
        <div>
            <h5 class="mb-0">Communication interne</h5>
            <small class="text-muted">Échangez avec les membres du laboratoire</small>
        </div>
    </div>

    <div class="tabs-row">
        <a href="${pageContext.request.contextPath}/messages?contexte=general"
           class="tab-link <%= "general".equals(contexte) ? "active" : "" %>">
            <i class="bi bi-globe"></i> Discussion générale
        </a>
        <a href="${pageContext.request.contextPath}/messages?contexte=equipe"
           class="tab-link <%= "equipe".equals(contexte) ? "active" : "" %>">
            <i class="bi bi-people"></i> Discussion d'équipe
        </a>
        <% if ("evenement".equals(contexte)) { %>
        <span class="tab-link active">
            <i class="bi bi-calendar-event"></i> <%= titre %>
        </span>
        <% } %>
    </div>

    <div class="chat-container">

        <div class="chat-header">
            <h6><%= titre %></h6>
            <small><%= sousTitre %></small>
        </div>

        <div class="chat-messages" id="chatMessages">
            <% if (messages.isEmpty()) { %>
                <div class="empty-chat">
                    <i class="bi bi-chat-square-text"></i>
                    <p>Aucun message pour le moment.<br>Soyez le premier à écrire !</p>
                </div>
            <% } else { %>
                <% for (com.testweba.model.Message msg : messages) {
                    boolean isMine = msg.getMembreId() == membreConnecte.getId();
                %>
                <div class="message-bubble <%= isMine ? "mine" : "other" %>">
                    <% if (!isMine) { %>
                    <div class="message-author">
                        <span class="avatar-circle"><i class="bi bi-person-fill"></i></span>
                        <%= msg.getMembreNom() %>
                    </div>
                    <% } %>
                    <div class="message-content"><%= msg.getContenu() %></div>
                    <div class="message-time">
                        <span><%= msg.getDateEnvoi() %></span>
                        <% if (isMine) { %>
                        <form method="post" action="${pageContext.request.contextPath}/messages"
                              style="display:inline;">
                            <input type="hidden" name="action" value="supprimer">
                            <input type="hidden" name="id" value="<%= msg.getId() %>">
                            <input type="hidden" name="contexte" value="<%= contexte %>">
                            <% if (contexteId != null) { %>
                            <input type="hidden" name="contexteId" value="<%= contexteId %>">
                            <% } %>
                            <button type="submit" class="delete-btn"
                                    onclick="return confirm('Supprimer ce message ?');">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>
                <% } %>
            <% } %>
        </div>

        <div class="chat-input-area">
            <form method="post" action="${pageContext.request.contextPath}/messages"
                  class="chat-input-row">
                <input type="hidden" name="action" value="envoyer">
                <input type="hidden" name="contexte" value="<%= contexte %>">
                <% if (contexteId != null) { %>
                <input type="hidden" name="contexteId" value="<%= contexteId %>">
                <% } %>
                <textarea name="contenu" class="chat-input" rows="1"
                          placeholder="Écrivez votre message..." required></textarea>
                <button type="submit" class="btn-send">
                    <i class="bi bi-send-fill"></i>
                </button>
            </form>
        </div>

    </div>

</div>

<script>
    // Auto-scroll vers le bas
    var chatMessages = document.getElementById('chatMessages');
    chatMessages.scrollTop = chatMessages.scrollHeight;

    // Enter pour envoyer (sans Shift)
    document.querySelector('.chat-input').addEventListener('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            this.closest('form').submit();
        }
    });
</script>

</body>
</html>
