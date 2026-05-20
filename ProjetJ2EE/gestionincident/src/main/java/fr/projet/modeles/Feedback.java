package fr.projet.modeles;

import java.util.UUID;
import java.time.OffsetDateTime;

public class Feedback {
    private UUID id;
    private int note;
    private String commentaire;
    private OffsetDateTime dateCreation;
    private boolean satisfait;
    private UUID incidentId;
    private UUID employeId;

    public Feedback() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public int getNote() { return note; }
    public void setNote(int note) { this.note = note; }
    public boolean isSatisfait() { return satisfait; }
    public void setSatisfait(boolean satisfait) { this.satisfait = satisfait; }
    public String getCommentaire() { return commentaire; }
    public void setCommentaire(String commentaire) { this.commentaire = commentaire; }
    public OffsetDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(OffsetDateTime dateCreation) { this.dateCreation = dateCreation; }
    public UUID getIncidentId() { return incidentId; }
    public void setIncidentId(UUID incidentId) { this.incidentId = incidentId; }
    public UUID getEmployeId() { return employeId; }
    public void setEmployeId(UUID employeId) { this.employeId = employeId; }
}
