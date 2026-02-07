# Manual de Implementación: Guía Paso a Paso (US4939)
**Para:** Sebastian Posada

Sigue estos pasos para la implementación del Dashboard de Estado General de Aplicaciones:

### Paso 1: Extracción Incremental
*   Asegúrate de que el pipeline de Python esté configurado para traer solo estados actualizados de los últimos 15 días.
*   Valida la tabla `raw_solicitudes_general` para confirmar que tienes todos los servicios (Instalación, Mantenimiento, Retiro).

### Paso 2: Modelado Dimensional
*   Crea el modelo `models/marts/fct_estado_general.sql`.
*   Usa macros de dbt para generar los indicadores de porcentaje de atención por servicio.
*   *Tip:* Calcula el porcentaje como `(Atendidas / Total) * 100`.

### Paso 3: Visualización de Tendencias
*   Crea un gráfico de áreas o líneas que muestre el volumen diario de solicitudes por estado.
*   Implementa el filtro de rango de fechas para permitir análisis de periodos específicos.

### Paso 4: Seguridad (RLS)
*   Si se requiere acceso personalizado, configura los roles en Power BI o la base de datos para que cada usuario vea solo la información de su competencia.

### Paso 5: Despliegue
*   Actualiza el contenedor Docker si es necesario.
*   Activa la actualización automática en el servicio de BI.
