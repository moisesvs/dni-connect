# Skill: crypto-validation

Validar certificados X.509, verificar firmas ECDSA y gestionar la cadena de confianza PKI.

## Descripción

Este skill encapsula todas las operaciones criptográficas para asegurar la integridad de datos:

1. **Validación de Certificados**: Verificar fecha, signer, extensiones
2. **Verificación de Firmas**: ECDSA con SHA-256
3. **Cadena de Confianza**: Validar ruta desde certificado raíz
4. **Revocación**: Consultar estado OCSP
5. **DER Parsing**: Decodificar estructuras X.509
6. **Algoritmos**: Soportar múltiples curvas (P-256, P-384, P-521)

## Inputs

```json
{
  "certificate": "base64|pem|der",
  "signature": "hex|base64",
  "signedData": "hex|base64",
  "certificateChain": [],
  "checkRevocation": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `certificate` | string\|bytes | ✅ | Certificado X.509 |
| `signature` | string\|bytes | ✅ | Firma ECDSA |
| `signedData` | string\|bytes | ✅ | Datos originales |
| `certificateChain` | array | ❌ | Cadena completa (hasta raíz) |
| `checkRevocation` | boolean | ❌ | Verificar OCSP (default: true) |

## Outputs

```json
{
  "success": true,
  "certificate": {
    "subject": "CN=MiDNI-CORE, O=Policia Nacional",
    "issuer": "CN=AC RAÍZ POLICIA, O=Policia Nacional",
    "serialNumber": "123456789ABCDEF0",
    "notBefore": "2023-01-01T00:00:00Z",
    "notAfter": "2033-01-01T00:00:00Z",
    "publicKey": {
      "algorithm": "EC",
      "curve": "P-256",
      "size": 256
    },
    "extensions": {
      "keyUsage": ["digitalSignature"],
      "extendedKeyUsage": ["id-kp-serverAuth"],
      "basicConstraints": {
        "critical": true,
        "ca": true,
        "pathLenConstraint": 0
      }
    },
    "valid": true
  },
  "signature": {
    "algorithm": "ECDSA",
    "hash": "SHA-256",
    "r": "ABC123...",
    "s": "DEF456...",
    "valid": true
  },
  "chain": {
    "depth": 3,
    "valid": true,
    "certificates": [
      {
        "subject": "CN=MiDNI-CORE",
        "issuer": "CN=AC RAÍZ POLICIA",
        "valid": true
      },
      {
        "subject": "CN=AC RAÍZ POLICIA",
        "issuer": "CN=AC RAÍZ TSA",
        "valid": true
      },
      {
        "subject": "CN=AC RAÍZ TSA",
        "issuer": "CN=AC RAÍZ TSA",
        "valid": true,
        "selfSigned": true
      }
    ]
  },
  "revocation": {
    "checked": true,
    "method": "OCSP",
    "status": "good",
    "thisUpdate": "2026-02-15T10:30:00Z",
    "nextUpdate": "2026-03-15T10:30:00Z"
  },
  "duration": 1200,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Validar certificado simple

```bash
./run-skill.sh crypto-validation \
  --certificate "MIIBkjCCAQMCAQA..." \
  --signature "ABC123..." \
  --signedData "DEF456..."
```

### Validar con cadena completa

```bash
./run-skill.sh crypto-validation \
  --certificate "..." \
  --signature "..." \
  --signedData "..." \
  --certificateChain "[cert1, cert2, cert3]"
```

### Validar sin OCSP (más rápido)

```bash
./run-skill.sh crypto-validation \
  --certificate "..." \
  --checkRevocation false
```

## Implementación

**Ubicación**: `packages/core/src/crypto/` + `apps/flutter/lib/core/crypto/`

**Módulos involucrados**:

- `EcdsaVerifier`: Verificación de firmas ECDSA
- `CertificateValidator`: Validación de cadenas X.509
- `DerParser`: Decodificación DER
- `OcspClient`: Verificación de revocación
- `AlgorithmMapper`: Mapeo de OIDs a algoritmos

## Algoritmos Soportados

| Algoritmo | OID | Curva | Hash |
|-----------|-----|-------|------|
| **ECDSA-SHA256** | `1.2.840.10045.4.3.2` | P-256 | SHA-256 |
| **ECDSA-SHA384** | `1.2.840.10045.4.3.3` | P-384 | SHA-384 |
| **ECDSA-SHA512** | `1.2.840.10045.4.3.4` | P-521 | SHA-512 |

## Validaciones

- ✅ Certificado dentro de rango temporal válido
- ✅ Firma ECDSA correcta matemáticamente
- ✅ Cadena de issuers válida
- ✅ Extensiones críticas soportadas
- ✅ Certificado no revocado (OCSP)
- ✅ Permisos (Key Usage, Extended Key Usage)

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Certificate expired` | Cert vencido | Actualizar certificado |
| `Invalid signature` | Datos o firma alterados | Rechazar |
| `Certificate not trusted` | Issuer no en cadena | Proporcionar cadena completa |
| `OCSP request failed` | Servidor OCSP no disponible | Reintentar o usar CRL |

## URLs PKI Policia Nacional

| Componente | URL |
|-----------|-----|
| **PKI Base** | `http://pki.policia.es/cnp/MiDNI` |
| **OCSP** | `http://ocsp.policia.es` |
| **CRL** | `http://crl.policia.es/cnp` |

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
