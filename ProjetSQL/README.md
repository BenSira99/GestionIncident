# ProjetSQL - Gestion d'une Bibliothèque Universitaire

## 📋 Description
Module PL/SQL permettant d'informatiser la gestion des opérations courantes d'une bibliothèque universitaire. Le projet modélise le processus d'emprunt de livres, la consultation de l'historique d'un étudiant et les retours d'exemplaires avec gestion automatisée des stocks.

## 🚀 Fonctionnalités
- Création du schéma relationnel (Tables ETUDIANT, LIVRE, EMPRUNT)
- Insertion de données de test (étudiants et livres)
- Emprunt de livre sécurisé (vérification de l'existence des entités et des stocks disponibles)
- Affichage de l'historique de l'étudiant via Curseur PL/SQL
- Calcul dynamique du nombre d'emprunts par étudiant (Fonction)
- Retour de livre et réintégration des stocks automatiques

## 🛠️ Stack Technique
- Base de Données : Oracle SQL / PL/SQL
- Langage de scripts : SQL

## ⚙️ Installation & Utilisation
1. Connectez-vous à votre environnement Oracle DB (via SQL*Plus, SQL Developer ou DBeaver).
2. Ouvrez et exécutez le script `bibliotheque.sql`.
3. Le script inclut la création de tables, les déclencheurs (séquences) et la compilation des procédures et fonctions.
4. Activez la console d'affichage dans votre SGBD en tapant `SET SERVEROUTPUT ON;` pour lire les retours de `DBMS_OUTPUT`.

## 📁 Structure du Projet
- `bibliotheque.sql` : Le code source complet contenant la DDL, les insertions (DML) et les blocs PL/SQL
- `explication.txt` : Le rapport technique détaillant chaque bloc

## 🔒 Sécurité
- Gestion des erreurs stricte avec des codes d'erreurs clairs via `RAISE_APPLICATION_ERROR`.
- Maintien de l'intégrité transactionnelle avec des mécanismes explicites de `COMMIT` et `ROLLBACK` en cas d'échec.

## 📄 Licence
MIT

## 👤 Auteur — BenSira99
