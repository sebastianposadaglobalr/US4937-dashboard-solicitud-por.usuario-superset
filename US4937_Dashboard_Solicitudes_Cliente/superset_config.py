# =========================================================
# CONFIGURACIÓN ARQUITECTO BI-OPS SENIOR - COMSATEL 2026
# =========================================================
# Este archivo fuerza la permisividad total para Kiosk Mode

# 1. Habilitar CORS Global
ENABLE_CORS = True
CORS_OPTIONS = {
    'supports_credentials': True,
    'allow_headers': ['*'],
    'resources': ['*'],
    'origins': ['*'],
}

# 2. Forzar Cabeceras de Iframe
# En Superset 6.0, HTTP_HEADERS es procesado por Talisman. 
# Vaciamos esto para evitar conflictos y configuramos Talisman abajo.
HTTP_HEADERS = {}

# 3. Configuración Talisman (Seguridad de Cabeceras)
# Aquí es donde ocurre la magia para el TV Wall.
TALISMAN_CONFIG = {
    "content_security_policy": {
        "frame-ancestors": ["*"],
        "frame-src": ["*"],
        "default-src": ["*", "'unsafe-inline'", "'unsafe-eval'"],
        "img-src": ["*", "data:"],
        "script-src": ["*", "'unsafe-inline'", "'unsafe-eval'"],
        "style-src": ["*", "'unsafe-inline'"],
    },
    "force_https": False,
    "session_cookie_secure": False,
    "session_cookie_samesite": "None",
    "frame_options": None, # Desactivamos X-Frame-Options nativo para permitir embedding
}

# 4. Sesiones y Cookies
# Vital para que el login persista dentro del iframe si es necesario
SESSION_COOKIE_SAMESITE = "None"
SESSION_COOKIE_SECURE = False
SECRET_KEY = "comsatel_vip_2026"

# 5. Acceso Público (Opcional pero recomendado para Kiosk)
PUBLIC_ROLE_LIKE_GAMMA = True
AUTH_ROLE_PUBLIC = 'Public'

# 6. Feature Flags
FEATURE_FLAGS = {
    "EMBEDDED_DASHBOARD": True,
    "DASHBOARD_NATIVE_FILTERS": True
}
