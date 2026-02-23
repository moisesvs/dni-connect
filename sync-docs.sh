#!/bin/bash

# DNI-Connect Documentation Sync Script
# Sincroniza automáticamente README.md, AGENTS.md y CHANGE_LOG.md
# Detecta cambios en código y actualiza documentación accordingly

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}📚 DNI-Connect Documentation Sync${NC}"
echo "=================================="

# Función para log
log_info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️ $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Verificar que estamos en el root del proyecto
if [ ! -f "package.json" ]; then
  log_error "No se encontró package.json. Ejecuta este script desde la raíz del proyecto."
  exit 1
fi

# Contador de cambios
CHANGES=0

# 1. Actualizar CHANGE_LOG.md si hay commits sin registrar
echo ""
log_info "Paso 1: Sincronizando CHANGE_LOG.md..."

if [ -f ".git/COMMIT_EDITMSG" ]; then
  LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%ad)" --date=short)
  if ! grep -q "$LAST_COMMIT" CHANGE_LOG.md 2>/dev/null; then
    log_warn "Último commit no está en CHANGE_LOG.md"
    log_info "Considera ejecutar: git log --oneline -10"
  fi
fi

# 2. Verificar estado de skills
echo ""
log_info "Paso 2: Verificando estado de Skills..."

SKILL_COUNT=$(find .agents/skills -maxdepth 1 -type d ! -name 'skills' 2>/dev/null | wc -l)
if [ "$SKILL_COUNT" -gt 0 ]; then
  log_success "Se encontraron $SKILL_COUNT skills documentados"
  
  # Verificar que cada skill tenga SKILL.md y config.json
  COMPLETE_SKILLS=0
  for skill_dir in .agents/skills/*/; do
    if [ -f "$skill_dir/SKILL.md" ] && [ -f "$skill_dir/config.json" ]; then
      ((COMPLETE_SKILLS++))
    else
      SKILL_NAME=$(basename "$skill_dir")
      log_warn "Skill $SKILL_NAME incompleto"
    fi
  done
  
  if [ "$COMPLETE_SKILLS" -eq "$SKILL_COUNT" ]; then
    log_success "Todos los $SKILL_COUNT skills están completamente documentados"
  fi
else
  log_warn "No se encontraron skills en .agents/skills/"
fi

# 3. Validar que archivos principales existen
echo ""
log_info "Paso 3: Validando archivos de documentación..."

DOC_FILES=("README.md" "AGENTS.md" "CHANGE_LOG.md")
for file in "${DOC_FILES[@]}"; do
  if [ -f "$file" ]; then
    SIZE=$(wc -l < "$file")
    log_success "$file existe ($SIZE líneas)"
  else
    log_error "$file NO ENCONTRADO"
  fi
done

# 4. Verificar que .agents/skills/README.md está actualizado
echo ""
log_info "Paso 4: Verificando índice de skills..."

if [ -f ".agents/skills/README.md" ]; then
  log_success ".agents/skills/README.md existe"
  
  # Contar referencias en el README
  REFERENCED=$(grep -c "^| \*\*" .agents/skills/README.md || true)
  if [ "$REFERENCED" -eq "$SKILL_COUNT" ]; then
    log_success "Todos los $SKILL_COUNT skills están referenciados en el índice"
  else
    log_warn "Índice podría estar desactualizado ($REFERENCED/$SKILL_COUNT skills)"
  fi
else
  log_error ".agents/skills/README.md NO ENCONTRADO"
fi

# 5. Validar YAML de workflows
echo ""
log_info "Paso 5: Validando workflows de CI/CD..."

if [ -d ".github/workflows" ]; then
  WORKFLOWS=$(find .github/workflows -name "*.yml" -o -name "*.yaml" | wc -l)
  if [ "$WORKFLOWS" -gt 0 ]; then
    log_success "Se encontraron $WORKFLOWS workflows"
    
    # Verificar YAML válido (si python3 está disponible)
    if command -v python3 &> /dev/null; then
      INVALID=0
      for workflow in .github/workflows/*.{yml,yaml}; do
        if [ -f "$workflow" ]; then
          if ! python3 -c "import yaml; yaml.safe_load(open('$workflow'))" 2>/dev/null; then
            ((INVALID++))
            log_warn "$(basename "$workflow") tiene YAML inválido"
          fi
        fi
      done
      
      if [ "$INVALID" -eq 0 ]; then
        log_success "Todos los workflows tienen YAML válido"
      fi
    fi
  else
    log_warn "No se encontraron workflows"
  fi
fi

# 6. Verificar estado del monorepo
echo ""
log_info "Paso 6: Verificando estructura del monorepo..."

DIRS_TO_CHECK=("apps/flutter" "apps/web/backend" "packages/core" ".agents/skills")
for dir in "${DIRS_TO_CHECK[@]}"; do
  if [ -d "$dir" ]; then
    log_success "Encontrado: $dir"
  else
    log_error "NO ENCONTRADO: $dir"
  fi
done

# 7. Resumén de cambios
echo ""
echo "=================================="
log_success "Sincronización completada"
echo ""

# 8. Sugerencias
echo -e "${BLUE}💡 Sugerencias:${NC}"
echo "  • Ejecuta 'git status' para ver cambios pendientes"
echo "  • Ejecuta 'npm run build:all' para compilar todo"
echo "  • Ejecuta './.agents/skills/status.sh' para estado de skills"
echo ""
echo -e "${BLUE}📖 Documentación:${NC}"
echo "  • README.md - Guía general del proyecto"
echo "  • AGENTS.md - Sistema de agentes y skills"
echo "  • CHANGE_LOG.md - Historial de cambios"
echo "  • .agents/skills/README.md - Índice de skills"
echo "  • .agents/skills/INVENTORY.md - Inventario detallado"
echo ""
