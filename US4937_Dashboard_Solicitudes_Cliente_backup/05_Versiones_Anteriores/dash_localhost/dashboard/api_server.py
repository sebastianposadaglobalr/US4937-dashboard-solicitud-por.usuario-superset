from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import pymysql
import pandas as pd
import os

app = FastAPI()

# Enable CORS for the frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database Configuration (TO BE SECURED)
DB_CONFIG = {
    'host': '192.168.1.180',
    'user': 'microservicio',
    'password': 'secr3t!', # Updated with user provided password
    'database': 'solicitudesservicio',
    'port': 3306
}

@app.get("/api/kpis")
async def get_kpis(client: str = "all", order_type: str = "all", asesor: str = "all"):
    try:
        connection = pymysql.connect(**DB_CONFIG)
        
        where_clause = "WHERE tipo_solicitud = 1"
        if client != "all":
            where_clause += f" AND cliente = '{client}'"
        if order_type != "all":
            where_clause += f" AND tipo_servicio = '{order_type}'"
        if asesor != "all":
            where_clause += f" AND asesor_id = (SELECT id FROM tb_asesor WHERE nombre = '{asesor}' LIMIT 1)"

        query = f"""
        SELECT 
            COUNT(*) as received,
            SUM(CASE WHEN estado = 3 OR (cita_id IS NOT NULL AND cita_id != '') THEN 1 ELSE 0 END) as scheduled,
            SUM(CASE WHEN estado = 5 THEN 1 ELSE 0 END) as completed,
            SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) as pending,
            SUM(CASE WHEN TIME(fecha) > '16:30:00' THEN 1 ELSE 0 END) as adicionales
        FROM tb_solicitud
        {where_clause}
        """
        
        df = pd.read_sql(query, connection)
        connection.close()
        
        result = {
            'received': int(df['received'].iloc[0]) if not df.empty else 0,
            'scheduled': int(df['scheduled'].iloc[0]) if not df.empty and not pd.isna(df['scheduled'].iloc[0]) else 0,
            'completed': int(df['completed'].iloc[0]) if not df.empty and not pd.isna(df['completed'].iloc[0]) else 0,
            'pending': int(df['pending'].iloc[0]) if not df.empty and not pd.isna(df['pending'].iloc[0]) else 0,
            'adicionales': int(df['adicionales'].iloc[0]) if not df.empty and not pd.isna(df['adicionales'].iloc[0]) else 0
        }
        return result
    except Exception as e:
        print(f"Error in /api/kpis: {e}")
        return {'received': 0, 'scheduled': 0, 'completed': 0, 'pending': 0, 'adicionales': 0}

@app.get("/api/timeline")
async def get_timeline(client: str = "all", asesor: str = "all", service: str = "all"):
    try:
        connection = pymysql.connect(**DB_CONFIG)
        
        where_clause = "WHERE s.tipo_solicitud = 1 AND (s.cita_id IS NOT NULL AND s.cita_id != '') AND s.estado != 7"
        if client != "all":
            where_clause += f" AND s.cliente = '{client}'"
        if asesor != "all":
            where_clause += f" AND a.nombre = '{asesor}'"
        if service != "all":
            where_clause += f" AND (c.tipo_servicio = '{service}' OR s.tipo_servicio = '{service}')"

        query = f"""
        SELECT 
            COALESCE(s.placa, SUBSTRING(s.vehiculo_id, 1, 8), 'Sin ID') as vehicle,
            s.cliente,
            a.nombre as asesor_name,
            COALESCE(c.tipo_servicio, s.tipo_servicio, 'Sin especificar') as service_type,
            CASE 
                WHEN s.estado = 1 THEN 'Pendiente'
                WHEN s.estado = 2 THEN 'Con Orden'
                WHEN s.estado = 3 THEN 'Programada'
                WHEN s.estado = 5 THEN 'Atendida'
                ELSE 'Otro'
            END as event,
            COALESCE(c.inicio, s.fecha) as start,
            COALESCE(c.fin, DATE_ADD(COALESCE(c.inicio, s.fecha), INTERVAL 2 HOUR)) as end
        FROM tb_solicitud s
        LEFT JOIN tb_asesor a ON s.asesor_id = a.id
        LEFT JOIN citas.tb_cita c ON CAST(s.cita_id AS CHAR) = CAST(c.id AS CHAR)
        {where_clause}
        ORDER BY COALESCE(c.inicio, s.fecha) DESC LIMIT 50
        """
        
        df = pd.read_sql(query, connection)
        
        if df.empty:
            return []
        
        df['start'] = pd.to_datetime(df['start']).dt.strftime('%Y-%m-%dT%H:%M:%S')
        df['end'] = pd.to_datetime(df['end']).dt.strftime('%Y-%m-%dT%H:%M:%S')
        
        connection.close()
        return df.to_dict(orient='records')
    except Exception as e:
        print(f"Error in /api/timeline: {e}")
        return []

@app.get("/api/clients")
async def get_clients():
    try:
        connection = pymysql.connect(**DB_CONFIG)
        # Limpieza profunda: TRIM y eliminación de saltos de línea/tabulaciones
        query = """
        SELECT DISTINCT REPLACE(REPLACE(TRIM(cliente), '\r', ''), '\n', '') as cliente 
        FROM tb_solicitud 
        WHERE cliente IS NOT NULL AND TRIM(cliente) != ''
        """
        df = pd.read_sql(query, connection)
        connection.close()
        
        # Filtrar duplicados que puedan haber quedado después de la limpieza
        clients = sorted(list(set([c.strip() for c in df['cliente'].dropna().tolist() if c.strip()])))
        print(f"DEBUG: Found {len(clients)} unique cleaned clients")
        return clients
    except Exception as e:
        print(f"ERROR in /api/clients: {e}")
        return []

@app.get("/api/asesores")
async def get_asesores():
    try:
        connection = pymysql.connect(**DB_CONFIG)
        df = pd.read_sql("SELECT DISTINCT nombre FROM tb_asesor WHERE nombre IS NOT NULL ORDER BY nombre", connection)
        connection.close()
        asesores = df['nombre'].tolist()
        print(f"DEBUG: Found {len(asesores)} asesores")
        return asesores
    except Exception as e:
        print(f"ERROR in /api/asesores: {e}")
        return []

@app.get("/api/services")
async def get_services():
    try:
        # User requested specific filter for: INSTALACION, MANTENIMIENTO, RETIRO
        services = [
            "TIPO_SERVICIO_INSTALACION",
            "TIPO_SERVICIO_MANTENIMIENTO",
            "TIPO_SERVICIO_RETIRO"
        ]
        return services
    except: return []

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
