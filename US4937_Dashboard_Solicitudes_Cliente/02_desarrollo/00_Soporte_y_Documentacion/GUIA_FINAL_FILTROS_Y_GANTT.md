# 🏁 PASOS FINALES: Filtros Superiores y Gráfico Gantt

Para que el campo `servicio` aparezca y los filtros se vean arriba como en tu imagen, sigue estos 3 pasos exactos:

---

## 1️⃣ PASO 1: Actualizar SQL (Estados Legibles y Citas)

Para que el Gantt y los filtros funcionen perfecto con los nombres de los estados, usa este SQL:

1. Ve a **SQL Lab** -> **SQL Editor**.
2. **PEGA ESTE CÓDIGO**:

```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS solicitud_fecha,
  s.cliente AS nombre_cliente,
  s.placa,
  s.tipo_servicio AS servicio,
  a.nombre AS asesor_nombre,
  
  /* ESTADOS DE SOLICITUD (Readable) */
  CASE s.estado
    WHEN 1 THEN 'Pendiente'
    WHEN 2 THEN 'Con orden asignada'
    WHEN 3 THEN 'Programada'
    WHEN 5 THEN 'Atendida'
    WHEN 7 THEN 'Cancelado'
    ELSE 'Otro'
  END AS estado_solicitud_nombre,

  /* DATOS DE LA CITA (Para el Gantt) */
  c.inicio AS cita_inicio,
  c.fin AS cita_fin,
  c.estado_actual AS cita_estado, -- Aquí saldrán los estados: ESTADO_CITA_...

  /* TIPO DE ORDEN */
  CASE 
    WHEN s.tipo_solicitud = 1 THEN 'BASICO'
    WHEN s.tipo_solicitud = 2 THEN 'VIP'
    ELSE 'OTROS'
  END AS tipo_orden,

  /* DÍA OPERATIVO */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
    ELSE DATE(s.fecha)
  END AS dia_operativo,

  /* BANDERA POST-CORTE (Para el KPI) */
  CASE 
    WHEN TIME(s.fecha) > '16:30:00' THEN 1 
    ELSE 0 
  END AS es_post_corte

FROM solicitudesservicio.tb_solicitud s
LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
LEFT JOIN citas.tb_cita c ON c.id = NULLIF(TRIM(s.cita_id), '')
WHERE s.estado <> 7;
```

3. Clic en **RUN** y **Save as dataset** con el nombre **`ds_tablero_final`**.

---

## 4️⃣ KPI: Solicitud Post-Corte (Lógica 16:30)

Este es el número que muestra las solicitudes que llegaron ayer después de las 4:30 PM y que deben atenderse HOY.

1. Crea un nuevo **Chart** tipo **Big Number**.
2. **Dataset**: `ds_tablero_final`.
3. **Metric** (Custom SQL): `SUM(es_post_corte)`.
4. **Nombre**: `Solicitud post corte`.
5. **Filtro del Tablero**: Cuando el tablero tenga el filtro de "Dia Operativo" en "Hoy", este número mostrará automáticamente solo las que llegaron tarde ayer.

---

## 2️⃣ PASO 2: Poner los Filtros ARRIBA (Horizontal)

Para que no estén a la izquierda sino arriba en una barra:

1. Ve a tu **Dashboard** -> **Edit Dashboard** (Lápiz).
2. Abre el panel de **FILTERS** de la izquierda.
3. Mira arriba a la derecha del panel de filtros, hay un icono de **Tuerca (Settings)** o un icono de **tres puntos**.
4. Busca la opción que dice: **"Filter bar layout"**.
5. Cambia de **Vertical (left)** a **Horizontal (top)**.
6. Dale a **SAVE** en el panel de filtros y luego **SAVE** azul arriba a la derecha en el Dashboard.

---

## 3️⃣ PASO 3: Crear el Gráfico Gantt (Mapa de Tiempos)

1. Clic en **+ CHART**.
2. **Dataset**: `ds_filtros_final`.
3. **Visualization Type**: Busca **Gantt** o **Time Table**. (Si no ves Gantt, usa **Time Table**).
4. **Configuración**:
   - **X-AXIS (Tiempo)**: Selecciona `solicitud_fecha`.
   - **ENTITY (Filas)**: Selecciona `placa` (para ver los carros como en tu imagen).
   - **DATES (Duración)**: Selecciona `solicitud_fecha` como inicio.
5. Dale a **CREATE** y agrégalo a tu tablero.

---

### 💡 Tip para los filtros:
Ahora que ya tienes el nuevo dataset `ds_filtros_final`, cuando entres a configurar los filtros (como en tu última foto), **asegúrate de cambiar el Dataset a `ds_filtros_final`** y verás que mágicamente aparece la columna `servicio`.

¡Cuéntame si ya los ves arriba!
