@echo off
TITLE COMSATEL - INICIAR DASHBOARD OFICIAL
COLOR 0B
ECHO ======================================================
ECHO    COMSATEL - ARRANQUE ENTREGABLE (US4937)
ECHO ======================================================
ECHO.
ECHO [1/3] Iniciando Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
timeout /t 5 /nobreak >nul

ECHO [2/3] Levantando Servicios Consolidados...
cd /d "%~dp0dashboard_dev_entregable"
docker-compose up -d --remove-orphans

ECHO.
ECHO [3/3] Abriendo Dashboard...
timeout /t 5 /nobreak >nul
start "" "http://localhost:8088"

ECHO.
ECHO ======================================================
ECHO [LISTO] El sistema esta operativo.
ECHO- Carpeta: %~dp0dashboard_dev_entregable
ECHO- Superset: http://localhost:8088 (admin/admin)
ECHO- Documentacion: dashboard_dev_entregable\GUIA_ENTREGA_FINAL.md
ECHO ======================================================
ECHO.
pause
