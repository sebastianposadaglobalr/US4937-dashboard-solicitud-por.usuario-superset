@echo off
setlocal
echo ===========================================================
echo    ARQUITECTURA SENIOR TV WALL - COMSATEL 2026
echo ===========================================================
cd /d "%~dp0dashboard_dev_entregable"

echo [1/3] Limpiando contenedores...
docker-compose down --remove-orphans

echo [2/3] Levantando Infraestructura (Superset + Nginx Proxy)...
docker-compose up -d --build

echo [3/3] Verificando puertos...
docker ps

echo.
echo ===========================================================
echo  INSTALACION COMPLETADA.
echo.
echo  Paso 1: Abre el rotador en: http://localhost/
echo  Paso 2: Haz Login una vez con admin/admin.
echo  Paso 3: Presiona F11.
echo.
echo  (El puerto 8088 sigue disponible para gestion directa)
echo ===========================================================
pause
