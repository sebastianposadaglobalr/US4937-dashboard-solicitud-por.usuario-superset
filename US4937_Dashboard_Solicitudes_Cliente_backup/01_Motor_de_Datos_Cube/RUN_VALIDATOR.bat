@echo off
TITLE Comsatel Connectivity Validator
COLOR 0E
ECHO ======================================================
ECHO  COMSATEL GLOBAL RESOURCES - VALIDATOR
ECHO ======================================================
ECHO.
ECHO Ejecutando validacion de conectividad...
ECHO.

:: Cambiar al directorio del script asegurando ruta absoluta
cd /d "%~dp0"

:: Verificar Python
python --version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    COLOR 0C
    ECHO [ERROR] Python no encontrado.
    PAUSE
    EXIT /B
)

:: Ejecutar validacion
python scripts\validate_connection.py

ECHO.
ECHO ======================================================
ECHO  INTERPRETACION DE RESULTADOS:
ECHO  1. [FAIL] 192.168.1.180 -> Significa que ESTA MAQUINA no llega a la BD.
ECHO     (Revise VPN o cable de red).
ECHO  2. [FAIL] 127.0.0.1:3307 -> Significa que el BRIDGE no esta prendido.
ECHO ======================================================
ECHO.
PAUSE
