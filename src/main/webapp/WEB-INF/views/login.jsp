<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        * { box-sizing: border-box; }

        body {
            background: linear-gradient(135deg, #0b2f57 0%, #1d6fa5 50%, #0ea5e9 100%);
            display: flex;
            align-items: center;
            min-height: 100vh;
            font-family: "Segoe UI", Arial, sans-serif;
            position: relative;
            overflow: hidden;
        }

        body::before {
            content: '';
            position: absolute; top: -100px; right: -100px;
            width: 400px; height: 400px;
            background: rgba(255,255,255,0.06); border-radius: 50%;
        }
        body::after {
            content: '';
            position: absolute; bottom: -120px; left: -80px;
            width: 350px; height: 350px;
            background: rgba(255,255,255,0.04); border-radius: 50%;
        }

        .login-wrapper { position: relative; z-index: 5; width: 100%; }

        .login-card {
            max-width: 440px;
            width: 100%;
            margin: auto;
        }

        .login-box {
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
        }

        .logo-header {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            padding: 36px 28px;
            text-align: center;
            position: relative;
        }

        .brand-icon {
            width: 56px; height: 56px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 26px; margin: 0 auto 14px;
        }

        .logo-header h3 {
            margin-bottom: 4px;
            font-weight: 800;
            font-size: 22px;
        }

        .logo-header p {
            margin: 0;
            opacity: 0.8;
            font-size: 13.5px;
        }

        .card-body { padding: 36px 32px; }

        .form-label {
            font-weight: 600;
            color: #334155;
            font-size: 13.5px;
            margin-bottom: 6px;
        }

        .input-wrap { position: relative; }
        .input-wrap i {
            position: absolute; left: 16px; top: 50%;
            transform: translateY(-50%);
            color: #94a3b8; font-size: 16px;
        }

        .form-control {
            border-radius: 12px;
            border: 1.5px solid #e2e8f0;
            padding: 12px 16px 12px 44px;
            font-size: 14.5px;
            transition: 0.2s;
        }
        .form-control:focus {
            border-color: #1d6fa5;
            box-shadow: 0 0 0 4px rgba(29,111,165,0.1);
        }

        .btn-lias {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 13px;
            font-weight: 700;
            font-size: 15px;
            transition: 0.2s;
            box-shadow: 0 8px 24px rgba(11,47,87,0.25);
        }
        .btn-lias:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(11,47,87,0.35);
            color: white;
        }

        .back-link {
            color: #64748b;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
            display: inline-flex; align-items: center; gap: 6px;
            transition: 0.2s;
        }
        .back-link:hover { color: #1d6fa5; }

        .alert-danger {
            border-radius: 12px;
            border: none;
            background: #fef2f2;
            color: #b91c1c;
            font-size: 13.5px;
            display: flex; align-items: center; gap: 10px;
        }
    </style>
</head>

<body>

<div class="login-wrapper">
    <div class="container">
        <div class="login-card">
            <div class="login-box">

                <div class="logo-header">
                    <div class="brand-icon">
                        <i class="bi bi-diagram-3-fill"></i>
                    </div>
                    <h3>Laboratoire LIAS</h3>
                    <p>Portail d'accès sécurisé</p>
                </div>

                <div class="card-body">

                    <% if (request.getAttribute("erreur") != null) { %>
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-circle-fill"></i>
                            <%= request.getAttribute("erreur") %>
                        </div>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/login">

                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <div class="input-wrap">
                                <i class="bi bi-envelope"></i>
                                <input type="email"
                                       name="email"
                                       class="form-control"
                                       placeholder="votre@email.com"
                                       required
                                       autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Mot de passe</label>
                            <div class="input-wrap">
                                <i class="bi bi-lock"></i>
                                <input type="password"
                                       name="motDePasse"
                                       class="form-control"
                                       placeholder="••••••••"
                                       required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-lias w-100">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/" class="back-link">
                            <i class="bi bi-arrow-left"></i> Retour à l'accueil
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>