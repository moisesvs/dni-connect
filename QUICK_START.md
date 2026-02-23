# 🚀 Guía Rápida: Sistema de Documentación y Automatización

Referencia rápida para trabajar con el sistema de documentación automática y sincronización de DNI-Connect.

---

## ⚡ Inicio Rápido

### 1️⃣ Hacer un Commit (Lo Más Importante)

```bash
# Git hook automático actualiza CHANGE_LOG.md
git add .
git commit -m "Agregar nueva funcionalidad"

# ✅ Automáticamente:
# • Detecta cambios (Flutter, Backend, Docs, Skills, Config)
# • Genera entrada en CHANGE_LOG.md
# • Registra commit hash, autor, timestamp
```

### 2️⃣ Verificar Sincronización

```bash
# Ejecutar validación manual (opcional)
./sync-docs.sh

# Verifica:
# ✅ CHANGE_LOG.md actualizado
# ✅ 18 skills completamente documentados
# ✅ README.md, AGENTS.md, CHANGE_LOG.md existen
# ✅ Índice de skills actualizado
# ✅ Workflows YAML válido
# ✅ Monorepo estructura correcta
```

### 3️⃣ Ver Documentación

```bash
# Docs principales:
README.md           # 📖 Guía general del proyecto
AGENTS.md           # 🤖 Sistema de agentes y 18 skills
CHANGE_LOG.md       # 📋 Historial automático de cambios

# Docs de skills:
.agents/skills/README.md      # 📚 Índice rápido
.agents/skills/INVENTORY.md   # 📊 Estadísticas detalladas
.agents/SYNC.md               # 🔄 Sistema sincronización
```

---

## 📚 Documentación Disponible

| Archivo | Propósito | Actualización |
|---------|-----------|---------------|
| **README.md** | Guía general: instalación, features, arquitectura, desarrollo | Manual + Automática en cambios |
| **AGENTS.md** | Sistema de agentes: 18 skills, CI/CD, workflows | Manual + Automática |
| **CHANGE_LOG.md** | Historial automático de commits y cambios | ✅ **Automática con cada commit** |
| **.agents/skills/README.md** | Índice de skills con tablas y ejemplos | Manual + Automática |
| **.agents/skills/INVENTORY.md** | Inventario detallado y estadísticas | Automática (parcial) |
| **.agents/SYNC.md** | Documentación del sistema de sincronización | Manual |

---

## 🔄 Sistema de Sincronización

### Automático (Post-Commit)

```bash
git commit -m "Tu cambio"
# ↓ Se ejecuta automáticamente .git/hooks/post-commit
# ↓ CHANGE_LOG.md se actualiza automáticamente
# ✅ Commit completado con docs sincronizadas
```

**¿Qué detecta?**
- `apps/flutter/*` → 📱 Flutter changes
- `apps/web/backend/*` → 🔧 Backend changes
- `docs/*`, `README.md`, `AGENTS.md` → 📚 Docs changes
- `.agents/skills/*` → 🤖 Skills changes
- `package.json`, `tsconfig.json` → ⚙️ Config changes

### Manual (Verificación)

```bash
./sync-docs.sh
```

**Verifica:**
- ✅ CHANGE_LOG.md actualizado
- ✅ 18 skills documentados completos
- ✅ Archivos principales existen (README, AGENTS, CHANGELOG)
- ✅ Índice de skills sincronizado
- ✅ YAML workflows válido
- ✅ Estructura monorepo correcta

---

## 📊 18 Skills Documentados

### Categorías

**Core Infrastructure** (4 skills)
```
✅ flutter-build      - Compilar app Flutter (Web/Android/iOS)
✅ backend-start      - Iniciar servidor Node.js backend
✅ monorepo-setup     - Instalar dependencias workspaces
✅ dev-watch          - Monitorear cambios y hot reload
```

**Verification & Crypto** (4 skills)
```
✅ qr-verification    - Validar QR MiDNI (ICAO 9303)
✅ nfc-reading        - Leer DNIe PACE/EAC
✅ crypto-validation  - Validar certificados X.509 y ECDSA
✅ pki-integration    - Conectar con PKI y OCSP
```

**Data & Sync** (2 skills)
```
✅ database-sync      - Sincronizar Google Firestore
✅ storage-upload     - Subir biometría a GCS
```

**Testing & Quality** (4 skills)
```
✅ backend-test       - Tests Node.js (Vitest)
✅ flutter-test       - Tests Flutter unitarios y e2e
✅ lint-check         - Análisis estático y formato código
✅ coverage           - Reporte de cobertura
```

**Deployment** (3 skills)
```
✅ deploy-backend     - Desplegar en Cloud Run
✅ deploy-flutter     - Publicar Play Store/App Store
✅ health-check       - Verificar salud servicios
```

**Design & Accessibility** (1 skill)
```
✅ ui-design          - Validar Material 3, WCAG, responsividad
```

---

## 🛠️ Comandos Útiles

### Verificación Rápida

```bash
# Ver estado de sincronización
./sync-docs.sh

# Ver últimos cambios
git log --oneline -5

# Ver qué cambió
git diff --name-only HEAD~1

# Ver cambios en CHANGE_LOG
git diff CHANGE_LOG.md
```

