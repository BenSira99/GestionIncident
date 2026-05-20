package fr.projet.dao;

import fr.projet.base.GestionnaireConnexion;
import fr.projet.modeles.Affectation;
import fr.projet.modeles.enums.StatutAffectation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AffectationDAO {

    public boolean creer(Affectation a) {
        String sql = "INSERT INTO affectation (incident_id, technicien_id, statut, rapport_intervention, commentaire_dsi, motif_rejet) VALUES (?, ?, ?::statut_affectation, ?, ?, ?)";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, a.getIncidentId());
            pstmt.setObject(2, a.getTechnicienId());
            pstmt.setString(3, a.getStatut() != null ? a.getStatut().name() : StatutAffectation.EN_ATTENTE.name());
            pstmt.setString(4, a.getRapportIntervention());
            pstmt.setString(5, a.getCommentaireDSI());
            pstmt.setString(6, a.getMotifRejet());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
