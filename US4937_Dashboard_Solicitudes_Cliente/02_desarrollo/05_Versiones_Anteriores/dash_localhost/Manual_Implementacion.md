# 🚀 Manual de Implementación: Dashboard Inicial (FastAPI + Vite)

Este manual documenta la implementación **INICIAL y PRINCIPAL** desarrollada a la medida (Custom Web App). Esta es la versión que corre en el puerto `3000` (Frontend) y `8000` (Backend).

PARA LA IMPLEMENTACIÓN ALTERNATIVA CON SUPERSET, VER: `alternativa_implementacion/implementacion cube_superset.md`

---

## 1. Arquitectura del Sistema
El sistema consta de dos componentes desacoplados que deben ejecutarse simultáneamente:

1. **Backend (API Python)**:
   * **Tecnología**: Python 3.x, FastAPI, PyMySQL, Pandas.
   * **Puerto**: `8000`
   * **Responsabilidad**: Conexión directa a MySQL (`192.168.1.180`), procesamiento de datos con Pandas y exposición de endpoints JSON.

2.  **Frontend (Web Interface)**:
    *   **Tecnología**: HTML5, Vanilla JS (con Chart.js/Luxon), Vite Server.
    *   **Puerto**: `3000`
    *   **Responsabilidad**: Interfaz de usuario reactiva, gráficos y comunicación asíncrona con el Backend.

---

## 2. Requisitos Previos

* **Python 3.10+**: Instalado y agregado al PATH.
* **Node.js & npm**: Requerido para ejecutar el servidor de desarrollo Vite (`npx`).
* **VPN Conectada**: Indispensable para acceder a la BD `192.168.1.180`.

---

## 3. Ubicación del Proyecto

**Ruta Principal:**
```powershell
C:\Users\User\Documents\Profesional\Global_resources-comsatel\requerimientos\US4937_Dashboard_Solicitudes_Cliente
```

**Carpetas Clave:**

* `/dashboard`: Código fuente del Frontend y Backend (`api_server.py`, `main.js`, `index.html`).
* `/venv`: Entorno virtual de Python con las dependencias instaladas.

---

## 4. Cómo Iniciar el Sistema (Forma Recomendada)

Hemos creado un script automatizado que levanta ambos servicios en ventanas separadas.

1.  Abre el explorador de archivos en la ruta del proyecto.
2.  Haz doble clic en el archivo:
    `INICIAR_DASHBOARD.bat`

Esto abrirá dos ventanas de consola:

*   **Ventana A (Backend)**: "Starting Backend (FastAPI)..."
*   **Ventana B (Frontend)**: "Starting Frontend (Vite)..." y abrirá el navegador automáticamente.

---

## 5. Ejecución Manual (En caso de fallo del .bat)

Si necesitas debuggear o iniciar los componentes uno por uno, usa **PowerShell**:

### Paso A: Iniciar Backend (API)
```powershell
cd "C:\Users\User\Documents\Profesional\Global_resources-comsatel\requerimientos\US4937_Dashboard_Solicitudes_Cliente"
.\venv\Scripts\activate
cd dashboard
python api_server.py
```
*Debe decir: `Uvicorn running on http://0.0.0.0:8000`*

### Paso B: Iniciar Frontend
Abre una **nueva** terminal de PowerShell:
```powershell
cd "C:\Users\User\Documents\Profesional\Global_resources-comsatel\requerimientos\US4937_Dashboard_Solicitudes_Cliente\dashboard"
npx vite --port 3000 --host
```
*Debe decir: `Local: http://localhost:3000`*

---

## 6. Solución de Problemas Comunes

| Síntoma | Causa Probable | Solución |
| :--- | :--- | :--- |
| **Tablero muestra todo en "0"** | El Backend no se está ejecutando o falló la conexión a BD. | 1. Verifica que la ventana negra del Backend esté abierta sin errores.<br>2. Revisa la conexión VPN. |
| **Error "Network Error" en consola** | Frontend no alcanza al puerto 8000. | Asegúrate de haber iniciado AMBOS servicios (Frontend y Backend). |
| **Gráficos vacíos** | No hay datos para los filtros seleccionados. | Intenta ampliar las fechas o cambiar el estado/cliente. |
