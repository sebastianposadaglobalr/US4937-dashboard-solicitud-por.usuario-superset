@echo off
TITLE Instalando Driver Postgres en Superset
COLOR 0B
ECHO ======================================================
ECHO  CORRIGIENDO ERROR DE DRIVER EN SUPERSET...
ECHO ======================================================
ECHO.
ECHO Instalando psycopg2-binary en el contenedor de Superset...
ECHO Espere un momento...

docker exec -u root 42b10483625b pip install psycopg2-binary

IF %ERRORLEVEL% NEQ 0 (
    COLOR 0C
    ECHO [ERROR] No se pudo instalar el driver.
    ECHO Asegurese que el contenedor de Superset este corriendo.
) ELSE (
    COLOR 0A
    ECHO [EXITO] Driver instalado correctamente.
    ECHO Ahora intente conectar de nuevo en la web.
)
PAUSE
