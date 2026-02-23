# Skill: monorepo-setup

Configurar e instalar todas las dependencias del monorepo.

## Descripción

Inicializa el entorno de desarrollo:

- Instalar dependencias con npm/yarn
- Configurar workspaces
- Verificar versión de Node.js
- Copiar archivos de configuración
- Validar setup

## Inputs

```json
{
  "installAll": true,
  "ci": false,
  "clean": false
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `installAll` | boolean | ❌ | Instalar todas las dependencias (default: true) |
| `ci` | boolean | ❌ | Modo CI (sin package-lock) |
| `clean` | boolean | ❌ | Limpiar node_modules previos |

## Outputs

```json
{
  "success": true,
  "nodeVersion": "20.11.0",
  "packagesInstalled": 1245,
  "workspacesConfigured": 3,
  "duration": 45000,
  "timestamp": "2026-02-20T10:30:00Z"
}
```

## Ejemplos

### Setup inicial completo

```bash
./run-skill.sh monorepo-setup --installAll true
```

### Setup en CI

```bash
./run-skill.sh monorepo-setup --ci true
```

### Limpiar y reinstalar

```bash
./run-skill.sh monorepo-setup --clean true --installAll true
```

## Implementación

**Comando base**: `npm install`

**Validaciones**:
- Node.js >= 20.0.0
- npm >= 10.0.0
- Escritura en directorio

## Errores Comunes

- **Versión Node insuficiente**: Actualizar a 20+
- **Permisos denegados**: Ejecutar con permisos adecuados
- **Conexión de red**: Reintentar

