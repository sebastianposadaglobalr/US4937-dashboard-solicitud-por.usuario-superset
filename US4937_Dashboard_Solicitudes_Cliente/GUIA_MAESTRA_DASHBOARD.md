# 🚀 Guía Maestra: Dashboard US4937 (Comsatel)

Este documento es tu referencia única para montar el proyecto de forma rápida y profesional.

## 📦 Arquitectura del Proyecto
- **Archivo de Docker:** El sistema se levanta con el archivo `docker-compose.yml` (ubicado en `dashboard_dev_entregable`).
- **Persistencia:** Todo se guarda en `superset_home`. **No pierdes nada al reiniciar.**

## 🛠️ Paso 0: Conexión a la Base de Datos
En Superset, ve a **Settings** -> **Database Connections** -> **+ Database** -> **MySQL**:

*   **Host:** `192.168.1.180`
*   **Port:** `3306`
*   **Database name:** `solicitudesservicio`
*   **Username:** `microservicio`
*   **Password:** `secr3t!`
*   **Display Name:** `Comsatel_PROD`

> [!IMPORTANT]
> **Drivers instalados:** El sistema usa `mysqlclient` (nativo). Si usas la opción "Other" para conectar, la URI es:
> `mysql+mysqlclient://microservicio:secr3t%21@192.168.1.180:3306/solicitudesservicio?charset=utf8mb4`

## 📊 Paso 1: Crear el Dataset Maestro
1. Entra a **SQL Lab** -> **SQL Editor**.
2. Selecciona Database: `Comsatel_PROD`.
3. Pega la **QUERY MAESTRA** (1 fila por solicitud con corte 16:30):
```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS fecha_solicitud,
  s.cliente AS nombre_cliente,
  a.nombre AS nombre_consultor,
  COALESCE(s.placa, SUBSTRING(s.vehiculo_id, 1, 8), 'Sin ID') AS vehicle,
  CASE
    WHEN s.estado = 1 THEN 'Pendiente'
    WHEN s.estado = 2 THEN 'Con Orden'
    WHEN s.estado = 3 THEN 'Programada'
    WHEN s.estado = 5 THEN 'Atendida'
    WHEN s.estado = 7 THEN 'Cancelado'
    ELSE 'Otro'
  END AS estado_solicitud_txt,
  c.tipo_servicio AS servicio,
  
  -- Lógica de Día Operativo (Corte 16:30)
  CASE 
    WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY) 
    ELSE DATE(s.fecha) 
  END AS dia_operativo,

  -- Columnas de Negocio (Para SUM)
  1 AS solicitud_recibida,
  CASE WHEN s.estado = 3 THEN 1 ELSE 0 END AS solicitud_programada,
  CASE WHEN s.estado = 5 THEN 1 ELSE 0 END AS solicitud_atendida,
  CASE WHEN s.estado = 1 THEN 1 ELSE 0 END AS solicitud_pendiente,
  CASE WHEN TIME(s.fecha) > '16:30:00' THEN 1 ELSE 0 END AS es_adicional,
  
  -- Timeline: start/end
  COALESCE(c.inicio, s.fecha) AS start,
  COALESCE(c.fin, DATE_ADD(COALESCE(c.inicio, s.fecha), INTERVAL 1 HOUR)) AS end

FROM tb_solicitud s
LEFT JOIN tb_asesor a ON a.id = s.asesor_id
LEFT JOIN citas.tb_cita c ON c.id = s.cita_id
WHERE s.tipo_solicitud = 1
  AND s.fecha < TIMESTAMP(CURDATE(), '16:30:00')
```
4. Dale a **Save** -> **Save as Dataset** y llámalo `Dataset_Comsatel`.

## 📈 Paso 2: Crear los Gráficos (Charts)
Ve a la pestaña **Datasets**, busca `Dataset_Comsatel` y haz clic encima para empezar a crear:

### A. Para los "Big Numbers" (Tarjetas)
Para cada una de las 4 tarjetas, configura lo siguiente en el panel izquierdo de **Superset**:

1.  **Metric (La medida):**
    *   Haz clic donde dice `COUNT(*)` para abrir el cuadro.
    *   **¡PASO CRÍTICO!** Haz clic en la pestaña que dice **"Simple"** (al lado de "Saved").
    *   Ahora sí verás el desplegable **Column** (elige `solicitud_recibida`) y **Aggregate** (elige **SUM**).
    *   Dale clic al botón **SAVE** azul.
2.  **Filtros (Para que sean del día actual):**
    *   Busca la sección **Filters** (debajo de Metric).
    *   Haz clic en **+ ADD FILTER** o arrastra `dia_operativo` ahí.
    *   Selecciona **"Custom"** o **"Current day"** para que el número sea el de hoy.
3.  **Título y Guardado:**
    *   Ponle el nombre arriba (ej: "Solicitudes Recibidas") y dale al botón **SAVE** de la esquina superior derecha.

| Tarjeta | Columna (en pestaña Simple) | Agregación (Aggregate) |
| :--- | :--- | :--- |
| **Recibidas** | `solicitud_recibida` | **SUM** |
| **Programadas** | `solicitud_programada` | **SUM** |
| **Atendidas** | `solicitud_atendida` | **SUM** |
| **Pendientes** | `solicitud_pendiente` | **SUM** |

### B. Para el Timeline / Gantt (Gestión de tiempo)
Selecciona el tipo de gráfico **Time-series Bar Chart**:
- **X-AXIS (Eje X):** Campo `start`.
- **METRIC:** Suma de `solicitud_recibida`.
- **BREAKDOWNS / COLOR:** Campo `servicio`.

### C. Pendientes por Consultor (Gráfico de Barras)
Selecciona el tipo de gráfico **Bar Chart** (o Bar Chart V2) y configura:
- **X-AXIS:** Campo `nombre_consultor`.
- **METRIC:** Cambia a pestaña **Simple** -> Column: `solicitud_pendiente` -> Aggregate: **SUM**.
- **FILTERS:** Arrastra `dia_operativo` -> Elige **Current day** (o Today).

## 🔍 Paso 3: Configurar los Filtros (Panel Izquierdo)
En tu Dashboard, haz clic en el icono de filtros (lado izquierdo) y dale a **+ ADD FILTER**. Configura cada filtro siguiendo esta tabla:

| Campo en Superset | Valor para Filtro 1 | Valor para Filtro 2 | Valor para Filtro 3 |
| :--- | :--- | :--- | :--- |
| **Filter name** | `Nombre Cliente` | `Consultor` | `Servicio` |
| **Filter Type** | `Value` | `Value` | `Value` |
| **Dataset** | `Dataset_Comsatel` | `Dataset_Comsatel` | `Dataset_Comsatel` |
| **Column** | `nombre_cliente` | `nombre_consultor` | `servicio` |

### Configuraciones Recomendadas (Checkboxes):
Para que tu dashboard sea profesional, marca o desmarca así:
- **Can select multiple values:** ✅ Marcado (Para elegir varios clientes a la vez).
- **Filter value is required:** ❌ Desmarcado (Para que el dashboard no salga vacío al inicio).
- **Select first filter value by default:** ❌ Desmarcado.
- **Dynamically search all filter values:** ✅ Marcado.

### 💡 Paso Final de Filtros:
Una vez configurados, dale al botón **SAVE** abajo a la derecha. Tus filtros aparecerán en una barra lateral en el dashboard. **¡Prueba seleccionando un cliente y verás cómo todo el dashboard se actualiza!**

---
**¡Listo!** El sistema está optimizado para ser rápido y visualmente limpio.

*Ing. Sebastian Posada - Desarrollo Senior US4937*
