<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membreConnecte =
        (com.testweba.model.Membre) session.getAttribute("membreConnecte");

    if (membreConnecte == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    @SuppressWarnings("unchecked")
    java.util.List<com.testweba.model.Membre> membres =
        (java.util.List<com.testweba.model.Membre>) request.getAttribute("membres");
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter mandat - LIAS</title>
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
        .hero-content { position: relative; z-index: 5; }
        .hero-title { font-size: 24px; font-weight: 800; margin-bottom: 6px; }
        .hero-sub { opacity: 0.8; font-size: 14px; margin: 0; }

        .form-card {
            background: white; border-radius: 20px; padding: 32px;
            box-shadow: 0 8px 24px rgba(15,23,42,0.06);
            max-width: 850px;
        }

        .section-label {
            display: flex; align-items: center; gap: 8px;
            font-weight: 700; color: #0b2f57; font-size: 14px;
            margin: 24px 0 14px; padding-bottom: 8px;
            border-bottom: 2px solid #f1f5f9;
        }
        .section-label:first-of-type { margin-top: 0; }

        .form-label { font-weight: 600; color: #334155; }
        .form-control, .form-select {
            border-radius: 10px; border: 1.5px solid #e2e8f0;
            padding: 10px 14px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 3px rgba(29,111,165,0.1);
        }

        .info-box {
            background: #eff6ff; border-left: 4px solid #1d6fa5;
            border-radius: 10px; padding: 12px 16px; margin-top: 8px;
            font-size: 13px; color: #1e40af;
        }

        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white; border: none; border-radius: 12px;
            padding: 12px 28px; font-weight: 600; font-size: 15px;
        }
        .btn-submit:hover { opacity: 0.9; color: white; }
    </style>
</head>

<body>

<%@ include file="sidebar.jsp" %>

<div class="main">

    <div class="hero-card">
        <div class="hero-content">
            <div class="hero-title"><i class="bi bi-award me-2"></i>Ajouter un mandat</div>
            <p class="hero-sub">Définir une responsabilité de gouvernance du laboratoire LIAS</p>
        </div>
    </div>

    <div class="form-card">
        <form method="post" action="${pageContext.request.contextPath}/mandats">

            <div class="section-label"><i class="bi bi-people"></i> Membres concernés</div>

            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label">Membre concerné <span class="text-danger">*</span></label>
                    <select name="membreId" class="form-select" required>
                        <option value="">-- Choisir un membre --</option>
                        <% if (membres != null) { %>
                            <% for (com.testweba.model.Membre m : membres) { %>
                                <option value="<%= m.getId() %>">
                                    <%= m.getNomComplet() %> - <%= m.getEmail() %> (<%= m.getRole() %>)
                                </option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="col-12">
                    <label class="form-label">Directeur associé <span class="text-danger">*</span></label>
                    <select name="directeurId" class="form-select" required>
                        <option value="">-- Choisir le directeur --</option>
                        <% if (membres != null) { %>
                            <% for (com.testweba.model.Membre m : membres) { %>
                                <option value="<%= m.getId() %>">
                                    <%= m.getNomComplet() %> - <%= m.getEmail() %>
                                </option>
                            <% } %>
                        <% } %>
                    </select>
                    <div class="info-box">
                        <i class="bi bi-info-circle me-1"></i>
                        Pour un mandat de directeur, choisissez le même membre.
                    </div>
                </div>

                <div class="col-12">
                    <label class="form-label">Vice-directeur</label>
                    <select name="viceDirecteurId" class="form-select">
                        <option value="">Aucun</option>
                        <% if (membres != null) { %>
                            <% for (com.testweba.model.Membre m : membres) { %>
                                <option value="<%= m.getId() %>">
                                    <%= m.getNomComplet() %> - <%= m.getEmail() %>
                                </option>
                            <% } %>
                        <% } %>
                    </select>
                </div>
            </div>

            <div class="section-label"><i class="bi bi-award"></i> Détails du mandat</div>

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Type de mandat <span class="text-danger">*</span></label>
                    <select name="typeMandat" class="form-select" required>
                        <option value="directeur">Directeur</option>
                        <option value="vice_directeur">Vice-directeur</option>
                        <option value="chef_equipe">Chef d'équipe</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">État</label>
                    <select name="actif" class="form-select">
                        <option value="true">Actif</option>
                        <option value="false">Inactif</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date début <span class="text-danger">*</span></label>
                    <input type="date" name="dateDebut" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date fin</label>
                    <input type="date" name="dateFin" class="form-control">
                </div>

                <div class="col-12">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4"
                              placeholder="Exemple : mandat actif du directeur du laboratoire"></textarea>
                </div>
            </div>

            <div class="d-flex gap-3 mt-4">
                <button type="submit" class="btn btn-submit">
                    <i class="bi bi-check-circle me-2"></i> Enregistrer
                </button>
                <a href="${pageContext.request.contextPath}/mandats"
                   class="btn btn-outline-secondary" style="border-radius:12px;padding:12px 28px;">
                    <i class="bi bi-arrow-left me-2"></i> Annuler
                </a>
            </div>

        </form>
    </div>

</div>

</body>
</html>