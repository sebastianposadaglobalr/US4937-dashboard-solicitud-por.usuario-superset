-- =============================================================================
-- PROYECTO: US4937 - DASHBOARD SOLICITUDES POR CLIENTE (COMSATEL)
-- OBJETIVO: CONSULTAS MAESTRAS DEFINITIVAS (SINTAXIS LIMPIA)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- [TEST] PRUEBA RÁPIDA DE CONEXIÓN (Ejecuta esto para confirmar vida)
-- -----------------------------------------------------------------------------
-- SELECT 1;

-- =============================================================================
-- [1] DATASET MAESTRO BASICO (Tabla Base para Superset)
-- =============================================================================
SELECT
    s.id AS solicitud_id,
    s.fecha AS solicitud_fecha,
    DATE(s.fecha) AS solicitud_dia_calendario,
    TIME(s.fecha) AS solicitud_hora,
    s.cliente_id,
    s.cliente,
    s.vehiculo_id,
    s.placa,
    NULLIF(TRIM(s.cita_id), '') AS cita_id,
    s.localidad,
    s.asesor_id,
    a.nombre AS asesor_nombre,
    -- Día operativo (Corte 16:30)
    CASE
        WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
        ELSE DATE(s.fecha)
    END AS dia_operativo,
    -- Ventana operativa
    CASE
        WHEN TIME(s.fecha) > '16:30:00' THEN 'Adicional (Post-Corte)'
        ELSE 'Programación Regular'
    END AS ventana_operativa,
    -- Estado solicitud
    CASE s.estado
        WHEN 1 THEN 'Pendiente'
        WHEN 2 THEN 'Con orden asignada'
        WHEN 3 THEN 'Programada'
        WHEN 5 THEN 'Atendida'
        WHEN 7 THEN 'Cancelada'
        ELSE 'Otro'
    END AS estado_solicitud_nombre
FROM solicitudesservicio.tb_solicitud s
    LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
WHERE
    s.tipo_solicitud = 1
    AND TRIM(UPPER(s.tipo_servicio)) = 'BASICO'
    AND s.estado <> 7;

-- =============================================================================
-- [2] KPI "DÍA OPERATIVO" (Resumen Agregado)
-- Reemplaza '2022-09-06' por CURRENT_DATE() para tiempo real
-- =============================================================================
SELECT
    '2022-09-06' AS dia_operativo_ref,
    COUNT(*) AS solicitudes_recibidas,
    SUM(
        CASE
            WHEN s.estado = 3 THEN 1
            ELSE 0
        END
    ) AS citas_programadas_solicitud,
    SUM(
        CASE
            WHEN s.estado = 5 THEN 1
            ELSE 0
        END
    ) AS atendidas,
    SUM(
        CASE
            WHEN s.estado = 1 THEN 1
            ELSE 0
        END
    ) AS pendientes,
    -- Adicionales ayer post-corte
    SUM(
        CASE
            WHEN DATE(s.fecha) = DATE_SUB('2022-09-06', INTERVAL 1 DAY)
            AND TIME(s.fecha) > '16:30:00' THEN 1
            ELSE 0
        END
    ) AS adicionales_post_corte_prev_day
FROM solicitudesservicio.tb_solicitud s
WHERE
    s.tipo_solicitud = 1
    AND TRIM(UPPER(s.tipo_servicio)) = 'BASICO'
    AND s.estado <> 7
    AND (
        CASE
            WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
            ELSE DATE(s.fecha)
        END
    ) = '2022-09-06';

-- =============================================================================
-- [3] BREAKDOWN POR ESTADO (Gráfico de Torta / Barras)
-- =============================================================================
SELECT
    CASE s.estado
        WHEN 1 THEN 'Pendiente'
        WHEN 2 THEN 'Con orden asignada'
        WHEN 3 THEN 'Programada'
        WHEN 5 THEN 'Atendida'
        WHEN 7 THEN 'Cancelada'
        ELSE 'Otro'
    END AS estado_solicitud,
    COUNT(*) AS total
FROM solicitudesservicio.tb_solicitud s
WHERE
    s.tipo_solicitud = 1
    AND TRIM(UPPER(s.tipo_servicio)) = 'BASICO'
    AND s.estado <> 7
    AND (
        CASE
            WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
            ELSE DATE(s.fecha)
        END
    ) = '2022-09-06'
GROUP BY
    s.estado;

-- =============================================================================
-- [4] TIMELINE (Gantt)
-- =============================================================================
SELECT
    s.id AS solicitud_id,
    s.placa,
    a.nombre AS asesor_nombre,
    c.id AS cita_id,
    c.inicio AS cita_inicio,
    c.fin AS cita_fin,
    c.estado_actual AS cita_estado_actual
FROM solicitudesservicio.tb_solicitud s
    LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
    JOIN citas.tb_cita c ON c.id = NULLIF(TRIM(s.cita_id), '')
WHERE
    s.tipo_solicitud = 1
    AND TRIM(UPPER(s.tipo_servicio)) = 'BASICO'
    AND (
        CASE
            WHEN TIME(s.fecha) > '16:30:00' THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
            ELSE DATE(s.fecha)
        END
    ) = '2022-09-06';