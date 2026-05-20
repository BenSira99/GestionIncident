<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription - Gestion d'Incidents</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/inscription.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
    <div class="conteneur-auth" style="height: auto; padding: 40px;">
        <div class="formulaire-section" style="width: 100%; max-width: 500px; margin: 0 auto;">
            <h1>Créer un compte</h1>
            <p class="sous-titre">Rejoignez la plateforme de gestion d'incidents.</p>

            <%
                String message = (String) session.getAttribute("inscriptionMessage");
                String erreur = (String) session.getAttribute("inscriptionErreur");
                if (message != null) {
                    session.removeAttribute("inscriptionMessage");
                }
                if (erreur != null) {
                    session.removeAttribute("inscriptionErreur");
                }
            %>
            <% if (message != null) { %>
                <div style="background: rgba(16, 185, 129, 0.12); border: 1px solid #10b981; color: #047857; padding: 14px; border-radius: 12px; margin-bottom: 20px;">
                    <%= message %>
                </div>
            <% } %>
            <% if (erreur != null) { %>
                <div style="background: rgba(239, 68, 68, 0.12); border: 1px solid #ef4444; color: #b91c1c; padding: 14px; border-radius: 12px; margin-bottom: 20px;">
                    <%= erreur %>
                </div>
            <% } %>
            <form action="inscription" method="post">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div class="groupe-champ">
                        <label for="nom">Nom</label>
                        <input type="text" id="nom" name="nom" placeholder="Dupont" required>
                    </div>
                    <div class="groupe-champ">
                        <label for="prenom">Prénom</label>
                        <input type="text" id="prenom" name="prenom" placeholder="Jean" required>
                    </div>
                </div>

                <div class="groupe-champ">
                    <label for="email">Adresse Email Pro</label>
                    <input type="email" id="email" name="email" placeholder="j.dupont@entreprise.com" required>
                </div>

                <div class="groupe-champ">
                    <label>Vous êtes ?</label>
                    <div class="selection-role">
                        <input type="radio" name="role" value="EMPLOYE" id="role-employe" checked required>
                        <label for="role-employe" class="carte-role">
                            <i data-lucide="user-round" class="icone"></i>
                            <span class="titre">Employé</span>
                            <span class="desc">Déclarer des incidents</span>
                        </label>

                        <input type="radio" name="role" value="TECHNICIEN" id="role-tech">
                        <label for="role-tech" class="carte-role">
                            <i data-lucide="wrench" class="icone"></i>
                            <span class="titre">Technicien</span>
                            <span class="desc">Résoudre les pannes</span>
                        </label>
                    </div>
                </div>

                <div class="groupe-champ">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <div id="champs-employe" style="display:block; margin-top: 12px;">
                    <p style="color: var(--texte-muet); margin-bottom: 16px;">Le matricule est généré automatiquement pour les employés.</p>
                    <div class="groupe-champ">
                        <label for="departement">Département</label>
                        <input type="text" id="departement" name="departement" placeholder="IT">
                    </div>
                    <div class="groupe-champ">
                        <label for="poste">Poste</label>
                        <input type="text" id="poste" name="poste" placeholder="Analyste">
                    </div>
                </div>

                <div id="champs-tech" style="display:none; margin-top: 12px;">
                    <div class="groupe-champ">
                        <label for="specialites">Spécialités</label>
                        <input type="text" id="specialites" name="specialites" placeholder="Réseau, Serveur">
                    </div>
                    <div class="groupe-champ">
                        <label for="niveau_expertise">Niveau d'expertise (1-5)</label>
                        <input type="number" id="niveau_expertise" name="niveau_expertise" min="1" max="5" value="3">
                    </div>
                    <div class="groupe-champ">
                        <label for="telephone">Téléphone</label>
                        <input type="text" id="telephone" name="telephone" placeholder="0612345678">
                    </div>
                </div>

                <button type="submit" style="margin-top: 20px;">S'inscrire</button>
            </form>

            <p style="margin-top: 24px; text-align: center; color: var(--texte-muet); font-size: 0.9rem;">
                Déjà un compte ? <a href="connexion.jsp" style="color: var(--couleur-secondaire); text-decoration: none;">Se connecter</a>
            </p>
        </div>
    </div>
    <script>
        lucide.createIcons();
        const roleEmploye = document.getElementById('role-employe');
        const roleTech = document.getElementById('role-tech');
        function basculerChamps() {
            if (roleTech.checked) {
                document.getElementById('champs-tech').style.display = 'block';
                document.getElementById('champs-employe').style.display = 'none';
            } else {
                document.getElementById('champs-tech').style.display = 'none';
                document.getElementById('champs-employe').style.display = 'block';
            }
        }
        roleEmploye.addEventListener('change', basculerChamps);
        roleTech.addEventListener('change', basculerChamps);
    </script>
</body>
</html>
