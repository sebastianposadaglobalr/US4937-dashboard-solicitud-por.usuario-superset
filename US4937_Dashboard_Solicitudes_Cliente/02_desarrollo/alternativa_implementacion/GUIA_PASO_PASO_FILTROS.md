# 🚀 GUÍA RÁPIDA: Agregar Filtros al Dashboard (5 minutos)

## ❓ ¿ELIMINAR O CREAR NUEVO?

**Opción más rápida: CREAR NUEVO** (así no rompes nada existente).

---

## PASO 1: Crear el Nuevo Dataset (2 min)

1. Abre Superset → **SQL Lab** → **SQL Editor**
2. **COPIA Y PEGA** este SQL:

```sql
SELECT
  s.id AS solicitud_id,
  s.fecha AS solicitud_fecha,
  s.cliente AS nombre_cliente,
  s.placa,
  s.localidad,
  s.tipo_servicio AS servicio,
  a.nombre AS asesor_nombre,
  s.estado AS estado_solicitud,
  NULLIF(TRIM(s.cita_id), '') AS cita_id,
  CASE 
    WHEN s.tipo_solicitud = 1 THEN 'BASICO'
    WHEN s.tipo_solicitud = 2 THEN 'VIP'
    ELSE 'OTROS'
  END AS tipo_orden,
  CASE
    WHEN TIME(s.fecha) > '16:30:00'
      THEN DATE_ADD(DATE(s.fecha), INTERVAL 1 DAY)
    ELSE DATE(s.fecha)
  END AS dia_operativo
FROM solicitudesservicio.tb_solicitud s
LEFT JOIN solicitudesservicio.tb_asesor a ON a.id = s.asesor_id
WHERE s.estado <> 7;
```

3. Clic en **RUN** (Play verde)
4. Clic en el botón pequeño **▼ SAVE** → **Save as dataset**
5. Nombre: `ds_filtros_completos` → Clic **SAVE**

---

## PASO 2: Agregar los 4 Filtros (3 min)

1. Ve a tu Dashboard → Clic **EDIT DASHBOARD** (lápiz arriba)
2. En la barra izquierda, clic en **FILTERS** (icono de embudo)
3. Clic **+ Add filter**

### Filtro 1: Tipo Orden
- **Filter name**: `Tipo Orden`
- **Dataset**: Elige `ds_filtros_completos`
- **Column**: Elige `tipo_orden`
- Clic **SAVE**

### Filtro 2: Cliente
- Clic **+ Add filter**
- **Filter name**: `Cliente`
- **Dataset**: `ds_filtros_completos`
- **Column**: `nombre_cliente`
- **SAVE**

### Filtro 3: Asesor
- Clic **+ Add filter**
- **Filter name**: `Asesor`
- **Dataset**: `ds_filtros_completos`
- **Column**: `asesor_nombre`
- **SAVE**

### Filtro 4: Servicio
- Clic **+ Add filter**
- **Filter name**: `Servicio`
- **Dataset**: `ds_filtros_completos`
- **Column**: `servicio`
- **SAVE**

---

## PASO 3: Guardar TODO

1. Cierra el panel de filtros
2. **MUY IMPORTANTE**: Clic en el botón azul **SAVE** del dashboard (arriba derecha)

---

## ✅ ¡LISTO!

Ahora tus filtros aparecerán en la barra lateral izquierda del dashboard.
