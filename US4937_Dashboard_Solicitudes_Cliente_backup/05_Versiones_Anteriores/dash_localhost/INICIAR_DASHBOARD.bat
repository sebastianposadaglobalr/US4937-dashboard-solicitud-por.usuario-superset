@echo off
TITLE Comsatel Dashboard Launcher
echo ==========================================
echo Starting Dashboard Services US4937
echo ==========================================

:: Start Backend in a new window
echo Starting Backend (FastAPI) on Port 8000...
start "Dashboard Backend" cmd /k "cd dashboard && ..\venv\Scripts\python.exe api_server.py"

:: Start Frontend in a new window
echo Starting Frontend (Vite) on Port 3000...
start "Dashboard Frontend" cmd /k "cd dashboard && npx vite --port 3000 --host"

echo.
echo ==========================================
echo Services are starting!
echo Backend: http://localhost:8000
echo Frontend: http://localhost:3000
echo ==========================================
pause
