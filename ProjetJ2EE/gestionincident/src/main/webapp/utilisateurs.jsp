<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fr.projet.modeles.Utilisateur" %>
<%@ page import="java.util.List" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if (u == null || !"DSI".equals(u.getRole().name())) {
        response.sendRedirect("dashboard");
        return;
    }
    List<Utilisateur> tousUtilisateurs = (List<Utilisateur>) request.getAttribute("listeUtilisateurs");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Utilisateurs - DSI</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/structure.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="layout-dashboard">
        <!-- Inclusion de la Sidebar -->
        <%@ include file="fragments/sidebar.jsp" %>

        <main class="contenu-principal">
            <div class="dashboard-container">
                <div class="header" style="margin-bottom: 40px;">
                    <h1>Gestion des Comptes</h1>
                    <p style="color: var(--texte-muet);">Activez ou gérez les accès des collaborateurs.</p>
                </div>

                <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); overflow: hidden;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: rgba(255,255,255,0.02);">
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">NOM / PRÉNOM</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">EMAIL</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">RÔLE</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">STATUT</th>
                                <th style="text-align: left; padding: 16px; color: var(--texte-muet); font-size: 0.8rem;">ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (tousUtilisateurs != null) { 
                                for (Utilisateur user : tousUtilisateurs) { %>
                                <tr style="border-top: 1px solid var(--bordure);">
                                    <td style="padding: 16px;"><strong><%= user.getNom() %> <%= user.getPrenom() %></strong></td>
                                    <td style="padding: 16px; font-size: 0.9rem;"><%= user.getEmail() %></td>
                                    <td style="padding: 16px;"><span style="font-size: 0.8rem; opacity: 0.8;"><%= user.getRole() %></span></td>
                                    <td style="padding: 16px;">
                                        <% if (user.isEstActif()) { %>
                                            <span style="background: rgba(16, 185, 129, 0.1); color: #10b981; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem;">Actif</span>
                                        <% } else { %>
                                            <span style="background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem;">En attente</span>
                                        <% } %>
                                    </td>
                                    <td style="padding: 16px;">
                                        <% if (!user.isEstActif()) { %>
                                            <form action="valider-utilisateur" method="post" style="display:inline;">
                                                <input type="hidden" name="id" value="<%= user.getId() %>">
                                                <button type="submit" style="background: var(--couleur-primaire); padding: 6px 12px; font-size: 0.8rem; width: auto;">Activer</button>
                                            </form>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
