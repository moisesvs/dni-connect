# Skill: qr-verification

Verificar y validar QRs MiDNI (ICAO 9303 Parte 13 - Visible Digital Seal).

## Descripción

Este skill encapsula el proceso completo de verificación de QRs del DNI electrónico español:

1. **Parseo**: Decodificación de bytes VDS
2. **Validación de Header**: Verificación de magia y versión
3. **Extracción de Datos**: Decodificación C40 y TLV
4. **Validación de Firma**: Verificación ECDSA con certificados PKI
5. **Validación Temporal**: Validación de fechas de emisión/expiración
6. **Verificación OCSP**: Estado de revocación del certificado

## Inputs

```json
{
  "qrData": "base64|raw",
  "format": "base64|hex|binary",
  "validateSignature": true,
  "validateTimestamp": true,
  "checkRevocation": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `qrData` | string\|bytes | ✅ | Datos del QR |
| `format` | string | ❌ | Formato: `base64` (default), `hex`, `binary` |
| `validateSignature` | boolean | ❌ | Validar firma ECDSA (default: true) |
| `validateTimestamp` | boolean | ❌ | Validar timestamps (default: true) |
| `checkRevocation` | boolean | ❌ | Verificar revocación OCSP (default: true) |

## Outputs

```json
{
  "success": true,
  "verification": {
    "header": {
      "magic": 220,
      "version": 2,
      "issuingCountry": "ES",
      "certificateReference": "ABC123",
      "documentIssueDate": "2023-01-15",
      "signatureCreationDate": "2024-02-20",
      "documentType": "NATIONAL_ID"
    },
    "data": {
      "documentNumber": "12345678X",
      "fullName": "JUAN GARCÍA PÉREZ",
      "dateOfBirth": "1990-05-10",
      "sex": "M",
      "nationality": "ES",
      "dateOfIssue": "2023-01-15",
      "dateOfExpiry": "2033-01-15",
      "issuingAuthority": "JEFATURA POLICÍA NACIONAL"
    },
    "signature": {
      "valid": true,
      "algorithm": "ECDSA-SHA256",
      "certificateChain": [
        {
          "subject": "CN=MiDNI-CORE",
          "issuer": "CN=AC RAÍZ POLICIA"
        }
      ]
    },
    "timestamp": {
      "valid": true,
      "qrGenerationTime": "2026-02-20T10:30:00Z",
      "expiresAt": "2026-02-20T10:35:00Z",
      "secondsRemaining": 180
    },
    "revocation": {
      "checked": true,
      "status": "GOOD"
    }
  },
  "steps": [
    { "name": "parse", "status": "success", "duration": 45 },
    { "name": "validate_header", "status": "success", "duration": 10 },
    { "name": "decode_data", "status": "success", "duration": 30 },
    { "name": "verify_signature", "status": "success", "duration": 250 },
    { "name": "validate_timestamp", "status": "success", "duration": 15 },
    { "name": "check_revocation", "status": "success", "duration": 180 }
  ],
  "totalDuration": 530,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Verificar QR en base64

```bash
./run-skill.sh qr-verification \
  --qrData "xQICAkVTQkMyMzAx..." \
  --format base64
```

### Verificar sin validar revocación (más rápido)

```bash
./run-skill.sh qr-verification \
  --qrData "xQICAkVTQkMyMzAx..." \
  --checkRevocation false
```

## Implementación

**Ubicación**: `packages/core/src/icao/` + `apps/flutter/lib/core/icao/`

**Módulos involucrados**:

- `VdsParser`: Parsea estructura VDS
- `TlvParser`: Decodifica elementos TLV
- `C40Decoder`: Decodifica caracteres C40
- `IcaoVerifier`: Orquesta los 6 pasos de verificación
- `EcdsaVerifier`: Valida firmas ECDSA
- `PkiClient`: Descarga certificados de PKI
- `OcspClient`: Valida estado del certificado
- `CertificateValidator`: Valida cadenas X.509

## Validaciones

- ✅ Magia VDS correcta (0xDC)
- ✅ Versión soportada (0x02-0x04)
- ✅ Datos TLV bien formados
- ✅ Firma ECDSA válida
- ✅ Timestamp dentro del rango de 5 minutos
- ✅ Certificado no revocado (OCSP)
- ✅ Cadena de certificados válida

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Invalid VDS magic` | Datos no son QR MiDNI | Verificar formato |
| `Signature verification failed` | Firma inválida o datos alterados | Rechazar |
| `Timestamp expired` | QR generado hace > 5 min | Solicitar nuevo QR |
| `Certificate revoked` | Certificado en lista de revocación | Solicitar verificación manual |

## Integración

- **Frontend**: Llamar a `/api/v1/verify/qr` en backend
- **Backend**: Ejecuta `IcaoVerifier.verify()` con callbacks
- **Flutter**: Usa `VdsParser` + `IcaoVerifier` para offline

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
