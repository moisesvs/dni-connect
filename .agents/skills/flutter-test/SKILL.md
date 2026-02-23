# Skill: flutter-test

Ejecutar tests unitarios y e2e de la aplicación Flutter.

## Descripción

Este skill ejecuta la batería completa de tests de Flutter:

- Tests unitarios (lib/core/)
- Tests de widgets (lib/widgets/)
- Tests de integración (test/integration/)
- Análisis estático (flutter analyze)
- Generación de cobertura

## Inputs

```json
{
  "platform": "web",
  "coverage": true,
  "watch": false
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `platform` | string | ❌ | `web`, `android`, `ios` (default: web) |
| `coverage` | boolean | ❌ | Generar cobertura (default: true) |
| `watch` | boolean | ❌ | Modo watch |

## Outputs

```json
{
  "success": true,
  "testsRun": 28,
  "testsPassed": 28,
  "testsFailed": 0,
  "coverage": {
    "lines": 85.3,
    "branches": 78.9
  },
  "duration": 22000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Ejecutar tests web con cobertura

```bash
./run-skill.sh flutter-test --platform web --coverage true
```

### Ejecutar tests en modo watch

```bash
./run-skill.sh flutter-test --watch true
```

## Implementación

**Ubicación**: `apps/flutter/`

**Comando base**:
```bash
flutter test --coverage
```

**Configuración**: `analysis_options.yaml`

## Errores Comunes

- **Flutter no instalado**: `flutter doctor`
- **Dependencias faltantes**: `flutter pub get`
- **Timeout**: Aumentar `--timeout` en parámetros

