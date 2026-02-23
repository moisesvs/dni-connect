# Skill: storage-upload

Subir imágenes faciales y datos de verificación a Google Cloud Storage.

## Descripción

Gestiona la carga de archivos en GCS:

- Subida de imágenes faciales (JPEG/PNG)
- Encriptación AES-256-GCM
- Metadatos de usuario
- Generación de URLs firmadas
- Reintentos automáticos

## Inputs

```json
{
  "userId": "user@example.com",
  "photoPath": "./photo.jpg",
  "metadata": {},
  "public": false
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `userId` | string | ✅ | ID del usuario |
| `photoPath` | string | ✅ | Ruta local de la foto |
| `metadata` | object | ❌ | Metadatos adicionales |
| `public` | boolean | ❌ | ¿URL pública? (default: false) |

## Outputs

```json
{
  "success": true,
  "storagePath": "photos/user@example.com/2026-02-20-photo.jpg",
  "publicUrl": "https://storage.googleapis.com/...",
  "signedUrl": "https://storage.googleapis.com/...?X-Goog-Signature=...",
  "size": 245312,
  "duration": 4200,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Subir foto de usuario

```bash
./run-skill.sh storage-upload \
  --userId user@example.com \
  --photoPath "./photo.jpg"
```

### Subir con URL pública

```bash
./run-skill.sh storage-upload \
  --userId user@example.com \
  --photoPath "./photo.jpg" \
  --public true
```

## Implementación

**Bucket**: `dni-connect-images`

**Estructura**: `photos/{userId}/{timestamp}-photo.{ext}`

**Encriptación**: AES-256-GCM (en reposo)

## Errores Comunes

- **Archivo no encontrado**: Verificar ruta
- **Permisos insuficientes**: Configurar IAM en GCS
- **Tamaño excesivo**: Limitar a 10MB

