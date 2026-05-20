<%@ page pageEncoding="UTF-8" %>
<%@ page import="fr.projet.modeles.Utilisateur" %>
<%
    Utilisateur userSidebar = (Utilisateur) session.getAttribute("utilisateur");
%>
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <span class="logo-texte">DSI Portal</span>
        <button class="btn-toggle" onclick="toggleSidebar()">
            <i data-lucide="menu"></i>
        </button>
    </div>

    <nav class="nav-menu">
        <a href="dashboard" class="nav-item ${pageContext.request.requestURI.contains('dashboard') ? 'actif' : ''}">
            <i data-lucide="layout-dashboard" class="icone"></i>
            <span class="label">Tableau de bord</span>
        </a>
        <a href="incidents" class="nav-item ${pageContext.request.requestURI.contains('incidents') ? 'actif' : ''}">
            <i data-lucide="ticket" class="icone"></i>
            <span class="label">Mes Incidents</span>
        </a>
        <% if (userSidebar != null && "DSI".equals(userSidebar.getRole().name())) { %>
        <a href="administration" class="nav-item ${pageContext.request.requestURI.contains('administration') ? 'actif' : ''}">
            <i data-lucide="shield-check" class="icone"></i>
            <span class="label">Administration</span>
        </a>
        <a href="utilisateurs" class="nav-item ${pageContext.request.requestURI.contains('utilisateurs') ? 'actif' : ''}">
            <i data-lucide="users" class="icone"></i>
            <span class="label">Utilisateurs</span>
        </a>
        <% } %>
        <a href="profil" class="nav-item ${pageContext.request.requestURI.contains('profil') ? 'actif' : ''}">
            <i data-lucide="user" class="icone"></i>
            <span class="label">Mon Profil</span>
        </a>
    </nav>

    <div style="padding: 20px; border-top: 1px solid var(--bordure);">
        <a href="logout" class="nav-item" style="color: #ef4444;">
            <i data-lucide="log-out" class="icone"></i>
            <span class="label">Déconnexion</span>
        </a>
    </div>
</aside>

<script>
    lucide.createIcons();
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('retractee');
    }
</script>
