# 🔄 Sistema de Sincronización Automática de Documentación

Documentación sobre el sistema que mantiene README.md, AGENTS.md y CHANGE_LOG.md sincronizados automáticamente con cada commit.

---

## 📚 Contenido

- [Visión General](#visión-general)
- [Componentes](#componentes)
- [Flujo de Sincronización](#flujo-de-sincronización)
- [Uso Manual](#uso-manual)
- [Configuración](#configuración)
- [Solución de Problemas](#solución-de-problemas)

---

## 🎯 Visión General

### Objetivo

El sistema de sincronización automática garantiza que:

✅ **CHANGE_LOG.md** se actualiza automáticamente después de cada commit  
✅ **README.md** y **AGENTS.md** reflejan cambios significativos  
✅ **.agents/skills/INVENTORY.md** mantiene estadísticas actualizadas  
✅ Documentación y código siempre están sincronizados  

### Beneficios

| Beneficio | Descripción |
|-----------|------------|
| **Trazabilidad** | Cada cambio queda registrado automáticamente |
| **Historico** | CHANGE_LOG.md actúa como auditoria completa |
| **Documentación Viva** | Docs siempre reflejan estado actual del código |
| **Cero Mantenimiento Manual** | Se actualiza sola sin intervención |

---

## 🔧 Componentes

### 1. Git Hook: Post-Commit (`.git/hooks/post-commit`)

**Activación**: Automáticamente después de cada `git commit`

**Funcionalidad**:
```bash
1. Detecta qué archivos cambiaron
2. Categoriza cambios (Flutter, Backend, Docs, Skills, Config)
3. Genera entrada automática en CHANGE_LOG.md
4. Registra: commit hash, mensaje, autor, timestamp
5. Agrega cambios al archivo si es relevante
```

**Cambios Detectados**:
- `apps/flutter/*` → 📱 Flutter (Web/Android/iOS)
- `apps/web/backend/*` → 🔧 Backend API
- `docs/*`, `README.md`, `AGENTS.md` → 📚 Documentación
- `.agents/skills/*` → 🤖 Sistema de Skills
- `package.json`, `tsconfig.json`, `pubspec.yaml` → ⚙️ Configuración

**Ejemplo de Entrada Generada**:
```markdown
### 🔄 Commit: a1b2c3d
- **Mensaje**: Add flutter-build skill documentation
- **Autor**: Juan Pérez
- **Timestamp**: 2026-02-23 14:30:45
- 🤖 **Skills**: Actualización en sistema de automatización
- 📚 **Docs**: Actualización de documentación
```

---

### 2. Script de Sincronización Manual (`sync-docs.sh`)

**Ubicación**: `/dni-connect/sync-docs.sh`

**Activación**: Ejecución manual desde terminal

```bash
./sync-docs.sh
```

**Funcionalidad**:
```
1. Verifica cambios pendientes en CHANGE_LOG.md
2. Valida integridad de skills (SKILL.md + config.json)
3. Confirma que archivos principales existen (README.md, AGENTS.md, CHANGE_LOG.md)
4. Verifica índice de skills (.agents/skills/README.md)
5. Valida YAML de workflows de CI/CD
6. Revisa estructura del monorepo
7. Genera reporte de sincronización
```

**Output de Ejemplo**:
```
📚 DNI-Connect Documentation Sync
==================================
ℹ️ Paso 1: Sincronizando CHANGE_LOG.md...
✅ CHANGE_LOG.md existe (150 líneas)
ℹ️ Paso 2: Verificando estado de Skills...
✅ Se encontraron 17 skills documentados
✅ Todos los 17 skills están completamente documentados
ℹ️ Paso 3: Validando archivos de documentación...
✅ README.md existe (400 líneas)
✅ AGENTS.md existe (500 líneas)
✅ CHANGE_LOG.md existe (150 líneas)
...
```

---

## 🔄 Flujo de Sincronización

### Flujo Automático (Por Commit)

```
┌──────────────────┐
│  git commit      │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────────────────┐
│  Post-commit Hook Ejecutado          │
│  (.git/hooks/post-commit)            │
└────────┬─────────────────────────────┘
         │
         ▼
┌──────────────────────────────────────┐
│  1. Analizar Archivos Cambiados      │
│  2. Categorizar Cambios              │
│  3. Generar Entrada CHANGE_LOG       │
│  4. Registrar Metadatos              │
└────────┬─────────────────────────────┘
         │
    ┌────┴──────┐
    ▼           ▼
  ✅ OK    ❌ ERROR
   │          │
   ▼          ▼
UPDATE    LOG ERROR
 DOCS      & SKIP
   │
   ▼
COMMIT
COMPLETADO
```

### Flujo Manual (Verificación)

```bash
# Ejecutar sincronización manual
./sync-docs.sh

# El script verifica:
# ├─ CHANGE_LOG.md actualizado
# ├─ Skills documentados (17/17)
# ├─ Archivos principales existen
# ├─ Índice de skills actualizado
# ├─ Workflows YAML válido
# └─ Monorepo estructura correcta

# Output con status de cada validación
```

---

## 🚀 Uso Manual

### Sincronizar Documentación

```bash
# Ejecutar verificación y sincronización completa
./sync-docs.sh

# Salida incluye:
# • Estado de cada archivo de documentación
# • Conteo de skills documentados
# • Validación de YAML workflows
# • Recomendaciones
```

### Ver Cambios Recientes

```bash
# Ver últimos 10 commits
git log --oneline -10

# Ver cambios en CHANGE_LOG.md
git diff HEAD~1 CHANGE_LOG.md

# Ver estado de cambios no enviados
git status
```

### Actualizar Manualmente CHANGE_LOG.md

Si necesitas agregar información manualmente:

```bash
# Editar changelog
nano CHANGE_LOG.md

# O usar tu editor favorito
code CHANGE_LOG.md
```

**Formato estándar para entradas**:
```markdown
### 🔄 Commit: [HASH_CORTO]
- **Mensaje**: [Mensaje del commit]
- **Autor**: [Autor del commit]
- **Timestamp**: [YYYY-MM-DD HH:MM:SS]
- [Categoría]: Descripción de cambios
```

---

## ⚙️ Configuración

### Habilitar Post-Commit Hook

El hook ya está configurado en `.git/hooks/post-commit`. Para verificar:

```bash
# Ver contenido del hook
cat .git/hooks/post-commit

# Verificar que es ejecutable
ls -la .git/hooks/post-commit

# Debe mostrar: -rwxr-xr-x (con x = ejecutable)
```

### Variables de Entorno

El sistema no requiere variables de entorno especiales. Se ejecuta con la configuración de git existente.

### Personalización

Para modificar el comportamiento:

```bash
# Editar el post-commit hook
nano .git/hooks/post-commit

# O editar el script manual
nano sync-docs.sh
```

**Cambios Comunes**:
- Agregar más categorías de detección
- Modificar formato de entradas en CHANGE_LOG
- Cambiar rutas de búsqueda de skills

---

## 🛠️ Solución de Problemas

### El hook post-commit no se ejecuta

**Problema**: Los cambios en CHANGE_LOG.md no ocurren automáticamente

**Solución**:
```bash
# Verificar que el archivo es ejecutable
chmod +x .git/hooks/post-commit

# Verificar contenido
cat .git/hooks/post-commit

# Verificar permisos
ls -la .git/hooks/post-commit
```

### Errores en el post-commit hook

**Síntoma**: Mensaje de error después de commit

**Diagnostico**:
```bash
# Ejecutar hook manualmente para debug
bash -x .git/hooks/post-commit

# Ver logs de git
cat .git/logs/HEAD | tail -20
```

### CHANGE_LOG.md tiene formato incorrecto

**Problema**: Entradas no están en formato correcto

**Solución**:
```bash
# Verificar formato
git diff CHANGE_LOG.md

# Correcciones manuales
nano CHANGE_LOG.md

# Restaurar desde último commit bueno
git checkout HEAD~1 CHANGE_LOG.md
```

### La sincronización manual no funciona

**Problema**: `./sync-docs.sh` da error

**Solución**:
```bash
# Hacer ejecutable
chmod +x sync-docs.sh

# Ejecutar con bash explícito
bash sync-docs.sh

# Ver errores específicos
bash -x sync-docs.sh
```

---

## 📊 Monitoreo

### Ver Estado de Sincronización

```bash
# Ver cambios pendientes
git status

# Ver historial de CHANGE_LOG
git log --oneline CHANGE_LOG.md

# Ver cambios sin commits
git diff --name-only

# Ver commits sin sincronizar
git log --oneline origin..HEAD
```

### Validar Integridad

```bash
# Ejecutar script de sincronización
./sync-docs.sh

# Verificar skills
find .agents/skills -name "SKILL.md" | wc -l

# Verificar documentación
wc -l README.md AGENTS.md CHANGE_LOG.md
```

### Estadísticas

```bash
# Contar commits en el changelog
grep -c "### 🔄 Commit:" CHANGE_LOG.md || echo "0 commits registrados"

# Ver últimas actualizaciones
tail -30 CHANGE_LOG.md

# Contar skills totales
find .agents/skills -maxdepth 1 -type d | wc -l
```

---

## 🔐 Seguridad

### Permisos de Git Hooks

Los hooks se ejecutan con permisos de tu usuario:

```bash
# Ver permisos del hook
ls -la .git/hooks/post-commit

# Resultado: -rwxr-xr-x (usuario puede ejecutar)
```

### Auditoría

Todos los cambios automáticos se registran en:
- `CHANGE_LOG.md` - Cambios del código
- `.git/logs/` - Log de git
- `git reflog` - Historial de referencias

---

## 📖 Referencias

- [AGENTS.md](./AGENTS.md) - Sistema de agentes y skills
- [README.md](./README.md) - Guía general del proyecto
- [.agents/skills/README.md](./.agents/skills/README.md) - Índice de skills
- [Git Hooks Documentación](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)

---

## 🚨 Notas Importantes

### ⚠️ Commits Vacíos

Si haces un commit sin cambios relevantes, el hook se ejecutará pero no agregará entrada al changelog:

```bash
git commit --allow-empty -m "Empty commit"
# → Post-commit hook ejecutado
# → Pero sin cambios relevantes para registrar
```

### ⚠️ Rebases y Force Push

Si usas `git rebase` o `git push --force`, el hook no se ejecutará en commits históricos:

```bash
# Los hooks solo funcionan en commits NUEVOS
git push --force  # No ejecuta hook en commits anteriores
```

### ✅ Mejor Práctica

Para mantener sincronización perfecta:

```bash
# Hacer commit como siempre
git add .
git commit -m "Mi cambio"

# El hook se ejecuta automáticamente
# CHANGE_LOG.md se actualiza solo

# Opcionalmente, validar sincronización
./sync-docs.sh

# Ver resultado
git diff CHANGE_LOG.md
```

---

**Última actualización:** 23 de Febrero, 2026  
**Versión:** 1.0.0  
**Sistema de Sincronización:** Activo ✅  
**Mantenedor:** DNI-Connect Automation
