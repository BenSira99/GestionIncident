-- ============================================================
-- Migration: 001_creation_base.sql (V3 - Full UUID)
-- Auteur: BenSira99
-- Description: Schéma intégralement basé sur UUID avec nettoyage.
-- ============================================================

-- 0. Nettoyage radical pour repartir de zéro
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Activation de l'extension pgcrypto pour gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Création des Types ENUM (Si non existants)
CREATE TYPE statut_incident AS ENUM ('OUVERT', 'EN_COURS', 'RESOLU', 'FERME', 'REJETE');
CREATE TYPE priorite_incident AS ENUM ('FAIBLE', 'MOYENNE', 'HAUTE', 'CRITIQUE');
CREATE TYPE complexite_incident AS ENUM ('SIMPLE', 'MODEREE', 'COMPLEXE', 'TRES_COMPLEXE');
CREATE TYPE statut_affectation AS ENUM ('EN_ATTENTE', 'ACCEPTEE', 'EN_COURS', 'TERMINEE', 'REJETEE');
CREATE TYPE role_utilisateur AS ENUM ('EMPLOYE', 'TECHNICIEN', 'DSI');
CREATE TYPE type_incident AS ENUM ('HARDWARE', 'SOFTWARE');
CREATE TYPE type_materiel AS ENUM ('ORDINATEUR', 'IMPRIMANTE', 'SERVEUR', 'RESEAU', 'TELEPHONE', 'AUTRE');

-- 2. Table Ville
CREATE TABLE IF NOT EXISTS ville (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom VARCHAR(100) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    region VARCHAR(100) NOT NULL,
    CONSTRAINT uk_ville_cp UNIQUE (nom, code_postal)
);

-- 3. Table Utilisateur
CREATE TABLE IF NOT EXISTS utilisateur (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(), -- Compatible auth.uid()
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    mot_de_passe_hash TEXT NOT NULL,
    telephone VARCHAR(20),
    role role_utilisateur NOT NULL DEFAULT 'EMPLOYE',
    actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    derniere_connexion TIMESTAMP WITH TIME ZONE,
    ville_id UUID REFERENCES ville(id) ON DELETE SET NULL,
    
    -- Employé
    matricule VARCHAR(50) UNIQUE,
    departement VARCHAR(100),
    poste VARCHAR(100),
    
    -- Technicien
    specialites TEXT,
    disponible BOOLEAN DEFAULT TRUE,
    niveau_expertise INTEGER DEFAULT 1 CHECK (niveau_expertise BETWEEN 1 AND 5)
);

-- 4. Table Matériel
CREATE TABLE IF NOT EXISTS materiel (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nom VARCHAR(100) NOT NULL,
    numero_serie VARCHAR(100) UNIQUE NOT NULL,
    marque VARCHAR(100),
    modele VARCHAR(100),
    type_materiel type_materiel NOT NULL DEFAULT 'ORDINATEUR',
    date_acquisition DATE DEFAULT CURRENT_DATE,
    actif BOOLEAN DEFAULT TRUE
);

-- 5. Table Catégorie Incident
CREATE TABLE IF NOT EXISTS categorie_incident (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    libelle VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    delai_resolution_heures INTEGER DEFAULT 24 CHECK (delai_resolution_heures > 0),
    coefficient_complexite DECIMAL(3,2) DEFAULT 1.0
);

-- 6. Table Incident
CREATE TABLE IF NOT EXISTS incident (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    date_ouverture TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    date_mise_a_jour TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    date_cloture TIMESTAMP WITH TIME ZONE,
    statut statut_incident DEFAULT 'OUVERT',
    priorite priorite_incident DEFAULT 'MOYENNE',
    complexite complexite_incident DEFAULT 'SIMPLE',
    type_incident type_incident NOT NULL,
    chemin_piece_jointe TEXT,
    employe_id UUID NOT NULL REFERENCES utilisateur(id),
    materiel_id UUID REFERENCES materiel(id),
    categorie_id UUID REFERENCES categorie_incident(id)
);

-- 7. Table Affectation
CREATE TABLE IF NOT EXISTS affectation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id UUID NOT NULL REFERENCES incident(id) ON DELETE CASCADE,
    technicien_id UUID NOT NULL REFERENCES utilisateur(id),
    date_affectation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    date_debut_intervention TIMESTAMP WITH TIME ZONE,
    date_fin_intervention TIMESTAMP WITH TIME ZONE,
    statut statut_affectation DEFAULT 'EN_ATTENTE',
    rapport_intervention TEXT,
    commentaire_dsi TEXT,
    motif_rejet TEXT,
    CONSTRAINT uk_incident_tech_uuid UNIQUE (incident_id, technicien_id)
);

-- 8. Table Feedback
CREATE TABLE IF NOT EXISTS feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    note INTEGER NOT NULL CHECK (note BETWEEN 1 AND 5),
    commentaire TEXT,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    satisfait BOOLEAN NOT NULL,
    incident_id UUID UNIQUE NOT NULL REFERENCES incident(id),
    employe_id UUID NOT NULL REFERENCES utilisateur(id)
);

-- 9. Table Statistiques Technicien
CREATE TABLE IF NOT EXISTS statistique_technicien (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    technicien_id UUID UNIQUE NOT NULL REFERENCES utilisateur(id) ON DELETE CASCADE,
    nb_incidents_affectes INTEGER DEFAULT 0,
    nb_incidents_resolus INTEGER DEFAULT 0,
    temps_resolution_moyen_min DECIMAL(10,2) DEFAULT 0.0,
    taux_succes DECIMAL(5,2) DEFAULT 0.0
);

-- ============================================================
--                   FONCTIONS ET TRIGGERS
-- ============================================================

-- Mise à jour automatique du timestamp de modification
CREATE OR REPLACE FUNCTION fn_maj_date_modification()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_mise_a_jour = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_maj_incident_date
BEFORE UPDATE ON incident
FOR EACH ROW EXECUTE FUNCTION fn_maj_date_modification();

-- Initialisation automatique des stats
CREATE OR REPLACE FUNCTION fn_init_stats_technicien()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role = 'TECHNICIEN' THEN
        INSERT INTO statistique_technicien (technicien_id) VALUES (NEW.id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_init_stats_tech
AFTER INSERT ON utilisateur
FOR EACH ROW EXECUTE FUNCTION fn_init_stats_technicien();

-- Index pour la performance
CREATE INDEX IF NOT EXISTS idx_user_role_uuid ON utilisateur(role);
CREATE INDEX IF NOT EXISTS idx_incident_statut_uuid ON incident(statut);
CREATE INDEX IF NOT EXISTS idx_affectation_tech_uuid ON affectation(technicien_id);
