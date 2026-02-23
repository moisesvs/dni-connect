# Skill: backend-start

Iniciar el servidor Node.js backend de DNI-Connect.

## Descripción

Este skill inicia y valida el servidor Express backend, incluyendo:
- Instalación de dependencias
- Configuración de variables de entorno
- Conexión a Firebase
- Validación de puertos
- Health check

## Inputs

```json
{
  "port": 3001,
  "environment": "development|production",
  "withHealthCheck": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `port` | number | ❌ | Puerto (default: 3001) |
| `environment` | string | ❌ | Entorno: `development` o `production` |
| `withHealthCheck` | boolean | ❌ | Ejecutar health check al iniciar (default: true) |

## Outputs

```json
{
  "success": true,
  "port": 3001,
  "baseUrl": "http://localhost:3001",
  "uptime": 2500,
  "timestamp": "2026-02-20T10:30:00Z",
  "endpoints": {
    "health": "GET /api/v1/health",
    "verifyQr": "POST /api/v1/verify/qr",
    "sync": "POST /api/v1/sync"
  }
}
```

## Ejemplos

### Iniciar en desarrollo

```bash
./run-skill.sh backend-start --environment development
```

### Iniciar en producción

```bash
./run-skill.sh backend-start --environment production --port 3001
```

## Implementación

**Ubicación**: `apps/web/backend/`

**Comandos ejecutados**:

```bash
# Instalar dependencias
npm install

# Ejecutar server
npm run dev        # desarrollo
npm run start      # producción
```

## Requerimientos

- Node.js ≥ 18
- npm o yarn
- Variables de entorno configuradas (`.env`)
- Google Cloud SDK configurado

## Variables de Entorno Requeridas

```env
PORT=3001
NODE_ENV=development
FIREBASE_PROJECT_ID=dni-connect-prod
FIREBASE_PRIVATE_KEY=...
FIREBASE_CLIENT_EMAIL=...
GOOGLE_CLOUD_STORAGE_BUCKET=dni-connect-images
JWT_SECRET=...
JWT_EXPIRY=3600
PKI_BASE_URL=http://pki.policia.es
```

## Validaciones

- ✅ Puerto disponible
- ✅ Firebase conexión activa
- ✅ Firestore accesible
- ✅ Cloud Storage accesible
- ✅ Health check: `GET /api/v1/health`

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `EADDRINUSE` | Puerto ocupado | Cambiar `port` o liberar el puerto |
| `Firebase auth failed` | Credenciales inválidas | Verificar `.env` |
| `ECONNREFUSED` | Firestore no accesible | Verificar conexión a internet |

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
