#!/bin/bash

##############################################################################
# DNI-Connect Hot Reload - Guía Rápida de Inicio
#
# Este archivo resume todo lo necesario para activar hot reload en el proyecto
##############################################################################

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════════╗
║                                                                          ║
║                   🚀 DNI-Connect Hot Reload Setup 🚀                     ║
║                                                                          ║
║              Cada cambio genera hot reload/restart automático             ║
║                                                                          ║
╚══════════════════════════════════════════════════════════════════════════╝

✅ CONFIGURACIÓN COMPLETADA

Se han creado/configurado los siguientes archivos:

📁 Skill nuevo:
   └─ .agents/skills/dev-watch/
      ├─ SKILL.md (documentación)
      ├─ config.json (configuración)
      ├─ README.md (guía rápida)
      └─ examples/ (ejemplos)

📄 Scripts principales:
   ├─ watch.sh (ejecutable con hot reload)
   ├─ package.json (actualizado con npm scripts)
   ├─ apps/web/backend/nodemon.json (config backend)
   └─ .watchmanconfig (optimización macOS)

📖 Documentación:
   ├─ HOT_RELOAD.md (inicio rápido)
   ├─ SETUP_HOT_RELOAD.md (resumen de cambios)
   ├─ AGENTS.md (actualizado)
   └─ this file!

═══════════════════════════════════════════════════════════════════════════

🎯 INICIO RÁPIDO

Opción 1: Ambas aplicaciones (Flutter + Backend)
═══════════════════════════════════════════════════════════════════════════

  npm run dev:watch

  Esto inicia:
  • Flutter Web: http://localhost:5173 (hot reload automático)
  • Backend API: http://localhost:3000 (auto-restart automático)


Opción 2: Solo Flutter
═══════════════════════════════════════════════════════════════════════════

  npm run dev:flutter:watch

  Flutter web se inicia en http://localhost:5173


Opción 3: Solo Backend
═══════════════════════════════════════════════════════════════════════════

  npm run dev:backend:watch

  Backend Node.js se inicia en http://localhost:3000


Opción 4: Usando el script directamente
═══════════════════════════════════════════════════════════════════════════

  ./watch.sh all web    # Flutter + Backend
  ./watch.sh flutter    # Solo Flutter
  ./watch.sh backend    # Solo Backend

═══════════════════════════════════════════════════════════════════════════

📊 QUÉ SE MONITOREA

┌─────────────────────────────────────────────────────────────────────────┐
│                         FLUTTER (Hot Reload)                            │
├─────────────────────────────────────────────────────────────────────────┤
│ Archivos:  apps/flutter/lib/**/*.dart                                   │
│ Acción:    Hot reload automático                                        │
│ Tiempo:    ~1 segundo                                                   │
│ Ejemplo:   Edita main.dart → automáticamente recarga en navegador      │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                      BACKEND (Auto-Restart)                             │
├─────────────────────────────────────────────────────────────────────────┤
│ Archivos:  apps/web/backend/src/**/*.ts                                 │
│ Acción:    Reinicia servidor automáticamente                            │
│ Tiempo:    ~1 segundo                                                   │
│ Ejemplo:   Edita server.ts → automáticamente reinicia servidor         │
└─────────────────────────────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════════════════

⚙️  REQUISITOS PREVIOS

  ✓ Node.js ≥ 20.0.0        (verificar: node --version)
  ✓ npm ≥ 9.0.0              (verificar: npm --version)
  ✓ Flutter SDK              (verificar: flutter --version)
  ✓ nodemon (npm install)    (se instala automáticamente si falta)

═══════════════════════════════════════════════════════════════════════════

🛠️  INSTALACIÓN (si es necesario)

  # Instalar nodemon si no está presente
  npm install --save-dev nodemon

  # Verificar que nodemon está instalado
  npm list nodemon

═══════════════════════════════════════════════════════════════════════════

📝 FLUJO DE TRABAJO TÍPICO

  1. Abre la terminal en la raíz del proyecto:
     $ cd /Users/e032284/Proyectos/DNI-Connect/dni-connect

  2. Inicia el watch mode:
     $ npm run dev:watch

  3. Abre http://localhost:5173 en el navegador

  4. Edita un archivo .dart o .ts

  5. ¡La aplicación se actualiza automáticamente!

═══════════════════════════════════════════════════════════════════════════

🎮 CONTROLES

  Ctrl+C                    Detener todos los procesos
  r (en Flutter)           Reiniciar aplicación Flutter
  q (en Flutter)           Salir de Flutter
  Guardar archivo          Trigger automático de reload/restart

═══════════════════════════════════════════════════════════════════════════

🐛 SOLUCIÓN DE PROBLEMAS

  ❌ "Flutter no está instalado"
     ✓ Ejecuta: flutter upgrade
     ✓ Agrega a PATH: export PATH="\$PATH:\$(pwd)/flutter/bin"

  ❌ "nodemon: command not found"
     ✓ Ejecuta: npm install --save-dev nodemon

  ❌ "Cambios no se detectan"
     ✓ Ejecuta: flutter clean
     ✓ Ejecuta: rm -rf apps/web/backend/.next
     ✓ Reinicia: npm run dev:watch

  ❌ "Backend se reinicia constantemente"
     ✓ Revisa que no haya archivos que se escriban en src/
     ✓ Aumenta delay en nodemon.json a 2000ms

═══════════════════════════════════════════════════════════════════════════

📚 DOCUMENTACIÓN ADICIONAL

  • Documentación completa: .agents/skills/dev-watch/SKILL.md
  • Guía de inicio rápido:   .agents/skills/dev-watch/README.md
  • Resumen de cambios:      SETUP_HOT_RELOAD.md
  • Hot reload rápido:       HOT_RELOAD.md
  • Agentes del proyecto:    AGENTS.md

═══════════════════════════════════════════════════════════════════════════

✨ ¡LISTO PARA DESARROLLAR!

Ejecuta: npm run dev:watch

Y empieza a ver cambios automáticos en tu aplicación.

═══════════════════════════════════════════════════════════════════════════

Fecha de creación: 20 de febrero de 2026
Versión: 1.0.0

EOF
