import socket
import select
import threading
import sys
import yaml
import logging
from datetime import datetime

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - [BRIDGE] - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("bridge_service.log"),
        logging.StreamHandler(sys.stdout)
    ]
)

def load_config(config_path):
    try:
        with open(config_path, 'r') as file:
            return yaml.safe_load(file)
    except Exception as e:
        logging.error(f"Failed to load config: {e}")
        sys.exit(1)

def handle_client(client_socket, target_host, target_port):
    target_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        target_socket.connect((target_host, target_port))
        logging.info(f"Connected to Target Database at {target_host}:{target_port}")
    except Exception as e:
        logging.error(f"Could not connect to target {target_host}:{target_port} - {e}")
        client_socket.close()
        return

    # Data transfer loop
    try:
        while True:
            # Wait for data from either client or target
            readable, _, _ = select.select([client_socket, target_socket], [], [])
            
            if client_socket in readable:
                data = client_socket.recv(4096)
                if len(data) == 0:
                    break
                target_socket.sendall(data)
            
            if target_socket in readable:
                data = target_socket.recv(4096)
                if len(data) == 0:
                    break
                client_socket.sendall(data)
                
    except Exception as e:
        logging.error(f"Connection error: {e}")
    finally:
        client_socket.close()
        target_socket.close()
        logging.info("Connection closed.")

def start_bridge(config):
    bind_host = config['bridge']['bind_host']
    bind_port = config['bridge']['bind_port']
    target_host = config['target']['host']
    target_port = config['target']['port']
    
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    
    try:
        server.bind((bind_host, bind_port))
        server.listen(5)
        logging.info(f"--------------------------------------------------")
        logging.info(f" BRIDGE STARTED ")
        logging.info(f" LISTENING ON: {bind_host}:{bind_port}")
        logging.info(f" FORWARDING TO: {target_host}:{target_port}")
        logging.info(f"--------------------------------------------------")
        
        while True:
            client_sock, addr = server.accept()
            logging.info(f"Accepted connection from {addr[0]}:{addr[1]}")
            
            # Here we could implement the whitelist check from config
            allowed_ips = config['security'].get('allowed_ips', [])
            if allowed_ips and addr[0] not in allowed_ips:
                logging.warning(f"Connection refused from {addr[0]} (Not witelisted)")
                client_sock.close()
                continue

            proxy_thread = threading.Thread(
                target=handle_client,
                args=(client_sock, target_host, target_port)
            )
            proxy_thread.daemon = True
            proxy_thread.start()
            
    except KeyboardInterrupt:
        logging.info("Stopping Bridge...")
    except Exception as e:
        logging.error(f"Bridge Fatal Error: {e}")
    finally:
        server.close()

if __name__ == "__main__":
    import os
    # Assuming config is in ../config relative to script or provided via arg
    config_path = os.path.join(os.path.dirname(__file__), '..', 'config', 'bridge_config.yaml')
    
    # Simple check if file exists
    if not os.path.exists(config_path):
        # Fallback for dev environment or direct execution
        config_path = "bridge_config.yaml"
        if not os.path.exists(config_path):
             logging.error("Config file not found.")
             sys.exit(1)
             
    conf = load_config(config_path)
    start_bridge(conf)
