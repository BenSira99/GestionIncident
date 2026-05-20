package fr.projet.modeles;

import fr.projet.modeles.enums.StatutIncident;
import fr.projet.modeles.enums.PrioriteIncident;
import fr.projet.modeles.enums.ComplexiteIncident;
import fr.projet.modeles.enums.TypeIncident;
import java.util.UUID;
import java.time.OffsetDateTime;

/**
 * Fichier: fr/projet/modeles/Incident.java
 * Auteur: BenSira99
 * Description: Modèle complet selon diagramme Mermaid.
 */
public class Incident {
    private UUID id;
    private String titre;
    private String description;
    private OffsetDateTime dateOuverture;
    private OffsetDateTime dateMiseAJour;
    private OffsetDateTime dateCloture;
    private StatutIncident statut;
    private PrioriteIncident priorite;
    private ComplexiteIncident complexite;
    private TypeIncident typeIncident;
    private String cheminPieceJointe;
    
    private UUID employeId;
    private UUID materielId;
    private UUID categorieId;

    public Incident() {}

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public StatutIncident getStatut() { return statut; }
    public void setStatut(StatutIncident statut) { this.statut = statut; }

    public PrioriteIncident getPriorite() { return priorite; }
    public void setPriorite(PrioriteIncident priorite) { this.priorite = priorite; }

    public ComplexiteIncident getComplexite() { return complexite; }
    public void setComplexite(ComplexiteIncident complexite) { this.complexite = complexite; }

    public TypeIncident getTypeIncident() { return typeIncident; }
    public void setTypeIncident(TypeIncident type) { this.typeIncident = type; }

    public UUID getEmployeId() { return employeId; }
    public void setEmployeId(UUID employeId) { this.employeId = employeId; }

    public OffsetDateTime getDateOuverture() { return dateOuverture; }
    public void setDateOuverture(OffsetDateTime dateOuverture) { this.dateOuverture = dateOuverture; }

    public OffsetDateTime getDateCloture() { return dateCloture; }
    public void setDateCloture(OffsetDateTime dateCloture) { this.dateCloture = dateCloture; }

    public OffsetDateTime getDateMiseAJour() { return dateMiseAJour; }
    public void setDateMiseAJour(OffsetDateTime dateMiseAJour) { this.dateMiseAJour = dateMiseAJour; }

    public UUID getMaterielId() { return materielId; }
    public void setMaterielId(UUID materielId) { this.materielId = materielId; }

    public UUID getCategorieId() { return categorieId; }
    public void setCategorieId(UUID categorieId) { this.categorieId = categorieId; }

    public String getCheminPieceJointe() { return cheminPieceJointe; }
    public void setCheminPieceJointe(String cheminPieceJointe) { this.cheminPieceJointe = cheminPieceJointe; }
}
