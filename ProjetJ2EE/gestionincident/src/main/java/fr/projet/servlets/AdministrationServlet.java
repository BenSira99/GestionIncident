package fr.projet.servlets;

import fr.projet.dao.IncidentDAO;
import fr.projet.dao.UtilisateurDAO;
import fr.projet.modeles.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/administration")
public class AdministrationServlet extends HttpServlet {
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();
    private final IncidentDAO incidentDAO = new IncidentDAO();
    
    // New DAOs used for admin views
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur utilisateur = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (utilisateur == null || !"DSI".equals(utilisateur.getRole().name())) {
            response.sendRedirect("dashboard");
            return;
        }

        List<Utilisateur> utilisateurs = utilisateurDAO.listerTout();
        int totalUtilisateurs = utilisateurs.size();
        long utilisateursEnAttente = utilisateurs.stream().filter(u -> !u.isEstActif()).count();
        int totalIncidents = incidentDAO.listerTout().size();
        // Liste des incidents ouverts à l'affectation
        List<fr.projet.modeles.Incident> incidentsOuverts = incidentDAO.listerOuverts();
        List<Utilisateur> techDisponibles = utilisateurDAO.listerTechniciensDisponibles();

        request.setAttribute("totalUtilisateurs", totalUtilisateurs);
        request.setAttribute("utilisateursEnAttente", utilisateursEnAttente);
        request.setAttribute("totalIncidents", totalIncidents);
        request.setAttribute("incidentsOuverts", incidentsOuverts);
        request.setAttribute("techDisponibles", techDisponibles);
        request.getRequestDispatcher("/administration.jsp").forward(request, response);
    }
}
