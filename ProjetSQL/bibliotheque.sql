-- ==============================================================================
-- Projet PL/SQL : Gestion d'une bibliotheque universitaire
-- Auteur : BenSira99
-- Description : Script de creation des tables, insertion de donnees, et 
--               creation des blocs PL/SQL (Procedures, Fonctions, Curseurs).
-- ==============================================================================

SET SERVEROUTPUT ON;

SPOOL D:\plsql\result.txt;

-- 1. Creation des tables

-- Table ETUDIANT
CREATE TABLE ETUDIANT (
    id_etudiant NUMBER PRIMARY KEY,
    nom VARCHAR2(50) NOT NULL,
    prenom VARCHAR2(50) NOT NULL,
    filiere VARCHAR2(50)
);

-- Table LIVRE
CREATE TABLE LIVRE (
    id_livre NUMBER PRIMARY KEY,
    titre VARCHAR2(100) NOT NULL,
    auteur VARCHAR2(100) NOT NULL,
    nb_exemplaires NUMBER DEFAULT 0 CHECK (nb_exemplaires >= 0)
);

-- Table EMPRUNT
CREATE TABLE EMPRUNT (
    id_emprunt NUMBER PRIMARY KEY,
    id_etudiant NUMBER NOT NULL,
    id_livre NUMBER NOT NULL,
    date_emprunt DATE NOT NULL,
    date_retour DATE,
    CONSTRAINT fk_etudiant FOREIGN KEY (id_etudiant) REFERENCES ETUDIANT(id_etudiant) ON DELETE CASCADE,
    CONSTRAINT fk_livre FOREIGN KEY (id_livre) REFERENCES LIVRE(id_livre) ON DELETE CASCADE
);

-- ==============================================================================
-- 2. Insertion des donnees d'exemple
-- ==============================================================================

-- Insertion de 5 etudiants
INSERT INTO ETUDIANT (id_etudiant, nom, prenom, filiere) VALUES (1, 'Martin', 'Alice', 'Informatique');
INSERT INTO ETUDIANT (id_etudiant, nom, prenom, filiere) VALUES (2, 'Bernard', 'Luc', 'Mathematiques');
INSERT INTO ETUDIANT (id_etudiant, nom, prenom, filiere) VALUES (3, 'Thomas', 'Sophie', 'Physique');
INSERT INTO ETUDIANT (id_etudiant, nom, prenom, filiere) VALUES (4, 'Petit', 'Hugo', 'Chimie');
INSERT INTO ETUDIANT (id_etudiant, nom, prenom, filiere) VALUES (5, 'Robert', 'Emma', 'Biologie');

-- Insertion de 5 livres
INSERT INTO LIVRE (id_livre, titre, auteur, nb_exemplaires) VALUES (101, 'Algorithmique Avancee', 'Cormen', 3);
INSERT INTO LIVRE (id_livre, titre, auteur, nb_exemplaires) VALUES (102, 'Bases de donnees relationnelles', 'Codd', 2);
INSERT INTO LIVRE (id_livre, titre, auteur, nb_exemplaires) VALUES (103, 'Physique Quantique', 'Feynman', 1);
INSERT INTO LIVRE (id_livre, titre, auteur, nb_exemplaires) VALUES (104, 'Chimie Organique', 'Vollhardt', 4);
INSERT INTO LIVRE (id_livre, titre, auteur, nb_exemplaires) VALUES (105, 'Introduction a l''IA', 'Russell', 0); -- Livre indisponible

COMMIT;


-- ==============================================================================
-- 3. Procedure emprunter_livre
-- ==============================================================================
CREATE OR REPLACE PROCEDURE emprunter_livre (
    p_id_etudiant IN NUMBER,
    p_id_livre IN NUMBER
) IS
    v_nb_exemplaires NUMBER;
    v_etudiant_existe NUMBER;
    v_livre_existe NUMBER;
BEGIN
    -- Verification de l'existence de l'etudiant
    SELECT COUNT(*) INTO v_etudiant_existe FROM ETUDIANT WHERE id_etudiant = p_id_etudiant;
    IF v_etudiant_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Erreur : L''etudiant specifie n''existe pas.');
    END IF;

    -- Verification de l'existence du livre
    SELECT COUNT(*) INTO v_livre_existe FROM LIVRE WHERE id_livre = p_id_livre;
    IF v_livre_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Erreur : Le livre specifie n''existe pas.');
    END IF;

    -- Verification de la disponibilite du livre
    SELECT nb_exemplaires INTO v_nb_exemplaires FROM LIVRE WHERE id_livre = p_id_livre;
    IF v_nb_exemplaires <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Erreur : Le livre n''est actuellement plus disponible (0 exemplaire).');
    END IF;

    -- Creation de l'emprunt
    INSERT INTO EMPRUNT (id_emprunt, id_etudiant, id_livre, date_emprunt, date_retour)
    VALUES (seq_emprunt.NEXTVAL, p_id_etudiant, p_id_livre, SYSDATE, NULL);

    -- Mise a jour du stock
    UPDATE LIVRE SET nb_exemplaires = nb_exemplaires - 1 WHERE id_livre = p_id_livre;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Succes : Le livre a ete emprunte par l''etudiant.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END emprunter_livre;
/



