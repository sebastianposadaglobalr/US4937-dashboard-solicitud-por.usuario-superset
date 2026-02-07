@echo off
TITLE COMSATEL - INICIAR DASHBOARD
COLOR 0A
ECHO ======================================================
ECHO    COMSATEL - ARRANQUE RAPIDO DE SUPERSET
ECHO ======================================================
ECHO.
ECHO [1/3] Iniciando Docker Desktop (si no esta abierto)...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
timeout /t 5 /nobreak >nul

ECHO [2/3] Levantando contenedores de Cube y Superset...
cd /d "%~dp001_Motor_de_Datos_Cube"
docker-compose up -d

ECHO.
ECHO [3/3] Abriendo Dashboard en navegador...
timeout /t 3 /nobreak >nul
start "" "http://localhost:8088"

ECHO.
ECHO ======================================================
ECHO [LISTO] El dashboard deberia abrirse en tu navegador.
ECHO.
ECHO  Accesos:
ECHO    - Superset: http://localhost:8088 (admin/admin)
ECHO    - Cube API: http://localhost:4001
ECHO ======================================================
ECHO.
pause
