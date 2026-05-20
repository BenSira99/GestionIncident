<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="fr.projet.modeles.Utilisateur" %>
<%
    Utilisateur utilisateur = (Utilisateur) request.getAttribute("profilUtilisateur");
    if (utilisateur == null) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Profil - Gestion d'Incidents</title>
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
                <div class="header" style="margin-bottom: 40px;">
                    <h1>Mon Profil</h1>
                    <p style="color: var(--texte-muet);">Consultez et mettez à jour vos informations personnelles.</p>
                </div>

                <div style="background: var(--surface); border-radius: 20px; border: 1px solid var(--bordure); padding: 32px; max-width: 900px;">
                    <div style="display: grid; gap: 20px;">
                        <div>
                            <h2>Informations de base</h2>
                            <p><strong>Nom :</strong> <%= utilisateur.getPrenom() %> <%= utilisateur.getNom() %></p>
                            <p><strong>Email :</strong> <%= utilisateur.getEmail() %></p>
                            <p><strong>Téléphone :</strong> <%= utilisateur.getTelephone() != null ? utilisateur.getTelephone() : "Non renseigné" %></p>
                            <p><strong>Rôle :</strong> <%= utilisateur.getRole() %></p>
                            <p><strong>Statut :</strong> <%= utilisateur.isEstActif() ? "Actif" : "En attente" %></p>
                        </div>
                        <div>
                            <h2>Détails métier</h2>
                            <% if ("EMPLOYE".equals(utilisateur.getRole().name())) { %>
                                <p><strong>Matricule :</strong> <%= utilisateur.getMatricule() != null ? utilisateur.getMatricule() : "-" %></p>
                                <p><strong>Département :</strong> <%= utilisateur.getDepartement() != null ? utilisateur.getDepartement() : "-" %></p>
                                <p><strong>Poste :</strong> <%= utilisateur.getPoste() != null ? utilisateur.getPoste() : "-" %></p>
                            <% } else if ("TECHNICIEN".equals(utilisateur.getRole().name())) { %>
                                <p><strong>Spécialités :</strong> <%= utilisateur.getSpecialites() != null ? utilisateur.getSpecialites() : "-" %></p>
                                <p><strong>Disponibilité :</strong> <%= utilisateur.isEstDisponible() ? "Disponible" : "Occupé" %></p>
                                <p><strong>Niveau d'expertise :</strong> <%= utilisateur.getNiveauExpertise() %></p>
                            <% } else { %>
                                <p>Rôle DSI : accès complet aux options d’administration.</p>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
