
import pymysql
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
    connection.close()
except Exception as e:
    print(f"Connection failed: {e}")
    sys.exit(1)
