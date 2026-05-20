package fr.projet.base;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Fichier: fr/projet/base/GestionnaireConnexion.java
 * Auteur: BenSira99
 * Description: Singleton gérant le pool de connexion HikariCP vers Supabase.
 */
public class GestionnaireConnexion {
    private static HikariDataSource sourceDeDonnees;

    static {
        Properties proprietes = new Properties();
        try (InputStream fluxEntree = GestionnaireConnexion.class.getClassLoader()
                .getResourceAsStream("db.properties")) {
            
            if (fluxEntree == null) {
                throw new RuntimeException("Fichier db.properties introuvable !");
            }
            
            proprietes.load(fluxEntree);

            HikariConfig configuration = new HikariConfig();
            configuration.setJdbcUrl(proprietes.getProperty("db.url"));
            configuration.setUsername(proprietes.getProperty("db.user"));
            configuration.setPassword(proprietes.getProperty("db.password"));
            configuration.setDriverClassName(proprietes.getProperty("db.driver"));

            // Optimisation du pool
            configuration.setMaximumPoolSize(Integer.parseInt(proprietes.getProperty("pool.size.max")));
            configuration.setConnectionTimeout(Long.parseLong(proprietes.getProperty("pool.timeout.ms")));
            configuration.addDataSourceProperty("prepareThreshold", "0");

            sourceDeDonnees = new HikariDataSource(configuration);
        } catch (IOException e) {
            throw new RuntimeException("Erreur lors du chargement de la configuration DB", e);
        }
    }

    /**
     * Fournit une connexion issue du pool.
     * @return Connection SQL
     * @throws SQLException Si la connexion échoue
     */
    public static Connection obtenirConnexion() throws SQLException {
        return sourceDeDonnees.getConnection();
    }

    /**
     * Ferme proprement le pool de connexion (à appeler lors de l'arrêt du serveur).
     */
    public static void fermerPool() {
        if (sourceDeDonnees != null) {
            sourceDeDonnees.close();
        }
    }
}
