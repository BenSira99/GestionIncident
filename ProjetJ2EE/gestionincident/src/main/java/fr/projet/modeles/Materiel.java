package fr.projet.modeles;

import fr.projet.modeles.enums.TypeMateriel;
import java.util.UUID;
import java.time.LocalDate;

public class Materiel {
    private UUID id;
    private String nom;
    private String numeroSerie;
    private String marque;
    private String modele;
    private TypeMateriel typeMateriel;
    private LocalDate dateAcquisition;
    private boolean actif;

    public Materiel() {}

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public TypeMateriel getTypeMateriel() { return typeMateriel; }
    public void setTypeMateriel(TypeMateriel typeMateriel) { this.typeMateriel = typeMateriel; }
    public String getNumeroSerie() { return numeroSerie; }
    public void setNumeroSerie(String numeroSerie) { this.numeroSerie = numeroSerie; }

    public String getMarque() { return marque; }
    public void setMarque(String marque) { this.marque = marque; }

    public String getModele() { return modele; }
    public void setModele(String modele) { this.modele = modele; }

    public LocalDate getDateAcquisition() { return dateAcquisition; }
    public void setDateAcquisition(LocalDate dateAcquisition) { this.dateAcquisition = dateAcquisition; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }
}
