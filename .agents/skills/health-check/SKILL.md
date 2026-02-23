# Skill: health-check

Verificar salud de servicios desplegados (backend, PKI, OCSP).

## Descripción

Monitorea disponibilidad de servicios:

- Health check del backend
- Disponibilidad de PKI (policia.es)
- Estado de OCSP
- Conectividad a Google Cloud
- Reportes de latencia

## Inputs

```json
{
  "service": "backend",
  "timeout": 10,
  "retries": 3
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `service` | string | ❌ | `backend`, `pki`, `ocsp`, `all` (default: all) |
| `timeout` | number | ❌ | Timeout en segundos (default: 10) |
| `retries` | number | ❌ | Reintentos antes de fallar (default: 3) |

## Outputs

```json
{
  "success": true,
  "services": {
    "backend": {
      "status": "healthy",
      "latency": 145,
      "timestamp": "2026-02-20T10:30:00Z"
    },
    "pki": {
      "status": "healthy",
      "latency": 250
    },
    "ocsp": {
      "status": "healthy",
      "latency": 320
    }
  },
  "duration": 8500,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Verificar todos los servicios

```bash
./run-skill.sh health-check --service all
```

### Verificar solo backend

```bash
./run-skill.sh health-check --service backend --retries 5
```

## Implementación

**Endpoints**:
- Backend: `GET /health`
- PKI: `HEAD http://pki.policia.es/`
- OCSP: `POST http://ocsp.policia.es/` (OCSPRequest)

## Errores Comunes

- **Timeout**: Servicio lento o no disponible
- **Conexión rechazada**: Verificar firewall
- **Certificado inválido**: Actualizar certificados raíz