-- ==============================================================================
-- 4. Fonction nb_emprunts_etudiant
-- ==============================================================================
CREATE OR REPLACE FUNCTION nb_emprunts_etudiant (
    p_id_etudiant IN NUMBER
) RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total 
    FROM EMPRUNT 
    WHERE id_etudiant = p_id_etudiant;
    
    RETURN v_total;
END nb_emprunts_etudiant;
/


-- ==============================================================================
-- 5. Curseur - Afficher les emprunts d'un etudiant
-- ==============================================================================
CREATE OR REPLACE PROCEDURE afficher_emprunts_etudiant (
    p_id_etudiant IN NUMBER
) IS
    -- Declaration du curseur pour recuperer les informations requises
    CURSOR c_emprunts IS
        SELECT l.titre, e.date_emprunt, e.date_retour
        FROM EMPRUNT e
        JOIN LIVRE l ON e.id_livre = l.id_livre
        WHERE e.id_etudiant = p_id_etudiant;
    
    v_emprunt c_emprunts%ROWTYPE;
    v_etudiant_nom VARCHAR2(100);
BEGIN
    -- Recuperation du nom de l'etudiant pour affichage (optionnel, pour l'UX)
    SELECT prenom || ' ' || nom INTO v_etudiant_nom FROM ETUDIANT WHERE id_etudiant = p_id_etudiant;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Historique des emprunts pour : ' || v_etudiant_nom);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    OPEN c_emprunts;
    LOOP
        FETCH c_emprunts INTO v_emprunt;
        EXIT WHEN c_emprunts%NOTFOUND;
        
        DBMS_OUTPUT.PUT('Livre : ' || RPAD(v_emprunt.titre, 35) || ' | Emprunte le : ' || TO_CHAR(v_emprunt.date_emprunt, 'DD/MM/YYYY'));
        
        IF v_emprunt.date_retour IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(' | Retourne le : ' || TO_CHAR(v_emprunt.date_retour, 'DD/MM/YYYY'));
        ELSE
            DBMS_OUTPUT.PUT_LINE(' | Statut : En cours');
        END IF;
    END LOOP;
    
    -- Si aucun emprunt
    IF c_emprunts%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucun emprunt enregistre pour cet etudiant.');
    END IF;
    
    CLOSE c_emprunts;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Erreur : Etudiant introuvable.');
END afficher_emprunts_etudiant;
/


-- ==============================================================================
-- 6. Procedure retourner_livre
-- ==============================================================================
CREATE OR REPLACE PROCEDURE retourner_livre (
    p_id_emprunt IN NUMBER
) IS
    v_id_livre NUMBER;
    v_date_retour DATE;
BEGIN
    -- Verifier l'existence de l'emprunt et s'il a deja ete retourne
    SELECT id_livre, date_retour INTO v_id_livre, v_date_retour 
    FROM EMPRUNT 
    WHERE id_emprunt = p_id_emprunt;
    
    IF v_date_retour IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Erreur : L''emprunt specifie a deja ete cloture (livre retourne).');
    END IF;

    -- Mise a jour de l'emprunt
    UPDATE EMPRUNT SET date_retour = SYSDATE WHERE id_emprunt = p_id_emprunt;
    
    -- Incrementation du stock
    UPDATE LIVRE SET nb_exemplaires = nb_exemplaires + 1 WHERE id_livre = v_id_livre;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Succes : Le livre a bien ete retourne et le stock mis a jour.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20005, 'Erreur : Emprunt introuvable avec l''ID fourni.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END retourner_livre;
/


-- ==============================================================================
-- 7. Test des procedures (Bloc Anonyme)
-- ==============================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- DEBUT DES TESTS DES PROCEDURES ET FONCTIONS    --');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    
    -- 1. Emprunter un livre (L''etudiant 1 emprunte le livre 101)
    DBMS_OUTPUT.PUT_LINE('>>> Action 1 : L''etudiant 1 emprunte le livre 101...');
    emprunter_livre(1, 101);
    

    -- 2. Emprunter un autre livre (L''etudiant 1 emprunte le livre 102)
    DBMS_OUTPUT.PUT_LINE('>>> Action 2 : L''etudiant 1 emprunte le livre 102...');
    emprunter_livre(1, 102);
    

    -- 3. Tester le nombre d''emprunts
    DBMS_OUTPUT.PUT_LINE('>>> Action 3 : Calcul du nombre total d''emprunts...');
    DBMS_OUTPUT.PUT_LINE('Nombre total d''emprunts pour l''etudiant 1 : ' || nb_emprunts_etudiant(1));
    

    -- 4. Afficher les emprunts
    DBMS_OUTPUT.PUT_LINE('>>> Action 4 : Affichage de l''historique des emprunts...');
    afficher_emprunts_etudiant(1);
    
    -- 5. Retourner le premier livre (On suppose que l''id_emprunt est 1)
    DBMS_OUTPUT.PUT_LINE('>>> Action 5 : Retour du livre (emprunt ID 1)...');
    retourner_livre(1);
    
    -- 6. Re-afficher les emprunts pour constater la date de retour
    DBMS_OUTPUT.PUT_LINE('>>> Action 6 : Verification de l''historique apres retour...');
    afficher_emprunts_etudiant(1);
    
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- FIN DES TESTS                                  --');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
END;
/

SPOOL OFF;