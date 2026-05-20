package fr.projet.test;

import fr.projet.base.GestionnaireConnexion;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Fichier: fr/projet/test/TestConnexionSupabase.java
 * Auteur: BenSira99
 * Description: Simple test pour valider la connexion JDBC vers Supabase.
 */
public class TestConnexionSupabase {
    public static void main(String[] args) {
        System.out.println("--- TEST DE CONNEXION SUPABASE ---");
        
        try (Connection connexion = GestionnaireConnexion.obtenirConnexion()) {
            if (connexion != null && !connexion.isClosed()) {
                System.out.println("✅ CONNEXION RÉUSSIE !");
                
                // Petit test de requête
                try (Statement instruction = connexion.createStatement();
                     ResultSet resultat = instruction.executeQuery("SELECT version()")) {
                    if (resultat.next()) {
                        System.out.println("🌐 Version PostgreSQL : " + resultat.getString(1));
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("❌ ÉCHEC DE LA CONNEXION");
            e.printStackTrace();
        } finally {
            GestionnaireConnexion.fermerPool();
        }
    }
}
