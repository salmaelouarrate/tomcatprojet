<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.Materiel materiel =
        (com.testweba.model.Materiel) request.getAttribute("materiel");

    if (materiel == null) {
        response.sendRedirect(request.getContextPath() + "/materiel");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier matériel - LIAS</title>

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

        .card {
            border: 1px solid #edf2f7;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(15,23,42,0.08);
            overflow: hidden;
        }

        .card-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%) !important;
            border: none;
            padding: 26px 28px;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .card-header h4 {
            font-weight: 800;
            letter-spacing: -0.3px;
            position: relative;
            z-index: 2;
        }

        .card-body {
            padding: 32px;
        }

        .form-label {
            font-weight: 700;
            color: #334155;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            margin-bottom: 6px;
        }

        .form-control {
            border-radius: 12px;
            border: 1.5px solid #e2e8f0;
            padding: 11px 16px;
            font-weight: 500;
            color: #1e293b;
            transition: 0.2s;
        }

        .form-control:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 4px rgba(29,111,165,0.1);
        }

        .btn-primary {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
        }

        .btn-secondary {
            background: #f1f5f9;
            color: #475569;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            margin-left: 10px;
            transition: 0.2s;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
            color: #334155;
        }
    </style>
</head>

<body class="bg-light">

<div class="container py-5">
    <div class="card shadow mx-auto" style="max-width:800px;">
        <div class="card-header text-white" style="background:#0b2f57;">
            <h4 class="mb-0">Modifier matériel</h4>
        </div>

        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/materiel">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= materiel.getId() %>">

                <div class="mb-3">
                    <label class="form-label">Nom du matériel</label>
                    <input type="text" name="nom" class="form-control"
                           value="<%= materiel.getNom() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4"><%= materiel.getDescription() != null ? materiel.getDescription() : "" %></textarea>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Quantité</label>
                        <input type="number" name="quantite" class="form-control"
                               min="1" value="<%= materiel.getQuantite() %>" required>
                    </div>

                    <div class="col-md-6 mb-4">
                        <label class="form-label">Date d'arrivée</label>
                        <input type="date" name="dateArrivee" class="form-control"
                               value="<%= materiel.getDateArrivee() != null ? materiel.getDateArrivee() : "" %>">
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Enregistrer</button>

                <a href="${pageContext.request.contextPath}/materiel" class="btn btn-secondary">
                    Annuler
                </a>
            </form>
        </div>
    </div>
</div>

</body>
</html>
