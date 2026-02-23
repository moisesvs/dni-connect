#!/bin/bash

# DNI-Connect Development Auto-Launch Script
# Lanza automáticamente la app Flutter web con hot reload

set -e

PROJECT_ROOT="/Users/e032284/Proyectos/DNI-Connect/dni-connect"
FLUTTER_DIR="$PROJECT_ROOT/apps/flutter"
BACKEND_DIR="$PROJECT_ROOT/apps/web/backend"

echo "🚀 DNI-Connect Development Environment"
echo "======================================"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function para lanzar backend
launch_backend() {
    if [ ! -d "$BACKEND_DIR" ]; then
        echo -e "${YELLOW}⚠️  Backend no encontrado en $BACKEND_DIR${NC}"
        return
    fi
    
    echo -e "${BLUE}📦 Iniciando Backend...${NC}"
    cd "$BACKEND_DIR"
    npm run dev > /tmp/backend.log 2>&1 &
    BACKEND_PID=$!
    echo -e "${GREEN}✅ Backend iniciado (PID: $BACKEND_PID)${NC}"
    sleep 3
}

# Function para lanzar Flutter
launch_flutter() {
    echo -e "${BLUE}🎨 Compilando Flutter Web...${NC}"
    cd "$FLUTTER_DIR"
    
    # Limpiar y preparar
    echo "📝 Limpiando caché..."
    /Users/e032284/Flutter-SDK/flutter/bin/flutter clean
    
    echo "📥 Obteniendo dependencias..."
    /Users/e032284/Flutter-SDK/flutter/bin/flutter pub get
    
    echo "🏗️  Compilando (esto puede tomar 2-5 minutos)..."
    /Users/e032284/Flutter-SDK/flutter/bin/flutter run -d chrome --verbose
}

# Function para matar procesos
cleanup() {
    echo -e "${YELLOW}⏹️  Limpiando procesos...${NC}"
    [ -n "$BACKEND_PID" ] && kill $BACKEND_PID 2>/dev/null || true
    echo -e "${GREEN}✅ Limpieza completada${NC}"
}

trap cleanup EXIT

# Lanzar
echo -e "${YELLOW}Iniciando servicios...${NC}"
echo ""

launch_backend
launch_flutter
