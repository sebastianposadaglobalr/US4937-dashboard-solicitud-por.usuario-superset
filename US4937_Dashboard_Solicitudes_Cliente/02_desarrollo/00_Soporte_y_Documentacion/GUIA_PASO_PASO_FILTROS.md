# Guía: Configuración de Filtros Avanzados (Paso a Paso)

Para lograr que los filtros se vean exactamente como en tu imagen de ejemplo, debemos hacer 2 cosas: **Ajustar el SQL** para que los nombres sean legibles y luego **Agregar los filtros nativos** al tablero.

---

## 1️⃣ PASO 1: Ajustar el SQL (Para etiquetas bonitas)

Necesitamos que el filtro de "Tipo de Orden" diga "BASICO" o "VIP" en lugar de 1 o 2.

1.  Ve a **SQL Lab** -> **SQL Editor**.
2.  Copia y pega este nuevo SQL (He quitado el filtro fijo de `tipo_solicitud=1` para que puedas elegir en el tablero):

```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS solicitud_fecha,
  s.cliente_id,
  s.cliente AS nombre_cliente,
  s.placa,
  s.localidad,
  s.tipo_servicio AS servicio,
  a.nombre AS asesor_nombre,
  s.estado AS estado_solicitud,
  NULLIF(TRIM(s.cita_id), '') AS cita_id,

  /* NUEVO: Etiquetas para el filtro */
  CASE 
    WHEN s.tipo_solicitud = 1 THEN 'BASICO'
    WHEN s.tipo_solicitud = 2 THEN 'VIP'
    ELSE 'OTROS'
  END AS tipo_orden,

  /* LÓGICA DE DÍA OPERATIVO */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
    ELSE DATE(s.fecha)
  END AS dia_operativo,

  CASE WHEN TIME(s.fecha) > '16:30:00' THEN 1 ELSE 0 END AS es_post_corte

FROM solicitudesservicio.tb_solicitud s
LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
WHERE s.estado <> 7; -- Excluye solo los cancelados
```

3.  Presiona **RUN** y luego **SAVE AS DATASET**.
4.  **IMPORTANTE**: Elige el mismo nombre que antes (`ds_solicitudes_basico_dia_operativo`) y marca **OVERWRITE** para actualizarlo.

---

## 2️⃣ PASO 2: Agregar los Filtros al Tablero

1.  Ve a tu **Dashboard** ("Tablero Operativo").
2.  Clic en el botón azul **EDIT DASHBOARD** (arriba a la derecha).
3.  En la columna izquierda, busca el icono de **FILTERS** (una flecha azul que apunta hacia adentro).
4.  Haz clic en el botón **+ ADD/EDIT FILTERS**.

### Agrega estos 4 filtros uno por uno:

Para cada uno, haz clic en **+ ADD FILTER** y configura así:

| Nombre del Filtro | Dataset | Column (Columna) |
| :--- | :--- | :--- |
| **Tipo Orden** | `ds_solicitudes_...` | `tipo_orden` |
| **Nombre Cliente** | `ds_solicitudes_...` | `nombre_cliente` |
| **Asesor** | `ds_solicitudes_...` | `asesor_nombre` |
| **Servicio** | `ds_solicitudes_...` | `servicio` |

**Tips para que queden perfectos:**
*   En **Filter Settings**, marca la opción "**Can select multiple values**" si quieres ver varios a la vez.
*   En **Default Value**, puedes escribir "BASICO" en el filtro de Tipo Orden para que siempre inicie así.

5.  Haz clic en **SAVE** en la ventana de filtros.
6.  ¡MUY IMPORTANTE!: Haz clic en el botón **SAVE** azul que está arriba del todo a la derecha del dashboard para que no se pierdan los cambios.

---

## 3️⃣ PASO 3: Ubicación de los filtros
Superset por defecto los pone en una barra lateral a la izquierda. Si quieres que se vean "horizontales" arriba como en tu imagen:
1.  En **Edit Dashboard**, busca los **3 puntos (...)** al lado del botón Save.
2.  Selecciona **Edit Properties**.
3.  Busca la sección **JSON Metadata** y asegura de que no haya restricciones.

---
¿Te ayudo a configurar el primero para probar?
