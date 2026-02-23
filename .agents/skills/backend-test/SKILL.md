# Skill: backend-test

Ejecutar tests unitarios e integración del backend Node.js con cobertura opcional.

## Descripción

Este skill encapsula la ejecución de pruebas del servidor backend:

- Validación de sintaxis y tipos con TypeScript
- Tests unitarios con Vitest
- Tests de integración con Google Cloud
- Generación de reportes de cobertura
- Salida de resultados en múltiples formatos

## Inputs

```json
{
  "watch": false,
  "coverage": true,
  "verbose": false,
  "env": "development"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `watch` | boolean | ❌ | Modo watch (ejecutar en tiempo real) |
| `coverage` | boolean | ❌ | Generar reporte de cobertura (default: true) |
| `verbose` | boolean | ❌ | Salida detallada (default: false) |
| `env` | string | ❌ | Entorno: `development`, `testing`, `production` |

## Outputs

```json
{
  "success": true,
  "testsRun": 42,
  "testsPassed": 42,
  "testsFailed": 0,
  "coverage": {
    "statements": 89.5,
    "branches": 85.2,
    "functions": 90.1,
    "lines": 89.8
  },
  "duration": 15500,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Ejecutar tests con cobertura

```bash
./run-skill.sh backend-test --coverage true
```

### Ejecutar tests en modo watch

```bash
./run-skill.sh backend-test --watch true --verbose true
```

### Ejecutar con entorno específico

```bash
./run-skill.sh backend-test --env testing --coverage true
```

## Implementación

**Ubicación**: `apps/web/backend/src/`

**Comando base**:
```bash
npm run test --workspace=apps/web/backend
```

**Configuración**: `vitest.config.ts` en backend

## Errores Comunes

- **Timeout**: Aumentar en vitest.config.ts
- **Port en uso**: Limpiar procesos previos
- **Credenciales faltantes**: Configurar GOOGLE_APPLICATION_CREDENTIALS

