# 🚀 GUIA MAESTRA: DESPLIEGUE DASHBOARD (End-to-End)

Sigue estos 4 pasos exactos para conectar todo.

## ✅ REQUISITO 0: VPN
Asegúrate de que tu VPN de Comsatel esté **CONECTADA**. (Tu IP actual es `172.16.19.65`).

## 1️⃣ PASO 1: Iniciar el Motor (Cube)
1.  Ve a la carpeta `superset_conection`.
2.  Dale Doble Click a: `RUN_CUBE.bat`.
3.  Espera a que diga `[SUCCESS] Cube corriendo`.
    *   *(Nota: Si funciona, puedes entrar a http://localhost:4001 para ver que responde).*

## 2️⃣ PASO 2: Corregir Superset (Solo una vez)
1.  En la misma carpeta, dale Doble Click a: `FIX_DRIVER.bat`.
    *   Esto instalará el "traductor" (driver) que le faltaba a Superset.
    *   Debe decir `[EXITO]`.

## 3️⃣ PASO 3: Abrir Superset
1.  Abre tu navegador en:
    👉 [http://localhost:8088](http://localhost:8088)
    *   User: `admin`
    *   Pass: `admin`

## 4️⃣ PASO 4: Conectar la Base de Datos
1.  Ve a **Settings** (Engranaje) -> **Database Connections** -> **+ DATABASE**.
2.  Elige **PostgreSQL** (¡No elijas MySQL!).
3.  Abre el archivo de texto `PASO_3_DATOS_CONEXION.txt`.
4.  Copia la **OPCION 2 (IP VPN)** y pégala en el campo **SQLAlchemy URI**.
    *   Debe verse algo así: `postgresql+psycopg2://admin:admin@172.16.19.65:15432/model`
5.  Dale a **TEST CONNECTION**.

---
**¡LISTO!**
Ahora puedes crear tus Datasets y Dashboards.
---

## 5️⃣ PASO 5: Modo "TV Wall" (Rotación Automática)
Si quieres dejar los dashboards en una pantalla de la oficina rotando solos:

1.  Busca el archivo `TV_WALL_LOOPER.html` en la carpeta.
2.  Ábrelo con Chrome o Edge.
3.  **Configuración rápida**: Si tus dashboards no son los IDs 1, 2 y 3, abre el archivo con el Bloc de notas y cambia los números en la línea: `const DASHBOARD_IDS = [1, 2, 3];`.
4.  Presiona **F11** para ponerlo en pantalla completa.
    *   *Los dashboards cambiarán cada 30 segundos automáticamente y sin cabeceras.*
