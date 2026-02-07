
import pymysql
import pandas as pd
import sys

DB_CONFIG = {
    'host': '192.168.1.180',
    'user': 'microservicio',
    'password': 'secr3t!', 
    'database': 'solicitudesservicio',
    'port': 3306
}

try:
    print("Attempting connection...")
    connection = pymysql.connect(**DB_CONFIG)
    print("Connection successful!")
    
    query = """
    SELECT 
        COUNT(*) as received,
        SUM(CASE WHEN estado = 3 OR (cita_id IS NOT NULL AND cita_id != '') THEN 1 ELSE 0 END) as scheduled,
        SUM(CASE WHEN estado = 5 THEN 1 ELSE 0 END) as completed,
        SUM(CASE WHEN estado = 1 THEN 1 ELSE 0 END) as pending,
        SUM(CASE WHEN TIME(fecha) > '16:30:00' THEN 1 ELSE 0 END) as adicionales
    FROM tb_solicitud
    WHERE tipo_solicitud = 1
    """
    
    print("Running query...")
    df = pd.read_sql(query, connection)
    print("Query Result:")
    print(df)
    
    connection.close()
except Exception as e:
    print(f"Failed: {e}")
    sys.exit(1)
