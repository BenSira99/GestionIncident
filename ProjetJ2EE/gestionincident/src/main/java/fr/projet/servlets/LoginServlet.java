package fr.projet.servlets;

import fr.projet.dao.UtilisateurDAO;
import fr.projet.modeles.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Fichier: fr/projet/servlets/LoginServlet.java
 * Auteur: BenSira99
 * Description: Contrôleur d'authentification utilisant UtilisateurDAO.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("password");

        try {
            // 1. Authentification via le DAO (BCrypt inclus)
            Utilisateur utilisateur = utilisateurDAO.authentifier(email, motDePasse).orElse(null);

            if (utilisateur != null) {
                // 2. Création de la session
                HttpSession session = request.getSession();
                session.setAttribute("utilisateur", utilisateur);
                session.setAttribute("role", utilisateur.getRole().name());

                // 3. Redirection vers le dashboard
                response.sendRedirect("dashboard");
            } else {
                // Échec : retour à la page de connexion avec message d'erreur
                request.setAttribute("erreur", "Identifiants invalides ou compte inactif.");
                request.getRequestDispatcher("connexion.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Une erreur technique est survenue.");
            request.getRequestDispatcher("connexion.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirection vers la page de login en cas d'accès direct en GET
        response.sendRedirect("connexion.jsp");
    }
}
