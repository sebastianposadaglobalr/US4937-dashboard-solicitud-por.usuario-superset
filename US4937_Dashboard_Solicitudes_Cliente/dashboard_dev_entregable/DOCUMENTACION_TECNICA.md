# 📖 Documentación Técnica de Conexión y Drivers

Este documento detalla la configuración "Nuclear" realizada para garantizar la estabilidad de Superset y su conexión con MySQL.

## 🛠️ Stack Tecnológico Producido
- **Base de Datos:** MySQL 8.0 (Host: 192.168.1.180)
- **Visualizador:** Apache Superset (Build personalizado)
- **Drivers de Conexión:** 
  - `mysqlclient`: Driver nativo de C para máxima velocidad.
  - `pymysql`: Driver de respaldo en Python.
  - `cryptography`: Necesario para el manejo de passwords con caracteres especiales (!).

## 🔗 Configuración de la Conexión
Para reconectar manualmente en el futuro, use estos parámetros:

| Campo | Valor |
| :--- | :--- |
| **Engine** | MySQL |
| **Host** | `192.168.1.180` |
| **Puerto** | `3306` |
| **Database** | `solicitudesservicio` |
| **User** | `microservicio` |
| **Password** | `secr3t!` |

### SQLAlchemy URI (Recomendada)
```text
mysql+mysqlclient://microservicio:secr3t%21@192.168.1.180:3306/solicitudesservicio?charset=utf8mb4
```

## 📁 Persistencia de Datos
La configuración utiliza un volumen local mapeado a la carpeta `superset_home`. 
- **Archivo maestro:** `superset.db` (Contiene todos tus dashboards y charts).
- **Seguridad:** Los datos están blindados contra reinicios de PC o Docker.

---
*Ing. Sebastian Posada - Implementación Senior*
