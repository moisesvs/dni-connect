#!/bin/bash

# Script para lanzar Flutter Web en Chrome

echo "🚀 Iniciando DNI-Connect Flutter Web..."

# Cambiar al directorio de Flutter
cd /Users/e032284/Proyectos/DNI-Connect/dni-connect/apps/flutter

if [ ! -f "pubspec.yaml" ]; then
  echo "❌ Error: pubspec.yaml no encontrado en $(pwd)"
  exit 1
fi

# Verificar Flutter
echo "📱 Flutter version:"
/Users/e032284/Flutter-SDK/flutter/bin/flutter --version

# Ejecutar Flutter
echo "⏳ Compilando y lanzando en Chrome..."
export FLUTTER_WEB=true
/Users/e032284/Flutter-SDK/flutter/bin/flutter run -d chrome

echo "✅ Flutter web en puerto 8080"
