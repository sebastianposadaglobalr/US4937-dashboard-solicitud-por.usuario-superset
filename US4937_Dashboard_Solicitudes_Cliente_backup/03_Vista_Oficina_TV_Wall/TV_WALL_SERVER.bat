@echo off
set PORT=8001
echo ====================================================
echo   SERVIDOR TV WALL - COMSATEL
echo ====================================================
echo.
echo 1. Iniciando servidor local en puerto %PORT%...
echo.
echo [INFO] Si no abre automaticamente, ve a: http://localhost:%PORT%/TV_WALL_LOOPER.html
echo.

:: Intentar abrir el navegador
start "" "http://localhost:%PORT%/TV_WALL_LOOPER.html"

:: Iniciar servidor simple de Python (incluido en Windows normalmente)
python -m http.server %PORT%

pause
