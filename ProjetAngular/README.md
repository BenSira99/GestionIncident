# Projet Académique Angular Sécurisé

## 📋 Description
Projet Angular académique conçu avec une architecture robuste et sécurisée selon les normes AppSec. Ce projet suit une convention de nommage bilingue : structure de dossiers en anglais et logique métier/composants en français.

## 🚀 Fonctionnalités
- Authentification sécurisée
- Gestion des rôles et permissions
- Validation stricte des entrées (Sanitisation)
- Architecture modulaire et scalable

## 🛠️ Stack Technique
- **Framework** : Angular 17+
- **Langage** : TypeScript
- **Style** : CSS (Vanilla)
- **Sécurité** : Normes AppSec (OWASP Top 10 mitigations)

## 📦 Prérequis
- Node.js v18+
- Angular CLI

## ⚙️ Installation
```bash
npm install
```

## 🏃 Lancement
```bash
ng serve
```

## 🧪 Tests
```bash
ng test
```

## 📁 Structure du Projet
- `src/app/core/` : Services transversaux (Français)
- `src/app/features/` : Modules fonctionnels (Français)
- `src/app/shared/` : Composants et pipes partagés (Français)
- `src/app/security/` : Logique de sécurité AppSec

## 🔒 Sécurité
Ce projet implémente les protections suivantes :
- Content Security Policy (CSP)
- Protection XSS (Angular Sanitizer)
- Intercepteurs de sécurité pour les headers HTTP
- Validation de schémas (Zod)

## 📄 Licence
MIT

## 👤 Auteur — BenSira99
