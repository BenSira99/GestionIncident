-- ============================================================
--                   POLITIQUES DE SÉCURITÉ (RLS)
-- ============================================================

-- Activation de la RLS sur toutes les tables
ALTER TABLE ville ENABLE ROW LEVEL SECURITY;
ALTER TABLE utilisateur ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiel ENABLE ROW LEVEL SECURITY;
ALTER TABLE categorie_incident ENABLE ROW LEVEL SECURITY;
ALTER TABLE incident ENABLE ROW LEVEL SECURITY;
ALTER TABLE affectation ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE statistique_technicien ENABLE ROW LEVEL SECURITY;

-- 1. Politiques pour la table INCIDENT
-- Un employé voit ses propres incidents
CREATE POLICY "Employés voient leurs incidents" ON incident
FOR SELECT USING (auth.uid() = employe_id);

-- La DSI et les Techniciens voient tout
CREATE POLICY "DSI et Tech voient tout" ON incident
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM utilisateur 
        WHERE id = auth.uid() AND role IN ('DSI', 'TECHNICIEN')
    )
);

-- 2. Politiques pour la table AFFECTATION
CREATE POLICY "Tech voient leurs affectations" ON affectation
FOR SELECT USING (auth.uid() = technicien_id);

-- 3. Politiques pour la table UTILISATEUR
CREATE POLICY "Lecture publique profils" ON utilisateur
FOR SELECT USING (true);

CREATE POLICY "Modif par soi-même" ON utilisateur
FOR UPDATE USING (auth.uid() = id);
