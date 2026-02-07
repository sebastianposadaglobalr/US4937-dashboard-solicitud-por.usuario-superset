@echo off
TITLE Comsatel Local CUBE Service
COLOR 0B
ECHO ======================================================
ECHO  COMSATEL GLOBAL RESOURCES - LOCAL CUBE LAYER
ECHO ======================================================
ECHO.
ECHO Iniciando Cube Core en Docker...
ECHO Asegurese de tener Docker Desktop corriendo.
ECHO.

:: Cambiar al directorio
cd /d "%~dp0"

:: Verificar Docker
docker --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    COLOR 0C
    ECHO [ERROR] Docker no esta instalado o no esta en el PATH.
    PAUSE
    EXIT /B
)

:: Levantar Servicio
docker-compose up -d

ECHO.
ECHO [SUCCESS] Cube corriendo en background.
ECHO.
ECHO  - Dashboard API: http://localhost:4001 (Puerto actualizado)
ECHO  - SQL API Port: 15432 (User: admin / Pass: admin)
ECHO.
ECHO Para ver logs: docker-compose logs -f
PAUSE
