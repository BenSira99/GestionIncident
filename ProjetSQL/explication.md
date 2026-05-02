# Rapport d'Implementation PL/SQL — Gestion d'une Bibliotheque Universitaire

**Auteur** : Ligban Droh Ben Sira
**Module** : Bases de Donnees Avancees — PL/SQL
**Date** : 02 Mai 2026
**Environnement** : Oracle Database 19c Enterprise Edition

Ce document detaille avec precision la structure, le fonctionnement ainsi que les choix d'implementation de chaque bloc PL/SQL mis en oeuvre pour le module de gestion de la bibliotheque universitaire.

---

## 1. Structure du Modele Relationnel (DDL)

Le projet repose sur **3 tables principales** concues pour respecter l'integrite referentielle et eviter les anomalies d'insertion.

### Table `ETUDIANT`

| Champ           | Type                      | Description                      |
| --------------- | ------------------------- | -------------------------------- |
| `id_etudiant` | `NUMBER PRIMARY KEY`    | Identifiant unique de l'etudiant |
| `nom`         | `VARCHAR2(50) NOT NULL` | Nom de famille                   |
| `prenom`      | `VARCHAR2(50) NOT NULL` | Prenom                           |
| `filiere`     | `VARCHAR2(50)`          | Cursus universitaire suivi       |

**Role** : Referentiel des etudiants inscrits a l'universite pouvant effectuer des emprunts.

### Table `LIVRE`

| Champ              | Type                              | Description                                                                    |
| ------------------ | --------------------------------- | ------------------------------------------------------------------------------ |
| `id_livre`       | `NUMBER PRIMARY KEY`            | Identifiant unique du livre                                                    |
| `titre`          | `VARCHAR2(100) NOT NULL`        | Titre de l'ouvrage                                                             |
| `auteur`         | `VARCHAR2(100) NOT NULL`        | Auteur de l'ouvrage                                                            |
| `nb_exemplaires` | `NUMBER DEFAULT 0 CHECK (>= 0)` | Quantite disponible en rayon. La contrainte `CHECK` empeche un stock negatif |

**Role** : Referentiel des livres disponibles au sein de la bibliotheque.

### Table `EMPRUNT`

| Champ            | Type                   | Description                            |
| ---------------- | ---------------------- | -------------------------------------- |
| `id_emprunt`   | `NUMBER PRIMARY KEY` | Identifiant unique de l'emprunt        |
| `id_etudiant`  | `NUMBER NOT NULL`    | Reference a l'etudiant (cle etrangere) |
| `id_livre`     | `NUMBER NOT NULL`    | Reference au livre (cle etrangere)     |
| `date_emprunt` | `DATE NOT NULL`      | Date de debut de l'emprunt             |
| `date_retour`  | `DATE`               | Date de retour (NULL si en cours)      |

**Contraintes** :

- `fk_etudiant` : Cle etrangere vers `ETUDIANT` avec `ON DELETE CASCADE`.
- `fk_livre` : Cle etrangere vers `LIVRE` avec `ON DELETE CASCADE`.

Ces clauses `ON DELETE CASCADE` garantissent la coherence des donnees : si un etudiant ou un livre est supprime, les emprunts associes sont automatiquement supprimes.

### Donnees d'exemple inserees

**5 etudiants** :

| ID | Nom     | Prenom | Filiere       |
| -- | ------- | ------ | ------------- |
| 1  | Martin  | Alice  | Informatique  |
| 2  | Bernard | Luc    | Mathematiques |
| 3  | Thomas  | Sophie | Physique      |
| 4  | Petit   | Hugo   | Chimie        |
| 5  | Robert  | Emma   | Biologie      |

**5 livres** :

| ID  | Titre                           | Auteur    | Stock |
| --- | ------------------------------- | --------- | ----- |
| 101 | Algorithmique Avancee           | Cormen    | 3     |
| 102 | Bases de donnees relationnelles | Codd      | 2     |
| 103 | Physique Quantique              | Feynman   | 1     |
| 104 | Chimie Organique                | Vollhardt | 4     |
| 105 | Introduction a l'IA             | Russell   | 0     |

> **Note** : Le livre 105 est volontairement insere avec 0 exemplaires pour tester le cas de refus d'emprunt.

---

## 2. Analyse Approfondie des Blocs PL/SQL

### A. Procedure `emprunter_livre (p_id_etudiant, p_id_livre)`

