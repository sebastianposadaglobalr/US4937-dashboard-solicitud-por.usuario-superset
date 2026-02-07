@echo off
TITLE Comsatel DB Bridge Service
COLOR 0A
ECHO ======================================================
ECHO  COMSATEL GLOBAL RESOURCES - SUPERSET/MYSQL BRIDGE
ECHO ======================================================
ECHO.
ECHO Iniciando el servicio de puente de base de datos...
ECHO.

:: Navegar al directorio donde se encuentra este archivo .bat
cd /d "%~dp0"

:: Verificar que Python este instalado
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    COLOR 0C
    ECHO [ERROR] Python no se encontro en el sistema.
    ECHO Por favor instale Python y agreguelo al PATH.
    PAUSE
    EXIT /B
)

:: Ejecutar el script del bridge
ECHO Ejecutando scripts\db_bridge.py ...
ECHO RUTA BASE: %CD%
ECHO.
python scripts\db_bridge.py

:: Si el script termina (por error o cierre), pausar para ver el mensaje
ECHO.
ECHO El servicio se ha detenido.
PAUSE
