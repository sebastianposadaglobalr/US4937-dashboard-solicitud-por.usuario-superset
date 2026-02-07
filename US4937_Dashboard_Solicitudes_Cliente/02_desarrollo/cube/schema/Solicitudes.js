cube(`Solicitudes`, {
  sql: `SELECT * FROM solicitudesservicio.tb_solicitud WHERE tipo_solicitud = 1`,

  joins: {
    Asesores: {
      sql: `${CUBE}.asesor_id = ${Asesores}.id`,
      relationship: `belongsTo`
    }
  },

  measures: {
    count: {
      type: `count`,
      title: `Total Solicitudes`
    },

    programadas: {
      type: `count`,
      filters: [{ sql: `${CUBE}.estado = 3 OR (${CUBE}.cita_id IS NOT NULL AND ${CUBE}.cita_id != '')` }],
      title: `Citas Programadas`
    },

    realizadas: {
      type: `count`,
      filters: [{ sql: `${CUBE}.estado = 5` }],
      title: `Servicios Realizados`
    },

    pendientes: {
      type: `count`,
      filters: [{ sql: `${CUBE}.estado = 1` }],
      title: `Pendientes`
    },

    adicionales: {
      type: `count`,
      filters: [{ sql: `TIME(${CUBE}.fecha) > '16:30:00'` }],
      title: `Adicionales (Post 16:30)`
    }
  },

  dimensions: {
    id: {
      sql: `id`,
      type: `number`,
      primaryKey: true
    },

    cliente: {
      sql: `TRIM(cliente)`,
      type: `string`
    },

    vehiculo: {
      sql: `COALESCE(placa, SUBSTRING(vehiculo_id, 1, 8), 'Sin ID')`,
      type: `string`
    },

    fecha: {
      sql: `fecha`,
      type: `time`
    },

    estado: {
      sql: `CASE 
              WHEN estado = 1 THEN 'Pendiente'
              WHEN estado = 2 THEN 'Con Orden'
              WHEN estado = 3 THEN 'Programada'
              WHEN estado = 5 THEN 'Atendida'
              ELSE 'Otro'
            END`,
      type: `string`
    }
  }
});

cube(`Asesores`, {
  sql: `SELECT * FROM solicitudesservicio.tb_asesor`,

  dimensions: {
    id: {
      sql: `id`,
      type: `number`,
      primaryKey: true
    },
    nombre: {
      sql: `nombre`,
      type: `string`
    }
  }
});