**Objectif** : Traiter et enregistrer une demande d'emprunt d'un livre par un etudiant.

**Validation en amont (3 controles)** :

1. **Verification de l'etudiant** — Une requete `SELECT COUNT(*)` determine si l'etudiant existe. Si le resultat vaut 0, une erreur `RAISE_APPLICATION_ERROR(-20001)` est levee.
2. **Verification du livre** — De meme, la procedure verifie l'existence du livre. Si le livre n'existe pas, l'erreur `RAISE_APPLICATION_ERROR(-20002)` est declenchee.
3. **Verification de disponibilite** — Elle lit la valeur actuelle de `nb_exemplaires`. Si cette quantite est inferieure ou egale a 0, l'erreur `RAISE_APPLICATION_ERROR(-20003)` signale que le livre est epuise.

**Actions transactionnelles** :

- Insertion de l'enregistrement dans la table `EMPRUNT` avec `seq_emprunt.NEXTVAL` comme identifiant et `SYSDATE` comme `date_emprunt`.
- Mise a jour du stock dans la table `LIVRE` : `nb_exemplaires = nb_exemplaires - 1`.
- Validation explicite via `COMMIT`.

**Gestion des exceptions** : Tout incident technique imprevu (`WHEN OTHERS`) declenche un `ROLLBACK` pour restaurer l'etat coherent initial de la base de donnees, puis releve l'exception avec `RAISE`.

---

### B. Fonction `nb_emprunts_etudiant (p_id_etudiant)`

**Objectif** : Retourner le nombre total de livres empruntes par un etudiant donne.

**Fonctionnement** :

- Execution d'une requete d'agregation `SELECT COUNT(*)` sur la table `EMPRUNT` filtree sur `id_etudiant = p_id_etudiant`.
- La valeur calculee est stockee dans la variable locale `v_total` puis retournee.

**Type de retour** : `NUMBER`

---

### C. Procedure avec Curseur `afficher_emprunts_etudiant (p_id_etudiant)`

**Objectif** : Afficher en sortie console l'integralite de l'historique des emprunts d'un etudiant en s'appuyant sur un **curseur explicite**.

**Curseur `c_emprunts`** :

- Il effectue une jointure (`JOIN`) entre les tables `EMPRUNT` et `LIVRE` afin de recuperer le titre du livre, la date d'emprunt et la date de retour pour l'etudiant fourni.

**Parcours du curseur** :

1. La procedure ouvre le curseur (`OPEN c_emprunts`).
2. Une boucle (`LOOP`) extrait les lignes une a une (`FETCH`) dans une variable typee (`%ROWTYPE`).
3. La boucle s'arrete lorsque la condition `EXIT WHEN c_emprunts%NOTFOUND` est vraie.
4. Pour chaque enregistrement, le systeme ecrit sur la sortie console via `DBMS_OUTPUT.PUT_LINE` en affichant :
   - Le titre du livre (formate avec `RPAD` sur 35 caracteres)
   - La date d'emprunt (formatee `DD/MM/YYYY`)
   - Le statut : `Retourne le : JJ/MM/AAAA` ou `Statut : En cours`

**Controles supplementaires** :

- Un message explicite s'affiche si aucun emprunt n'est trouve pour cet etudiant (`c_emprunts%ROWCOUNT = 0`).
- L'exception `NO_DATA_FOUND` est geree pour signaler un etudiant introuvable.

---

### D. Procedure `retourner_livre (p_id_emprunt)`

**Objectif** : Cloturer un emprunt actif en enregistrant la date de retour et en incrementant le stock disponible en rayon.

**Processus de controle** :

1. Recuperation des informations de l'emprunt (`id_livre`, `date_retour`) en fonction du `p_id_emprunt` via `SELECT ... INTO`.
2. Si l'emprunt est deja marque d'une date de retour, une erreur `RAISE_APPLICATION_ERROR(-20004)` empeche un double retour d'un meme pret (ce qui fausserait le stock reel).

**Mises a jour des donnees** :

- Enregistrement de la date du jour via `SYSDATE` pour le champ `date_retour` de l'emprunt.
- Incrementation du stock : `nb_exemplaires = nb_exemplaires + 1` dans la table `LIVRE`.
- Validation de la transaction via `COMMIT`.

**Gestion des exceptions** :

- `WHEN NO_DATA_FOUND` : Si l'identifiant de l'emprunt n'existe pas en base, l'erreur `RAISE_APPLICATION_ERROR(-20005)` est levee.
- `WHEN OTHERS` : `ROLLBACK` puis `RAISE` pour tout autre incident.

