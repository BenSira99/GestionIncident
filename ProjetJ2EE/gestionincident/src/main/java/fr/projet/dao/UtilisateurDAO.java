package fr.projet.dao;

import fr.projet.base.GestionnaireConnexion;
import fr.projet.modeles.Utilisateur;
import fr.projet.modeles.enums.RoleUtilisateur;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.Optional;
import java.util.UUID;
import java.util.ArrayList;
import java.util.List;

public class UtilisateurDAO implements InterfaceDAO<Utilisateur> {

    /**
     * Authentifie un utilisateur par email et mot de passe.
     */
    public Optional<Utilisateur> authentifier(String email, String motDePasseClair) {
        String sql = "SELECT * FROM utilisateur WHERE email = ? AND actif = true";
        
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String hash = rs.getString("mot_de_passe_hash");
                // Vérification BCrypt
                if (BCrypt.checkpw(motDePasseClair, hash)) {
                    return Optional.of(extraireUtilisateur(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public Optional<Utilisateur> trouverParId(UUID id) {
        String sql = "SELECT * FROM utilisateur WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setObject(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return Optional.of(extraireUtilisateur(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    @Override
    public List<Utilisateur> listerTout() {
        List<Utilisateur> liste = new ArrayList<>();
        String sql = "SELECT * FROM utilisateur";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) liste.add(extraireUtilisateur(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public List<Utilisateur> listerTechniciensDisponibles() {
        List<Utilisateur> liste = new ArrayList<>();
        String sql = "SELECT * FROM utilisateur WHERE role = 'TECHNICIEN' AND disponible = true AND actif = true";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) liste.add(extraireUtilisateur(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return liste;
    }

    public String genererMatricule(RoleUtilisateur role) {
        String prefix = role != null ? role.name() : "EMPLOYE";
        String sql = "SELECT COALESCE(MAX(CAST(substring(matricule FROM '\\\\d+$') AS integer)), 0) AS max FROM utilisateur WHERE role = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role != null ? role.name() : "EMPLOYE");
            ResultSet rs = pstmt.executeQuery();
            int max = 0;
            if (rs.next()) max = rs.getInt("max");
            int next = max + 1;
            return String.format("%s-%03d", prefix, next);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return String.format("%s-001", prefix);
    }

    public boolean modifierDisponibilite(UUID id, boolean disponible) {
        String sql = "UPDATE utilisateur SET disponible = ? WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, disponible);
            pstmt.setObject(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean creer(Utilisateur u) {
        // Par défaut actif = false pour validation DSI
        // Générer un matricule si non fourni
        if (u.getMatricule() == null || u.getMatricule().trim().isEmpty()) {
            u.setMatricule(genererMatricule(u.getRole()));
        }

        String sql = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe_hash, role, actif, telephone, matricule, departement, poste, specialites, disponible, niveau_expertise) VALUES (?, ?, ?, ?, ?::role_utilisateur, false, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, u.getNom());
            stmt.setString(2, u.getPrenom());
            stmt.setString(3, u.getEmail());
            // Hashage sécurisé
            String hash = BCrypt.hashpw(u.getMotDePasseHash(), BCrypt.gensalt());
            stmt.setString(4, hash);
            stmt.setString(5, u.getRole().name());
            stmt.setString(6, u.getTelephone());
            stmt.setString(7, u.getMatricule());
            stmt.setString(8, u.getDepartement());
            stmt.setString(9, u.getPoste());
            stmt.setString(10, u.getSpecialites());
            stmt.setBoolean(11, u.isEstDisponible());
            stmt.setInt(12, u.getNiveauExpertise());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean modifierStatut(UUID id, boolean actif) {
        String sql = "UPDATE utilisateur SET actif = ? WHERE id = ?";
        try (Connection conn = GestionnaireConnexion.obtenirConnexion();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBoolean(1, actif);
            pstmt.setObject(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override public boolean modifier(Utilisateur objet) { return false; } // À implémenter
    @Override public boolean supprimer(UUID id) { return false; } // À implémenter

    private Utilisateur extraireUtilisateur(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setId((UUID) rs.getObject("id"));
        u.setNom(rs.getString("nom"));
        u.setPrenom(rs.getString("prenom"));
        u.setEmail(rs.getString("email"));
        u.setTelephone(rs.getString("telephone"));
        u.setRole(RoleUtilisateur.valueOf(rs.getString("role")));
        u.setEstActif(rs.getBoolean("actif"));
        u.setDateCreation(rs.getObject("date_creation", java.time.OffsetDateTime.class));
        u.setVilleId((UUID) rs.getObject("ville_id"));
        
        // Champs Employé
        u.setMatricule(rs.getString("matricule"));
        u.setDepartement(rs.getString("departement"));
        u.setPoste(rs.getString("poste"));
        
        // Champs Technicien
        u.setSpecialites(rs.getString("specialites"));
        u.setEstDisponible(rs.getBoolean("disponible"));
        u.setNiveauExpertise(rs.getInt("niveau_expertise"));
        
        return u;
    }
}
