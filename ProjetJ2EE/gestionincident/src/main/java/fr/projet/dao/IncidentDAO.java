package fr.projet.dao;

import fr.projet.modeles.Incident;
import fr.projet.modeles.enums.StatutIncident;
import fr.projet.base.GestionnaireConnexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public class IncidentDAO implements InterfaceDAO<Incident> {

    @Override
    public Optional<Incident> trouverParId(UUID id) {
        String sql = "SELECT * FROM incident WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return Optional.of(extraireIncident(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    @Override
    public List<Incident> listerTout() {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT * FROM incident ORDER BY date_ouverture DESC";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                incidents.add(extraireIncident(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return incidents;
    }

    @Override
    public boolean creer(Incident i) {
        String sql = "INSERT INTO incident (titre, description, statut, type_incident, employe_id, materiel_id, categorie_id) VALUES (?, ?, ?::statut_incident, ?::type_incident, ?, ?, ?)";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, i.getTitre());
            pstmt.setString(2, i.getDescription());
            pstmt.setString(3, i.getStatut() != null ? i.getStatut().name() : StatutIncident.OUVERT.name());
            pstmt.setString(4, i.getTypeIncident() != null ? i.getTypeIncident().name() : "SOFTWARE");
            pstmt.setObject(5, i.getEmployeId());
            pstmt.setObject(6, i.getMaterielId());
            pstmt.setObject(7, i.getCategorieId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean modifier(Incident i) {
        String sql = "UPDATE incident SET titre = ?, description = ?, statut = ?::statut_incident_type WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, i.getTitre());
            pstmt.setString(2, i.getDescription());
            pstmt.setString(3, i.getStatut().name());
            pstmt.setObject(4, i.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean supprimer(UUID id) {
        String sql = "DELETE FROM incident WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Incident> listerParEmploye(UUID employeId) {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT * FROM incident WHERE employe_id = ? ORDER BY date_ouverture DESC";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, employeId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                incidents.add(extraireIncident(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return incidents;
    }

    public List<Incident> listerOuverts() {
        List<Incident> incidents = new ArrayList<>();
        String sql = "SELECT * FROM incident WHERE statut = 'OUVERT' ORDER BY date_ouverture DESC";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                incidents.add(extraireIncident(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return incidents;
    }

    private Incident extraireIncident(ResultSet rs) throws SQLException {
        Incident i = new Incident();
        i.setId((UUID) rs.getObject("id"));
        i.setTitre(rs.getString("titre"));
        i.setDescription(rs.getString("description"));
        i.setStatut(StatutIncident.valueOf(rs.getString("statut")));
        i.setDateOuverture(rs.getObject("date_ouverture", java.time.OffsetDateTime.class));
        i.setEmployeId((UUID) rs.getObject("employe_id"));
        i.setMaterielId((UUID) rs.getObject("materiel_id"));
        i.setCategorieId((UUID) rs.getObject("categorie_id"));
        return i;
    }
}
