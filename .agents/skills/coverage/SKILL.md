# Skill: coverage

Generar y reportar cobertura de tests en múltiples formatos.

## Descripción

Produce reportes detallados de cobertura de código:

- Cobertura de statements, branches, functions, lines
- Reportes en formato LCOV, JSON, HTML
- Cálculo de umbrales de calidad
- Comparación con umbral mínimo
- Generación de reportes visuales

## Inputs

```json
{
  "format": "lcov",
  "minThreshold": 80,
  "reportPath": "./coverage"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `format` | string | ❌ | `lcov`, `json`, `html` (default: lcov) |
| `minThreshold` | number | ❌ | Umbral mínimo (%) (default: 80) |
| `reportPath` | string | ❌ | Ruta de salida del reporte |

## Outputs

```json
{
  "success": true,
  "coverage": {
    "statements": 89.5,
    "branches": 85.2,
    "functions": 90.1,
    "lines": 89.8
  },
  "meetsThreshold": true,
  "reportPath": "./coverage/index.html",
  "duration": 12000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Generar reporte LCOV

```bash
./run-skill.sh coverage --format lcov --minThreshold 80
```

### Generar reporte HTML

```bash
./run-skill.sh coverage --format html --reportPath ./coverage-report
```

## Implementación

**Herramientas**: nyc, vitest, jest

**Archivos de salida**:
- `./coverage/lcov.info` (LCOV)
- `./coverage/coverage-summary.json` (JSON)
- `./coverage/index.html` (HTML)

## Errores Comunes

- **Umbral no alcanzado**: Mejora cobertura de tests
- **Archivos faltantes**: Verificar configuración de cobertura
- **Permisos**: Permitir escritura en directorio de salida

