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
    <title>Dashboard - Gestion d'Incidents</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/structure.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="layout-dashboard">
        <!-- Sidebar Reutilisable -->
        <%@ include file="fragments/sidebar.jsp" %>

        <main class="contenu-principal">
            <div class="dashboard-container">
                <div class="header" style="margin-bottom: 40px;">
                    <h1>Bienvenue, <%= u.getPrenom() %></h1>
                    <p style="color: var(--texte-muet);">Voici un résumé de l'activité sur la plateforme.</p>
                </div>

                <div class="carte-stats" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 24px; margin-bottom: 40px;">
                    <div class="stat" style="background: var(--surface); padding: 24px; border-radius: 20px; border: 1px solid var(--bordure);">
                        <p style="color: var(--texte-muet); font-size: 0.8rem;">Incidents Ouverts</p>
                        <h2 style="font-size: 2rem;"><%= (incidents != null) ? incidents.size() : 0 %></h2>
                    </div>
                    <div class="stat" style="background: var(--surface); padding: 24px; border-radius: 20px; border: 1px solid var(--bordure);">
                        <p style="color: var(--texte-muet); font-size: 0.8rem;">En cours</p>
                        <h2 style="font-size: 2rem;">0</h2>
                    </div>
                    <% if ("DSI".equals(u.getRole().name())) { %>
                    <div class="stat" style="background: var(--surface); padding: 24px; border-radius: 20px; border: 1px solid var(--bordure);">
                        <p style="color: var(--texte-muet); font-size: 0.8rem;">Utilisateurs à valider</p>
                        <h2 style="font-size: 2rem; color: #f59e0b;">!</h2>
                    </div>
                    <% } %>
                </div>

                <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); overflow: hidden;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: rgba(255,255,255,0.02);">
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">RÉSUMÉ DES INCIDENTS</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">STATUT</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (incidents != null && !incidents.isEmpty()) { 
                                for (Incident inc : incidents) { %>
                                <tr style="border-top: 1px solid var(--bordure);">
                                    <td style="padding: 16px;"><strong><%= inc.getTitre() %></strong></td>
                                    <td style="padding: 16px;"><span style="background: rgba(245, 158, 11, 0.1); color: #f59e0b; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem;"><%= inc.getStatut() %></span></td>
                                    <td style="padding: 16px; font-size: 0.9rem;"><%= inc.getDateOuverture().toLocalDate() %></td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="3" style="text-align: center; padding: 60px; color: var(--texte-muet);">Rien à signaler.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
