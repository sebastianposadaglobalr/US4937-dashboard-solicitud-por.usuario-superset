# Documentación Técnica: Estado General de las Solicitudes (US4939)
**Autor:** Ing. Sebastian Posada - Consorcio Senior de Arquitectura & Analítica

## 1. Alcance Estratégico
El Dashboard de Estado General es la vista consolidada de mayor jerarquía en el sistema SIGO. Permite a la supervisión de servicios tener un control holístico sobre los tres pilares operativos: **Instalación, Mantenimiento y Retiro**.

## 2. Definición Técnica
*   **Infraestructura:** Stack de código abierto (DuckDB + dbt + Airflow) desacoplado para máxima portabilidad.
*   **Seguridad y Accesos:** Implementación proyectada de **RLS (Row Level Security)** para personalización del acceso según privilegios del usuario.
*   **Análisis Temporal:** Implementación de series de tiempo para seguimiento de tendencias en ventanas de 15 días.

## 3. Componentes de Visualización
*   **Vista Macro:** Distribución porcentual por tipo de servicio.
*   **Vista Micro:** Estado operativo segmentado (Atendidas, Pendientes, Canceladas) por categoría.
*   **Tendencia:** Histórico de volumen de solicitudes para detección de estacionalidad.

---
*Arquitectura escalable orientada a valor de negocio.*
