{{ config(materialized='view') }}

WITH source AS (
    SELECT * FROM {{ source('raw', 'raw_solicitudes') }}
),

renamed AS (
    SELECT
        id_solicitud,
        cliente_nombre,
        tipo_cliente,
        asesor_responsable AS asesor,
        servicio_tipo AS servicio,
        fecha_creacion,
        fecha_programacion,
        -- Lógica de corte: 4:30 PM (16:30)
        CASE 
            WHEN CAST(fecha_creacion AS TIME) <= '16:30:00' THEN 'BASE'
            ELSE 'ADICIONAL'
        END AS categoria_corte,
        estado_solicitud
    FROM source
    WHERE tipo_cliente = 'BÁSICO' -- Filtro según requerimiento US4937
)

SELECT * FROM renamed
