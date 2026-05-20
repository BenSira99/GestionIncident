@echo off
REM ==============================================================================
REM Script de lancement pour Windows du projet Java J2EE (BenSira99)
REM ==============================================================================

setlocal
set "commandeMaven=mvn"

REM Test si mvn est disponible, sinon on cherche mvnw
where %commandeMaven% >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "mvnw.cmd" (
        set "commandeMaven=.\mvnw.cmd"
    ) else (
        echo ❌ Erreur : Maven n'est pas installe et mvnw.cmd est introuvable.
        echo Veuillez installer Maven ou ajouter mvnw a la racine.
        pause
        exit /b 1
    )
)

echo.
echo 🚀 Preparation du lancement du projet : Gestion d'Incidents...
echo.

echo 🛠️  Nettoyage et lancement en mode HOT RELOAD...
echo 🌍 Ouverture automatique de : http://localhost:8080/gestion_incident/connexion.jsp
start "" "http://localhost:8080/gestion_incident/connexion.jsp"
call %commandeMaven% jetty:run

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠️  Une erreur est survenue lors du lancement du projet.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo ✅ Projet arrete normalement.
pause
