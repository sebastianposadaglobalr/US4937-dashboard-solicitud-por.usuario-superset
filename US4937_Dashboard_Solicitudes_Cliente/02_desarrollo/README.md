# Documentación Técnica: Dashboard de Solicitudes por Cliente (US4937)
**Autor:** Ing. Sebastian Posada - Consorcio Senior de Arquitectura & Analítica

## 1. Introducción y Contexto
Este proyecto forma parte de la optimización del ecosistema SIGO de Comsatel. El objetivo primordial es el despliegue de un tablero de control reactivo para el monitoreo de solicitudes de clientes de tipo **BÁSICO**. Se busca identificar proactivamente retrasos en la programación y asegurar la fluidez operativa diaria.

## 2. Arquitectura de la Solución (Realismo 2026)
Hemos diseñado una infraestructura basada en principios de **minimalismo tecnológico** y **alta eficiencia de costos**, priorizando herramientas que garantizan escalabilidad sin comprometer el presupuesto:

*   **Capa de Datos (Storage):** Implementación sobre **DuckDB / Postgres** para una gestión ágil de datos analíticos con latencia mínima.
*   **Transformación (Analytics Engineering):** Uso de **dbt (data build tool)** para centralizar la lógica de negocio, control de versiones y calidad mediante tests automáticos.
*   **Orquestación:** Despliegue de un nodo ligero de **Apache Airflow** para la automatización de pipelines con una frecuencia de actualización de 2 horas.
*   **Contenerización:** Infraestructura acoplada mediante **Docker** y **Docker Compose**, permitiendo un despliegue reproducible en cualquier entorno (Local/Cloud).

## 3. Requerimientos Analíticos y Lógica de Negocio
La pieza central de la inteligencia de este dashboard es la **Regla de Corte de las 16:30 hrs**:
*   **Solicitudes Base:** Registradas hasta las 16:30 del día previo.
*   **Solicitudes Adicionales:** Registradas posterior al corte, impactando la carga operativa no prevista.

## 4. Estrategia de Desarrollo
El desarrollo se ejecuta bajo una metodología incremental:
1.  **Staging Layer:** Normalización de fuentes operativas SIGO.
2.  **Marts Layer:** Modelado dimensional y aplicación de lógica temporal (Time-window partitioning).
3.  **Visualization Layer:** Exposición de KPIs críticos (Recibidas, Programadas, Realizadas) con filtros dinámicos por Cliente y Asesor.

---
*Este documento constituye la base técnica para el equipo de desarrollo y asegura la alineación con los estándares de excelencia de Comsatel.*
