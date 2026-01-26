import pandas as pd
import duckdb
from datetime import datetime, timedelta
import random

def generate_mock_data():
    clients = ['ACEROS UNIVERSAL', 'MINERA LAS BAMBAS', 'TRANS-SAB']
    asesores = ['ANGELES CORDOVA', 'JUAN PEREZ', 'MARIA LOPEZ']
    services = ['INSTALACION', 'MANTENIMIENTO', 'RETIRO']
    
    data = []
    for i in range(100):
        create_time = datetime.now() - timedelta(days=random.randint(0, 7), hours=random.randint(0, 23))
        data.append({
            'id_solicitud': f'SOL-{1000+i}',
            'cliente_nombre': random.choice(clients),
            'tipo_cliente': 'BÁSICO',
            'asesor_responsable': random.choice(asesores),
            'servicio_tipo': random.choice(services),
            'fecha_creacion': create_time,
            'fecha_programacion': create_time + timedelta(days=1),
            'estado_solicitud': random.choice(['PENDIENTE', 'PROGRAMADA', 'ATENDIDA']),
            'vehiculo_id': f'V-{random.randint(1, 20)}'
        })
    return pd.DataFrame(data)

if __name__ == "__main__":
    df = generate_mock_data()
    con = duckdb.connect('sigo_local.db')
    con.execute("CREATE TABLE IF NOT EXISTS raw_solicitudes AS SELECT * FROM df")
    print("Datos simulados cargados en sigo_local.db")
