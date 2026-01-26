-- Tabla Raw de Solicitudes (Simulación de origen SIGO)
CREATE TABLE IF NOT EXISTS raw_solicitudes (
    id_solicitud VARCHAR PRIMARY KEY,
    cliente_nombre VARCHAR,
    tipo_cliente VARCHAR, -- BÁSICO, CORPORATIVO, etc.
    asesor_responsable VARCHAR,
    servicio_tipo VARCHAR, -- INSTALACIÓN, MANTENIMIENTO, etc.
    fecha_creacion TIMESTAMP,
    fecha_programacion TIMESTAMP,
    estado_solicitud VARCHAR, -- PENDIENTE, ATENDIDA, CANCELADA
    vehiculo_id VARCHAR
);

-- Tabla de Atenciones (Eventos reales)
CREATE TABLE IF NOT EXISTS raw_atenciones (
    id_atencion VARCHAR PRIMARY KEY,
    id_solicitud VARCHAR,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    tecnico_nombre VARCHAR
);
