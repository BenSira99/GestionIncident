package fr.projet.modeles;

import fr.projet.modeles.enums.StatutAffectation;
import java.util.UUID;
import java.time.OffsetDateTime;

public class Affectation {
    private UUID id;
    private UUID incidentId;
    private UUID technicienId;
    private OffsetDateTime dateAffectation;
    private OffsetDateTime dateDebutIntervention;
    private OffsetDateTime dateFinIntervention;
    private StatutAffectation statut;
    private String rapportIntervention;
    private String commentaireDSI;
    private String motifRejet;

    public Affectation() {}

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public UUID getIncidentId() { return incidentId; }
    public void setIncidentId(UUID id) { this.incidentId = id; }
    public UUID getTechnicienId() { return technicienId; }
    public void setTechnicienId(UUID id) { this.technicienId = id; }
    public StatutAffectation getStatut() { return statut; }
    public void setStatut(StatutAffectation statut) { this.statut = statut; }

    public OffsetDateTime getDateAffectation() { return dateAffectation; }
    public void setDateAffectation(OffsetDateTime date) { this.dateAffectation = date; }

    public OffsetDateTime getDateDebutIntervention() { return dateDebutIntervention; }
    public void setDateDebutIntervention(OffsetDateTime date) { this.dateDebutIntervention = date; }

    public OffsetDateTime getDateFinIntervention() { return dateFinIntervention; }
    public void setDateFinIntervention(OffsetDateTime date) { this.dateFinIntervention = date; }

    public String getRapportIntervention() { return rapportIntervention; }
    public void setRapportIntervention(String rapport) { this.rapportIntervention = rapport; }

    public String getCommentaireDSI() { return commentaireDSI; }
    public void setCommentaireDSI(String commentaire) { this.commentaireDSI = commentaire; }

    public String getMotifRejet() { return motifRejet; }
    public void setMotifRejet(String motif) { this.motifRejet = motif; }
}
