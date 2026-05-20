@echo off
REM ==============================================================================
REM Script de lancement RAPIDE (JSP) pour Windows - BenSira99
REM ==============================================================================

setlocal
set "commandeMaven=mvn"

REM Detection de Maven
where %commandeMaven% >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "mvnw.cmd" (
        set "commandeMaven=.\mvnw.cmd"
    ) else (
        echo ❌ Erreur : Maven introuvable.
        pause
        exit /b 1
    )
)

echo.
echo ⚡ Lancement du serveur (Mode Rapide)...
echo.

REM Ouverture automatique de la page de CONNEXION
start "" "http://localhost:8080/gestion_incident/connexion.jsp"

echo 🛠️ Compilation et deploiement...
call %commandeMaven% package org.codehaus.cargo:cargo-maven3-plugin:run -DskipTests

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ⚠️ Echec. Tentative avec nettoyage complet...
    call %commandeMaven% clean package cargo:run -DskipTests
)

echo.
echo ✅ Session terminee.
pause
