-- =====================================================
-- QUERIES SQL FINALES PARA DASHBOARD US4937
-- ¡IMPORTANTE! Ejecutar con la base de datos seleccionada
-- =====================================================

-- Seleccionar la base de datos
USE solicitudesservicio;

-- =====================================================
-- QUERY 1: KPIs PRINCIPALES
-- =====================================================
SELECT
    -- Solicitudes Recibidas: todas las de tipo_solicitud = 1
    COUNT(*) as solicitudes_recibidas,

-- Citas Programadas: estado = 3 (Programada) O tienen cita_id
SUM(
    CASE
        WHEN estado = 3
        OR (
            cita_id IS NOT NULL
            AND cita_id != ''
        ) THEN 1
        ELSE 0
    END
) as citas_programadas,

-- Servicios Realizados: estado = 5 (Atendida)
SUM( CASE WHEN estado = 5 THEN 1 ELSE 0 END ) as servicios_realizados,

-- Servicios Pendientes: estado = 1 (Pendiente)
SUM(
    CASE
        WHEN estado = 1 THEN 1
        ELSE 0
    END
) as servicios_pendientes
FROM tb_solicitud
WHERE
    tipo_solicitud = 1;

-- =====================================================
-- QUERY 2: TIMELINE PARA GANTT (DATOS ACTUALES)
-- =====================================================
SELECT
    COALESCE(
        s.placa,
        SUBSTRING(s.vehiculo_id, 1, 8),
        'Sin ID'
    ) as vehiculo,
    s.cliente,
    s.estado,
    CASE
        WHEN s.estado = 1 THEN 'Pendiente'
        WHEN s.estado = 2 THEN 'Con Orden'
        WHEN s.estado = 3 THEN 'Programada'
        WHEN s.estado = 5 THEN 'Atendida'
        WHEN s.estado = 7 THEN 'Cancelado'
        ELSE 'Otro'
    END as estado_nombre,
    s.cita_id,
    c.estado_actual as estado_cita,
    c.tipo_servicio,
    s.fecha as fecha_solicitud,
    c.inicio as cita_inicio,
    c.fin as cita_fin,
    COALESCE(c.inicio, s.fecha) as inicio_visual,
    COALESCE(
        c.fin,
        DATE_ADD(
            COALESCE(c.inicio, s.fecha),
            INTERVAL 2 HOUR
        )
    ) as fin_visual
FROM tb_solicitud s
    LEFT JOIN citas.tb_cita c ON CAST(s.cita_id AS CHAR) = CAST(c.id AS CHAR)
WHERE
    s.tipo_solicitud = 1
    AND (
        s.cita_id IS NOT NULL
        AND s.cita_id != ''
    )
    AND s.estado != 7
ORDER BY COALESCE(c.inicio, s.fecha) DESC
LIMIT 50;

-- =====================================================
-- QUERY 3: VERIFICAR CUÁNTOS REGISTROS HAY PARA EL GANTT
-- =====================================================
SELECT
    COUNT(*) as total_registros_gantt,
    SUM(
        CASE
            WHEN c.inicio IS NOT NULL THEN 1
            ELSE 0
        END
    ) as con_fecha_inicio,
    SUM(
        CASE
            WHEN c.fin IS NOT NULL THEN 1
            ELSE 0
        END
    ) as con_fecha_fin
FROM tb_solicitud s
    LEFT JOIN citas.tb_cita c ON CAST(s.cita_id AS CHAR) = CAST(c.id AS CHAR)
WHERE
    s.tipo_solicitud = 1
    AND (
        s.cita_id IS NOT NULL
        AND s.cita_id != ''
    )
    AND s.estado != 7;

-- =====================================================
-- QUERY 4: ESTADOS ACTUALES (PARA VERIFICAR)
-- =====================================================
SELECT
    estado,
    CASE
        WHEN estado = 1 THEN 'Pendiente'
        WHEN estado = 2 THEN 'Con orden asignada'
        WHEN estado = 3 THEN 'Programada'
        WHEN estado = 5 THEN 'Atendida'
        WHEN estado = 7 THEN 'Cancelado'
        ELSE 'Desconocido'
    END as nombre_estado,
    COUNT(*) as cantidad
FROM tb_solicitud
WHERE
    tipo_solicitud = 1
GROUP BY
    estado
ORDER BY estado;