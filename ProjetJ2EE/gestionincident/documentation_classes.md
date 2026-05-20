# Documentation des Classes — Gestion d'Incidents

Ce document décrit le rôle de chaque classe et énumération utilisée dans le projet de gestion d'incidents.

## 👥 Acteurs (Utilisateurs)

### `Utilisateur` (Abstraite)

Classe de base pour tous les utilisateurs du système. Elle contient les informations communes : nom, email, mot de passe (hashé), téléphone et statut actif. Chaque utilisateur est obligatoirement rattaché à une `Ville` pour sa localisation. Elle implémente l'interface `IAuthentifiable`.

### `Employe`

Représente l'utilisateur final qui rencontre un problème technique. Il peut soumettre des incidents, consulter l'état de ses demandes et donner un feedback une fois l'incident résolu.

### `Technicien`

Spécialiste chargé de la résolution des incidents. Il possède des spécialités et un niveau d'expertise. Il reçoit des affectations, rédige des rapports d'intervention et peut consulter ses statistiques de performance.

### `DSI` (Directeur des Systèmes d'Information)

Administrateur du système. Il a une vue globale, affecte les techniciens aux incidents et génère les rapports d'activité.

## 🛠️ Cœur du Métier

### `Incident`

Représente un problème technique signalé.

- **Distinction Hardware/Software** : Un incident peut être de type matériel (Hardware) ou logiciel (Software).
- Il possède un statut (Ouvert, En cours, Résolu, etc.), une priorité et une complexité.
- Il est lié à l'employé qui l'a créé et au matériel concerné (si Hardware).

### `Materiel`

Représente l'équipement physique (Ordinateur, Imprimante, etc.) possédé par l'entreprise.

### `CategorieIncident`

Permet de classifier les incidents (Réseau, Logiciel, Matériel, etc.). Chaque catégorie définit un délai de résolution théorique.

### `Affectation`

Liaison temporelle entre un `Incident` et un `Technicien`. Elle suit le cycle de vie de l'intervention (Date début, Date fin, Rapport).

## 📊 Suivi et Qualité

### `Feedback`

Évaluation déposée par l'employé après la clôture d'un incident. Contient une note et un commentaire sur la satisfaction globale.
### `Ville`

Localisation géographique. Dans cette version simplifiée, elle est uniquement rattachée à l'Utilisateur.

### `Rapport`

Document consolidé généré par la DSI pour analyser les performances du système sur une période donnée.

### `StatistiqueTechnicien`

Indicateurs de performance spécifiques à un technicien (nombre d'incidents, taux de réussite, temps de résolution).

## ⚙️ Énumérations (Types)

- **`StatutIncident`** : Cycle de vie d'un incident.
- **`PrioriteIncident`** : Urgence (Faible à Critique).
- **`ComplexiteIncident`** : Difficulté technique.
- **`TypeIncident`** : Hardware ou Software.
- **`TypeMateriel`** : Nature de l'équipement physique.
- **`StatutAffectation`** : État de l'assignation au technicien.
- **`RoleUtilisateur`** : Droits d'accès (Employé, Technicien, DSI).
