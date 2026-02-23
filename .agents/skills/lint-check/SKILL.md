# Skill: lint-check

Análisis estático de código y formateo automático con ESLint y Prettier.

## Descripción

Valida la calidad del código en todo el monorepo:

- Análisis con ESLint
- Verificación con TypeScript strict mode
- Formateo con Prettier
- Corrección automática de problemas
- Generación de reportes

## Inputs

```json
{
  "fix": false,
  "format": true,
  "strict": false
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `fix` | boolean | ❌ | Corregir problemas automáticamente |
| `format` | boolean | ❌ | Formatear código con Prettier (default: true) |
| `strict` | boolean | ❌ | Modo estricto (default: false) |

## Outputs

```json
{
  "success": true,
  "errors": 0,
  "warnings": 5,
  "fixed": 8,
  "formatted": 12,
  "duration": 8500,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Verificar código

```bash
./run-skill.sh lint-check --fix false
```

### Corregir problemas automáticamente

```bash
./run-skill.sh lint-check --fix true --format true
```

### Verificación estricta

```bash
./run-skill.sh lint-check --strict true
```

## Implementación

**Ubicación**: Raíz del monorepo

**Comandos base**:
```bash
npm run lint
npm run lint -- --fix
prettier --write .
```

**Configuración**:
- `.eslintrc.json`
- `.prettierrc`
- `tsconfig.json`

## Errores Comunes

- **Conflictos ESLint/Prettier**: Usar plugin eslint-config-prettier
- **Timeout**: Incluir archivos relevantes
- **Permisos denegados**: Verificar permisos de archivo

