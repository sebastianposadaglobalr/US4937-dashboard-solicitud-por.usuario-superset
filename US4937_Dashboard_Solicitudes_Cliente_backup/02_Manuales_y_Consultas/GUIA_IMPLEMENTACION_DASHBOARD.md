# Guía Paso a Paso: Dashboard "Control Diario de Solicitudes"

Esta guía explica **exactamente dónde hacer clic** para configurar todo rápido y sin errores.

---

## PASO 1: Crear el Dataset (Tu Fuente de Datos)

1.  En el menú superior, ve a **SQL Lab** -> **SQL Editor**.
2.  A la izquierda, selecciona:
    *   **Database**: `solicitudesservicio` (o el nombre de tu conexión MySQL).
    *   **Schema**: `solicitudesservicio`.
3.  Copia y pega este código SQL EXACTO en el editor central:

```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS solicitud_fecha,
  s.cliente_id,
  s.placa,
  s.localidad,
  a.nombre AS asesor_nombre,
  s.estado AS estado_solicitud,
  NULLIF(TRIM(s.cita_id), '') AS cita_id,

  /* CAMPO CLAVE: Si es después de 4:30 PM, cuenta como mañana */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
    ELSE DATE(s.fecha)
  END AS dia_operativo,

  /* Bandera para saber si fue después del corte */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN 1 ELSE 0
  END AS es_post_corte

FROM solicitudesservicio.tb_solicitud s
LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
WHERE s.tipo_solicitud = 1
  AND TRIM(UPPER(s.tipo_servicio)) = 'BASICO'
  AND s.estado <> 7;
```

4.  Presiona el botón **RUN** (Play) para verificar que salen datos abajo.
5.  Haz clic en el botón **SAVE AS DATASET** (botón pequeño cerca de Run).
6.  En la ventana que sale:
    *   **Dataset Name**: `ds_solicitudes_basico_dia_operativo`
    *   **Overwrite existing**: MÁRCALO (Check).
    *   Clic en **SAVE & EXPLORE**.

---

## PASO 2: Crear las Métricas (Las Fórmulas)

**¡IMPORTANTE!** Para ver el botón de crear métricas, necesitas editar el Dataset, no el Gráfico.

1.  **Desde donde estás (Como se ve en tu imagen)**:
    *   Mira arriba a la izquierda, en la sección **Chart Source**.
    *   Haz clic en los **3 puntos (...)** verticales al lado del nombre del dataset (`solicitudesservicio.ds...`).
    *   En el menú que se despliega, haz clic en **Edit dataset**.

2.  **En la ventana emergente que se abre**:
    *   Verás pestañas arriba: *Columns*, *Metrics*, *Computed Columns*.
    *   Haz clic en la pestaña **METRICS**.
    *   Ahí abajo verás el botón **+ ADD ITEM** (o *Add Metric*).

3.  **Agrega las fórmulas** (Copia y pega una por una):
    *   Clic en **+ ADD ITEM**.
    *   **SQL Expression**: Copia la fórmula.
    *   **Label**: Escribe el nombre exacto.
    *   Clic **SAVE**.

Lista de Métricas a crear:

| Metric Key (IMPORTANTE: Único) | Label (Nombre Visual) | SQL Expression (Copia y pega esto) |
| :--- | :--- | :--- |
| `kpi_sin_cita` | `KPI_Sin_Cita` | `SUM(CASE WHEN cita_id IS NULL THEN 1 ELSE 0 END)` |
| `kpi_programadas` | `KPI_Citas_Programadas` | `SUM(CASE WHEN estado_solicitud = 3 THEN 1 ELSE 0 END)` |
| `kpi_realizados` | `KPI_Realizados` | `SUM(CASE WHEN estado_solicitud = 5 THEN 1 ELSE 0 END)` |
| `kpi_pendientes` | `KPI_Pendientes` | `SUM(CASE WHEN estado_solicitud = 1 THEN 1 ELSE 0 END)` |
| `kpi_post_corte` | `KPI_Post_Corte` | `SUM(es_post_corte)` |

---

## PASO 3: Crear los Gráficos (Charts)

Ahora crearemos los 5 gráficos. Ve a **Charts** -> **+ CHART**.

### Gráfico A: Los Números Grandes (KPI Cards)
Debes hacer esto 5 veces (uno por cada KPI creado arriba), o hacer uno y duplicarlo.

1.  **Dataset**: `ds_solicitudes_basico_dia_operativo`
2.  **Visualization Type**: Selecciona **Big Number**.
3.  Clic **CREATE NEW CHART**.
4.  En la configuración (izquierda):
    *   **Metric**: Selecciona una de tus métricas (ej. `KPI_Sin_Cita`).
    *   **Time Range**: Déjalo en `No filter` (IMPORTANTE).
5.  Clic **SAVE**.
    *   **Name**: "KPI Recibidas".
    *   **Add to Dashboard**: Escribe "Tablero Operativo" y dale crear/seleccionar.
    *   **Save & Go to Dashboard** (al final).

