# Skill: pki-integration

Integración con PKI de la Policía Nacional para descargar y verificar certificados.

## Descripción

Conecta con los servicios de PKI y OCSP:

- Descargar certificados por referencia
- Verificar estado OCSP
- Validar cadena de certificados
- Gestión de errores de PKI
- Cacheo de certificados

## Inputs

```json
{
  "certRef": "abc123xyz",
  "validateOcsp": true,
  "cacheTTL": 3600
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `certRef` | string | ✅ | Referencia de certificado |
| `validateOcsp` | boolean | ❌ | Verificar OCSP (default: true) |
| `cacheTTL` | number | ❌ | TTL de caché en segundos (default: 3600) |

## Outputs

```json
{
  "success": true,
  "certificate": {
    "subject": "...",
    "issuer": "...",
    "validFrom": "2026-01-01T00:00:00Z",
    "validTo": "2027-01-01T00:00:00Z"
  },
  "ocspStatus": "good",
  "cached": false,
  "duration": 2100,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Descargar y verificar certificado

```bash
./run-skill.sh pki-integration --certRef "abc123xyz" --validateOcsp true
```

### Con caché personalizado

```bash
./run-skill.sh pki-integration --certRef "abc123xyz" --cacheTTL 7200
```

## Implementación

**Ubicación**: `packages/core/src/crypto/pki-client.ts`

**Endpoints**:
- PKI: `http://pki.policia.es/cnp/MiDNI/{certRef}`
- OCSP: `http://ocsp.policia.es`

## Errores Comunes

- **Certificado no encontrado**: Verificar referencia
- **OCSP revocado**: Rechazar verificación
- **Timeout**: Aumentar timeout de red

