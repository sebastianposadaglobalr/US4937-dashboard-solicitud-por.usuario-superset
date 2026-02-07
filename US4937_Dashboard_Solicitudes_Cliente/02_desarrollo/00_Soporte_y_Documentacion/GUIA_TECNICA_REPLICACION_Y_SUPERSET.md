# 🛠️ Guía Técnica de Replicación: Stack Superset + Cube

**Autor:** Sebastian Posada  
**Proyecto:** US4937 - Dashboard Solicitudes por Cliente (Alternativa Dockerizada)

---

## 1. Resumen de la Arquitectura
Esta implementación utiliza un stack moderno de contenedores para garantizar portabilidad y facilidad de despliegue. A diferencia de la versión "Custom" (FastAPI), esta versión utiliza herramientas estándar de BI.

### Componentes:

* **Base de Datos Origen:** MySQL (MariaDB) de Comsatel (`192.168.1.180`).
* **Capa Semántica:** Cube.js (Puerto 4000). Abstrae la lógica de negocio y problemas de drivers.
* **Visualización:** Apache Superset (Puerto 8088).
* **Orquestación:** Docker Compose.

---

## 2. Despliegue Automatizado
Para facilitar la replicación en cualquier máquina nueva (Laptop de desarrollo o Servidor), se ha creado un script de "Un solo click".

### Pasos para replicar:
1.  Instalar **Docker Desktop**.
2.  Conectarse a la VPN de Comsatel.
3.  Ejecutar el script:
    
    ```powershell
    start DESPLEGAR_STACK.bat
    ```

Este script se encarga de:

* Limpiar contenedores viejos.
* Levantar la red de Docker.
* Iniciar Superset y Cube.js con la configuración correcta.

---

## 3. Lógica de Negocio (Queries)
La inteligencia del negocio (reglas de "Día Operativo" y cortes de hora) está definida directamente en las consultas SQL maestras.

*   > **Ver archivo fuente:** [`QUERIES_PARA_DBEAVER.sql`](QUERIES_PARA_DBEAVER.sql)

Estas queries manejan automáticamente:

* Corte diario a las 16:30.
* Clasificación de estados.
* Asignación de "Día Operativo" vs "Día Calendario".

---

## 4. Manual de Configuración Paso a Paso
Una vez desplegado el stack, la configuración dentro de Superset (Creación de gráficos y datasets) se detalla en el siguiente documento operativo:

*   > **Ver guía paso a paso:** [`GUIA_PASO_A_PASO_SUPERSET.md`](GUIA_PASO_A_PASO_SUPERSET.md)

---

**Nota Técnica:**
Este stack soluciona el problema conocido de autenticación `caching_sha2_password` de MySQL 8 mediante el uso de drivers inyectados (`pymysql`) y la orquestación vía Docker, eliminando la necesidad de instalaciones locales de Python o drivers de sistema en la máquina del usuario final.
