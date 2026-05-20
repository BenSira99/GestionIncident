-- ============================================================
-- Migration: 003_optimisation_securite.sql
-- Description: Corrections basées sur le Linter Supabase
-- ============================================================

-- 1. Sécurisation des fonctions (Fix: Function Search Path Mutable)
ALTER FUNCTION fn_maj_date_modification() SET search_path = public;
ALTER FUNCTION fn_init_stats_technicien() SET search_path = public;

-- 2. Indexation des clés étrangères manquantes (Fix: Unindexed foreign keys)
CREATE INDEX IF NOT EXISTS idx_feedback_employe_id ON feedback(employe_id);
CREATE INDEX IF NOT EXISTS idx_incident_categorie_id ON incident(categorie_id);
CREATE INDEX IF NOT EXISTS idx_incident_employe_id ON incident(employe_id);
CREATE INDEX IF NOT EXISTS idx_incident_materiel_id ON incident(materiel_id);
CREATE INDEX IF NOT EXISTS idx_utilisateur_ville_id ON utilisateur(ville_id);
CREATE INDEX IF NOT EXISTS idx_affectation_incident_id ON affectation(incident_id);

-- 3. Optimisation et Fusion des Politiques RLS (Fix: Auth RLS Initialization Plan & Multiple Permissive Policies)

-- Nettoyage des anciennes politiques pour éviter les doublons (Idempotence)
DROP POLICY IF EXISTS "Employés voient leurs incidents" ON incident;
DROP POLICY IF EXISTS "DSI et Tech voient tout" ON incident;
DROP POLICY IF EXISTS "Politique lecture globale incident" ON incident;

CREATE POLICY "Politique lecture globale incident" ON incident
FOR SELECT USING (
    (SELECT auth.uid()) = employe_id 
    OR 
    EXISTS (
        SELECT 1 FROM utilisateur 
        WHERE id = (SELECT auth.uid()) AND role IN ('DSI', 'TECHNICIEN')
    )
);

-- Optimisation des autres politiques existantes
DROP POLICY IF EXISTS "Modif par soi-même" ON utilisateur;
CREATE POLICY "Modif par soi-même" ON utilisateur
FOR UPDATE USING ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "Tech voient leurs affectations" ON affectation;
CREATE POLICY "Tech voient leurs affectations" ON affectation
FOR SELECT USING ((SELECT auth.uid()) = technicien_id);

-- 4. Ajout des politiques manquantes (Fix: RLS Enabled No Policy)

-- VILLE : Lecture publique pour tout le monde
DROP POLICY IF EXISTS "Lecture publique ville" ON ville;
CREATE POLICY "Lecture publique ville" ON ville FOR SELECT USING (true);

-- MATERIEL : Lecture pour les utilisateurs authentifiés (Optimisé)
DROP POLICY IF EXISTS "Lecture materiel authentifie" ON materiel;
CREATE POLICY "Lecture materiel authentifie" ON materiel FOR SELECT USING ((SELECT auth.role()) = 'authenticated');

-- CATEGORIE : Lecture publique
DROP POLICY IF EXISTS "Lecture publique categories" ON categorie_incident;
CREATE POLICY "Lecture publique categories" ON categorie_incident FOR SELECT USING (true);

-- FEEDBACK : L'employé voit ses propres feedbacks, la DSI voit tout
DROP POLICY IF EXISTS "Acces feedback" ON feedback;
CREATE POLICY "Acces feedback" ON feedback
FOR SELECT USING (
    (SELECT auth.uid()) = employe_id 
    OR 
    EXISTS (SELECT 1 FROM utilisateur WHERE id = (SELECT auth.uid()) AND role = 'DSI')
);

-- STATISTIQUES : Lecture publique (ou restreinte à DSI/Tech selon besoin)
DROP POLICY IF EXISTS "Lecture publique stats" ON statistique_technicien;
CREATE POLICY "Lecture publique stats" ON statistique_technicien FOR SELECT USING (true);
