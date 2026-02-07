# Dashboard de Gestión de Solicitudes - Comsatel VIP

**Desarrollado por:** Sebastian Posada  
**Analista BI**  
**Proyecto:** US4937 - Dashboard Solicitudes por Cliente  

---

## Introducción
Este proyecto nace de la necesidad de tener una visibilidad clara y en tiempo real sobre cómo estamos atendiendo a nuestros clientes VIP. No es solo un tablero de control; es una herramienta pensada para que el equipo de operaciones pueda tomar decisiones rápidas, viendo tanto el panorama general (KPIs) como el detalle operativo de cada vehículo en un solo lugar.

## ¿Qué hace este Dashboard?
El objetivo fue centralizar la información que antes estaba dispersa. Ahora, al abrir el dashboard, lo primero que ves son los indicadores clave: cuántas solicitudes han llegado, qué tenemos programado, qué se ha completado y qué está pendiente del día.

Lo más importante es la **Gestión de Tiempos**. Implementé un diagrama de Gantt que permite rastrear cada placa o vehículo. Puedes ver qué está haciendo cada asesor y en qué estado se encuentra el servicio (si está en espera, programado o ya atendido). Además, le agregué funciones de zoom y desplazamiento para que, si hay muchos vehículos, no se pierda la claridad y se pueda navegar fácilmente entre las fechas.

## ¿Cómo está construido?
Para que el sistema fuera rápido y no dependiera de licencias costosas, decidí usar herramientas potentes pero ligeras:

*   **El "Cerebro" (Backend):** Usé **FastAPI con Python**. Es excelente para conectar directamente con nuestras bases de datos y entregar la información de forma instantánea.
*   **La Cara del Proyecto (Frontend):** Está hecho con **JavaScript puro y CSS**. Esto garantiza que la página cargue rápido en cualquier pantalla. Para los gráficos, utilicé la librería **Chart.js**, ajustándola especialmente para las necesidades del diagrama de tiempo.
*   **Manejo de Tiempos:** Como trabajamos con citas y horarios críticos, integré un sistema que maneja automáticamente la zona hora de **Lima, Perú**, asegurando que siempre veamos la hora real de la operación.
*   **Actualización Automática:** El dashboard se refresca solo cada 5 minutos. No hay que darle F5 ni hacer nada manual; los datos siempre están al día.

---

## Despliegue en Pantallas de 55"
Para que esto se vea bien en las pantallas grandes de la oficina o del centro de control, los pasos son sencillos:

1.  **Conexión:** Basta con conectar una Mini-PC o un dispositivo similar detrás del televisor vía HDMI.
2.  **Configuración de Pantalla Completa:** Lo ideal es abrir el navegador (Chrome o Edge) en "Modo Kiosk". Esto hace que la barra de direcciones y los menús desaparezcan, dejando solo el dashboard a pantalla completa.
3.  **Encendido Automático:** Se puede programar para que, apenas se encienda el equipo, abra la página del dashboard sin que nadie tenga que intervenir.

## ¿Cómo pasamos esto a Producción?
Cuando estemos listos para el lanzamiento oficial, el proceso es ordenado:

*   **Servidor de Aplicaciones:** El código de Python se instala en el servidor principal, configurando las conexiones seguras a la base de datos mediante variables de entorno.
*   **Empaquetado de la Visualización:** El frontend se compila para que sea lo más liviano posible, reduciendo los tiempos de carga al mínimo.
*   **Seguridad y Acceso:** Se configura un servidor web (como Nginx) para que gestione el tráfico de forma segura y sirva la página a los usuarios autorizados.
*   **Monitoreo:** Dejaré activo un sistema de logs para revisar que las consultas a la base de datos sigan siendo rápidas y que el auto-refresco funcione sin caídas.

---
Este dashboard es un paso adelante en la transformación digital de Comsatel, enfocado en la eficiencia y la excelencia en el servicio al cliente.
