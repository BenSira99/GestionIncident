package fr.projet.modeles;

import java.util.UUID;

public class Ville {
    private UUID id;
    private String nom;
    private String codePostal;
    private String region;

    public Ville() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getCodePostal() { return codePostal; }
    public void setCodePostal(String codePostal) { this.codePostal = codePostal; }
    public String getRegion() { return region; }
    public void setRegion(String region) { this.region = region; }

    @Override
    public String toString() { return nom + " (" + codePostal + ")"; }
}
