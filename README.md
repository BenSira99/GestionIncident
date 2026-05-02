# Projet Academique

## 📋 Description
Ce projet academique comprend une gestion de base de donnees SQL avec PL/SQL pour une bibliotheque universitaire, ainsi qu'un projet frontend.

## 🚀 Fonctionnalités
- Gestion des etudiants, livres et emprunts.
- Validation des stocks en amont via triggers et procedures.
- Calcul de statistiques d'emprunts.
- Generation de rapports d'historique d'emprunts par etudiant.

## 🛠️ Stack Technique
- Oracle Database 19c
- PL/SQL
- Git & GitHub

## 📦 Prérequis
- Oracle Database 19c ou version superieure.
- SQL*Plus ou SQL Developer.

## ⚙️ Installation
Cloner le depot :
```bash
git clone https://github.com/BenSira99/ProjetAcademique.git
```

## 🔧 Configuration (.env)
Aucune variable d'environnement requise pour la partie SQL.

## 🏃 Lancement
Executer le script SQL dans Oracle :
```sql
@ProjetSQL/bibliotheque.sql
```

## 🧪 Tests
Les tests sont inclus directement a la fin du script `bibliotheque.sql`.

## 🐳 Docker
Non applicable.

## 📁 Structure du Projet
```
.
├── ProjetAngular/      # Code source Angular
├── ProjetSQL/          # Code source SQL et PL/SQL
│   ├── bibliotheque.sql
│   ├── explication.md
│   └── result.txt
├── .gitignore
├── LICENSE
└── README.md
```

## 🔒 Sécurité
- Pas de secrets en dur.
- Validation rigoureuse des entrees et contraintes SQL.

## 📄 Licence
Ce projet est sous licence MIT.

## 👤 Auteur — BenSira99
Ligban Droh Ben Sira
