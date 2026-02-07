@echo off
TITLE Correccion Autenticacion MySQL
COLOR 0B
ECHO ======================================================
ECHO  INTENTANDO CORREGIR PROTOCOLO DE AUTENTICACION
ECHO ======================================================
ECHO.
ECHO El error "ER_NOT_SUPPORTED_AUTH_MODE" ocurre porque MySQL 8
ECHO usa una encriptacion moderna que Cube aun no soporta por defecto.
ECHO.
ECHO Intentaremos cambiar tu usuario a 'mysql_native_password'.
ECHO Esto requiere Docker. Espere...
ECHO.

rem Usamos una imagen ligera de Alpine para correr el cliente MySQL
docker run --rm alpine sh -c "apk add --no-cache mysql-client && mysql -h 192.168.1.180 -u microservicio -psecr3t! -e \"ALTER USER 'microservicio'@'%%' IDENTIFIED WITH mysql_native_password BY 'secr3t!'; FLUSH PRIVILEGES; SELECT 'EXITO: CAMBIO REALIZADO CORRECTAMENTE';\""

IF %ERRORLEVEL% NEQ 0 (
    COLOR 0C
    ECHO.
    ECHO [FALLO] No se pudo cambiar la autenticacion automaticamente.
    ECHO POSIBLE CAUSA: El usuario 'microservicio' no tiene permisos de admin.
    ECHO.
    ECHO SOLUCION MANUAL:
    ECHO Contacta al DBA (Administrador de Base de Datos) y pidele ejecutar esto:
    ECHO.
    ECHO    ALTER USER 'microservicio'@'%%' IDENTIFIED WITH mysql_native_password BY 'secr3t!';
    ECHO.
) ELSE (
    COLOR 0A
    ECHO.
    ECHO [EXITO] Se actualizo la autenticacion.
    ECHO Ahora reinicia el Cube (Cierra la ventana negra y vuelve a abrir RUN_CUBE.bat).
)
PAUSE
