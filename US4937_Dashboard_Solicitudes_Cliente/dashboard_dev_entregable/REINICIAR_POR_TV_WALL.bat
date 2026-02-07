@echo off
echo ==========================================
echo   REINICIANDO SUPERSET PARA TV WALL
echo ==========================================
cd /d "%~dp0"
docker-compose up -d --build
echo.
echo [OK] Configuracion de Iframes aplicada.
echo [OK] Superset reiniciado.
echo.
pause
