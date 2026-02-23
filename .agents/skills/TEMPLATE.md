# Skill: [nombre-skill]

Descripción breve del skill en una o dos líneas.

## Descripción Detallada

Explicación completa de qué hace el skill, incluyendo:
- Pasos principales que realiza
- Validaciones que ejecuta
- Integraciones que utiliza
- Resultados que produce

## Inputs

```json
{
  "param1": "required value",
  "param2": "optional value"
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `param1` | type | ✅ | Descripción del parámetro |
| `param2` | type | ❌ | Descripción del parámetro |

## Outputs

```json
{
  "success": true,
  "data": {
    "result": "value"
  },
  "duration": 1000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Caso 1: Descripción breve

```bash
./run-skill.sh [nombre-skill] --param1 value1 --param2 value2
```

Resultado esperado:
```json
{
  "success": true,
  "data": {}
}
```

### Caso 2: Otro caso de uso

```bash
./run-skill.sh [nombre-skill] --param1 value1
```

## Implementación

**Ubicación**: `path/to/implementation`

**Módulos involucrados**:
- ModuleA
- ModuleB

**Lenguajes soportados**:
- TypeScript
- Dart
- Python

## Validaciones

- ✅ Validación 1
- ✅ Validación 2
- ✅ Validación 3

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `Error A` | Causa A | Solución A |
| `Error B` | Causa B | Solución B |

## Versionado

- **v1.0.0** (2026-02-20): Creación inicial
