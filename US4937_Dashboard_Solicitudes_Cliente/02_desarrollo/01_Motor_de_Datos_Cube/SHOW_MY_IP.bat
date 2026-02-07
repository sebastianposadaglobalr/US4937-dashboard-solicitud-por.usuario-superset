@echo off
TITLE Mi Direccion IP
COLOR 0A
ECHO ======================================================
ECHO  TU DIRECCION IP LOCAL ES:
ECHO ======================================================
ECHO.
ipconfig | findstr /i "IPv4"
ECHO.
ECHO Usa el numero que aparece arriba (ej: 192.168.1.X)
ECHO para reemplazar en la conexion si 'host.docker.internal' falla.
ECHO.
PAUSE
