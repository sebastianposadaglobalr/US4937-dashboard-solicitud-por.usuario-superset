# 🚀 Guía Rápida: Creación de Dashboard US4937

¡Tu sistema ya tiene **PERSISTENCIA TOTAL**! Todo lo que crees se guarda en la carpeta `dashboard_dev_entregable\superset_home`. 
- ✅ Si apagas el computador, tus dashboards **NO se pierden**.
- ✅ La conexión se guarda automáticamente.

## Paso 0: Conectar a la Base de Datos
Si la conexión se te perdió, ve a **Settings** -> **Database Connections** -> **+ Database** -> **MySQL** y llena estos campos:

*   **Host:** `192.168.1.180`
*   **Port:** `3306`
*   **Database name:** `solicitudesservicio`
*   **Username:** `microservicio`
*   **Password:** `secr3t!`
*   **Display Name:** `Comsatel_PROD`

> [!TIP]
> Si prefieres usar la URI avanzada (Option "Other"), usa esta:
> `mysql+mysqlclient://microservicio:secr3t%21@192.168.1.180:3306/solicitudesservicio?charset=utf8mb4`

## Paso 1: Crear el Dataset Maestro
1. Entra a **SQL Lab** -> **SQL Editor**.
2. Selecciona Database: `Comsatel_PROD` y Schema: `solicitudesservicio`.
3. Pega esta Query (Corregida con JOINs):
```sql
SELECT 
    s.cliente AS nombre_cliente,
    a.nombre AS nombre_asesor,
    c.tipo_servicio AS servicio,
    'BASICO' AS tipo_orden,
    CASE 
        WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY) 
        ELSE DATE(s.fecha) 
    END AS dia_operativo,
    1 AS metrica_recibidas,
    CASE WHEN s.estado = 3 THEN 1 ELSE 0 END AS metrica_programadas,
    CASE WHEN s.estado = 5 THEN 1 ELSE 0 END AS metrica_atendidas,
    CASE WHEN s.estado = 1 THEN 1 ELSE 0 END AS metrica_pendientes
FROM tb_solicitud s
LEFT JOIN tb_asesor a ON a.id = s.asesor_id
LEFT JOIN citas.tb_cita c ON CAST(s.cita_id AS CHAR) = CAST(c.id AS CHAR)
WHERE s.tipo_solicitud = 1
```
4. Dale a **Save** -> **Save as Dataset** y llámalo `Dataset_Oficial_Comsatel`.

## Paso 2: Crear los Big Numbers (Indicadores)
Ve a **Datasets** -> Clic en `Dataset_Oficial_Comsatel` -> **Create Chart**:

1. **Solicitudes Recibidas:**
   - Tipo: `Big Number`.
   - Metric: `SUM(metrica_recibidas)`.
   - Filtro de tiempo: `dia_operativo` = `Current Day`.
2. **Citas Programadas:**
   - Metric: `SUM(metrica_programadas)`.
3. **Servicios Realizados:**
   - Metric: `SUM(metrica_atendidas)`.
4. **Servicios Pendientes:**
   - Metric: `SUM(metrica_pendientes)`.

## Paso 3: Configurar los Filtros
En el **Dashboard**, añade un componente de **Filters**:
- **Tipo Orden:** Columna `tipo_orden`.
- **Nombre Cliente:** Columna `nombre_cliente`.
- **Asesor:** Columna `nombre_asesor`.
- **Servicio:** Columna `servicio`.

---
**¡Listo!** Con esto tendrás el Dashboard idéntico al solicitado, con los cortes de tiempo automáticos y filtros funcionales.

*Ing. Sebastian Posada - Entrega Express US4937*
