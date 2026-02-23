# dev-watch Skill - Guía de Uso Rápido

## 🎯 Propósito

Monitorea cambios en el código y ejecuta automáticamente:
- **Flutter**: Hot reload cuando cambian archivos `.dart`
- **Backend**: Auto-restart cuando cambian archivos `.ts` o `.json`

## 🚀 Inicio Rápido

### Opción 1: Usar el script `watch.sh`

```bash
# Ambas aplicaciones (Flutter web + Backend)
./watch.sh all web

# Solo Flutter
./watch.sh flutter web

# Solo Backend
./watch.sh backend
```

### Opción 2: Usar npm scripts

```bash
# Ambas aplicaciones
npm run dev:watch

# Solo Flutter
npm run dev:flutter:watch

# Solo Backend
npm run dev:backend:watch
```

### Opción 3: Usar el skill directamente

```bash
./run-skill.sh dev-watch --target all --platform web
```

## 📝 Ejemplos Comunes

### Desarrollo Flutter Web

```bash
./watch.sh flutter web
```

El servidor Flutter se inicia en `http://localhost:5173` con hot reload automático.

### Desarrollo Backend Node.js

```bash
./watch.sh backend
```

El servidor reinicia automáticamente cuando detecta cambios en `src/**`.

### Desarrollo Full-Stack (Flutter + Backend)

```bash
npm run dev:watch
```

Inicia ambas aplicaciones en paralelo con hot reload automático.

## ⚙️ Requisitos

- Flutter SDK instalado y en PATH
- Node.js ≥ 20.0.0
- npm ≥ 9.0.0

### Instalar Dependencias Faltantes

```bash
# Instalar nodemon para watch del backend
npm install --save-dev nodemon

# Actualizar Flutter
flutter upgrade
```

## 🔄 Comportamiento

### ¿Qué causa un hot reload/restart?

| Tipo | Archivos | Acción | Tiempo |
|------|----------|--------|--------|
| Flutter | `*.dart` | Hot reload | ~1s |
| Flutter | `pubspec.yaml` | Rebuild | ~5s |
| Backend | `*.ts` | Restart | ~1s |
| Backend | `*.json` | Restart | ~500ms |

### Rutas Ignoradas Automáticamente

- `node_modules/`
- `.dart_tool/`
- `build/`
- `dist/`
- `.next/`
- `.git/`

## 🛑 Detener el Watch

Presiona `Ctrl+C` en la terminal para detener todos los procesos.

## 📊 Ver Logs

Los cambios se registran automáticamente:

```bash
# Ver últimos cambios en Flutter
tail -f .dev-watch/flutter.log

# Ver últimos cambios en Backend
tail -f .dev-watch/backend.log

# Ver todos los cambios
tail -f .dev-watch/changes.log
```

## ❌ Solución de Problemas

### "Flutter no está instalado"

```bash
# Instalar Flutter
curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_version.tar.gz -o flutter.tar.gz
tar xf flutter.tar.gz
export PATH="$PATH:$(pwd)/flutter/bin"
```

### "nodemon: command not found"

```bash
npm install --save-dev nodemon
```

### Cambios no se detectan

```bash
# Limpiar cachés
flutter clean
rm -rf apps/web/backend/.next build dist

# Reintentar watch
./watch.sh all web
```

### Backend se reinicia constantemente

Revisa que no haya archivos que se escriban frecuentemente en `src/`. Si es necesario, agrega rutas a `ignorePaths` en `config.json`.

## 📚 Para Más Información

Ver [SKILL.md](./SKILL.md) para documentación completa.
