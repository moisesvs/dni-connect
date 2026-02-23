# Skill: nfc-reading

Leer e interpretar datos del DNIe mediante protocolo PACE (Password Authenticated Connection Establishment).

## Descripción

Este skill implementa la lectura de chips NFC del DNI electrónico español con protocolo PACE:

1. **Detección NFC**: Detectar chip PACE disponible
2. **Inicialización PACE**: Establecer conexión segura con contraseña
3. **Extracción de Datos**: Leer ficheros protegidos (DG1, DG2, DG11, SOD)
4. **Validación de Integridad**: Verificar firmas (SOD)
5. **Decodificación ASN.1**: Parsear estructuras BERTLV
6. **Extracción de Biometría**: Decodificar foto facial (JPEG)

## Inputs

```json
{
  "can": "123456",
  "mrz": "NÚMERO/FECHA/FECHA",
  "readPhotoData": true,
  "validateSod": true,
  "timeout": 30000
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `can` | string | ✅ | Card Access Number (6 dígitos) |
| `mrz` | string | ❌ | Machine Readable Zone (para PACE alternativo) |
| `readPhotoData` | boolean | ❌ | Extraer foto facial (default: true) |
| `validateSod` | boolean | ❌ | Validar Security Object Document (default: true) |
| `timeout` | number | ❌ | Timeout en ms (default: 30000) |

## Outputs

```json
{
  "success": true,
  "nfc": {
    "connected": true,
    "paceVersion": "3",
    "chipSerial": "ABCD1234"
  },
  "data": {
    "documentNumber": "12345678X",
    "fullName": "JUAN GARCÍA PÉREZ",
    "dateOfBirth": "1990-05-10",
    "sex": "M",
    "nationality": "ES",
    "dateOfIssue": "2023-01-15",
    "dateOfExpiry": "2033-01-15",
    "photoBase64": "iVBORw0KGgoAAAANSUhEUgAA..."
  },
  "biometrics": {
    "photoHash": "SHA256-ABC123...",
    "photoValidated": true
  },
  "security": {
    "sodValid": true,
    "certificateChain": [
      { "subject": "CN=Document Signer" }
    ]
  },
  "steps": [
    { "name": "detect_nfc", "status": "success", "duration": 500 },
    { "name": "pace_init", "status": "success", "duration": 1200 },
    { "name": "read_dg1", "status": "success", "duration": 300 },
    { "name": "read_dg2", "status": "success", "duration": 2000 },
    { "name": "read_dg11", "status": "success", "duration": 800 },
    { "name": "read_sod", "status": "success", "duration": 400 },
    { "name": "validate_sod", "status": "success", "duration": 1500 }
  ],
  "totalDuration": 6700,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Leer DNIe con CAN

```bash
./run-skill.sh nfc-reading --can 123456
```

### Leer sin validar SOD (más rápido)

```bash
./run-skill.sh nfc-reading --can 123456 --validateSod false
```

### Leer sin extraer foto

```bash
./run-skill.sh nfc-reading --can 123456 --readPhotoData false
```

## Implementación

**Ubicación**: `apps/flutter/lib/core/services/` + `apps/flutter/lib/core/protocols/`

**Módulos involucrados**:

- `NfcService`: Gestión de comunicación NFC
- `PaceProtocol`: Implementación del protocolo PACE
- `AsniParser`: Decodificación ASN.1/BER-TLV
- `SodValidator`: Validación de Security Object Document
- `PhotoExtractor`: Extracción de foto JPEG

## Campos Extraibles (DataGroup)

| DG | Contenido |
|----|-----------|
| **DG1** | MRZ, Número DNI, Nombres, Fechas |
| **DG2** | Foto facial (JPEG) |
| **DG7** | Imagen de firma (opcional) |
| **DG11** | Dirección completa, lugar de nacimiento |
| **DG12** | Datos del documento (emisor, vigencia) |
| **SOD** | Security Object Document (firmas) |

## Validaciones

- ✅ CAN de 6 dígitos
- ✅ PACE protocol handshake exitoso
- ✅ Lectura de todos los DGs
- ✅ SOD válido (firmas)
- ✅ Cadena de certificados válida
- ✅ Hash de foto coincide (SOD)

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `NFC not enabled` | NFC desactivado en dispositivo | Activar NFC en configuración |
| `Chip not detected` | Chip fuera de rango | Acercar más el DNI |
| `PACE handshake failed` | CAN incorrecto | Verificar 6 dígitos del CAN |
| `Read timeout` | Conexión lenta | Mantener dispositivo más estable |
| `SOD validation failed` | Foto alterada | DNI original verificado externamente |

## Plataformas

- **Android**: Usa `flutter_nfc_kit` + `android.nfc` APIs
- **iOS**: Usa `CoreNFC` framework (sin soporte PACE nativo, simulación en backend)
- **Web**: No soportado (requiere NFC Hardware)

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
