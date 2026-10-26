<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Calendrier - LIAS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js"></script>

    <style>
        body { background: #f4f7fb; font-family: "Segoe UI", Arial, sans-serif; }

        .navbar {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5) !important;
            padding: 16px 0;
            box-shadow: 0 4px 20px rgba(11,47,87,0.15);
        }
        .navbar-brand {
            font-weight: 800; font-size: 19px;
            display: flex; align-items: center; gap: 10px;
        }
        .btn-connexion {
            background: rgba(255,255,255,0.15);
            border: 1.5px solid rgba(255,255,255,0.4);
            color: white; border-radius: 10px;
            padding: 8px 18px; font-weight: 600; font-size: 14px;
            transition: 0.2s;
        }
        .btn-connexion:hover { background: white; color: #0b2f57; }

        .hero-section {
            background: linear-gradient(135deg, #0b2f57, #1d6fa5);
            padding: 50px 0 70px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .hero-section::before {
            content: '';
            position: absolute; top: -50px; right: -50px;
            width: 250px; height: 250px;
            background: rgba(255,255,255,0.06);
            border-radius: 50%;
        }
        .hero-badge {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            padding: 6px 16px; border-radius: 999px;
            font-size: 13px; font-weight: 600; margin-bottom: 16px;
        }
        .hero-title { font-size: 34px; font-weight: 900; margin-bottom: 8px; }
        .hero-sub { opacity: 0.85; font-size: 15px; margin: 0; }

        .content-wrapper { margin-top: -40px; position: relative; z-index: 10; padding-bottom: 60px; }

        .legend-bar {
            background: white; border-radius: 18px; padding: 16px 24px;
            box-shadow: 0 12px 36px rgba(11,47,87,0.1);
            margin-bottom: 20px;
            display: flex; gap: 20px; flex-wrap: wrap; align-items: center;
        }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; color: #334155; }
        .legend-dot { width: 12px; height: 12px; border-radius: 4px; }

        .calendar-card {
            background: white; border-radius: 22px; padding: 28px;
            box-shadow: 0 16px 50px rgba(11,47,87,0.12);
        }

        /* FullCalendar custom theme */
        .fc { font-family: "Segoe UI", Arial, sans-serif; }
        .fc .fc-toolbar-title { font-size: 19px !important; font-weight: 800 !important; color: #0b2f57 !important; }
        .fc .fc-button-primary {
            background: #0b2f57 !important; border-color: #0b2f57 !important;
            border-radius: 10px !important; font-weight: 600 !important;
            text-transform: capitalize !important; padding: 8px 16px !important;
        }
        .fc .fc-button-primary:hover { background: #1d6fa5 !important; border-color: #1d6fa5 !important; }
        .fc .fc-button-primary:not(:disabled).fc-button-active,
        .fc .fc-button-primary:not(:disabled):active {
            background: #1d6fa5 !important; border-color: #1d6fa5 !important;
        }
        .fc-event {
            border-radius: 8px !important; border: none !important;
            font-weight: 600 !important; font-size: 12.5px !important;
            padding: 3px 8px !important; cursor: pointer !important;
        }
        .fc-day-today { background: #eff6ff !important; }
        .fc-col-header-cell { background: #f8fafc !important; padding: 10px 0 !important; }
        .fc-col-header-cell-cushion {
            color: #0b2f57 !important; font-weight: 700 !important;
            text-transform: uppercase; font-size: 12px;
        }
        .fc-daygrid-day-number { color: #334155; font-weight: 600; font-size: 13px; }
        .fc-theme-standard td, .fc-theme-standard th { border-color: #f1f5f9 !important; }

        /* Modal */
        .event-modal {
            display: none; position: fixed; inset: 0;
            background: rgba(11,47,87,0.5);
            z-index: 9999; align-items: center; justify-content: center;
            backdrop-filter: blur(3px);
        }
        .event-modal.show { display: flex; }
        .event-modal-content {
            background: white; border-radius: 22px; padding: 32px;
            max-width: 460px; width: 90%;
            box-shadow: 0 30px 70px rgba(0,0,0,0.3);
            animation: popIn 0.25s ease;
        }
        @keyframes popIn {
            from { transform: scale(0.92) translateY(10px); opacity: 0; }
            to { transform: scale(1) translateY(0); opacity: 1; }
        }
        .event-type-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 999px;
            font-size: 12.5px; font-weight: 700; margin-bottom: 14px;
        }
        .modal-detail-row {
            display: flex; gap: 12px; align-items: flex-start;
            padding: 10px 0; border-bottom: 1px solid #f1f5f9;
        }
        .modal-detail-row:last-of-type { border-bottom: none; }
        .modal-detail-row i { color: #1d6fa5; font-size: 16px; width: 18px; margin-top: 2px; }
        .modal-detail-row span { font-size: 14px; color: #334155; }
        .btn-close-modal {
            background: #f1f5f9; border: none; color: #334155;
            border-radius: 12px; padding: 11px 22px;
            font-weight: 700; cursor: pointer; transition: 0.2s; font-size: 14px;
        }
        .btn-close-modal:hover { background: #e2e8f0; }
    </style>
</head>

<body>

<nav class="navbar navbar-dark">
    <div class="container">
        <a href="${pageContext.request.contextPath}/espace-public" class="navbar-brand">
            <i class="bi bi-diagram-3-fill"></i> Laboratoire LIAS
        </a>
        <a href="${pageContext.request.contextPath}/login" class="btn-connexion">
            <i class="bi bi-box-arrow-in-right me-1"></i> Connexion membres
        </a>
    </div>
</nav>

<div class="hero-section">
    <div class="container" style="position:relative;z-index:5;">
        <div class="hero-badge">
            <i class="bi bi-calendar3"></i> Accès public
        </div>
        <h1 class="hero-title">Calendrier des événements</h1>
        <p class="hero-sub">Visualisation des conférences, séminaires et workshops du laboratoire LIAS</p>
    </div>
</div>

<div class="container content-wrapper">

    <div class="legend-bar">
        <div class="legend-item"><div class="legend-dot" style="background:#3b82f6;"></div> Conférence</div>
        <div class="legend-item"><div class="legend-dot" style="background:#10b981;"></div> Séminaire</div>
        <div class="legend-item"><div class="legend-dot" style="background:#f59e0b;"></div> Workshop</div>
        <div class="legend-item"><div class="legend-dot" style="background:#8b5cf6;"></div> Journée</div>
        <div class="legend-item"><div class="legend-dot" style="background:#1d6fa5;"></div> Autre</div>
    </div>

    <div class="calendar-card">
        <div id="calendar"></div>
    </div>

</div>

<!-- Modal détail événement -->
<div class="event-modal" id="eventModal">
    <div class="event-modal-content">
        <div id="modalType"></div>
        <h4 id="modalTitle" style="color:#0b2f57;font-weight:800;margin-bottom:18px;"></h4>
        <div style="margin-bottom:24px;">
            <div class="modal-detail-row">
                <i class="bi bi-calendar3"></i>
                <span id="modalDate"></span>
            </div>
            <div class="modal-detail-row">
                <i class="bi bi-geo-alt"></i>
                <span id="modalLieu"></span>
            </div>
        </div>
        <button class="btn-close-modal" onclick="closeModal()">
            <i class="bi bi-x me-1"></i> Fermer
        </button>
    </div>
</div>

<script>
    const contextPath = '${pageContext.request.contextPath}';

    document.addEventListener('DOMContentLoaded', function () {
        const calendarEl = document.getElementById('calendar');

        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            locale: 'fr',
            height: 'auto',
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,listMonth'
            },
            buttonText: {
                today: "Aujourd'hui",
                month: "Mois",
                week: "Semaine",
                list: "Liste"
            },
            events: contextPath + '/calendrier?format=json',
            eventClick: function (info) {
                const event = info.event;
                const props = event.extendedProps;

                document.getElementById('modalTitle').textContent = event.title;
                document.getElementById('modalDate').textContent =
                    event.start ? event.start.toLocaleDateString('fr-FR', {
                        weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
                    }) : '—';
                document.getElementById('modalLieu').textContent = props.lieu || 'Lieu non précisé';

                const colors = {
                    'conference': '#3b82f6',
                    'seminaire': '#10b981',
                    'workshop': '#f59e0b',
                    'journee': '#8b5cf6'
                };
                const color = colors[props.type] || '#1d6fa5';
                const typeEl = document.getElementById('modalType');
                typeEl.innerHTML = '<span class="event-type-badge" style="background:' +
                    color + '20;color:' + color + ';"><i class="bi bi-tag-fill"></i>' +
                    (props.type || 'Événement') + '</span>';

                document.getElementById('eventModal').classList.add('show');
            },
            eventMouseEnter: function (info) {
                info.el.style.opacity = '0.85';
                info.el.style.transform = 'scale(1.02)';
            },
            eventMouseLeave: function (info) {
                info.el.style.opacity = '1';
                info.el.style.transform = 'scale(1)';
            }
        });

        calendar.render();
    });

    function closeModal() {
        document.getElementById('eventModal').classList.remove('show');
    }

    document.getElementById('eventModal').addEventListener('click', function (e) {
        if (e.target === this) closeModal();
    });
</script>

</body>
</html>