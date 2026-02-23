# Skill: database-sync

Sincronizar datos verificados de DNI con Google Cloud Firestore y Google Cloud Storage.

## Descripción

Este skill gestiona la persistencia y sincronización de datos verificados:

1. **Autenticación**: Verificar JWT y permisos
2. **Almacenamiento de Datos**: Guardar datos verificados en Firestore
3. **Almacenamiento de Biometría**: Subir foto facial a GCS
4. **Historial**: Mantener registro de verificaciones
5. **Sincronización**: Mantener datos en caché local
6. **Limpieza**: Eliminar datos expirados

## Inputs

```json
{
  "userId": "user@example.com",
  "dniData": { },
  "photoBase64": "iVBORw0KGgo...",
  "verificationResult": { },
  "method": "qr|nfc",
  "retryOnFailure": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `userId` | string | ✅ | Email o UUID del usuario |
| `dniData` | object | ✅ | Datos del DNI extraídos |
| `photoBase64` | string | ❌ | Foto en base64 |
| `verificationResult` | object | ✅ | Resultado de verificación |
| `method` | string | ✅ | `qr` o `nfc` |
| `retryOnFailure` | boolean | ❌ | Reintentar en caso de fallo (default: true) |

## Outputs

```json
{
  "success": true,
  "stored": {
    "firestore": {
      "collection": "verifications",
      "document": "verif_abc123xyz789",
      "timestamp": "2026-02-20T10:30:00Z"
    },
    "storage": {
      "bucket": "dni-connect-images",
      "path": "photos/user@example.com/2026-02-20-photo.jpg",
      "url": "https://storage.googleapis.com/..."
    }
  },
  "history": {
    "totalVerifications": 5,
    "lastVerification": "2026-02-20T10:30:00Z",
    "allVerifications": [
      {
        "id": "verif_001",
        "method": "qr",
        "timestamp": "2026-02-20T10:30:00Z",
        "status": "verified"
      }
    ]
  },
  "duration": 2500,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Sincronizar datos de QR verificado

```bash
./run-skill.sh database-sync \
  --userId user@example.com \
  --method qr \
  --dniData '{...}' \
  --verificationResult '{...}'
```

### Sincronizar datos con foto

```bash
./run-skill.sh database-sync \
  --userId user@example.com \
  --method nfc \
  --dniData '{...}' \
  --photoBase64 "iVBORw0KGgo..." \
  --verificationResult '{...}'
```

## Implementación

**Ubicación**: `apps/web/backend/src/routes/` + `apps/flutter/lib/core/services/`

**Módulos involucrados**:

- `FirestoreService`: Gestión de Firestore
- `StorageService`: Gestión de GCS
- `VerificationStore`: Modelo de datos
- `SyncService`: Sincronización (Flutter)

## Estructura Firestore

```
firestore/
├── users/
│   └── {userId}/
│       ├── profile (name, email, phone)
│       ├── verifications (subcollection)
│       │   └── {verificationId}
│       │       ├── method: "qr" | "nfc"
│       │       ├── timestamp
│       │       ├── data: { documentNumber, fullName, ... }
│       │       ├── status: "pending" | "verified" | "failed"
│       │       └── certificateChain
│       └── history (subcollection)
└── verifications/ (índice global)
    └── {verificationId} (replica de user.verifications)
```

## Estructura GCS

```
gs://dni-connect-images/
├── photos/
│   └── {userId}/
│       ├── 2026-02-20-photo.jpg
│       ├── 2026-02-19-photo.jpg
│       └── ...
└── signatures/
    └── {userId}/
        └── 2026-02-20-signature.jpg
```

## Validaciones

- ✅ JWT válido
- ✅ Usuario existe en base de datos
- ✅ Datos verificados correctamente
- ✅ Foto válida (JPEG/PNG)
- ✅ Sin duplicados en últimas 24h
- ✅ Almacenamiento disponible

## Políticas de Retención

| Datos | Retención |
|-------|-----------|
| Verificaciones exitosas | 7 años (RGPD) |
| Foto facial | 6 meses (actualizable) |
| Firmas digitales | 10 años (legal) |
| Logs de acceso | 1 año |

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Permission denied` | JWT inválido o expirado | Renovar token |
| `Storage quota exceeded` | GCS lleno | Limpiar datos antiguos |
| `Network timeout` | Sin conexión a internet | Reintentar |
| `Document already exists` | Duplicado en 24h | Verificar historial |

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
