package fr.projet.servlets;

import fr.projet.dao.UtilisateurDAO;
import fr.projet.modeles.Utilisateur;
import fr.projet.modeles.enums.RoleUtilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/inscription")
public class InscriptionServlet extends HttpServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("password");
        String roleStr = request.getParameter("role");

        // Champs supplémentaires selon le rôle
        String telephone = request.getParameter("telephone");
        String matricule = request.getParameter("matricule");
        String departement = request.getParameter("departement");
        String poste = request.getParameter("poste");
        String specialites = request.getParameter("specialites");
        String niveauExpertiseStr = request.getParameter("niveau_expertise");
        int niveauExpertise = 1;
        try { if (niveauExpertiseStr != null) niveauExpertise = Integer.parseInt(niveauExpertiseStr); } catch (NumberFormatException ignored) {}

        Utilisateur u = new Utilisateur();
        u.setNom(nom);
        u.setPrenom(prenom);
        u.setEmail(email);
        u.setMotDePasseHash(motDePasse); // Sera haché dans le DAO
        u.setRole(RoleUtilisateur.valueOf(roleStr));
        u.setTelephone(telephone);
        u.setMatricule(matricule);
        u.setDepartement(departement);
        u.setPoste(poste);
        u.setSpecialites(specialites);
        u.setNiveauExpertise(niveauExpertise);
        u.setEstDisponible("TECHNICIEN".equals(roleStr));

        HttpSession session = request.getSession();
        if (utilisateurDAO.creer(u)) {
            session.setAttribute("inscriptionMessage", "Inscription réussie ! Votre compte doit être validé par la DSI avant de pouvoir vous connecter.");
            response.sendRedirect("connexion.jsp");
        } else {
            session.setAttribute("inscriptionErreur", "Erreur lors de l'inscription. L'email est peut-être déjà utilisé.");
            response.sendRedirect("inscription.jsp");
        }
    }
}
