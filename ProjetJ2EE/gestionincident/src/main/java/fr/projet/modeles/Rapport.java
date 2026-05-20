package fr.projet.modeles;

import java.util.UUID;
import java.time.OffsetDateTime;
import java.time.LocalDate;

public class Rapport {
    private UUID id;
    private String titre;
    private OffsetDateTime dateGeneration;
    private LocalDate periodeDebut;
    private LocalDate periodeFin;
    private int totalIncidents;
    private int totalResolus;
    private int totalEnCours;
    private String contenuJson;
    private UUID genereParDsiId;

    public Rapport() {}

    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }
    public OffsetDateTime getDateGeneration() { return dateGeneration; }
    public void setDateGeneration(OffsetDateTime dateGeneration) { this.dateGeneration = dateGeneration; }
    public LocalDate getPeriodeDebut() { return periodeDebut; }
    public void setPeriodeDebut(LocalDate periodeDebut) { this.periodeDebut = periodeDebut; }
    public LocalDate getPeriodeFin() { return periodeFin; }
    public void setPeriodeFin(LocalDate periodeFin) { this.periodeFin = periodeFin; }
    public int getTotalIncidents() { return totalIncidents; }
    public void setTotalIncidents(int totalIncidents) { this.totalIncidents = totalIncidents; }
    public int getTotalResolus() { return totalResolus; }
    public void setTotalResolus(int totalResolus) { this.totalResolus = totalResolus; }
    public int getTotalEnCours() { return totalEnCours; }
    public void setTotalEnCours(int totalEnCours) { this.totalEnCours = totalEnCours; }
    public String getContenuJson() { return contenuJson; }
    public void setContenuJson(String contenuJson) { this.contenuJson = contenuJson; }
    public UUID getGenereParDsiId() { return genereParDsiId; }
    public void setGenereParDsiId(UUID genereParDsiId) { this.genereParDsiId = genereParDsiId; }
}
