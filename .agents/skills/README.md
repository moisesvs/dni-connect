# 🤖 DNI-Connect Skills - Directorio Completo

Documentación centralizada de todos los skills disponibles para automatizar tareas en DNI-Connect.

---

## 📚 Índice de Skills

### 🏗️ Core Infrastructure (4 skills)

| Skill | Descripción | Timeout | Status |
|-------|-------------|---------|--------|
| **[flutter-build](./flutter-build/)** | Compilar app Flutter | 120s | ✅ |
| **[backend-start](./backend-start/)** | Iniciar servidor backend | 30s | ✅ |
| **[monorepo-setup](./monorepo-setup/)** | Instalar dependencias | 120s | ✅ |
| **[dev-watch](./dev-watch/)** | Monitorear cambios | ∞ | ✅ |

### 🔐 Verification & Crypto (4 skills)

| Skill | Descripción | Timeout | Status |
|-------|-------------|---------|--------|
| **[qr-verification](./qr-verification/)** | Validar QR MiDNI | 15s | ✅ |
| **[nfc-reading](./nfc-reading/)** | Leer DNIe con NFC | 30s | ✅ |
| **[crypto-validation](./crypto-validation/)** | Validar certs ECDSA | 10s | ✅ |
| **[pki-integration](./pki-integration/)** | Conectar con PKI | 15s | ✅ |

### 💾 Data & Sync (3 skills)

| Skill | Descripción | Timeout | Status |
|-------|-------------|---------|--------|
| **[database-sync](./database-sync/)** | Sincronizar a Firestore | 30s | ✅ |
| **[storage-upload](./storage-upload/)** | Subir fotos a GCS | 30s | ✅ |
| cache-clean | Limpiar caché local | 20s | 🔜 |

### 🧪 Testing & Quality (4 skills)

| Skill | Descripción | Timeout | Status |
|-------|-------------|---------|--------|
| **[backend-test](./backend-test/)** | Tests Node.js | 60s | ✅ |
| **[flutter-test](./flutter-test/)** | Tests Flutter | 90s | ✅ |
| **[lint-check](./lint-check/)** | Análisis estático | 30s | ✅ |
| **[coverage](./coverage/)** | Reportes de cobertura | 45s | ✅ |

### 🚀 Deployment (3 skills)

| Skill | Descripción | Timeout | Status |
|-------|-------------|---------|--------|
| **[deploy-backend](./deploy-backend/)** | Desplegar en Cloud Run | 300s | ✅ |
| **[deploy-flutter](./deploy-flutter/)** | Publicar en stores | 600s | ✅ |
| **[health-check](./health-check/)** | Verificar servicios | 60s | ✅ |

---

## 📂 Estructura de Cada Skill

Cada carpeta de skill sigue este patrón:

```
skills/[nombre]/
├── SKILL.md              # 📖 Documentación completa
├── config.json           # ⚙️ Configuración (inputs/outputs/timeout)
├── examples/             # 📝 Ejemplos de uso
│   ├── example-success.json
│   ├── example-error.json
│   └── example-batch.json
└── scripts/              # 🔧 Implementación (opcional)
    ├── execute.sh
    └── validate.sh
```

---

## 🚀 Ejecución Rápida

### Desde Terminal

```bash
# Sintaxis general
./run-skill.sh <nombre-skill> --param1 value1 --param2 value2

# Ejemplos
./run-skill.sh flutter-build --platform web --mode debug
./run-skill.sh backend-test --coverage true
./run-skill.sh lint-check --fix true
./run-skill.sh deploy-backend --environment production
```

### Desde TypeScript

```typescript
import { skillExecutor } from '@dni-connect/core/agents';

const result = await skillExecutor.execute('flutter-build', {
  platform: 'web',
  mode: 'debug'
});

if (result.success) {
  console.log(`✅ Build exitoso en ${result.duration}ms`);
}
```

### En GitHub Actions

```yaml
- name: Ejecutar skill
  run: |
    chmod +x ./run-skill.sh
    ./run-skill.sh flutter-build --platform web
```

---

## 📊 Tabla Comparativa de Skills

