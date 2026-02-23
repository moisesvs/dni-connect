# 🤖 DNI-Connect Agents & Skills

Documentación completa sobre agentes y skills disponibles para automatizar tareas en DNI-Connect.

---

## 📚 Contenido

- [Visión General](#visión-general)
- [Skills Disponibles](#skills-disponibles)
- [Estructura de Skills](#estructura-de-skills)
- [Uso de Skills](#uso-de-skills)
- [Workflow de CI/CD](#workflow-de-cicd)
- [Desarrollo de Skills](#desarrollo-de-skills)

---

## 🎯 Visión General

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

## 📚 Skills Disponibles

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

## 🔗 Referencias

- **[README.md](./README.md)** - Guía general del proyecto
- **[ARCHITECTURE.md](./docs/ARCHITECTURE.md)** - Arquitectura técnica
- **[CHANGE_LOG.md](./CHANGE_LOG.md)** - Historial de cambios
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

**Última actualización:** Febrero 2026  
**Versión de Skills:** 1.0.0  
**Mantenedor:** DNI-Connect Team
