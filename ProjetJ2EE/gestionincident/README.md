# 🛠️ Gestionnaire d'Incidents Premium

Plateforme de gestion d'incidents informatiques moderne, développée en Java J2EE avec une architecture MVC et une base de données **Supabase** (PostgreSQL).

## 🚀 Fonctionnalités
- **Authentification Sécurisée** : Connexion avec hachage BCrypt.
- **Interface Glassmorphism** : Design premium et responsive.
- **Workflow DSI** : Validation des comptes et gestion centralisée.
- **Hot Reload** : Rechargement automatique du code en développement via Jetty.
- **Sécurité RLS** : Protection des données au niveau ligne avec Row Level Security.

## 🛠️ Stack Technique
- **Backend** : Java 11+, Jakarta EE 10 (Servlets, JSP).
- **Base de données** : Supabase / PostgreSQL.
- **Pool de connexion** : HikariCP.
- **Build** : Maven.
- **Serveur** : Jetty 11 (Développement).

## ⚙️ Installation
1. Configurer vos accès dans `src/main/resources/db.properties`.
2. Initialiser la base de données via le CLI Supabase : `supabase db push`.
3. Lancer le projet : Double-cliquez sur `lancer-projet.bat`.

## 🔒 Sécurité
Le projet respecte les standards OWASP avec une validation stricte des entrées et une gestion sécurisée des sessions.

---
**Auteur** : BenSira99
**Licence** : MIT
