# 📋 Hot Reload Setup - Resumen de Cambios

## ✅ Lo que se ha Configurado

### 1. **Nuevo Skill: `dev-watch`** ✨
Monitorea cambios en el código y ejecuta automáticamente hot reload/restart.

**Ubicación:** [.agents/skills/dev-watch/](./.agents/skills/dev-watch/)

**Archivos creados:**
- `SKILL.md` - Documentación completa
- `config.json` - Configuración de inputs/outputs
- `README.md` - Guía de uso rápido
- `examples/` - Ejemplos de uso

### 2. **Script de Watch Principal** 🔄
Archivo ejecutable que gestiona el hot reload automático.

**Ubicación:** [`watch.sh`](./watch.sh)

**Funcionalidades:**
- Watch Flutter con hot reload
- Watch Backend con auto-restart
- Ejecución en paralelo o individual
- Logs detallados por componente

### 3. **Scripts npm Convenientes** 📦
Agregados al `package.json` para acceso rápido.

**Nuevos scripts:**
```bash
npm run dev:watch           # Flutter + Backend con hot reload
npm run dev:flutter:watch  # Solo Flutter
npm run dev:backend:watch  # Solo Backend
```

### 4. **Configuración Nodemon** ⚙️
Archivo de configuración para auto-restart del backend.

**Ubicación:** [`apps/web/backend/nodemon.json`](./apps/web/backend/nodemon.json)

**Features:**
- Watch `src/**` automáticamente
- Monitorea cambios en `.ts` y `.json`
- Delay de 1 segundo para evitar múltiples reinicios
- Logs informativos de cambios

### 5. **Configuración Watchman** 👀
Optimización para macOS de monitoreo de archivos.

**Ubicación:** [`.watchmanconfig`](./.watchmanconfig)

**Beneficios:**
- Mejor rendimiento en macOS
- Ignora automáticamente directorios innecesarios
- Reduce falsos positivos

### 6. **Documentación de Inicio Rápido** 📖
Guía práctica para desarrolladores.

**Ubicación:** [`HOT_RELOAD.md`](./HOT_RELOAD.md)

**Contenido:**
- Cómo iniciar con hot reload
- Qué se monitorea
- Solución de problemas

### 7. **Actualización de AGENTS.md** 🤖
Documentación actualizada para incluir el nuevo skill.

**Cambios:**
- Agregado `dev-watch` en Core Infrastructure
- Ejemplos de uso del nuevo skill

## 🚀 Cómo Usar

### Opción 1: Todo en Uno (Recomendado)

```bash
npm run dev:watch
```

Inicia ambas aplicaciones con hot reload automático.

### Opción 2: Solo Flutter

```bash
./watch.sh flutter web
npm run dev:flutter:watch
```

### Opción 3: Solo Backend

```bash
./watch.sh backend
npm run dev:backend:watch
```

### Opción 4: Skill del Agente

```bash
./run-skill.sh dev-watch --target all --platform web
```

## 📊 Flujo de Hot Reload

```
┌─────────────────────────────────────┐
│     Usuario edita archivos          │
│  • .dart en apps/flutter/lib/**     │
│  • .ts en apps/web/backend/src/**   │
└────────────┬────────────────────────┘
             │
             ▼
┌─────────────────────────────────────┐
│  Sistema de Watch detecta cambios   │
│  • Chokidar (Flutter)               │
│  • Nodemon (Backend)                │
└────────────┬────────────────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
    ┌───────┐   ┌─────────┐
    │Flutter│   │ Backend │
    │ Hot   │   │  Auto   │
    │Reload │   │ Restart │
    └───┬───┘   └────┬────┘
        │            │
        ▼            ▼
   ✅ App Updated  ✅ API Restarted
```

## ⚙️ Requisitos

- ✅ Node.js ≥ 20.0.0
- ✅ npm ≥ 9.0.0
- ✅ Flutter SDK (para desarrollo Flutter)
- ✅ nodemon (instalado como dev dependency)

### Verificar Requisitos

```bash
node --version      # ≥ v20.0.0
npm --version       # ≥ 9.0.0
flutter --version   # ≥ 3.x
npx nodemon --version
```

## 🔧 Instalación de Dependencias

Si nodemon no está instalado:

```bash
npm install --save-dev nodemon
```

## 📝 Monitoreo y Logs

### Logs Automáticos

Se generan en:
- `.dev-watch/flutter.log` - Actividad de Flutter
- `.dev-watch/backend.log` - Actividad de Backend
- `.dev-watch/changes.log` - Todos los cambios

### Ver Logs en Tiempo Real

```bash
# Flutter
tail -f .dev-watch/flutter.log

# Backend
tail -f .dev-watch/backend.log

# Todos
tail -f .dev-watch/changes.log
```

## 🐛 Solución de Problemas

### Problema: "Flutter no está instalado"

**Solución:**
```bash
flutter upgrade
export PATH="$PATH:$(pwd)/flutter/bin"
```

### Problema: "nodemon: command not found"

**Solución:**
```bash
npm install --save-dev nodemon
npm list nodemon  # Verificar
```

### Problema: Cambios no se detectan

**Solución:**
```bash
flutter clean
rm -rf apps/web/backend/dist apps/web/backend/node_modules
npm run dev:watch
```

### Problema: Backend se reinicia constantemente

**Solución:**
Verificar `nodemon.json` - es posible que haya archivos que se escriban en `src/` muy frecuentemente. Usar `ignore` para excluirlos.

## 📚 Documentación Completa

Para detalles técnicos:
- [.agents/skills/dev-watch/SKILL.md](./.agents/skills/dev-watch/SKILL.md)
- [.agents/skills/dev-watch/README.md](./.agents/skills/dev-watch/README.md)
- [AGENTS.md](./AGENTS.md#-core-infrastructure)

## 📅 Fecha de Creación

**20 de febrero de 2026**

**Última Actualización:** 20 de febrero de 2026

---

¡Listo! Ahora cada cambio en el código genera automáticamente hot reload o restart. 🚀
