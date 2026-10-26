<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    com.testweba.model.PV pv =
        (com.testweba.model.PV) request.getAttribute("pv");
    if (pv == null) {
        response.sendRedirect(request.getContextPath() + "/pv");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier PV - LIAS</title>
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

        .form-card {
            background: white;
            border-radius: 24px;
            padding: 38px;
            box-shadow: 0 10px 40px rgba(15,23,42,0.08);
            border: 1px solid #edf2f7;
            max-width: 700px;
            margin: 50px auto;
        }

        .form-header {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 60%, #0ea5e9 100%);
            color: white;
            border-radius: 16px;
            padding: 26px 28px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .form-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.07);
            border-radius: 50%;
        }

        .form-header h4 {
            font-weight: 800;
            position: relative;
            z-index: 2;
            letter-spacing: -0.3px;
        }

        .form-header small {
            color: rgba(255,255,255,0.8);
            position: relative;
            z-index: 2;
            font-weight: 500;
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

        .form-control::placeholder {
            color: #94a3b8;
        }

        .btn-submit {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            font-size: 15px;
            box-shadow: 0 6px 18px rgba(11,47,87,0.25);
            transition: 0.2s;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 26px rgba(11,47,87,0.35);
            color: white;
        }

        .btn-outline-secondary {
            border-radius: 12px;
            padding: 12px 28px;
            font-weight: 700;
            border: 1.5px solid #e2e8f0;
            color: #475569;
            transition: 0.2s;
        }

        .btn-outline-secondary:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
            color: #334155;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-card">

        <div class="form-header">
            <h4 class="mb-1"><i class="bi bi-pencil-square me-2"></i>Modifier le Procès-verbal</h4>
            <small>Mettre à jour les informations du PV</small>
        </div>

        <form action="${pageContext.request.contextPath}/pv" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="<%= pv.getId() %>">

            <div class="row g-3">

                <div class="col-12">
                    <label class="form-label">Titre de la réunion <span class="text-danger">*</span></label>
                    <input type="text" name="titre" class="form-control"
                           value="<%= pv.getTitre() != null ? pv.getTitre() : "" %>"
                           required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Date de réunion <span class="text-danger">*</span></label>
                    <input type="date" name="dateReunion" class="form-control"
                           value="<%= pv.getDateReunion() != null ? pv.getDateReunion() : "" %>"
                           required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Lien du PV (URL)</label>
                    <input type="text" name="pvPath" class="form-control"
                           value="<%= pv.getPvPath() != null ? pv.getPvPath() : "" %>"
                           placeholder="Ex: https://drive.google.com/...">
                </div>

                <div class="col-12">
                    <label class="form-label">Ordre du jour</label>
                    <textarea name="ordreDuJour" class="form-control" rows="5"><%= pv.getOrdreDuJour() != null ? pv.getOrdreDuJour() : "" %></textarea>
                </div>

                <div class="col-12 d-flex gap-3 mt-2">
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-check-circle me-2"></i> Mettre à jour
                    </button>
                    <a href="${pageContext.request.contextPath}/pv"
                       class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-2"></i> Annuler
                    </a>
                </div>

            </div>
        </form>

    </div>
</div>

</body>
</html>
