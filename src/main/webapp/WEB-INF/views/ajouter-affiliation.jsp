<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Membre membre =
        (com.testweba.model.Membre) request.getAttribute("membre");

    if (membre == null) {
        response.sendRedirect(request.getContextPath() + "/membres");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter affiliation - LIAS</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        :root {
            --blue: #0b2f57;
            --blue-2: #1d6fa5;
            --blue-3: #0ea5e9;
            --bg: #f8faff;
            --card: #ffffff;
            --border: #edf2f7;
            --text: #1e293b;
            --muted: #64748b;
        }

        * { box-sizing: border-box; }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Inter', sans-serif;
        }

        .page {
            max-width: 920px;
            margin: 0 auto;
            padding: 46px 18px;
        }

        .hero {
            background: linear-gradient(135deg, var(--blue) 0%, var(--blue-2) 60%, var(--blue-3) 100%);
            color: white;
            border-radius: 22px;
            padding: 30px 32px;
            box-shadow: 0 16px 40px rgba(11, 47, 87, 0.2);
            margin-bottom: 26px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -8%;
            width: 240px;
            height: 240px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .hero > * {
            position: relative;
            z-index: 2;
        }

        .hero h2 {
            font-weight: 800;
            margin: 0;
            letter-spacing: -0.5px;
        }

        .hero-info {
            color: rgba(255,255,255,.85);
            margin-top: 8px;
            font-weight: 500;
        }

        .form-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 30px;
            box-shadow: 0 10px 36px rgba(15, 23, 42, 0.07);
        }

        .section-title {
            font-weight: 800;
            color: var(--blue);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 8px;
        }

        .form-control,
        .form-select {
            border-radius: 12px;
            border: 1.5px solid var(--border);
            padding: 11px 16px;
            font-weight: 500;
            color: var(--text);
            transition: 0.2s;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--blue-2);
            box-shadow: 0 0 0 4px rgba(29,111,165,0.1);
        }

        .hint {
            color: var(--muted);
            font-size: 13px;
            margin-top: 6px;
            font-weight: 500;
        }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 26px;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--blue), var(--blue-2));
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 700;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
        }

        .btn-light-custom {
            background: #eff6ff;
            color: var(--blue);
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 700;
            text-decoration: none;
            transition: 0.2s;
        }

        .btn-light-custom:hover {
            background: #dbeafe;
            color: var(--blue);
            transform: translateY(-2px);
        }

        .member-chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,255,255,.14);
            border: 1px solid rgba(255,255,255,.25);
            padding: 9px 16px;
            border-radius: 999px;
            margin-top: 16px;
            font-weight: 700;
            backdrop-filter: blur(4px);
        }

        @media (max-width: 768px) {
            .hero,
            .form-card {
                padding: 22px;
            }

            .actions {
                justify-content: stretch;
            }

            .actions .btn,
            .actions a {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>

<body>

<div class="page">

    <div class="hero">
        <h2>Ajouter une affiliation</h2>
        <div class="hero-info">
            Définir une période d’affiliation pour un membre du laboratoire.
        </div>

        <div class="member-chip">
            <i class="bi bi-person-circle"></i>
            <span><%= membre.getNom() %> <%= membre.getPrenom() %> · ID <%= membre.getId() %></span>
        </div>
    </div>

    <div class="form-card">
        <h5 class="section-title">
            <i class="bi bi-diagram-3"></i>
            Informations d’affiliation
        </h5>

        <form method="post" action="${pageContext.request.contextPath}/membres">

            <input type="hidden" name="action" value="addAffiliation">
            <input type="hidden" name="membreId" value="<%= membre.getId() %>">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Date début</label>
                    <input type="date" name="dateDebut" class="form-control" required>
                    <div class="hint">Date de début de l’affiliation.</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Date fin</label>
                    <input type="date" name="dateFin" class="form-control">
                    <div class="hint">Laisser vide si l’affiliation est en cours.</div>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Type affiliation</label>
                <select name="typeAffiliation" class="form-select" required>
                    <option value="">-- Sélectionner --</option>
                    <option value="LIAS">LIAS</option>
                    <option value="associe">Associé</option>
                    <option value="collaborateur">Collaborateur</option>
                    <option value="doctorant">Doctorant</option>
                    <option value="ancien">Ancien membre</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">Commentaire</label>
                <textarea name="commentaire" class="form-control" rows="4"
                          placeholder="Exemple : affiliation actuelle au laboratoire LIAS"></textarea>
            </div>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/membres?action=historique&id=<%= membre.getId() %>"
                   class="btn-light-custom">
                    <i class="bi bi-arrow-left"></i> Annuler
                </a>

                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check2-circle"></i> Enregistrer
                </button>
            </div>

        </form>
    </div>

</div>

</body>
</html>