---

## 3. Plan de Validation et Resultats d'Execution

Le bloc anonyme (section 7 du script) execute **6 actions sequentielles** pour valider le bon fonctionnement de l'ensemble des procedures et fonctions.

### Action 1 — Emprunt nominal (Succes)

- **Description** : L'etudiant ID 1 (Alice Martin) emprunte le livre ID 101 (Algorithmique Avancee).
- **Appel** : `emprunter_livre(1, 101)`
- **Attendu** : Insertion dans `EMPRUNT`, stock passe de 3 a 2.
- **Resultat obtenu** :

```
>>> Action 1 : L'etudiant 1 emprunte le livre 101...
Succes : Le livre a ete emprunte par l'etudiant.
```

> **Verdict** : VALIDE

### Action 2 — Second emprunt nominal (Succes)

- **Description** : L'etudiant ID 1 (Alice Martin) emprunte le livre ID 102 (Bases de donnees relationnelles).
- **Appel** : `emprunter_livre(1, 102)`
- **Attendu** : Insertion dans `EMPRUNT`, stock passe de 2 a 1.
- **Resultat obtenu** :

```
>>> Action 2 : L'etudiant 1 emprunte le livre 102...
Succes : Le livre a ete emprunte par l'etudiant.
```

> **Verdict** : VALIDE

### Action 3 — Comptage des emprunts via la Fonction (Succes)

- **Description** : Appel de la fonction `nb_emprunts_etudiant(1)` pour verifier le nombre total d'emprunts.
- **Attendu** : 2 emprunts.
- **Resultat obtenu** :

```
>>> Action 3 : Calcul du nombre total d'emprunts...
Nombre total d'emprunts pour l'etudiant 1 : 2
```

> **Verdict** : VALIDE

### Action 4 — Affichage via le Curseur (Succes)

- **Description** : Appel de `afficher_emprunts_etudiant(1)` pour lister l'historique complet des emprunts d'Alice Martin.
- **Attendu** : 2 lignes avec le statut "En cours".
- **Resultat obtenu** :

```
>>> Action 4 : Affichage de l'historique des emprunts...
----------------------------------------------------
Historique des emprunts pour : Alice Martin
----------------------------------------------------
Livre : Algorithmique Avancee          | Emprunte le : 02/05/2026 | Statut : En cours
Livre : Bases de donnees relationnelles| Emprunte le : 02/05/2026 | Statut : En cours
```

> **Verdict** : VALIDE

### Action 5 — Retour d'un livre (Succes)

- **Description** : Cloture de l'emprunt ID 1 (Algorithmique Avancee).
- **Appel** : `retourner_livre(1)`
- **Attendu** : `date_retour` mise a jour, stock repasse de 2 a 3.
- **Resultat obtenu** :

```
>>> Action 5 : Retour du livre (emprunt ID 1)...
Succes : Le livre a bien ete retourne et le stock mis a jour.
```

> **Verdict** : VALIDE

### Action 6 — Verification apres retour via le Curseur (Succes)

- **Description** : Re-affichage de l'historique pour constater que le premier emprunt est maintenant marque comme retourne.
- **Attendu** : 1 ligne "Retourne le" + 1 ligne "En cours".
- **Resultat obtenu** :

```
>>> Action 6 : Verification de l'historique apres retour...
----------------------------------------------------
Historique des emprunts pour : Alice Martin
----------------------------------------------------
Livre : Algorithmique Avancee          | Emprunte le : 02/05/2026 | Retourne le : 02/05/2026
Livre : Bases de donnees relationnelles| Emprunte le : 02/05/2026 | Statut : En cours
```

> **Verdict** : VALIDE

---

## 4. Synthese des Resultats

| Element teste                  | Type                | Resultat         |
| ------------------------------ | ------------------- | ---------------- |
| `emprunter_livre`            | Procedure           | **VALIDE** |
| `nb_emprunts_etudiant`       | Fonction            | **VALIDE** |
| `afficher_emprunts_etudiant` | Procedure / Curseur | **VALIDE** |
| `retourner_livre`            | Procedure           | **VALIDE** |

> Tous les blocs PL/SQL ont ete executes avec succes.
> Le script a ete valide sur **Oracle Database 19c** le **27/04/2026**.
>
> *Procedure PL/SQL terminee avec succes.*