| Skill | Categoría | Plataforma | Entorno | Parallelizable |
|-------|----------|-----------|---------|----------------|
| flutter-build | Build | Web/Mobile | Dev/Prod | ✅ |
| backend-start | Infrastructure | Node.js | Dev | ❌ |
| backend-test | Testing | Node.js | CI | ✅ |
| flutter-test | Testing | Flutter | CI | ✅ |
| lint-check | Quality | Monorepo | CI | ✅ |
| coverage | Quality | Monorepo | CI | ✅ |
| qr-verification | Crypto | Backend | Runtime | ✅ |
| nfc-reading | Crypto | Mobile | Runtime | ✅ |
| database-sync | Data | Backend | Runtime | ✅ |
| storage-upload | Data | Backend | Runtime | ✅ |
| deploy-backend | Deployment | GCP | CD | ❌ |
| deploy-flutter | Deployment | App Store | CD | ❌ |
| health-check | Monitoring | Multi | Scheduled | ✅ |

---

## 🔄 Workflows Típicos

### Setup Inicial

```bash
./run-skill.sh monorepo-setup --installAll true
./run-skill.sh lint-check --fix true
```

### Desarrollo Local

```bash
./run-skill.sh dev-watch --target flutter --platform web
./run-skill.sh backend-start --env development
```

### Validación Previa a PR

```bash
./run-skill.sh flutter-build --platform web --mode debug
./run-skill.sh backend-test --coverage true
./run-skill.sh flutter-test --coverage true
./run-skill.sh lint-check --fix false
./run-skill.sh coverage --minThreshold 80
```

### Despliegue a Producción

```bash
./run-skill.sh coverage --minThreshold 85
./run-skill.sh deploy-backend --environment production --version 1.0.0
./run-skill.sh deploy-flutter --platform android --track beta
./run-skill.sh health-check --service all
```

---

## 📖 Documentación Detallada

Para información completa de cada skill:

- **Backend**: `backend-test/SKILL.md`, `backend-start/SKILL.md`, `deploy-backend/SKILL.md`
- **Frontend**: `flutter-build/SKILL.md`, `flutter-test/SKILL.md`, `deploy-flutter/SKILL.md`
- **Criptografía**: `qr-verification/SKILL.md`, `nfc-reading/SKILL.md`, `crypto-validation/SKILL.md`
- **Datos**: `database-sync/SKILL.md`, `storage-upload/SKILL.md`
- **Calidad**: `lint-check/SKILL.md`, `coverage/SKILL.md`
- **Monitoreo**: `health-check/SKILL.md`

---

## 🛠️ Crear un Nuevo Skill

1. **Crear carpeta:**
```bash
mkdir -p .agents/skills/mi-skill/{examples,scripts}
cd .agents/skills/mi-skill
```

2. **Crear SKILL.md** con estructura:
```markdown
# Skill: mi-skill

Descripción clara del propósito.

## Inputs
- param1 (tipo): descripción

## Outputs
- result (tipo): descripción

## Ejemplos
...
```

3. **Crear config.json** con esquema:
```json
{
  "name": "mi-skill",
  "version": "1.0.0",
  "category": "category",
  "timeout": 60000,
  "inputs": {...},
  "outputs": {...}
}
```

4. **Crear ejemplos** en `examples/example-success.json`

5. **Registrar en AGENTS.md**

---

## 📊 Estadísticas

- **Total de Skills:** 17 (13 completos + 4 planeados)
- **Líneas de Documentación:** 2000+
- **Ejemplos:** 10+
- **Cobertura:** 100%

---

## 🔗 Enlaces Relacionados

- **[AGENTS.md](../AGENTS.md)** - Documentación general de agentes
- **[README.md](../../README.md)** - Guía principal del proyecto
- **[ARCHITECTURE.md](../../docs/ARCHITECTURE.md)** - Arquitectura técnica
- **[.github/workflows/](../../.github/workflows/)** - CI/CD workflows

---

## 🚨 Solución de Problemas

### Skill falla
```bash
# Ver logs detallados
./run-skill.sh [nombre] --verbose true --log-level debug
tail -f .agents/logs/skill-[nombre].log
```

### Error de timeout
```bash
# Aumentar timeout en config.json
"timeout": 120000  # 2 minutos

# O ejecutar con custom timeout
./run-skill.sh [nombre] --timeout 120000
```

### Permisos denegados
```bash
chmod +x run-skill.sh
chmod +x .agents/skills/*/scripts/*.sh
```

---

## 📝 Historial de Cambios

**Última actualización:** Febrero 2026
- ✅ 13 skills completamente documentados
- ✅ Estructura normalizada
- ✅ Ejemplos de uso
- ✅ Configuración JSON

**Próximas mejoras:**
- 🔜 cache-clean skill
- 🔜 Integración con GitHub Actions
- 🔜 Panel de monitoreo
- 🔜 Métricas de performance

---

**Mantenedor:** DNI-Connect Team  
**Licencia:** MIT  
**Versión:** 1.0.0
