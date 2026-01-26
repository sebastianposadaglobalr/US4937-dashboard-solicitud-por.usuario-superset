{{ config(materialized='table') }}

WITH solicitudes AS (
    SELECT * FROM {{ ref('stg_solicitudes') }}
),

kpis AS (
    SELECT
        cliente_nombre,
        asesor,
        servicio,
        categoria_corte,
        COUNT(id_solicitud) AS total_recibidas,
        SUM(CASE WHEN estado_solicitud = 'PROGRAMADA' THEN 1 ELSE 0 END) AS total_programadas,
        SUM(CASE WHEN estado_solicitud = 'ATENDIDA' THEN 1 ELSE 0 END) AS total_realizadas,
        SUM(CASE WHEN estado_solicitud = 'PENDIENTE' THEN 1 ELSE 0 END) AS total_pendientes
    FROM solicitudes
    GROUP BY 1, 2, 3, 4
)

SELECT * FROM kpis
