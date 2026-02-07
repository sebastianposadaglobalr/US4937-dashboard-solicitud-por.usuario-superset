# 📊 Resumen Maestro de Queries Final (US4937)

Usa estas consultas directamente en DBeaver o Superset. 

## 1. Localización de Tablas (DBeaver)
- **Conexión:** `192.168.1.180:3306`
- **Esquema `solicitudesservicio`:** Tablas `tb_solicitud` y `tb_asesor`.
- **Esquema `citas`:** Tabla `tb_cita`.

---

## 2. Queries Operativas

### 2.1 Cards KPI Globales (Big Numbers)
```sql
SELECT
  1 AS solicitud_recibida,
  CASE WHEN s.fecha <= (SELECT TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '16:30:00')) THEN 1 ELSE 0 END AS solicitud_inicio_dia,
  CASE WHEN s.fecha > (SELECT TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '16:30:00')) THEN 1 ELSE 0 END AS solicitud_adicional,
  CASE WHEN s.estado = 3 THEN 1 ELSE 0 END AS solicitud_programada,
  CASE WHEN s.estado = 5 THEN 1 ELSE 0 END AS solicitud_atendida,
  CASE WHEN s.estado = 1 THEN 1 ELSE 0 END AS solicitud_pendiente
FROM tb_solicitud s
WHERE s.tipo_solicitud = 1 
  AND s.fecha < TIMESTAMP(CURDATE(), '16:30:00')
```

### 2.2 Timeline / Gantt (Gestión de Tiempo)
```sql
SELECT
  COALESCE(s.placa, SUBSTRING(s.vehiculo_id, 1, 8), 'Sin ID') AS vehicle,
  s.cliente,
  a.nombre AS nombre_consultor,
  c.tipo_servicio AS servicio,
  'Cita' AS evento,
  c.inicio AS start,
  COALESCE(c.fin, DATE_ADD(c.inicio, INTERVAL 1 HOUR)) AS end
FROM tb_solicitud s
JOIN citas.tb_cita c ON c.id = s.cita_id
LEFT JOIN tb_asesor a ON a.id = s.asesor_id
WHERE s.tipo_solicitud = 1 AND c.inicio IS NOT NULL
ORDER BY c.inicio DESC LIMIT 500;
```

---
**Ing. Sebastian Posada - Cierre de Proyecto US4937**
