#!/bin/bash

# Script para lanzar Flutter Web y el backend

echo "🚀 Iniciando DNI-Connect..."
echo ""

# 1. Backend (si no está corriendo)
echo "📦 Verificando backend..."
if ! nc -z localhost 3001 2>/dev/null; then
  echo "Iniciando backend en puerto 3001..."
  cd /Users/e032284/Proyectos/DNI-Connect/dni-connect
  npm run dev:backend > /tmp/backend.log 2>&1 &
  sleep 5
fi

# 2. Flutter Web
echo "🎨 Compilando Flutter Web..."
cd /Users/e032284/Proyectos/DNI-Connect/dni-connect/apps/flutter

# Limpiar caché
flutter clean -q
flutter pub get -q

# Lanzar con espera
echo "⏳ Compilando (esto puede tomar 2-5 minutos)..."
flutter run -d chrome

echo "✅ Listo!"
