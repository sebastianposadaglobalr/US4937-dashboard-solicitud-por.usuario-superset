# 📊 Consultas Maestras de los Dashboards

Aquí tienes el detalle de los SQL utilizados para los datasets y filtros que configuramos en Superset.

## 1. Dataset Principal (ds_solicitudes_basico_dia_operativo)
Esta es la consulta base que alimenta todos los gráficos y tablas.

```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS solicitud_fecha,
  s.cliente_id,
  s.cliente AS nombre_cliente, -- Filtro: Nombre de Cliente
  s.placa,
  s.localidad,
  s.tipo_servicio,            -- Filtro: Tipo de Servicio
  a.nombre AS asesor_nombre,  -- Filtro: Asesor
  s.estado AS estado_solicitud,
  NULLIF(TRIM(s.cita_id), '') AS cita_id,

  /* LÓGICA DE DÍA OPERATIVO (Corte 16:30) */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
    ELSE DATE(s.fecha)
  END AS dia_operativo,

  /* Bandera de Post-Corte */
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN 1 ELSE 0
  END AS es_post_corte

FROM solicitudesservicio.tb_solicitud s
LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
WHERE s.tipo_solicitud = 1 -- Filtro: Tipo de Orden (VIP/Básico)
  AND s.estado <> 7;      -- Excluir cancelados
```

## 2. Lógica de Filtros Específicos

| Filtro | Columna SQL | Origen |
| :--- | :--- | :--- |
| **Tipo de Orden** | `s.tipo_solicitud` | Filtrado en el WHERE (`1` para básico en este caso). |
| **Nombre de Cliente**| `s.cliente` | Directamente de la tabla `tb_solicitud`. |
| **Asesor** | `a.nombre` | Obtenido mediante el JOIN con `tb_asesor`. |
| **Tipo de Servicio** | `s.tipo_servicio` | Directamente de la tabla `tb_solicitud`. |

## 3. Fórmulas de los KPIs (Métricas)

| KPI | Fórmula SQL en Superset |
| :--- | :--- |
| **KPI_Sin_Cita** | `SUM(CASE WHEN cita_id IS NULL THEN 1 ELSE 0 END)` |
| **KPI_Citas_Programadas** | `SUM(CASE WHEN estado_solicitud = 3 THEN 1 ELSE 0 END)` |
| **KPI_Realizados** | `SUM(CASE WHEN estado_solicitud = 5 THEN 1 ELSE 0 END)` |
| **KPI_Pendientes** | `SUM(CASE WHEN estado_solicitud = 1 THEN 1 ELSE 0 END)` |
