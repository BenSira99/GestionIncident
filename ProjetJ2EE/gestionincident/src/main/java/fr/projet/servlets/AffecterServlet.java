package fr.projet.servlets;

import fr.projet.dao.AffectationDAO;
import fr.projet.dao.UtilisateurDAO;
import fr.projet.modeles.Affectation;
import fr.projet.modeles.Utilisateur;
import fr.projet.modeles.enums.StatutAffectation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/affecter")
public class AffecterServlet extends HttpServlet {
    private final AffectationDAO affectationDAO = new AffectationDAO();
    private final UtilisateurDAO utilisateurDAO = new UtilisateurDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;
        if (u == null || !"DSI".equals(u.getRole().name())) {
            response.sendRedirect("dashboard");
            return;
        }

        String incidentIdStr = request.getParameter("incidentId");
        String technicienIdStr = request.getParameter("technicienId");

        try {
            UUID incidentId = UUID.fromString(incidentIdStr);
            UUID technicienId = UUID.fromString(technicienIdStr);

            Affectation a = new Affectation();
            a.setIncidentId(incidentId);
            a.setTechnicienId(technicienId);
            a.setStatut(StatutAffectation.ACCEPTEE);

            boolean ok = affectationDAO.creer(a);
            if (ok) {
                utilisateurDAO.modifierDisponibilite(technicienId, false);
                request.setAttribute("message", "Affectation créée avec succès.");
            } else {
                request.setAttribute("erreur", "Échec lors de la création de l'affectation.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("erreur", "Données invalides pour l'affectation.");
        }

        response.sendRedirect("administration");
    }
}
