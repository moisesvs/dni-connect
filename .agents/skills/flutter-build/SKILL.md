# Skill: flutter-build

Compilar y validar la aplicación Flutter para Web, Android e iOS.

## Descripción

Este skill encapsula todo el proceso de compilación de la app Flutter, incluyendo:
- Validación de dependencias
- Análisis estático (lint)
- Compilación para la plataforma especificada
- Generación de artefactos

## Inputs

```json
{
  "platform": "web|android|ios|all",
  "mode": "debug|release",
  "clean": "boolean (default: false)"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `platform` | string | ✅ | Plataforma objetivo: `web`, `android`, `ios`, o `all` |
| `mode` | string | ❌ | Modo de compilación: `debug` (default) o `release` |
| `clean` | boolean | ❌ | Ejecutar `flutter clean` antes de compilar |

## Outputs

```json
{
  "success": true,
  "platform": "web",
  "mode": "debug",
  "outputPath": "build/web",
  "duration": 45000,
  "errors": [],
  "warnings": [],
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Compilar para Web (debug)

```bash
./run-skill.sh flutter-build --platform web --mode debug
```

### Compilar para Android (release)

```bash
./run-skill.sh flutter-build --platform android --mode release
```

### Compilar para todas las plataformas

```bash
./run-skill.sh flutter-build --platform all --mode release
```

## Implementación

**Ubicación**: `apps/flutter/`

**Comandos ejecutados**:

```bash
# Instalar dependencias
flutter pub get

# Análisis estático
flutter analyze

# Compilación
flutter build web
flutter build apk
flutter build ios
```

## Requerimientos

- Flutter SDK ≥ 3.24
- Dart SDK ≥ 3.5
- Android SDK (para Android)
- Xcode (para iOS)
- Node.js ≥ 18 (para Web)

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `No Android SDK found` | SDK no instalado | Ejecutar `flutter doctor` |
| `CocoaPods not found` | Dependencias macOS | Ejecutar `sudo gem install cocoapods` |
| `Build failed` | Lint errors | Revisar análisis con `flutter analyze` |

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
