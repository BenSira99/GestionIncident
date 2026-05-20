package fr.projet.modeles;

import fr.projet.modeles.enums.RoleUtilisateur;
import java.util.UUID;
import java.time.OffsetDateTime;

/**
 * Fichier: fr/projet/modeles/Utilisateur.java
 * Auteur: BenSira99
 * Description: Modèle central pour les utilisateurs (Employé, Technicien, DSI).
 */
public class Utilisateur {
    private UUID id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasseHash;
    private String telephone;
    private RoleUtilisateur role;
    private boolean estActif;
    private OffsetDateTime dateCreation;
    private UUID villeId;

    // Attributs spécifiques Employé
    private String matricule;
    private String departement;
    private String poste;

    // Attributs spécifiques Technicien
    private String specialites;
    private boolean estDisponible;
    private int niveauExpertise;

    // Constructeur par défaut
    public Utilisateur() {}

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public OffsetDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(OffsetDateTime dateCreation) { this.dateCreation = dateCreation; }

    public UUID getVilleId() { return villeId; }
    public void setVilleId(UUID villeId) { this.villeId = villeId; }

    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }

    public String getPoste() { return poste; }
    public void setPoste(String poste) { this.poste = poste; }

    public String getSpecialites() { return specialites; }
    public void setSpecialites(String specialites) { this.specialites = specialites; }

    public boolean isEstDisponible() { return estDisponible; }
    public void setEstDisponible(boolean estDisponible) { this.estDisponible = estDisponible; }

    public int getNiveauExpertise() { return niveauExpertise; }
    public void setNiveauExpertise(int niveauExpertise) { this.niveauExpertise = niveauExpertise; }

    // Getters et Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotDePasseHash() { return motDePasseHash; }
    public void setMotDePasseHash(String motDePasseHash) { this.motDePasseHash = motDePasseHash; }

    public RoleUtilisateur getRole() { return role; }
    public void setRole(RoleUtilisateur role) { this.role = role; }

    public boolean isEstActif() { return estActif; }
    public void setEstActif(boolean estActif) { this.estActif = estActif; }

    public String getMatricule() { return matricule; }
    public void setMatricule(String matricule) { this.matricule = matricule; }

    // ... (Ajouter les autres getters/setters si nécessaire)
    
    @Override
    public String toString() {
        return prenom + " " + nom + " (" + role + ")";
    }
}