*(Repite para los otros 4 KPIs: Programadas, Realizados, Pendientes, Post-Corte)*.

### Gráfico B: Comparativo Día (Tendencia)
1.  **Nuevo Chart**. Tipo: **Big Number with Trendline**.
2.  **Temporal X-Axis**: Selecciona `dia_operativo` (¡IMPORTANTE! No uses `solicitud_fecha`).
3.  **Metric**: `COUNT(*)` (o selecciona la métrica `Total` si la tienes).
4.  **Time Grain**: Selecciona `Day`.
5.  **Aggregation Method**: `Last Value` (Obtendrá el valor del día actual).
6.  **Save**: Nombre "Total Diario vs Ayer". Agregar al mismo Dashboard.

### Gráfico C: Tabla Detallada
1.  **Nuevo Chart**. Tipo: **Table**. Clic en **Create New Chart**.
2.  **Query Mode**: Haz clic en el botón **Raw records** (es mejor para tablas de detalle).
3.  **Columns** (Arrastra estas columnas desde la izquierda):
    *   `dia_operativo`
    *   `solicitud_fecha`
    *   `placa`
    *   `asesor_nombre`
    *   `estado_solicitud`
    *   `cita_id`
4.  **Sort by**: Selecciona `solicitud_fecha` y asegúrate que esté en orden descendente.
5.  **Save**: Nombre "Detalle de Solicitudes". Agregar al Dashboard.

---

## PASO 4: Armar el Dashboard (El toque final)

1.  Ve a **Dashboards** -> clic en "Tablero Operativo".
2.  Clic en **EDIT DASHBOARD** (botón lápiz, derecha arriba).
3.  **FILTROS (Crucial)**:
    *   Clic en la flecha azul "**FILTERS**" (barra lateral izquierda).
    *   Clic **+ ADD FILTER**.
    *   **Filter Type**: Cambia "Value" por **Time range** (¡ESTO ES LO MÁS IMPORTANTE!).
    *   **Filter Name**: "Dia Operativo".
    *   **Column**: Elige `dia_operativo`.
    *   **Pre-filter / Default Value**: 
        *   Selecciona **Current day**.
    *   Clic **SAVE**.

### 🔥 PASO 5: Automatización (Refresh y "Hoy" por defecto)

1.  **Actualización Automática (Cada 5 min)**:
    *   En el Dashboard, haz clic en los **3 puntos (...)** arriba a la derecha.
    *   Selecciona **Set auto-refresh interval**.
    *   Elige **5 minutes**.
2.  **Fuerza el Refresco**: Asegúrate de que el botón **SAVE** del dashboard esté guardado después de cambiar esto.

3.  **Para que cargue "Hoy" siempre**:
    *   En la configuración del Filtro (donde estás en tu imagen), en la sección **Filter Settings**, asegúrate de que esté marcado **Filter has default value**.
    *   En el popup de "Time Range" que tienes abierto, al darle a **APPLY**, ese rango de "Current Day" quedará fijo como el inicio de cada sesión.

### ✨ PASO 6: Diseño y Estética (¡El toque Premium!)

Para que el tablero se vea profesional y con color:

1.  **Colores en los KPIs (Big Numbers)**:
    *   Edita cada gráfico de Big Number.
    *   Ve a la pestaña **Customize** (al lado de Data).
    *   Busca **Header Font Size** (puedes subirlo para que el número sea más grande).
    *   Busca **Secondary Metric** (si activaste comparativos).
    *   Para el color del número: Superset usa el color del tema por defecto, pero puedes usar **Markdown** en los títulos para resaltarlos.

2.  **Centrar y Estilo en el Dashboard**:
    *   En el Dashboard, dale a **Edit Dashboard**.
    *   Haz clic en los **3 puntos (...)** de un gráfico -> **Edit properties**.
    *   Puedes cambiar el **Background color** del Dashboard completo en **Settings** -> **Dashboard Properties** -> **JSON Metadata** (esto es avanzado, pero puedes elegir un esquema de colores predefinido allí).

3.  **Uso de "Markdown Charts" para títulos grandes**:
    *   Si quieres un título centrado y colorido, agrega un elemento de tipo **Markdown** desde la barra lateral derecha del Dashboard.
    *   Escribe: `<h1 style="text-align:center; color:#007bff;">Mi Título</h1>`

4.  **Temas**:
    *   Arriba a la derecha en el Dashboard, en **Settings**, busca **Color Scheme**. Prueba con "Superset Colors" o esquemas vibrantes.

5.  **Guardar**: Clic en **SAVE** arriba a la derecha.

4.  **Acomodar**:
    *   Arrastra los 5 KPIs a la fila 1.
    *   Pon el gráfico de Tendencia debajo.
    *   Pon la Tabla al final.

5.  **Guardar**: Clic en **SAVE** arriba a la derecha.

¡Listo! Al entrar, automáticamente mostrará el "Día Operativo" de HOY. Si son las 5:00 PM, mostrará las de hoy después del corte + las de mañana.
