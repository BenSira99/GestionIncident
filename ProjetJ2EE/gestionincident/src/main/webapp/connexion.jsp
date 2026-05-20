<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion | Gestion d'Incidents</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <!-- CSS -->
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <div class="conteneur-auth">
        <!-- Section Visuelle -->
        <div class="visuel">
            <div style="position: absolute; bottom: 40px; left: 40px; z-index: 2;">
                <h2 style="font-size: 1.5rem; font-weight: 600;">Portail Technique</h2>
                <p style="color: rgba(255,255,255,0.7); font-size: 0.9rem;">Sécurisé par BenSira Vault</p>
            </div>
        </div>

        <!-- Section Formulaire -->
        <div class="formulaire-section">
            <h1>Bienvenue</h1>
            <p class="sous-titre">Veuillez vous authentifier pour continuer.</p>

            <%
                String message = (String) session.getAttribute("inscriptionMessage");
                String erreur = (String) request.getAttribute("erreur");
                if (message != null) {
                    session.removeAttribute("inscriptionMessage");
                }
            %>
            <% if (erreur != null) { %>
                <div style="background: rgba(239, 68, 68, 0.1); border: 1px solid #ef4444; color: #ef4444; padding: 12px; border-radius: 8px; margin-bottom: 24px; font-size: 0.875rem;">
                    <%= erreur %>
                </div>
            <% } %>

            <% if (message != null) { %>
                <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid #10b981; color: #10b981; padding: 12px; border-radius: 8px; margin-bottom: 24px; font-size: 0.875rem;">
                    <%= message %>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="groupe-champ">
                    <label for="email">Adresse Email</label>
                    <input type="email" id="email" name="email" placeholder="nom@entreprise.com" required>
                </div>

                <div class="groupe-champ">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit">Se connecter</button>
            </form>

            <div style="margin-top: 32px; text-align: center;">
                <p style="color: var(--texte-muet); font-size: 0.8rem;">
                    Nouveau ici ? <a href="inscription.jsp" style="color: var(--couleur-secondaire); text-decoration: none; font-weight: 600;">Créer un compte</a>
                </p>
                <p style="color: var(--texte-muet); font-size: 0.8rem; margin-top: 8px;">
                    Problème d'accès ? <a href="#" style="color: var(--couleur-primaire); text-decoration: none;">Contacter la DSI</a>
                </p>
            </div>
        </div>
    </div>

</body>
</html>
