package fr.projet.servlets;

import fr.projet.dao.IncidentDAO;
import fr.projet.modeles.Incident;
import fr.projet.modeles.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private final IncidentDAO incidentDAO = new IncidentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            response.sendRedirect("connexion.jsp");
            return;
        }

        Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
        
        try {
            List<Incident> incidents;
            
            // Filtrage : l'employé ne voit que ses propres incidents
            if ("EMPLOYE".equals(u.getRole().name())) {
                incidents = incidentDAO.listerParEmploye(u.getId());
            } else {
                incidents = incidentDAO.listerTout();
            }
            
            request.setAttribute("incidents", incidents);
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
