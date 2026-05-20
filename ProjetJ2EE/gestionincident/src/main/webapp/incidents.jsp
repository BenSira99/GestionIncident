<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fr.projet.modeles.Utilisateur" %>
<%@ page import="fr.projet.modeles.Incident" %>
<%@ page import="java.util.List" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if (u == null) { response.sendRedirect("connexion.jsp"); return; }
    List<Incident> incidents = (List<Incident>) request.getAttribute("incidents");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Incidents - Gestion d'Incidents</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/structure.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="layout-dashboard">
        <%@ include file="fragments/sidebar.jsp" %>

        <main class="contenu-principal">
            <div class="dashboard-container">
                <div class="header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
                    <div>
                        <h1>Mes Incidents</h1>
                        <p style="color: var(--texte-muet);">Suivez l'état de vos demandes d'assistance.</p>
                    </div>
                    <button type="button" onclick="ouvrirModalIncident()" style="width: auto; padding: 12px 24px; display: flex; align-items: center; gap: 8px;">
                        <i data-lucide="plus-circle"></i>
                        Déclarer un incident
                    </button>
                </div>

                <% String message = (String) request.getAttribute("message");
                   if (message != null) { %>
                   <div style="margin-bottom: 20px; padding: 16px; border-radius: 16px; background: rgba(16, 185, 129, 0.12); color: #047857;">
                       <%= message %>
                   </div>
                <% } %>

                <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); overflow: hidden;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: rgba(255,255,255,0.02);">
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">INCIDENT</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">STATUT</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">OUVERT LE</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">DERNIÈRE MAJ</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (incidents != null && !incidents.isEmpty()) { 
                                for (Incident inc : incidents) { %>
                                <tr style="border-top: 1px solid var(--bordure);">
                                    <td style="padding: 16px;">
                                        <strong><%= inc.getTitre() %></strong><br>
                                        <small style="color: var(--texte-muet);"><%= inc.getDescription().substring(0, Math.min(inc.getDescription().length(), 40)) %>...</small>
                                    </td>
                                    <td style="padding: 16px;">
                                        <span style="background: rgba(99, 102, 241, 0.1); color: var(--couleur-primaire); padding: 4px 12px; border-radius: 20px; font-size: 0.75rem;">
                                            <%= inc.getStatut() %>
                                        </span>
                                    </td>
                                    <td style="padding: 16px; font-size: 0.9rem;"><%= inc.getDateOuverture().toLocalDate() %></td>
                                    <td style="padding: 16px; font-size: 0.9rem; color: var(--texte-muet);">-</td>
                                    <td style="padding: 16px;"><a href="#" style="color: var(--couleur-primaire); text-decoration: none;"><i data-lucide="eye"></i></a></td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="5" style="text-align: center; padding: 60px; color: var(--texte-muet);">Aucun incident enregistré.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <div id="modalIncident" class="modal" style="display:none; position: fixed; inset:0; background: rgba(0,0,0,0.5); z-index: 100; justify-content: center; align-items: center;">
        <div style="background: var(--surface); border-radius: 24px; width: min(720px, 95%); padding: 32px; position: relative;">
            <button type="button" onclick="fermerModalIncident()" style="position:absolute; top: 16px; right: 16px; background: transparent; border: none; color: var(--texte); font-size: 1.2rem; cursor: pointer;">✕</button>
            <h2>Déclarer un nouvel incident</h2>
            <p style="color: var(--texte-muet); margin-bottom: 20px;">Remplissez les champs ci-dessous pour enregistrer un incident sur Supabase.</p>
            <form action="incidents" method="post">
                <div style="display: grid; gap: 18px;">
                    <label>
                        <span style="display:block; margin-bottom: 8px; font-weight:600;">Titre</span>
                        <input type="text" name="titre" required style="width:100%; padding: 14px; border-radius: 14px; border: 1px solid var(--bordure); background: var(--surface); color: var(--texte);" />
                    </label>
                    <label>
                        <span style="display:block; margin-bottom: 8px; font-weight:600;">Description</span>
                        <textarea name="description" rows="6" required style="width:100%; padding: 14px; border-radius: 14px; border: 1px solid var(--bordure); background: var(--surface); color: var(--texte);"></textarea>
                    </label>
                    <label>
                        <span style="display:block; margin-bottom: 8px; font-weight:600;">Type d'incident</span>
                        <select name="typeIncident" required style="width:100%; padding: 14px; border-radius: 14px; border: 1px solid var(--bordure); background: var(--surface); color: var(--texte);">
                            <option value="SOFTWARE">Software</option>
                            <option value="HARDWARE">Hardware</option>
                        </select>
                    </label>
                    <div style="display: flex; justify-content: flex-end; gap: 12px; margin-top: 8px;">
                        <button type="button" onclick="fermerModalIncident()" style="background: transparent; border: 1px solid var(--bordure); padding: 12px 20px; border-radius: 14px; color: var(--texte);">Annuler</button>
                        <button type="submit" style="background: var(--couleur-primaire); border:none; color:#fff; padding: 12px 24px; border-radius: 14px;">Enregistrer</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script>
        lucide.createIcons();
        function ouvrirModalIncident() {
            document.getElementById('modalIncident').style.display = 'flex';
        }
        function fermerModalIncident() {
            document.getElementById('modalIncident').style.display = 'none';
        }
    </script>
</body>
</html>
