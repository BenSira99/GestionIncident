-- Migration: 004_allow_insert_utilisateur.sql
-- Ajoute une politique d'INSERT pour permettre l'inscription d'utilisateurs via l'application serveur.
-- NOTE: Appliquez cette migration avec `supabase db push` ou via l'éditeur SQL Supabase.

-- Politique permissive mais avec vérification des valeurs critiques (rôle = EMPLOYE, actif = false)
DROP POLICY IF EXISTS "Inscription publique" ON utilisateur;
CREATE POLICY "Inscription publique" ON utilisateur
FOR INSERT
USING (true)
WITH CHECK (
  role = 'EMPLOYE'::role_utilisateur
  AND actif = false
);
