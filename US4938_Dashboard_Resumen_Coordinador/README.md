# Documentación Técnica: Dashboard Resumen Diario por Coordinador (US4938)
**Autor:** Ing. Sebastian Posada - Consorcio Senior de Arquitectura & Analítica

## 1. Visión del Proyecto
Este requerimiento se enfoca en la descentralización del monitoreo operativo, permitiendo que cada coordinador visualize su avance diario frente a la cuota esperada de programación. Es un componente clave para la autogestión y cumplimiento de metas de servicio en Comsatel.

## 2. Arquitectura de Datos
La solución se integra en el framework de analítica SIGO, utilizando:
*   **Pipeline de Datos:** Ingesta desde SIGO SQL Server hacia el data warehouse local.
*   **Modelado Semántico (dbt Labs):** Transformaciones SQL robustas para categorizar solicitudes en tiempo real.
*   **Capa Visual:** Implementación de tarjetas dinámicas para balanceo de carga (Activas vs Adicionales).

## 3. Definición de KPIs y Métricas
*   **Carga Inicial (Activas):** Solicitudes presentes antes del corte programado (16:30 p.m.).
*   **Carga Reactiva (Adicionales):** Solicitudes ingresadas "on-the-fly" que requieren atención inmediata.
*   **Frecuencia de Actualización:** < 2 horas, garantizando frescura de datos para toma de decisiones.

---
*Diseñado bajo estándares de ingeniería de datos moderna.*
