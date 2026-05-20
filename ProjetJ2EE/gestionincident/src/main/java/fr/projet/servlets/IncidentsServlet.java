package fr.projet.servlets;

import fr.projet.dao.IncidentDAO;
import fr.projet.modeles.Utilisateur;
import fr.projet.modeles.Incident;
import fr.projet.modeles.enums.StatutIncident;
import fr.projet.modeles.enums.TypeIncident;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/incidents")
public class IncidentsServlet extends HttpServlet {
    private final IncidentDAO incidentDAO = new IncidentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }

        List<Incident> liste;
        // Si c'est un employé, il ne voit que ses incidents
        if ("EMPLOYE".equals(u.getRole().name())) {
            liste = incidentDAO.listerParEmploye(u.getId());
        } else {
            // DSI et Techniciens voient tout
            liste = incidentDAO.listerTout();
        }

        String message = request.getParameter("message");
        if (message == null && session != null) {
            message = (String) session.getAttribute("incidentMessage");
            if (message != null) {
                session.removeAttribute("incidentMessage");
            }
        }

        request.setAttribute("incidents", liste);
        request.setAttribute("message", message);
        request.getRequestDispatcher("incidents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }

        String titre = request.getParameter("titre");
        String description = request.getParameter("description");
        String typeIncident = request.getParameter("typeIncident");

        Incident incident = new Incident();
        incident.setTitre(titre);
        incident.setDescription(description);
        incident.setStatut(StatutIncident.OUVERT);
        incident.setTypeIncident(typeIncident != null ? TypeIncident.valueOf(typeIncident) : TypeIncident.SOFTWARE);
        incident.setEmployeId(u.getId());
        incident.setMaterielId(null);
        incident.setCategorieId(null);

        String message;
        if (incidentDAO.creer(incident)) {
            message = "Incident déclaré avec succès.";
        } else {
            message = "Erreur lors de l'enregistrement de l'incident. Vérifiez les informations et réessayez.";
        }

        if (session != null) {
            session.setAttribute("incidentMessage", message);
        }
        response.sendRedirect("incidents");
    }
}
