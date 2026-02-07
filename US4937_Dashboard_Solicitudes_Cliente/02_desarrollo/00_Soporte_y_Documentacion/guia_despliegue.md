# 🚀 GUÍA PASO A PASO: Despliegue Dashboard Superset (US4937)

Esta guía condensa todo lo necesario para desplegar el dashboard de "Día Operativo" corrigiendo el error de conexión y utilizando las queries maestras definidas.

---

## 1. Requisitos del Sistema

*   **Docker Desktop** (con Linux Containers habilitado).
*   **Conexión VPN** activa a la red de Comsatel.
*   **Puerto 8088** libre (Superset).
*   **Puerto 4000** libre (Cube.js).

---

## 2. Despliegue Automatizado

Para facilitar la replicación en cualquier máquina nueva (Laptop de desarrollo o Servidor), se ha creado un script de "Un solo click".

### 2.1. Instrucciones de Arranque

1.  Abre una terminal o el explorador de archivos.
2.  Ejecuta el archivo: `DESPLEGAR_STACK.bat`.
3.  El script hará lo siguiente:
    *   Detendrá contenedores anteriores.
    *   Descargará imágenes necesarias (si no existen).
    *   Levantará los servicios en segundo plano.

---

## 3. Credenciales y URLs Acceso

*   **Superset:** [🚀 **Entra a Superset** (Click aquí)](http://localhost:8088)
*   **Cube.js:** [http://localhost:4000](http://localhost:4000)
*   **Usuario:** `admin`
*   **Password:** `admin`
*   **Archivo SQL Maestro (Copiar queries de aquí):**
    [QUERIES_PARA_DBEAVER.sql](file:///C:/Users/User/Documents/Profesional/Global_resources-comsatel/requerimientos/US4937_Dashboard_Solicitudes_Cliente/alternativa_implementacion/QUERIES_PARA_DBEAVER.sql)

---

## 4. Manual de Configuración Paso a Paso

Una vez desplegado el stack, la configuración dentro de Superset (Creación de gráficos y datasets) se detalla en el siguiente documento operativo:

### 🛑 PASO CRÍTICO 0: Corregir el Error `No module named 'MySQLdb'`
Si ves este error en tus gráficos, significa que Superset está intentando usar un driver antiguo que no está instalado en el contenedor.

**SOLUCIÓN DEFINITIVA:**
1.  En Superset, ve a **Settings** (arriba a la derecha) -> **Database Connections**.
2.  Edita tu conexión (probablemente llamada 'MySQL' o 'Comsatel').
3.  **NO uses la interfaz gráfica** de "Host", "Port", etc.
4.  Busca la opción **"SQLAlchemy URI"** (a veces bajo "Advanced" o "Edit configuration").
5.  Reemplaza **TODO** el texto allí por esta cadena exacta:

    ```text
    mysql+pymysql://microservicio:secr3t!@192.168.1.180:3306/solicitudesservicio
    ```
    *(La clave es `mysql+pymysql` al inicio. Si dice solo `mysql://`, fallará).*

6.  Haz clic en **TEST CONNECTION**. Debe salir "Connection looks good!".
7.  **FINISH**.

---

## 🛠️ PASO 1: Crear los Datasets (Tablas Virtuales)

Ve a **SQL Lab** -> **SQL Editor** en Superset. Asegúrate de seleccionar la base de datos `solicitudesservicio`.

### Dataset 1: Maestro BASICO (Detalle)
1.  Copia la Query **[1]** del archivo `QUERIES_PARA_DBEAVER.sql`.
    *   *Nota: Reemplaza las variables `@hoy` y `@corte` por valores fijos o asegúrate que Superset soporte variables de sesión. Para producción, reemplaza `@corte` por `'16:30:00'` directo en el código.*
2.  Ejecuta con **RUN**.
3.  **Save** -> **Save as Dataset** -> Nombre: `Maestro_Basico`.

### Dataset 2: KPI Dashboard (Agregado)
1.  Copia la Query **[2]** del archivo SQL.
2.  Reemplaza `@hoy` por `CURRENT_DATE()` (o tu fecha fija de test) y `@corte` por `'16:30:00'` dentro de la query.
3.  **Run** -> **Save as Dataset** -> Nombre: `KPI_Dia_Operativo`.

### Dataset 3: Timeline (Gantt)
1.  Copia la Query **[4]** del archivo SQL.
2.  Igual que arriba, asegura que las fechas estén bien definidas.
3.  **Run** -> **Save as Dataset** -> Nombre: `Timeline_Citas`.

---

## 📊 PASO 2: Crear Gráficos (Charts)

### A. KPIs (Numeros Grandes)
Usa el dataset **`KPI_Dia_Operativo`**.

*   **Tipo:** Big Number.
*   **Crear 5 Gráficos independientes:**
    1.  **Recibidas:** Metric = `solicitudes_recibidas`.
    2.  **Programadas:** Metric = `citas_programadas_solicitud`.
    3.  **Atendidas:** Metric = `atendidas`.
    4.  **Pendientes:** Metric = `pendientes`.
    5.  **Adicionales (Ayer Post-Corte):** Metric = `adicionales_post_corte_prev_day`.

### B. Tabla Detalle
Usa el dataset **`Maestro_Basico`**.

*   **Tipo:** Table.
*   **Columns:** `solicitud_id`, `solicitud_fecha`, `dia_operativo`, `ventana_operativa`, `estado_solicitud_nombre`, `cliente`, `placa`, `asesor_nombre`.

### C. Timeline (Gantt Simplificado)
Usa el dataset **`Timeline_Citas`**.

*   **Tipo:** Time-series Bar Chart (o Gannt si tienes el plugin, si no, usa barras horizontales).
*   **X Axis:** `cita_inicio`.
*   **Metrics:** `COUNT(*)`.
*   **Group by:** `asesor_nombre` o `placa`.

---

## 🎛️ PASO 3: Armar el Dashboard

1.  Ve a **Dashboards** -> **+ DASHBOARD**.
2.  Ponle título: "Dashboard Operativo Comsatel (Día Corte 16:30)".
3.  Arrastra tus gráficos (Charts) al lienzo.
4.  **Configurar Filtros (Filter Bar):**
    *   Añade un filtro llamado "Día Operativo".
    *   Columna: `dia_operativo` (del dataset `Maestro_Basico`).
    *   Valor por defecto: `Today` (o tu fecha fija `2022-09-06`).
    *   *Asegúrate que este filtro aplique a todos los gráficos.*

---

## ❓ Solución de Problemas Comunes

| Problema | Solución |
| :--- | :--- |
| **Error `No module named 'MySQLdb'`** | Revisa el PASO 0. Debes usar `mysql+pymysql://` en la conexión. |
| **KPIs en 0** | Verifica que la variable `@hoy` coincida con fechas donde hay datos (ej. 2022-09-06). |
| **Gráfico vacío** | Revisa el rango de tiempo del gráfico (Time Range). Ponlo en "No filter" o adáptalo a la fecha histórica. |

---
**¡Listo! Con esto tienes el dashboard desplegado con la lógica de negocio validada.**
