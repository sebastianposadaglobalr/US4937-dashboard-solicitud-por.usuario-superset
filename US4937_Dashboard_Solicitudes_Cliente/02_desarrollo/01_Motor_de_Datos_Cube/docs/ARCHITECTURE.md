# Connectivity Diagnosis & Architecture

## 1. Diagnostics: Why connection fails?
The direct connection between **Superset 6.0** (likely Cloud or Containerized) and **On-Premise MySQL** (`192.168.1.180`) fails inevitably due to **Network Reachability**.
- `192.168.x.x` is a private RFC1918 address.
- Cube Cloud (External) cannot route packets to this private IP.
- Superset (if containerized) might run on a different bridge network, but the main blocker is the **Cloud <-> Premise gap**.

## 2. Solution: "The Bridge" Architecture
We implement a **Python-based TCP Intermediate Layer (Bridge)**.

### **Architecture Diagram**
```mermaid
graph LR
    subgraph OnPrem_Network [On-Premise Network]
        MySQL[(MySQL DB\n192.168.1.180)]
        Bridge[("Python Bridge\n(db_bridge.py)")]
    end
    
    subgraph Cloud_Services [Cloud / External]
        Cube[Cube Cloud\n(Semantic Layer)]
        Superset[Superset 6.0\n(BI Tool)]
    end

    MySQL <-->|Local TCP:3306| Bridge
    Bridge <-->|Exposed Public IP:3307| Cube
    Cube <-->|SQL API| Superset
```

### **Component Roles:**
1.  **MySQL (`192.168.1.180`)**: Source of truth.
2.  **Bridge (`db_bridge.py`)**: 
    - Runs on a machine that has *both* access to MySQL AND is reachable from the internet (via Port Forwarding or DMZ).
    - Listens on Port `3307`.
    - Forwards traffic transparently to MySQL `3306`.
    - Adds logging and stability monitoring.
3.  **Cube Cloud**:
    - Connects to the **Bridge Public IP** on port `3307`.
    - Models the data safely.
4.  **Superset**:
    - Connects effectively to **Cube Cloud** using the `elasticsearch+http` or standard SQL API driver provided by Cube.
    - DOES NOT connect to MySQL directly.

## 3. Implementation Steps

1.  **Deploy Bridge**: Run `db_bridge.py` on the network edge or a jump host.
2.  **Configure Network**: Forward public port `3307` -> Machine running Bridge.
3.  **Connect Cube**: Point Cube Cloud connection to `Public_IP:3307`.
4.  **Connect Superset**: Add Database -> `Cube Cloud`.

## 4. Why this is Robust?
- **Decoupling**: Superset doesn't need drivers for legacy MySQL or VPNs. It talks to Cube (modern API).
- **Security**: The Bridge can implement IP Whitelisting (only allow Cube IPs).
- **Control**: You can stop the bridge instantly to cut access.
