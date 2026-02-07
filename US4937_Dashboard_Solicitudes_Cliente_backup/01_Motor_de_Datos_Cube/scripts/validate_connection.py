import socket
import time
import sys

def check_port(host, port, timeout=5):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        if result == 0:
            print(f"[OK] Connection to {host}:{port} successful.")
            return True
        else:
            print(f"[FAIL] Port {port} on {host} is not reachable (Code: {result}).")
            return False
    except Exception as e:
        print(f"[ERROR] {e}")
        return False
    finally:
        sock.close()

def main():
    print("--- Connectivity Validator ---")
    
    # 1. Check Local MySQL
    print("\n1. Checking Internal MySQL (192.168.1.180:3306)...")
    mysql_ok = check_port("192.168.1.180", 3306)
    
    if not mysql_ok:
        print("CRITICAL: Cannot reach internal MySQL. Bridge will fail.")
        sys.exit(1)

    # 2. Check Bridge Listening
    print("\n2. Checking Bridge (Localhost:3307)...")
    bridge_ok = check_port("127.0.0.1", 3307)
    
    if not bridge_ok:
        print("WARNING: Bridge script (db_bridge.py) does not seem to be running on localhost.")
    else:
        print("SUCCESS: Bridge is active and listening.")

    print("\n--- Summary ---")
    if mysql_ok and bridge_ok:
        print("READY: Infrastructure is set locally. Proceed to configure Cube Cloud.")
    else:
        print("NOT READY: Fix connectivity issues.")

if __name__ == "__main__":
    main()
