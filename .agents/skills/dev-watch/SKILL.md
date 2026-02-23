# Skill: dev-watch

Monitorear cambios en el código y ejecutar hot reload/rebuild automático para la aplicación Flutter y backend Node.js.

## Descripción

Este skill gestiona el desarrollo con hot reload automático:

1. **Watch Mode Flutter**: Monitorea cambios en `apps/flutter/lib/**` y ejecuta hot reload
2. **Watch Mode Backend**: Monitorea cambios en `backend/src/**` y reinicia el servidor
3. **Sincronización**: Ejecuta ambos en paralelo
4. **Logging**: Registra todos los cambios detectados
5. **Error Recovery**: Reinicia automáticamente si hay errores

## Inputs

```json
{
  "target": "flutter|backend|all",
  "platform": "web|android|ios",
  "verbose": true,
  "watchPaths": ["src/**", "lib/**"],
  "ignorePaths": ["node_modules/**", "build/**", ".dart_tool/**"]
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `target` | string | ✅ | `flutter`, `backend`, o `all` |
| `platform` | string | ❌ | Plataforma Flutter: `web`, `android`, `ios` (default: web) |
| `verbose` | boolean | ❌ | Modo verbose con logs detallados (default: true) |
| `watchPaths` | array | ❌ | Rutas a monitorear |
| `ignorePaths` | array | ❌ | Rutas a ignorar |

## Outputs

```json
{
  "success": true,
  "processes": {
    "flutter": {
      "pid": 12345,
      "status": "running",
      "platform": "web",
      "reloads": 5,
      "lastReload": "2026-02-20T10:30:00Z"
    },
    "backend": {
      "pid": 12346,
      "status": "running",
      "restarts": 2,
      "lastRestart": "2026-02-20T10:30:00Z",
      "port": 3000
    }
  },
  "filesWatched": 45,
  "totalChanges": 12
}
```

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `success` | boolean | Indicador de éxito |
| `processes` | object | Estado de procesos en ejecución |
| `filesWatched` | number | Total de archivos monitoreados |
| `totalChanges` | number | Total de cambios detectados |

## Cambios Soportados

- ✅ Archivos `.dart` → Hot reload Flutter
- ✅ Archivos `.ts` → Reinicio backend
- ✅ Archivos `.json` → Reinicio backend
- ✅ Archivos `pubspec.yaml` → Rebuild Flutter
- ✅ Archivos `package.json` → Reinstalar deps y reinicio

## Requisitos

- Flutter SDK (para desarrollo Flutter)
- Node.js ≥ 20.0.0
- npm con workspaces
- chokidar-cli (para file watching)
- nodemon (para auto-restart backend)

## Instalación de Dependencias

```bash
npm install --save-dev chokidar-cli nodemon
flutter pub get
```

## Uso

### Ejecutar desde CLI

```bash
# Watch solo Flutter (web)
./run-skill.sh dev-watch --target flutter --platform web

# Watch solo backend Node.js
./run-skill.sh dev-watch --target backend

# Watch ambas aplicaciones
./run-skill.sh dev-watch --target all --platform web

# Modo verbose
./run-skill.sh dev-watch --target all --verbose true
```

### Ejecutar desde npm

```bash
# Modo desarrollo con hot reload (Flutter + Backend)
npm run dev:watch

# Solo Flutter web
npm run dev:flutter:watch

# Solo backend
npm run dev:backend:watch
```

## Ejemplo de Config

Ver archivo `config.json` para estructura de inputs/outputs.

## Archivo de Cambios Registrados

Los cambios se registran en `.dev-watch/changes.log`:

```
2026-02-20T10:30:15Z | flutter | lib/main.dart | hot-reload
2026-02-20T10:30:20Z | backend | src/server.ts | restart
2026-02-20T10:30:25Z | flutter | lib/app.dart | hot-reload
```

## Mejores Prácticas

1. **Evitar cambios masivos**: Los cambios masivos pueden sobrecargar el watch
2. **Usar pequeños commits**: Realizar commits frecuentes y pequeños
3. **Monitorear logs**: Revisar los logs en tiempo real para depuración
4. **Limpieza periódica**: Ejecutar `npm run clean` si hay problemas

## Solución de Problemas

### El backend no se reinicia

```bash
# Verificar si nodemon está instalado
npm list nodemon

# Reinstalar nodemon
npm install --save-dev nodemon
```

### Flutter no hace hot reload

```bash
# Verificar Flutter CLI
flutter doctor

# Limpiar build
flutter clean

# Reinstalar dependencias
flutter pub get
```

### Demasiadas recargas/reinicios

Reducir ruido configurando `ignorePaths` adecuadamente en `config.json`.

## Más Información

- [Flutter Hot Reload Docs](https://docs.flutter.dev/development/tools/hot-reload)
- [Nodemon Docs](https://nodemon.io/)
- [Chokidar Docs](https://github.com/paulmillr/chokidar)
