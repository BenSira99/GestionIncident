package fr.projet.modeles;

import java.util.UUID;

public class CategorieIncident {
    private UUID id;
    private String libelle;
    private String description;
    private int delaiResolutionHeures;
    private double coefficientComplexite;

    public CategorieIncident() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
    public int getDelaiResolutionHeures() { return delaiResolutionHeures; }
    public void setDelaiResolutionHeures(int delai) { this.delaiResolutionHeures = delai; }
    public double getCoefficientComplexite() { return coefficientComplexite; }
    public void setCoefficientComplexite(double coefficientComplexite) { this.coefficientComplexite = coefficientComplexite; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
