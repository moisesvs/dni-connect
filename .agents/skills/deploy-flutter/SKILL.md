# Skill: deploy-flutter

Publicar aplicaciones Flutter en Play Store y App Store.

## Descripción

Automatiza publicación en stores:

- Build de aplicación (APK/AAB para Android, IPA para iOS)
- Firma de aplicaciones
- Carga a App Store Connect / Google Play Console
- Gestión de versiones
- Publicación automática o manual

## Inputs

```json
{
  "platform": "android",
  "track": "internal",
  "version": "1.0.0"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `platform` | string | ✅ | `android` o `ios` |
| `track` | string | ❌ | `internal`, `alpha`, `beta`, `production` |
| `version` | string | ❌ | Versión (del pubspec.yaml) |

## Outputs

```json
{
  "success": true,
  "platform": "android",
  "buildId": "build_123",
  "appBundle": "app-release.aab",
  "size": 35840000,
  "track": "internal",
  "duration": 180000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Publicar en Android (internal)

```bash
./run-skill.sh deploy-flutter \
  --platform android \
  --track internal
```

### Publicar en iOS (beta)

```bash
./run-skill.sh deploy-flutter \
  --platform ios \
  --track beta
```

## Implementación

**Ubicación**: `apps/flutter/`

**Herramientas**:
- flutter build apk/aab (Android)
- flutter build ios (iOS)
- Fastlane para publicación

## Errores Comunes

- **Certificados faltantes**: Configurar en Keychain/Xcode
- **Versión duplicada**: Incrementar número de versión
- **Permisos de acceso**: Verificar credenciales de store

