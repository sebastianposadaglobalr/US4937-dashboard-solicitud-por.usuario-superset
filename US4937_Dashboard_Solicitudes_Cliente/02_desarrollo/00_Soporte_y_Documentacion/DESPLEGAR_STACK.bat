@echo off
TITLE Solucionador de Docker + Cube
echo ==========================================
echo DIAGNOSTICO Y ARRANQUE COMSATEL
echo ==========================================
echo.

:: 1. Verificar Docker
echo [1/3] Verificando Docker Desktop...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Docker Desktop NO esta corriendo.
    echo ----------------------------------------------------
    echo POR FAVOR: Abre la aplicacion "Docker Desktop" en tu
    echo Windows y espera a que el icono de la ballena este
    echo verde y estable. Luego vuelve a correr este script.
    echo ----------------------------------------------------
    echo.
    pause
    exit /b
)

:: 2. Limpiar cache de Compose
echo [2/3] Preparando contenedores...
docker-compose down --remove-orphans >nul 2>&1

:: 3. Levantar Stack
echo [3/3] Iniciando Cube y Superset...
docker-compose up -d --force-recreate

echo.
echo ==========================================
echo EXITO: Servicios en proceso de arranque.
echo.
echo 1. Espera 60 segundos antes de entrar.
echo 2. Cube: http://localhost:4000
echo 3. Superset: http://localhost:8088
echo 4. Login: admin / admin
echo ==========================================
echo.
pause
