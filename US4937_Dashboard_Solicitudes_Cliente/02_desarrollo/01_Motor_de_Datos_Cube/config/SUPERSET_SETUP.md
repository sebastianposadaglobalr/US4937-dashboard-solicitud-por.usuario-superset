# Superset 6.0 Connectivity Guide

## 1. Connection Strategy
Superset connects to **Cube Cloud** using the SQL API. Cube Cloud emulates a **PostgreSQL** database interface, which is natively supported and highly stable in Superset.

## 2. Driver Requirements
Ensure your Superset instance has the PostgreSQL driver installed (standard in most images).
- Driver: `psycopg2` or `postgresql-client`

## 3. Database Connection Parameters
In Superset (Settings -> Database Connections -> + Database):

- **Database Type**: PostgreSQL
- **Display Name**: `Comsatel_Cube_Semantic`
- **SQLAlchemy URI**:
  ```
  postgresql+psycopg2://<CUBE_USER>:<CUBE_PASS>@<CUBE_HOST>:5432/model
  ```
  *Replace `<CUBE_USER>`, `<CUBE_PASS>`, and `<CUBE_HOST>` with your credentials from the Cube Cloud "Connect to SQL API" section.*

## 4. Why this works?
- **No MySQL Driver Issues**: Superset talks to Cube via Postgres protocol.
- **No Timezone/Charset Issues**: Cube handles the normalization.
- **Performance**: Cube handles caching and pre-aggregation.

## 5. Troubleshooting
If connection fails:
1.  **Check Bridge**: Ensure your `db_bridge.py` is running and the Public IP used in Cube Cloud is correct.
2.  **Cube Logs**: Check Cube Cloud logs to see if it can reach your Bridge.
3.  **Superset Network**: Ensure Superset can resolve the Cube Cloud DNS.
