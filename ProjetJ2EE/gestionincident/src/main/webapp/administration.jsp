<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="fr.projet.modeles.Utilisateur" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if (u == null || !"DSI".equals(u.getRole().name())) {
        response.sendRedirect("dashboard");
        return;
    }

    Integer totalUtilisateurs = (Integer) request.getAttribute("totalUtilisateurs");
    Long utilisateursEnAttente = (Long) request.getAttribute("utilisateursEnAttente");
    Integer totalIncidents = (Integer) request.getAttribute("totalIncidents");
    List<Utilisateur> liste = (List<Utilisateur>) request.getAttribute("listeUtilisateurs");
    List<fr.projet.modeles.Incident> incidentsOuverts = (List<fr.projet.modeles.Incident>) request.getAttribute("incidentsOuverts");
    List<Utilisateur> techDisponibles = (List<Utilisateur>) request.getAttribute("techDisponibles");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Administration - Gestion d'Incidents</title>
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
                <div class="header" style="margin-bottom: 24px; display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <h1>Administration</h1>
                        <p style="color: var(--texte-muet);">Tableau de bord administratif et indicateurs.</p>
                    </div>
                </div>

                <div style="display:flex; gap:20px; margin-bottom:20px;">
                    <div style="flex:1; background:var(--surface); padding:20px; border-radius:16px; border:1px solid var(--bordure);">
                        <p style="color:var(--texte-muet);">Total utilisateurs</p>
                        <h2><%= (totalUtilisateurs != null) ? totalUtilisateurs : 0 %></h2>
                        <p style="color:var(--texte-muet); font-size:0.9rem;"><%= (utilisateursEnAttente != null) ? utilisateursEnAttente : 0 %> en attente</p>
                    </div>

                        <div style="margin-bottom:20px;">
                            <h2 style="margin-bottom:12px;">Incidents ouverts</h2>
                            <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); overflow: hidden;">
                                <table style="width:100%; border-collapse:collapse;">
                                    <thead>
                                        <tr style="background: rgba(255,255,255,0.02);">
                                            <th style="text-align:left; padding:16px; color:var(--texte-muet);">TITRE</th>
                                            <th style="text-align:left; padding:16px; color:var(--texte-muet);">OUVERT PAR</th>
                                            <th style="text-align:left; padding:16px; color:var(--texte-muet);">OUVERT LE</th>
                                            <th style="text-align:left; padding:16px; color:var(--texte-muet);">ACTION</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (incidentsOuverts != null && !incidentsOuverts.isEmpty()) {
                                            for (fr.projet.modeles.Incident inc : incidentsOuverts) { %>
                                                <tr style="border-top:1px solid var(--bordure);">
                                                    <td style="padding:16px;"><strong><%= inc.getTitre() %></strong><br><small style="color:var(--texte-muet)"><%= inc.getDescription().length() > 80 ? inc.getDescription().substring(0,80)+"..." : inc.getDescription() %></small></td>
                                                    <td style="padding:16px;"><%= inc.getEmployeId() %></td>
                                                    <td style="padding:16px;"><%= inc.getDateOuverture() != null ? inc.getDateOuverture().toLocalDate() : "-" %></td>
                                                    <td style="padding:16px;">
                                                        <button type="button" onclick="ouvrirModalAffecter('<%= inc.getId() %>')" style="background:var(--couleur-primaire); color:#fff; padding:8px 12px; border-radius:10px; border:none;">Affecter</button>
                                                    </td>
                                                </tr>
                                        <%  } } else { %>
                                            <tr><td colspan="4" style="text-align:center; padding:40px; color:var(--texte-muet);">Aucun incident ouvert.</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Modal d'affectation -->
                        <div id="modalAffecter" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.5); z-index:200; justify-content:center; align-items:center;">
                            <div style="background:var(--surface); border-radius:20px; padding:24px; width:min(640px,95%); position:relative;">
                                <button type="button" onclick="fermerModalAffecter()" style="position:absolute; right:12px; top:12px; background:transparent; border:none; font-size:18px;">✕</button>
                                <h3>Affecter un technicien</h3>
                                <form action="affecter" method="post">
                                    <input type="hidden" id="incidentId" name="incidentId" value="">
                                    <div style="margin-top:12px;">
                                        <label for="technicienId">Technicien disponible</label>
                                        <select id="technicienId" name="technicienId" required style="width:100%; padding:12px; border-radius:10px; margin-top:8px;">
                                            <% if (techDisponibles != null && !techDisponibles.isEmpty()) {
                                                for (Utilisateur t : techDisponibles) { %>
                                                    <option value="<%= t.getId() %>"><%= t.getPrenom() %> <%= t.getNom() %> — <%= t.getSpecialites() != null ? t.getSpecialites() : "" %></option>
                                            <%  } } else { %>
                                                    <option disabled>Aucun technicien disponible</option>
                                            <% } %>
                                        </select>
                                    </div>
                                    <div style="display:flex; justify-content:flex-end; gap:8px; margin-top:16px;">
                                        <button type="button" onclick="fermerModalAffecter()" style="background:transparent; border:1px solid var(--bordure); padding:8px 12px; border-radius:8px;">Annuler</button>
                                        <button type="submit" style="background:var(--couleur-primaire); color:#fff; border:none; padding:8px 12px; border-radius:8px;">Affecter</button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <script>
                            function ouvrirModalAffecter(incidentId) {
                                document.getElementById('incidentId').value = incidentId;
                                document.getElementById('modalAffecter').style.display = 'flex';
                            }
                            function fermerModalAffecter() { document.getElementById('modalAffecter').style.display = 'none'; }
                        </script>
                    <div style="flex:1; background:var(--surface); padding:20px; border-radius:16px; border:1px solid var(--bordure);">
                        <p style="color:var(--texte-muet);">Total incidents</p>
                        <h2><%= (totalIncidents != null) ? totalIncidents : 0 %></h2>
                        <p style="color:var(--texte-muet); font-size:0.9rem;">Vue d'ensemble des signalements</p>
                    </div>
                </div>

                <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); overflow: hidden;">
                    <table style="width:100%; border-collapse:collapse;">
                        <thead>
                            <tr style="background: rgba(255,255,255,0.02);">
                                <th style="text-align:left; padding:16px; color:var(--texte-muet);">NOM / PRÉNOM</th>
                                <th style="text-align:left; padding:16px; color:var(--texte-muet);">EMAIL</th>
                                <th style="text-align:left; padding:16px; color:var(--texte-muet);">RÔLE</th>
                                <th style="text-align:left; padding:16px; color:var(--texte-muet);">STATUT</th>
                                <th style="text-align:left; padding:16px; color:var(--texte-muet);">ACTION</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (liste != null && !liste.isEmpty()) {
                                for (Utilisateur user : liste) { %>
                                    <tr style="border-top:1px solid var(--bordure);">
                                        <td style="padding:16px;"><strong><%= user.getNom() %> <%= user.getPrenom() %></strong></td>
                                        <td style="padding:16px;"><%= user.getEmail() %></td>
                                        <td style="padding:16px;"><%= user.getRole() %></td>
                                        <td style="padding:16px;"><%= user.isEstActif() ? "Actif" : "En attente" %></td>
                                        <td style="padding:16px;">
                                            <% if (!user.isEstActif()) { %>
                                                <form action="valider-utilisateur" method="post" style="display:inline;">
                                                    <input type="hidden" name="id" value="<%= user.getId() %>">
                                                    <button type="submit" style="background:var(--couleur-primaire); color:#fff; padding:8px 12px; border-radius:10px; border:none;">Activer</button>
                                                </form>
                                            <% } %>
                                        </td>
                                    </tr>
                            <%  } } else { %>
                                <tr><td colspan="5" style="text-align:center; padding:40px; color:var(--texte-muet);">Aucun utilisateur trouvé.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>
</body>
</html>