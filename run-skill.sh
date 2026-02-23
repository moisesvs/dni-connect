#!/usr/bin/env bash

##############################################################################
# DNI-Connect Skill Runner
# 
# Ejecuta skills especializados de agentes.
# Uso: ./run-skill.sh [skill-id] [--param value ...]
#
# Ejemplos:
#   ./run-skill.sh flutter-build --platform web --mode release
#   ./run-skill.sh backend-start --environment production
#   ./run-skill.sh qr-verification --qrData "base64data"
##############################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR"
SKILLS_DIR="$SCRIPT_DIR/.agents/skills"

# Funciones de utilidad
log_info() {
  echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
  echo -e "${RED}❌ $1${NC}"
}

# Mostrar ayuda
show_help() {
  cat <<EOF
${BLUE}DNI-Connect Skill Runner${NC}

Uso: $(basename "$0") [skill-id] [options]

Skills disponibles:

  Core Infrastructure:
    - flutter-build       Compilar Flutter (Web/Android/iOS)
    - backend-start       Iniciar servidor Node.js
    - monorepo-setup      Setup del monorepo

  Verification & Security:
    - qr-verification     Verificar QRs MiDNI
    - nfc-reading         Leer DNIe con PACE
    - crypto-validation   Validar certificados

  Data Management:
    - database-sync       Sincronizar con Firestore
    - storage-upload      Subir a Google Cloud Storage

  Quality & Deployment:
    - flutter-test        Tests de Flutter
    - backend-test        Tests del backend
    - deploy-backend      Deploy en Cloud Run

Opciones globales:
    -h, --help            Mostrar esta ayuda
    -v, --verbose         Modo verbose (debug)
    --dry-run             Mostrar qué se ejecutaría sin hacerlo

Ejemplos:
    $(basename "$0") flutter-build --platform web --mode release
    $(basename "$0") backend-start --environment production
    $(basename "$0") qr-verification --qrData "data"
    $(basename "$0") --help

Para más información, ver: $SKILLS_DIR/README.md
EOF
}

# Validar que existe el skill
validate_skill() {
  local skill_id="$1"
  
  if [[ ! -d "$SKILLS_DIR/$skill_id" ]]; then
    log_error "Skill no encontrado: $skill_id"
    log_info "Skills disponibles en: $SKILLS_DIR"
    exit 1
  fi
  
  if [[ ! -f "$SKILLS_DIR/$skill_id/config.json" ]]; then
    log_error "Configuración faltante: $SKILLS_DIR/$skill_id/config.json"
    exit 1
  fi
  
  if [[ ! -f "$SKILLS_DIR/$skill_id/SKILL.md" ]]; then
    log_warning "Documentación faltante: $SKILLS_DIR/$skill_id/SKILL.md"
  fi
}

# Cargar configuración del skill
load_config() {
  local skill_id="$1"
  local config_file="$SKILLS_DIR/$skill_id/config.json"
  
  cat "$config_file"
}

# Ejecutar skill (placeholder - será reemplazado por lógica real)
execute_skill() {
  local skill_id="$1"
  shift
  local args=("$@")
  
  log_info "Ejecutando skill: $skill_id"
  log_info "Argumentos: ${args[@]}"
  
  # Aquí iría la lógica de ejecución específica
  # Por ahora, solo mostramos que estaríamos ejecutándolo
  
  case "$skill_id" in
    flutter-build)
      log_info "Compilando Flutter..."
      # TODO: flutter build ${args[@]}
      ;;
    backend-start)
      log_info "Iniciando backend..."
      # TODO: npm start (en apps/web/backend)
      ;;
    qr-verification)
      log_info "Verificando QR..."
      # TODO: Llamar a API
      ;;
    nfc-reading)
      log_info "Leyendo NFC..."
      # TODO: Ejecutar NFC service
      ;;
    database-sync)
      log_info "Sincronizando datos..."
      # TODO: Llamar a Firestore sync
      ;;
    *)
      log_error "Skill no implementado: $skill_id"
      return 1
      ;;
  esac
  
  log_success "Skill ejecutado: $skill_id"
}

# Main
main() {
  if [[ $# -eq 0 ]]; then
    show_help
    exit 0
  fi
  
  local skill_id=""
  local verbose=false
  local dry_run=false
  
  # Parsear argumentos globales
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        show_help
        exit 0
        ;;
      -v|--verbose)
        verbose=true
        shift
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      -*)
        log_error "Opción desconocida: $1"
        exit 1
        ;;
      *)
        skill_id="$1"
        shift
        break
        ;;
    esac
  done
  
  if [[ -z "$skill_id" ]]; then
    log_error "Skill ID no especificado"
    show_help
    exit 1
  fi
  
  # Validar que el skill existe
  validate_skill "$skill_id"
  
  # Cargar configuración
  log_info "Cargando configuración..."
  config=$(load_config "$skill_id")
  [[ "$verbose" == "true" ]] && log_info "Config: $config"
  
  # Ejecutar
  if [[ "$dry_run" == "true" ]]; then
    log_warning "DRY RUN - No se ejecutará nada"
    log_info "Skill: $skill_id"
    log_info "Argumentos: $@"
  else
    execute_skill "$skill_id" "$@"
  fi
}

# Ejecutar main
main "$@"
