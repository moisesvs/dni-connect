# 🔄 Hot Reload Development Guide

Guía rápida para ejecutar la aplicación con hot reload automático.

## 🚀 Inicio Rápido

### Opción 1: Todo Junto (Recomendado)

```bash
npm run dev:watch
```

Esto inicia:
- ✅ **Flutter Web** en `http://localhost:5173` con hot reload
- ✅ **Backend Node.js** en `http://localhost:3000` con auto-restart

### Opción 2: Solo Flutter

```bash
npm run dev:flutter:watch
```

Flutter web se inicia con hot reload automático.

### Opción 3: Solo Backend

```bash
npm run dev:backend:watch
```

Backend Node.js se reinicia automáticamente en cada cambio.

## 📋 Lo que se Monitorea

### Flutter (`apps/flutter/lib/**`)
- Cambios en `.dart` → Hot reload (~1s)
- Cambios en `pubspec.yaml` → Rebuild (~5s)

### Backend (`apps/web/backend/src/**`)
- Cambios en `.ts` → Auto-restart (~1s)
- Cambios en `.json` → Auto-restart (~500ms)

### Rutas Ignoradas
- `node_modules/`, `.dart_tool/`, `build/`, `dist/`, `.git/`

## ⌨️ Controles

| Comando | Efecto |
|---------|--------|
| `Ctrl+C` | Detener todos los procesos |
| `r` (en Flutter) | Reiniciar la aplicación |
| `q` (en Flutter) | Salir de Flutter |

## 🐛 Solución de Problemas

### "Flutter no está instalado"
```bash
flutter upgrade
echo 'export PATH="$PATH:$(pwd)/flutter/bin"' >> ~/.zshrc
```

### "nodemon: command not found"
```bash
npm install --save-dev nodemon
```

### Cambios no se detectan
```bash
flutter clean
rm -rf apps/web/backend/.next
./watch.sh all web
```

## 📚 Documentación Completa

Ver [.agents/skills/dev-watch/SKILL.md](./.agents/skills/dev-watch/SKILL.md) para detalles técnicos.