### Desarrollo

```bash
# Instalar dependencias
npm install

# Compilar todo
npm run build:all

# Ver estado de skills
./.agents/skills/status.sh
```

### Git Workflow

```bash
# Agregar cambios
git add .

# Hacer commit (hook se ejecuta automáticamente)
git commit -m "Descripción de cambios"

# Ver cambios documentados
git show HEAD

# Enviar cambios
git push origin rama
```

---

## 📖 Cómo Leer la Documentación

### Para Nuevos Desarrolladores

1. **Comienza con [README.md](README.md)**
   - Visión general del proyecto
   - Requisitos e instalación
   - Estructura del proyecto
   - Cómo hacer build y desarrollo

2. **Lee [AGENTS.md](AGENTS.md)**
   - Entiende el sistema de skills
   - Ve qué tareas puedes automatizar
   - Aprende el workflow CI/CD

3. **Consulta [.agents/skills/README.md](.agents/skills/README.md)**
   - Busca un skill específico
   - Ver parámetros de entrada/salida
   - Ver ejemplos de uso

### Para Tareas Específicas

#### "Quiero agregar una nueva feature"
1. Lee [README.md - Development Workflow](README.md)
2. Elige entre Flutter, Backend o ambos
3. Sigue el workflow, haz commit
4. ✅ CHANGE_LOG.md se actualiza automáticamente

#### "Quiero entender los skills"
1. Lee [AGENTS.md - Skills Disponibles](AGENTS.md#-skills-disponibles)
2. Ve categoría que te interesa
3. Consulta `.agents/skills/[nombre]/SKILL.md`
4. Prueba con ejemplos en `examples/`

#### "Quiero saber qué cambió últimamente"
1. Ver [CHANGE_LOG.md](CHANGE_LOG.md)
2. Busca sección `[Unreleased]` para cambios recientes
3. O ejecuta `git log --oneline` para commits

#### "Quiero crear un nuevo skill"
1. Lee [AGENTS.md - Desarrollo de Skills](AGENTS.md#-desarrollo-de-skills)
2. Crea carpeta `.agents/skills/[nombre]/`
3. Crea `SKILL.md` y `config.json`
4. Agrega ejemplos en `examples/`
5. Haz commit, ¡el changelog se actualiza solo!

---

## ✅ Checklist: Antes de Hacer Commit

```bash
# ✅ Cambios listos
git status

# ✅ Código compilado y testeado
npm run build:all

# ✅ Sin errores de lint
npm run lint

# ✅ Tests pasando
npm run test

# ✅ Hacer commit (hook sincroniza docs)
git add .
git commit -m "Descripción clara del cambio"

# ✅ Verificar CHANGE_LOG.md se actualizó
git diff CHANGE_LOG.md

# ✅ Enviar cambios
git push
```

---

## 🚨 Troubleshooting

### El CHANGE_LOG.md no se actualiza

```bash
# Verificar que hook es ejecutable
ls -la .git/hooks/post-commit

# Debe mostrar: -rwxr-xr-x
# Si no, hacer ejecutable:
chmod +x .git/hooks/post-commit

# Reintentar commit
git commit -m "Test" --allow-empty
```

### La sincronización manual falla

```bash
# Hacer ejecutable
chmod +x sync-docs.sh

# Ejecutar con debug
bash -x sync-docs.sh

# O con bash explícito
bash sync-docs.sh
```

### No encuentro documentación sobre un skill

```bash
# Buscar en índice
grep "skill-name" .agents/skills/README.md

# O ver todos los skills
ls -la .agents/skills/

# O leer inventario detallado
cat .agents/skills/INVENTORY.md
```

---

## 📞 Soporte y Referencias

| Pregunta | Recurso |
|----------|---------|
| ¿Cómo instalo el proyecto? | [README.md - Instalación](README.md) |
| ¿Cómo uso skills? | [AGENTS.md - Uso de Skills](AGENTS.md) |
| ¿Qué skills hay disponibles? | [.agents/skills/README.md](.agents/skills/README.md) |
| ¿Cómo funciona sincronización? | [.agents/SYNC.md](.agents/SYNC.md) |
| ¿Qué cambios se hicieron? | [CHANGE_LOG.md](CHANGE_LOG.md) |
| ¿Cómo crear nuevo skill? | [AGENTS.md - Desarrollo](AGENTS.md#-desarrollo-de-skills) |
| ¿Código fuente? | [Estructura del Proyecto](README.md#-estructura-del-proyecto) |

---

## 🎯 Resumen Rápido

✅ **Más importante**: Haz commits normalmente  
✅ **Automático**: CHANGE_LOG.md se actualiza solo  
✅ **Verificar**: Ejecuta `./sync-docs.sh` si quieres validar  
✅ **Documentación**: Todo está en README.md, AGENTS.md y .agents/skills/  

---

**Última actualización:** 23 de Febrero, 2026  
**Documentación:** Completa y Sincronizada ✅  
**Sistema Automático:** Activo ✅
