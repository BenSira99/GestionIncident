package fr.projet.test;

import fr.projet.dao.UtilisateurDAO;
import fr.projet.modeles.Utilisateur;
import fr.projet.modeles.enums.RoleUtilisateur;

public class CreerUtilisateurTest {
    public static void main(String[] args) {
        UtilisateurDAO dao = new UtilisateurDAO();
        
        Utilisateur admin = new Utilisateur();
        admin.setNom("Admin");
        admin.setPrenom("Système");
        admin.setEmail("admin@test.com");
        admin.setMotDePasseHash("admin123"); // Sera hashé par le DAO
        admin.setRole(RoleUtilisateur.DSI);
        admin.setMatricule("DSI-001");
        
        if (dao.creer(admin)) {
            System.out.println("✅ Utilisateur admin@test.com créé avec le mot de passe : admin123");
        } else {
            System.out.println("❌ Erreur lors de la création.");
        }
    }
}
