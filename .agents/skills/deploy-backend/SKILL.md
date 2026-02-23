# Skill: deploy-backend

Desplegar backend en Google Cloud Run.

## Descripción

Automatiza despliegue del backend en producción:

- Build de la aplicación
- Creación de imagen Docker
- Push a Artifact Registry
- Despliegue en Cloud Run
- Verificación de salud

## Inputs

```json
{
  "environment": "production",
  "version": "1.0.0",
  "region": "europe-west1"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `environment` | string | ❌ | `development`, `staging`, `production` |
| `version` | string | ❌ | Versión a desplegar (default: desde package.json) |
| `region` | string | ❌ | Región GCP (default: europe-west1) |

## Outputs

```json
{
  "success": true,
  "serviceUrl": "https://backend-abc123-ew.a.run.app",
  "version": "1.0.0",
  "imageDigest": "sha256:...",
  "deploymentTime": "2026-02-20T10:30:00Z",
  "duration": 120000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Desplegar en producción

```bash
./run-skill.sh deploy-backend \
  --environment production \
  --version 1.0.0
```

### Desplegar en staging

```bash
./run-skill.sh deploy-backend \
  --environment staging \
  --region europe-west1
```

## Implementación

**Ubicación**: `apps/web/backend/`

**Dockerfile**: Buildable
**Registro**: Artifact Registry (Europa)

## Errores Comunes

- **Credenciales GCP**: Verificar autenticación
- **Cuota excedida**: Verificar límites en GCP
- **Build fallido**: Revisar logs de compilación

