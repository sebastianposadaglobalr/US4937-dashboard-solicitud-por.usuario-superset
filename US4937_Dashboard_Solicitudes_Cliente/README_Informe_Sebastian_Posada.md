# Informe de Implementación: Dashboard Solicitudes por Cliente (US4937)
**Por: Ing. Sebastián Posada**
**Fecha:** 26 de enero de 2026

---

## 1. Introducción y Propósito
Este documento detalla la solución técnica implementada para el requerimiento **US4937**, centrada en la visualización estratégica de solicitudes para clientes de tipo **BÁSICO**. El objetivo principal es proporcionar a la Gerencia de Operaciones una herramienta que permita identificar cuellos de botella y gestionar demoras con una frecuencia de actualización menor a 2 horas.

## 2. Definiciones de Conceptos Clave
Para una comprensión clara, definimos los pilares de esta solución:
*   **dbt (data build tool):** Herramienta que permite transformar datos en el almacén mediante SQL, aplicando ingeniería de software (tests, control de versiones).
*   **Staging Layer:** Capa donde se limpian los datos crudos y se preparan para el negocio.
*   **Mart Layer:** Tabla final diseñada específicamente para el consumo de usuarios y BI.
*   **DAG (Directed Acyclic Graph):** Flujo de tareas en Airflow que se ejecuta en un orden específico.
*   **Lógica de Corte:** Regla de negocio que marca solicitudes como "Base" o "Adicional" según la hora de ingreso (16:30 hrs).

## 3. ¿Por qué esta Arquitectura?
He propuesto un stack basado en **DuckDB + dbt + Airflow** por las siguientes razones:
*   **Eficiencia de Costos:** Son herramientas Open Source que no requieren licencias costosas por volumen de datos.
*   **Rendimiento:** DuckDB permite procesar cientos de miles de registros en segundos localmente.
*   **Modularidad:** dbt permite que el código sea reutilizable y fácil de auditar por otros ingenieros.
*   **Automatización:** Airflow garantiza que el dashboard se refresque solo, cumpliendo el SLA de 2 horas.

## 4. Guía de Implementación Paso a Paso

### Paso 1: Configuración del Entorno
Hemos estructurado el proyecto para ser profesional desde el día 1. 
- La carpeta `models/` contiene el corazón de las transformaciones.
- La carpeta `dags/` contiene las instrucciones de actualización.

### Paso 2: El Proceso de Transformación (La Lógica)
1.  **Limpieza:** El modelo `stg_solicitudes` filtra solo los clientes "BÁSICO".
2.  **La Regla de Oro:** Se implementó una lógica SQL que identifica la hora de creación. Si es después de las 4:30 PM, se marca como `ADICIONAL`. Esto es vital para medir correctamente la planificación operativa.
3.  **KPIs:** El modelo `fct_solicitudes_diarias` agrupa todo en 4 métricas: Recibidas, Programadas, Atendidas y Pendientes.

### Paso 3: Orquestación y Calidad
1.  **Actualización Horaria:** Configuré un DAG en Airflow que corre cada 60 minutos. No hay intervención manual.
2.  **Pruebas Automáticas:** En GitLab, he configurado un pipeline que "regaña" al desarrollador si el código SQL está mal formateado o si los datos resultan nulos donde no deberían serlo.

### Paso 4: Visualización
Solo resta conectar Power BI (o Apache Superset) a la tabla final producida. He dejado un simulador de datos (`scripts/generate_mock_data.py`) para que veas el dashboard funcionando incluso sin conexión real a producción.

## 5. Conclusión
Esta guía no es solo código; es una base sólida diseñada para escalar. Sebastián Posada propone esta solución como el estándar de excelencia para proyectos de analítica en Comsatel, priorizando la precisión operativa y la eficiencia técnica.

---
*Para cualquier duda sobre la conexión de fuentes, consulte el archivo sources.yml en la carpeta de staging.*
