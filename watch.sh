#!/usr/bin/env bash

##############################################################################
# Development Watch Script - Auto Hot Reload
#
# Monitorea cambios en Flutter y Backend, ejecutando hot reload automático
# Uso: ./watch.sh [flutter|backend|all] [platform]
##############################################################################

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR"

# Defaults
TARGET="${1:-all}"
PLATFORM="${2:-web}"

# Logging
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

log_flutter() {
  echo -e "${MAGENTA}📱 Flutter: $1${NC}"
}

log_backend() {
  echo -e "${MAGENTA}🔧 Backend: $1${NC}"
}

# Limpiar procesos al salir
cleanup() {
  log_warning "Deteniendo procesos..."
  kill 0 2>/dev/null || true
  log_success "Procesos detenidos"
}

trap cleanup EXIT INT TERM

# Validar herramientas
check_requirements() {
  if [[ "$TARGET" == "flutter" || "$TARGET" == "all" ]]; then
    if ! command -v flutter &> /dev/null; then
      log_error "Flutter no está instalado. Ver: https://flutter.dev/docs/get-started/install"
      exit 1
    fi
    log_success "Flutter SDK encontrado"
  fi
  
  if [[ "$TARGET" == "backend" || "$TARGET" == "all" ]]; then
    if ! command -v node &> /dev/null; then
      log_error "Node.js no está instalado"
      exit 1
    fi
    
    if ! command -v nodemon &> /dev/null; then
      log_warning "nodemon no está instalado. Instalando..."
      npm install --save-dev nodemon
    fi
    log_success "Node.js y nodemon encontrados"
  fi
}

# Watch Flutter
watch_flutter() {
  log_flutter "Iniciando watch mode..."
  cd "$PROJECT_ROOT/apps/flutter"
  
  # Verificar dependencias Flutter
  if [[ ! -d "build" ]]; then
    log_flutter "Instalando dependencias Flutter..."
    flutter pub get
  fi
  
  case "$PLATFORM" in
    web)
      log_flutter "Iniciando servidor web con hot reload..."
      flutter run -d web --web-port=5173
      ;;
    android)
      log_flutter "Iniciando en Android..."
      flutter run -d android
      ;;
    ios)
      log_flutter "Iniciando en iOS..."
      flutter run -d ios
      ;;
    *)
      log_error "Plataforma desconocida: $PLATFORM"
      exit 1
      ;;
  esac
}

# Watch Backend
watch_backend() {
  log_backend "Iniciando watch mode..."
  cd "$PROJECT_ROOT/apps/web/backend"
  
  # Verificar dependencias
  if [[ ! -d "node_modules" ]]; then
    log_backend "Instalando dependencias..."
    npm install
  fi
  
  # Compilar TypeScript
  if [[ ! -d "dist" ]]; then
    log_backend "Compilando TypeScript..."
    npm run build
  fi
  
  # Iniciar con nodemon
  log_backend "Iniciando servidor con auto-restart..."
  npx nodemon \
    --watch src \
    --ext ts,json \
    --exec 'npm run start' \
    --delay 1000ms \
    --ignore 'dist/**' \
    --ignore 'node_modules/**'
}

# Main
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   DNI-Connect Development Watch Mode${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
echo ""

log_info "Target: $TARGET"
log_info "Plataforma: $PLATFORM"
echo ""

check_requirements

case "$TARGET" in
  flutter)
    watch_flutter
    ;;
  backend)
    watch_backend
    ;;
  all)
    log_info "Iniciando ambas aplicaciones..."
    echo ""
    watch_backend &
    BACKEND_PID=$!
    sleep 2
    watch_flutter &
    FLUTTER_PID=$!
    
    wait
    ;;
  *)
    log_error "Target desconocido: $TARGET. Usa: flutter, backend, o all"
    exit 1
    ;;
esac
