# Manual de Implementación: Guía Paso a Paso (US4938)
**Para:** Sebastian Posada

Esta es tu guía directa para desarrollar el Dashboard de Resumen por Coordinador:

### Paso 1: Configurar el Modelo Base
*   Crea un nuevo archivo SQL en `models/marts/fct_resumen_coordinador.sql`.
*   Asegúrate de importar los datos de `stg_solicitudes` (usando el modelo que ya definimos para US4937).

### Paso 2: Implementar la Lógica de Carga
1.  **Solicitudes Activas:** Filtra aquellas cuyo `created_at` es anterior a las 16:30 del día previo.
2.  **Solicitudes Adicionales:** Filtra las posteriores a dicha hora.
3.  **Agregación:** Agrupa por `coordinador_id` y por `tipo_servicio` (Instalación, Mantenimiento, Retiro).

### Paso 3: Definir el Modelo Semántico
*   Calcula los campos `pendientes` y `atendidas` basándote en el estado actual de la solicitud en SIGO.
*   Corre `dbt run --select fct_resumen_coordinador` para validar la tabla.

### Paso 4: Diseño del Tablero
*   En Power BI, crea un gráfico de barras comparativo: Atendidas vs Pendientes.
*   Usa un filtro de "Slicer" para seleccionar el Coordinador (ej: Jorge Balarezo).
*   Añade la línea de tendencia semanal con un eje de fechas.

### Paso 5: Automatización
*   Verifica que el DAG de Airflow incluya este nuevo modelo en el flujo de ejecución horaria.
*   Monitorea los logs de dbt para asegurar que no haya colisiones de datos.
