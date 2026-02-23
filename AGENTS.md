# 🤖 DNI-Connect Agents & Skills

Documentación completa sobre agentes y skills disponibles para automatizar tareas en DNI-Connect.

---

## 📚 Contenido

- [Visión General](#visión-general)
- [Sistema de Sincronización Automática](#-sistema-de-sincronización-automática)
- [Skills Disponibles](#skills-disponibles)
- [Estructura de Skills](#estructura-de-skills)
- [Uso de Skills](#uso-de-skills)
- [Workflow de CI/CD](#workflow-de-cicd)
- [Desarrollo de Skills](#desarrollo-de-skills)
- [Documentación Asociada](#-documentación-asociada)

---

## 🎯 Visión General

### Arquitectura del Proyecto

**DNI-Connect** es una solución multiplataforma con estructura simplificada:

```
dni-connect/
├── apps/
│   └── flutter/          # Aplicación Flutter (Web, Android, iOS)
│       ├── lib/          # Código Dart compartido
│       ├── web/          # Configuración web
│       ├── android/      # Configuración Android
│       └── ios/          # Configuración iOS
├── backend/              # API REST Node.js + TypeScript
│   ├── src/
│   ├── package.json
│   └── tsconfig.json
├── packages/
│   └── core/             # Librerías compartidas (crypto, verificación)
└── .agents/
    └── skills/           # Skills de automatización
```

**Componentes:**
- **Web**: Flutter Web (apps/flutter)
- **Mobile**: Flutter iOS/Android (apps/flutter)
- **Backend**: Node.js + TypeScript (backend/)
- **Core**: Librerías criptográficas (packages/core/)

### ¿Qué son los Skills?

Los **skills** son tareas automatizadas que ejecutan funcionalidades específicas del proyecto. Cada skill:

- 📋 Tiene documentación completa en `SKILL.md`
- ⚙️ Define inputs y outputs claros en `config.json`
- 📝 Incluye ejemplos de uso en `examples/`
- 🔧 Se puede ejecutar desde terminal o desde agentes

### Arquitectura de Agentes

```
┌─────────────────────────────────────────┐
│        GitHub Actions / Triggers         │
│  (Push, PR, Manual Dispatch, Schedule)  │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│      Agent Orchestrator                  │
│  • Valida cambios                        │
│  • Determina skills necesarios           │
│  • Ejecuta en paralelo/secuencia         │
└────────────────┬────────────────────────┘
                 │
      ┌──────────┼──────────┬──────────┐
      ▼          ▼          ▼          ▼
  ┌────────┐ ┌────────┐ ┌────────┐ ┌──────────┐
  │ Build  │ │ Test   │ │ Verify │ │ Deploy   │
  │ Skills │ │Skills  │ │Skills  │ │Skills    │
  └────────┘ └────────┘ └────────┘ └──────────┘
```

---

## � Sistema de Sincronización Automática

### Overview

El sistema de sincronización automática mantiene **CHANGE_LOG.md** actualizado con cada commit, garantizando que la documentación siempre refleje el estado actual del código.

### Componentes Principales

#### 1. Post-Commit Hook (`.git/hooks/post-commit`)

**Ejecutión:** Automática después de cada `git commit`

**Funcionalidad:**
```bash
# Analiza cambios en el código
# Categoriza por tipo: Flutter, Backend, Docs, Skills, Config
# Genera entrada automática en CHANGE_LOG.md
# Registra: commit hash, mensaje, autor, timestamp, categoría
```

**Categorías Detectadas:**
```
📱 Flutter    - apps/flutter/*
🔧 Backend    - apps/web/backend/*, backend/*
📚 Docs       - docs/*, README.md, AGENTS.md
🤖 Skills     - .agents/skills/*
⚙️ Config     - package.json, tsconfig.json, pubspec.yaml
```

**Ejemplo de Salida:**
```markdown
### 🔄 Commit: a1b2c3d
- **Mensaje**: Agregar flutter-build skill documentation
- **Autor**: Juan Pérez
- **Timestamp**: 2026-02-23 14:30:45
- 🤖 **Skills**: Actualización en sistema de automatización
```

**Permisos:**
```bash
chmod +x .git/hooks/post-commit  # Hacer ejecutable
```

#### 2. Script de Sincronización Manual (`sync-docs.sh`)

**Ejecución:** Manual desde terminal

```bash
./sync-docs.sh
```

**Validaciones Realizadas:**
- ✅ CHANGE_LOG.md actualizado
- ✅ 18 skills completamente documentados
- ✅ Archivos principales existen (README.md, AGENTS.md, CHANGE_LOG.md)
- ✅ Índice de skills actualizado
- ✅ Workflows YAML válido
- ✅ Estructura monorepo correcta

**Output:**
```
ℹ️ Paso 1: Sincronizando CHANGE_LOG.md...
✅ Paso 2: Verificando estado de Skills...
✅ Se encontraron 18 skills documentados
✅ Todos los 18 skills están completamente documentados
...
✅ Sincronización completada
```

### Flujo de Sincronización

```
Cambios en código (Flutter, Backend, Docs, Skills, Config)
            │
            ▼
    git commit "mensaje"
            │
            ▼
.git/hooks/post-commit (automático)
            │
    ┌───────┼───────┐
    ▼       ▼       ▼
 Analiza Categoriza Genera
 cambios  cambios   entrada
            │
            ▼
    CHANGE_LOG.md actualizado
            │
            ▼
    ✅ Commit completado con docs sincronizadas
```

### Para Agentes: Cómo Usar la Sincronización

**Dentro de un Skill o Workflow:**

```bash
# Los agentes pueden confiar en que CHANGE_LOG.md siempre está actualizado
# después de cada commit

# Verificar sincronización
./sync-docs.sh

# Ver cambios recientes
grep "### 🔄 Commit:" CHANGE_LOG.md | head -10

# Obtener último commit registrado
tail -20 CHANGE_LOG.md
```

**En TypeScript/Node.js:**

```typescript
import fs from 'fs';

// Leer CHANGE_LOG para verificar cambios recientes
const changelog = fs.readFileSync('CHANGE_LOG.md', 'utf-8');
const hasRecentSkillsChanges = changelog.includes('🤖 **Skills**');

if (hasRecentSkillsChanges) {
  console.log('Cambios recientes en skills detectados');
  // Ejecutar acciones correspondientes
}
```

### Referencias Técnicas

- **Documentación Completa:** [.agents/SYNC.md](./.agents/SYNC.md)
- **Guía Rápida:** [QUICK_START.md](./QUICK_START.md#-sistema-de-sincronización)
- **Solución de Problemas:** [.agents/SYNC.md - Solución de Problemas](./.agents/SYNC.md#-solución-de-problemas)

---

### 🏗️ Core Infrastructure

**Gestión de compilación y configuración del monorepo.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **dev-watch** | ✅ | Monitorear cambios y ejecutar hot reload automático |
| **flutter-build** | ✅ | Compilar app Flutter (Web/Android/iOS) en debug/release |
| **backend-start** | ✅ | Iniciar servidor Node.js backend con hot-reload |
| **monorepo-setup** | ✅ | Instalar dependencias y configurar workspaces |

**Usar:**
```bash
./run-skill.sh dev-watch --target all --platform web
./run-skill.sh flutter-build --platform web --mode debug
./run-skill.sh backend-start --env development
./run-skill.sh monorepo-setup --install-all
```

---

### 🔐 Verification & Crypto

**Validación de identidad y operaciones criptográficas.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **qr-verification** | ✅ | Decodificar y validar QR MiDNI (ICAO 9303 Pt.13) |
| **nfc-reading** | ✅ | Leer DNIe con protocolo PACE/EAC |
| **crypto-validation** | ✅ | Validar certificados X.509 y firmas ECDSA |
| **pki-integration** | ✅ | Conectar con PKI y verificar OCSP |

**Usar:**
```bash
./run-skill.sh qr-verification --qr-data "..." --validate-ocsp true
./run-skill.sh nfc-reading --can "123456" --mrz "..."
./run-skill.sh crypto-validation --cert-path "./cert.pem"
./run-skill.sh pki-integration --cert-ref "abc123"
```

---

### 💾 Data & Sync

**Almacenamiento y sincronización de datos.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **database-sync** | ✅ | Sincronizar datos con Google Cloud Firestore |
| **storage-upload** | ✅ | Subir biometría a Google Cloud Storage |
| **cache-clean** | ✅ | Limpiar datos expirados en caché local |

**Usar:**
```bash
./run-skill.sh database-sync --user-id "user@example.com" --method qr
./run-skill.sh storage-upload --photo-path "./photo.jpg" --user-id "user@example.com"
./run-skill.sh cache-clean --retention-days 30
```

---

### 🎨 Design & Accessibility

**Validación de diseño, accesibilidad y Material 3.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **ui-design** | ✅ | Validar Material 3, contraste WCAG, responsividad |

**Usar:**
```bash
./run-skill.sh ui-design --action validate --targetFile lib/core/theme/app_theme.dart
./run-skill.sh ui-design --action generate-theme --colorSeed "#003366"
./run-skill.sh ui-design --action contrast-check --wcagLevel AA
./run-skill.sh ui-design --action responsivity-test --breakpoints mobile,tablet,desktop
./run-skill.sh ui-design --action audit --generateDocs true
```

---

### 🔒 Security & Compliance

**Auditoría de seguridad, validación OWASP y cumplimiento legal.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **security-audit** | ✅ | Auditoría completa de seguridad OWASP Top 10 |

**Acciones disponibles:**
- `audit` - Auditoría completa de seguridad
- `owasp` - Validación OWASP Top 10 (2023)
- `dependencies` - Scan de dependencias vulnerables
- `secrets` - Detección de secretos expuestos
- `headers` - Auditoría de headers de seguridad HTTP
- `encryption` - Verificación de cifrado en tránsito/reposo
- `compliance` - Auditoría GDPR/CCPA

**Usar:**
```bash
./run-skill.sh security-audit --action audit
./run-skill.sh security-audit --action owasp --generateReport true
./run-skill.sh security-audit --action dependencies --checkVulnerabilities true
./run-skill.sh security-audit --action secrets --scanPath backend/
./run-skill.sh security-audit --action headers --apiUrl https://api.example.com
./run-skill.sh security-audit --action encryption --validateCerts true
./run-skill.sh security-audit --action compliance --standards GDPR,CCPA
```

**Características:**
- ✅ Validación OWASP Top 10
- ✅ Escaneo de dependencias vulnerables (CVE database)
- ✅ Detección de secretos (API keys, tokens, credentials)
- ✅ Auditoría de headers HTTP
- ✅ Verificación de certificados PKI
- ✅ Validación de encriptación
- ✅ Cumplimiento GDPR/CCPA
- ✅ Generación de reportes HTML/JSON

---

### 🧪 Testing & Quality

**Pruebas, validación y análisis de código.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **flutter-test** | ✅ | Ejecutar tests unitarios y e2e de Flutter |
| **backend-test** | ✅ | Tests de Node.js backend (Vitest) |
| **lint-check** | ✅ | Análisis estático y formato de código |
| **coverage** | ✅ | Generar reporte de cobertura |

**Usar:**
```bash
./run-skill.sh flutter-test --platform web --coverage true
./run-skill.sh backend-test --watch false --coverage true
./run-skill.sh lint-check --fix true
./run-skill.sh coverage --report-format lcov
```

---

### 🚀 Deployment

**Despliegue en producción.**

| Skill | Estado | Descripción |
|-------|--------|-------------|
| **deploy-backend** | ✅ | Desplegar backend en Google Cloud Run |
| **deploy-flutter** | ✅ | Publicar apps en Play Store / App Store |
| **health-check** | ✅ | Verificar salud de servicios desplegados |

**Usar:**
```bash
./run-skill.sh deploy-backend --environment production --version 1.0.0
./run-skill.sh deploy-flutter --platform android --track internal
./run-skill.sh health-check --service backend
```

---

## 📋 Estructura de Skills

Cada skill sigue esta estructura normalizada:

```
.agents/skills/[nombre]/
│
├── SKILL.md                    # Documentación completa
│   ├── Descripción
│   ├── Inputs (parámetros)
│   ├── Outputs (resultados)
│   ├── Ejemplos de uso
│   ├── Implementación
│   └── Errores comunes
│
├── config.json                 # Configuración del skill
│   ├── name: Nombre único
│   ├── version: Versión
│   ├── inputs: Esquema de parámetros
│   ├── outputs: Esquema de resultados
│   └── timeout: Tiempo máximo
│
├── examples/                   # Ejemplos de uso
│   ├── example-success.json    # Caso exitoso
│   ├── example-error.json      # Caso de error
│   └── example-batch.json      # Caso en lote
│
└── scripts/                    # Implementación (opcional)
    ├── execute.sh              # Script de ejecución
    └── validate.sh             # Validaciones previas
```

---

## 🚀 Uso de Skills

### Desde Terminal

```bash
# Sintaxis básica
./run-skill.sh <skill-name> [--param1 value1] [--param2 value2]

# Ejemplo: Flutter build
./run-skill.sh flutter-build \
  --platform web \
  --mode debug \
  --clean false

# Ejemplo: Database sync
./run-skill.sh database-sync \
  --userId user@example.com \
  --method qr \
  --retryOnFailure true
```

### Desde Código TypeScript

```typescript
// Backend: apps/web/backend/src
import { skillExecutor } from '@dni-connect/core/agents';

const result = await skillExecutor.execute('flutter-build', {
  platform: 'web',
  mode: 'debug',
  clean: false
});

if (result.success) {
  console.log(`Build completado en ${result.duration}ms`);
}
```

### Con GitHub Actions

```yaml
# .github/workflows/ci-build.yml
name: CI Build
on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run flutter-build skill
        run: |
          chmod +x ./run-skill.sh
          ./run-skill.sh flutter-build \
            --platform web \
            --mode debug
```

---

## 🔄 Workflow de CI/CD

### Flujo General de Cambios

```
┌─────────────────┐
│ Push / Pull      │
│ Request          │
└────────┬─────────┘
         │
         ▼
┌─────────────────────────────────┐
│ 1. DETECTAR CAMBIOS             │
│ • Qué archivos cambiaron        │
│ • Qué tipo de cambio            │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ 2. SELECCIONAR SKILLS           │
│ • flutter-build (si cambió /lib)│
│ • backend-test (si cambió /src) │
│ • lint-check (código modificado)│
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────────────────────┐
│ 3. VALIDACIÓN (paralelo)        │
│ • Build ✓                        │
│ • Tests ✓                        │
│ • Lint ✓                         │
└────────┬────────────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
  ✅ OK    ❌ FAIL
   │         │
   ▼         ▼
APROB.    RECHAZ.
 MERGE     + NOTIFY
   │         │
   ▼         ▼
4.DEPLOY  REPORT
```

### Triggers Automáticos

| Evento | Skills Ejecutados | Condición |
|--------|------------------|-----------|
| **Push a main** | flutter-build, backend-test, lint-check | Siempre |
| **PR abierto** | backend-test, lint-check | Cambios en código |
| **Tag v\*** | deploy-backend, deploy-flutter | Nueva release |
| **Manual** | Cualquier skill | Dispatch manual |
| **Schedule** | health-check | Diariamente a las 3am UTC |

---

## 🛠️ Desarrollo de Skills

### Crear un Nuevo Skill

1. **Crear estructura:**
```bash
mkdir -p .agents/skills/[nombre]/{examples,scripts}
cd .agents/skills/[nombre]
```

2. **Crear `SKILL.md`:**
```markdown
# Skill: [nombre]

Descripción clara del propósito.

## Inputs
- param1 (tipo): descripción
- param2 (tipo): descripción

## Outputs
- result (tipo): descripción
```

3. **Crear `config.json`:**
```json
{
  "name": "skill-name",
  "version": "1.0.0",
  "inputs": {
    "param1": {
      "type": "string",
      "required": true,
      "description": "..."
    }
  },
  "outputs": {
    "success": { "type": "boolean" },
    "result": { "type": "object" }
  },
  "timeout": 60000
}
```

4. **Crear ejemplos:**
```json
// examples/example-success.json
{
  "input": { "param1": "value" },
  "expectedOutput": { "success": true }
}
```

### Validar Skill

```bash
# Validar estructura
./run-skill.sh validate --skill-path .agents/skills/[nombre]

# Ejecutar tests del skill
./run-skill.sh test --skill-path .agents/skills/[nombre]
```

---

## 📊 Monitoreo y Reportes

### Ver Status de Skills

```bash
# Status de ejecuciones recientes
./run-skill.sh status --last-hours 24

# Detalles de una ejecución
./run-skill.sh logs --skill-id abc123xyz789

# Estadísticas
./run-skill.sh stats --format json
```

### Historial de Cambios

Los cambios de skills se registran en:
- **CHANGE_LOG.md** - Registro manual de cambios
- **.agents/skills/*/SKILL.md** - Documentación actualizada
- **GitHub Actions artifacts** - Logs de ejecuciones

---

## ⚙️ Configuración Global

### Variables de Entorno

```bash
# .env.agents
AGENTS_LOG_LEVEL=info          # debug|info|warn|error
AGENTS_TIMEOUT=300000          # ms
AGENTS_RETRY_COUNT=3
AGENTS_RETRY_DELAY=1000        # ms
AGENTS_PARALLEL_LIMIT=4        # Skills en paralelo
```

### Permisos Requeridos

- ✅ Acceso a Google Cloud (Firestore, Storage, Cloud Run)
- ✅ Credenciales de repositorio (Push a GitHub)
- ✅ Acceso a Play Store / App Store Connect (para deploy)
- ✅ Certificados PKI (para verificación)

---

## � Documentación Asociada

### Documentos Principales

| Documento | Propósito | Audiencia |
|-----------|-----------|-----------|
| **[START_HERE.md](./START_HERE.md)** | Punto de entrada al proyecto | Todos |
| **[QUICK_START.md](./QUICK_START.md)** | Guía rápida en 3 pasos | Nuevos desarrolladores |
| **[README.md](./README.md)** | Instalación, arquitectura, features | Todos |
| **[CHANGE_LOG.md](./CHANGE_LOG.md)** | Historial automático de cambios | Mantenedores, Seguimiento |
| **[.agents/SYNC.md](./.agents/SYNC.md)** | Sistema de sincronización automática | Técnicos, Agentes |
| **[.agents/skills/README.md](./.agents/skills/README.md)** | Índice de 18 skills con ejemplos | Implementadores |
| **[.agents/skills/INVENTORY.md](./.agents/skills/INVENTORY.md)** | Inventario detallado de skills | Analistas |
| **[docs/DOCUMENTATION_MAP.md](./docs/DOCUMENTATION_MAP.md)** | Mapa visual de toda la documentación | Navegadores |
| **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** | Resumen de lo implementado | Mantenedores |

### Para Agentes: Acceso a Documentación

**Desde Bash/Shell:**
```bash
# Ver índice de skills
cat .agents/skills/README.md

# Ver inventario completo
cat .agents/skills/INVENTORY.md

# Ver configuración de un skill específico
cat .agents/skills/[nombre]/config.json

# Ver documentación de un skill
cat .agents/skills/[nombre]/SKILL.md

# Ver cambios recientes
head -50 CHANGE_LOG.md
```

**Desde Node.js/TypeScript:**
```typescript
import fs from 'fs';
import path from 'path';

// Obtener lista de skills
const skillsDir = './.agents/skills';
const skills = fs.readdirSync(skillsDir)
  .filter(f => fs.statSync(path.join(skillsDir, f)).isDirectory());

// Cargar configuración de un skill
const skillConfig = JSON.parse(
  fs.readFileSync(`./.agents/skills/${skillName}/config.json`, 'utf-8')
);

// Leer CHANGE_LOG
const changelog = fs.readFileSync('./CHANGE_LOG.md', 'utf-8');
```

**Desde Agentes/Workflows:**
```yaml
# Ejemplo: GitHub Actions leyendo documentación
- name: Get skills list
  run: |
    ls -la .agents/skills/ > /tmp/skills.txt
    cat /tmp/skills.txt

- name: Validate skill documentation
  run: |
    for skill in .agents/skills/*/; do
      if [ ! -f "$skill/SKILL.md" ] || [ ! -f "$skill/config.json" ]; then
        echo "❌ Skill incompleto: $(basename $skill)"
        exit 1
      fi
    done
```

### Estructura de Documentación para Agentes

```
.agents/
├── SYNC.md ..................... Sistema de sincronización
├── skills/
│   ├── README.md ............... Índice de skills (usa esto como catálogo)
│   ├── INVENTORY.md ............ Estadísticas completas
│   ├── status.sh ............... Script de estado
│   └── [skill-name]/
│       ├── SKILL.md ............ Documentación completa (lee esto)
│       ├── config.json ......... Esquema de inputs/outputs (usa esto)
│       └── examples/
│           ├── example-success.json
│           ├── example-error.json
│           └── example-batch.json
```

### Cómo los Agentes Usan Esta Información

1. **Descubrimiento de Skills**: Leer `.agents/skills/README.md`
2. **Configuración**: Consultar `.agents/skills/[nombre]/config.json`
3. **Documentación**: Revisar `.agents/skills/[nombre]/SKILL.md`
4. **Ejemplos**: Ver `.agents/skills/[nombre]/examples/`
5. **Histórico**: Consultar `CHANGE_LOG.md`
6. **Sincronización**: Ejecutar `./sync-docs.sh` antes de acciones críticas

---

## �🔗 Referencias

- **[README.md](./README.md)** - Guía general del proyecto
- **[QUICK_START.md](./QUICK_START.md)** - Guía rápida para empezar
- **[START_HERE.md](./START_HERE.md)** - Punto de entrada para nuevos
- **[CHANGE_LOG.md](./CHANGE_LOG.md)** - Historial automático de cambios
- **[.agents/SYNC.md](./.agents/SYNC.md)** - Sistema de sincronización automática
- **[.agents/skills/README.md](./.agents/skills/README.md)** - Índice de 18 skills
- **[.agents/skills/INVENTORY.md](./.agents/skills/INVENTORY.md)** - Inventario detallado
- **[docs/DOCUMENTATION_MAP.md](./docs/DOCUMENTATION_MAP.md)** - Mapa de documentación
- **[docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md)** - Arquitectura técnica
- **[IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)** - Resumen de implementación
- **GitHub Actions:** [.github/workflows/](../.github/workflows/)

---

## 🚨 Solución de Problemas

### Skill falla con timeout

```bash
# Aumentar timeout en config.json
"timeout": 120000  # 2 minutos

# O ejecutar con timeout custom
./run-skill.sh [nombre] --timeout 120000
```

### Errores de permisos

```bash
# Verificar credenciales
export GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json
./run-skill.sh validate-auth

# Re-autenticar
gcloud auth application-default login
```

### Logs de depuración

```bash
# Ejecutar con verbosidad
./run-skill.sh [nombre] --verbose true --log-level debug

# Ver logs completos
tail -f .agents/logs/skill-[nombre].log
```

---

**Última actualización:** 23 de Febrero, 2026  
**Versión de Skills:** 1.0.0  
**Sistema de Sincronización:** Activo ✅  
**Mantenedor:** DNI-Connect Automation Team
