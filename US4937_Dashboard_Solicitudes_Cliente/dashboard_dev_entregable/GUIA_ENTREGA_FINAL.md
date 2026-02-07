# 🏁 Guía de Entrega Final - Dashboard US4937

¡Felicidades! El sistema de Dashboards de Comsatel ya está consolidado, limpio y operativo. Esta carpeta contiene **únicamente** lo necesario para el funcionamiento perfecto del proyecto.

## 🛠️ ¿Qué se instaló y configuró?
Hemos realizado una "cirugía nuclear" al entorno de Superset para garantizar que nunca más tengas fallas de conexión:

1.  **Drivers Nativos MySQL:** Se inyectó el driver `mysqlclient` directamente en el corazón (venv) de Superset. Esto es mucho más estable y rápido que los conectores genéricos.
2.  **Persistencia Garantizada:** Todo lo que crees en Superset (dashboards, charts, usuarios) se guarda automáticamente en la carpeta local `superset_home`. Si apagas el PC o borras los contenedores, **tu trabajo NO se perderá**.
3.  **Drivers de Seguridad:** Instalamos `cryptography` para manejar conexiones seguras con el password `secr3t!`.

## 🔗 Datos de Conexión Satisfactoria
Cuando crees un nuevo dataset, usa siempre estos datos:

*   **Motor:** MySQL
*   **Host:** `192.168.1.180`
*   **Puerto:** `3306`
*   **BD:** `solicitudesservicio`
*   **Usuario:** `microservicio`
*   **Password:** `secr3t!`
*   **URI (SQLAlchemy):** 
    `mysql+mysqlclient://microservicio:secr3t%21@192.168.1.180:3306/solicitudesservicio?charset=utf8mb4`

## 📊 Quick-Start: Crear Big Numbers
Para tus KPIs de hoy (Corte 16:30), usa esta query maestra en el **SQL Lab**:

```sql
SELECT 
    COUNT(*) AS solicitudes_recibidas,
    SUM(CASE WHEN estado = 3 THEN 1 ELSE 0 END) AS citas_programadas,
    SUM(CASE WHEN estado = 5 THEN 1 ELSE 0 END) AS atendidas,
    SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) AS pendientes
FROM tb_solicitud
WHERE tipo_solicitud = 1 
AND (CASE WHEN TIME(fecha) > '16:30:00' THEN DATE_ADD(DATE(fecha), INTERVAL 1 DAY) ELSE DATE(fecha) END) = CURRENT_DATE();
```

## 🚀 Cómo iniciar el proyecto
Simplemente ejecuta el archivo `INICIAR_DASHBOARD.bat` que está en la raíz de la carpeta principal. Él se encargará de abrir Docker y levantar todo por ti.

---
**Nota:** El histórico de desarrollo y manuales antiguos han sido movidos a la carpeta `documentos_desarrollo_no_necesarios` para evitar ruidos visuales durante tu entrega.

**Ing. Sebastian Posada - Desarrollo Senior**
