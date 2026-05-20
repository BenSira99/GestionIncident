-- ============================================================
-- Migration: 004_table_rapport.sql
-- Description: Ajout de la table Rapport mentionnée dans le diagramme
-- ============================================================

-- DELETE FROM supabase_migrations.schema_migrations WHERE version = '004';

CREATE TABLE IF NOT EXISTS rapport (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre VARCHAR(200) NOT NULL,
    date_generation TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    periode_debut DATE NOT NULL,
    periode_fin DATE NOT NULL,
    total_incidents INTEGER DEFAULT 0,
    total_resolus INTEGER DEFAULT 0,
    total_en_cours INTEGER DEFAULT 0,
    contenu_json TEXT, -- Pour stocker des stats complexes
    genere_par_id UUID NOT NULL REFERENCES utilisateur(id) ON DELETE CASCADE
);

-- Activation RLS
ALTER TABLE rapport ENABLE ROW LEVEL SECURITY;

-- Politique : Seule la DSI peut voir et générer des rapports
DROP POLICY IF EXISTS "Acces rapports DSI uniquement" ON rapport;
CREATE POLICY "Acces rapports DSI uniquement" ON rapport
FOR ALL USING (
    EXISTS (
        SELECT 1 FROM utilisateur 
        WHERE id = (SELECT auth.uid()) AND role = 'DSI'
    )
);

-- Indexation
CREATE INDEX IF NOT EXISTS idx_rapport_dsi ON rapport(genere_par_id);
