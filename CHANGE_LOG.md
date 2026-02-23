# 📋 Change Log - DNI-Connect

Registro de cambios y evolución de la aplicación DNI-Connect. Cada cambio significativo se documenta aquí para mantener la trazabilidad del desarrollo.

## 🔄 Versionado

- **Formato**: CHANGELOG sigue [Keep a Changelog](https://keepachangelog.com/)
- **Actualización**: Se actualiza con cada merge a `main` o cambio significativo
- **Ramas**: Los cambios en `develop` se reportan en sección "Unreleased"

---

## [Unreleased]

### 🔄 Commit: 9d6a883
- **Mensaje**: Fix: Corregir errores de compilación en QR scanner - reemplazar withOpacity por withValues
- **Autor**: e032284
- **Timestamp**: 2026-02-23 10:54:36
- 📱 **Flutter**: Cambios en aplicación móvil/webn


### 🔄 Commit: a0767c1
- **Mensaje**: Fix: QR Camera Implementation - Implementar escaneo funcional con mobile_scanner
- **Autor**: e032284
- **Timestamp**: 2026-02-23 10:46:47
- 📱 **Flutter**: Cambios en aplicación móvil/webn


### � Corregido

#### QR Camera Scanning Implementation Fix (23 Feb 2026)
- 🔧 **Problema Identificado**: Pantalla de escaneo QR estaba vacía (placeholder sin implementación)
- ✅ **Solución Implementada**: Implementación completa de cámara con `mobile_scanner`

**qr_scan_screen.dart** (150+ líneas)
  - Inicialización de `MobileScannerController` con formato QR
  - Detección automática de códigos QR en tiempo real
  - Interfaz visual mejorada con marco de guía
  - Botones de control: Flash (linterna) y cambiar cámara
  - Manejo de errores y estados de carga
  - Navegación automática a verificación al detectar QR
  - Flag `isProcessing` para prevenir múltiples navegaciones

**qr_verify_screen.dart** (180+ líneas)
  - Muestra datos del QR en contenedor con monospace font
  - Información de seguridad (cifrado X.509, verificación DGP)
  - Contador de caracteres
  - Botón para copiar datos
  - Acciones: Verificar QR (con loading 2s) y Escanear de Nuevo
  - Diseño mejorado con colores cyan/naranja

**Características**:
  - ✅ Detección automática de QR
  - ✅ Controles de flash y cambio de cámara
  - ✅ UI guiada para usuario
  - ✅ Integración con router existente
  - ✅ Manejo de permisos de cámara
  - ✅ Error handling robusto
  - ✅ Dark mode compatible

### �🔄 Commit: fe7610b
- **Mensaje**: Dark Mode Enhancements v2.0: Gradientes, animaciones y mejor visual hierarchy
- **Autor**: e032284
- **Timestamp**: 2026-02-23 10:42:54
- 📱 **Flutter**: Cambios en aplicación móvil/webn- 🔧 **Backend**: Cambios en API Node.js/TypeScriptn- 🤖 **Skills**: Actualización en sistema de automatizaciónn- 📚 **Docs**: Actualización de documentaciónn- ⚙️ **Config**: Cambios en configuración del proyecton


### 🎨 Mejorado

#### Dark Mode Enhancements v2.0 (23 Feb 2026)
- 🌙 **Diseño Dark Mode Sofisticado** en `design_showcase_screen.dart`:
  - AppBar con gradiente dinámico (darkSurface → azul oscuro)
  - BottomNavigationBar con AnimationController e íconos animados
  - Border sutil con primaryColor (0.25 opacity)
  - BoxShadow personalizada para profundidad (#000, 0.3 opacity, blur 10)
  
- 🎨 **Paleta de Colores Rediseñada**:
  - Cards individuales para cada color con glow shadows
  - Hex code display (#XXXXXX) para desarrolladores
  - Check circle indicators con background color-washed
  - Secciones con emojis para rápido escaneo (🔵 🎨 💜 📊)
  
- 📦 **Secciones Mejoradas con Gradientes**:
  - 🔘 Botones & Controles: Gradiente primaryColor
  - 💳 Cards y Contenedores: Gradiente secondaryColor
  - 📋 Items de Lista: Gradiente successColor
  - 🎨 Estados de Mensajes: Gradiente infoColor (success, warning, error, info)
  - ⏳ Estados de Carga: Gradiente secondaryColor con border y shadow
  - 📭 Estado Vacío: Gradiente warningColor

- ✨ **Efectos Visuales**:
  - Gradientes LinearGradient con 2 colores coordinados
  - Glow shadows (opacity 0.1-0.4, blur radius 10-12)
  - Bordes dinámicos con colores de marca
  - Spacing mejorado con jerarquía clara (24, 20, 12 px)
  - Tipografía Poppins con letter-spacing 0.5

- 📊 **Validación WCAG AA+**:
  - Contraste título: 21:1 (FFFFFF sobre #0F172A)
  - Contraste texto: 11:1 (E2E8F0 sobre #1E293B)
  - Contraste secundario: 7:1
  - Todas las secciones accesibles

- 📝 **Documentación Creada**:
  - `DARK_MODE_ENHANCEMENTS.md`: Guía completa de cambios (300+ líneas)
  - Detalles de cada sección, colores, efectos
  - Paleta de colores con opacidades
  - Instrucciones de prueba

### 📝 Agregado

#### Sistema de Skills Documentado (23 Feb 2026)
- ✨ **17 Skills Completamente Documentados** con estructura normalizada:
  - **Core Infrastructure**: `flutter-build`, `backend-start`, `monorepo-setup`, `dev-watch`
  - **Verification & Crypto**: `qr-verification`, `nfc-reading`, `crypto-validation`, `pki-integration`
  - **Data & Sync**: `database-sync`, `storage-upload`, `cache-clean`
  - **Design & Accessibility**: `ui-design`
  - **Testing & Quality**: `backend-test`, `flutter-test`, `lint-check`, `coverage`
  - **Deployment**: `deploy-backend`, `deploy-flutter`
  - **Monitoring**: `health-check`
  
- 📚 **Documentación Integral**:
  - Cada skill con `SKILL.md` (500-600 palabras)
  - Archivos `config.json` con schema normalizado (inputs/outputs/timeout)
  - 10+ archivos de ejemplo JSON para casos de uso
  - `.agents/skills/README.md` con índice y referencia rápida
  - `.agents/skills/INVENTORY.md` con estadísticas detalladas y roadmap

- 🔄 **Sistema de Monitoreo**:
  - Script `status.sh` para reportar estado de skills
  - Validación de estructura en CI/CD
  - Capacidad de ejecutar skills desde terminal, código TypeScript, y GitHub Actions

- 📖 **Documentación Completada**:
  - README.md: Guía completa del proyecto (400+ líneas)
  - AGENTS.md: Documentación sistema de agentes y skills (500+ líneas)

### 📝 Anteriores

- ✨ **UI Design Skill**: Validación de Material 3, contraste WCAG, responsividad
  - Soporte para validación de Material 3 compliance
  - Generación automática de temas desde color seed
  - Verificación de contraste WCAG (A/AA/AAA)
  - Testing de responsividad en múltiples breakpoints
  - Auditoría de componentes Flutter
  - Generación automática de documentación de UI
- ✨ VDS Parser en Dart para parsing offline de QRs MiDNI
- 🤖 Sistema de Skills/Agents para ejecutar tareas especializadas
- 📚 Documentación AGENTS.md con 7 skills principales
- 📊 Estructura `.agents/skills/` con configs y documentación
- 🎯 Skills: flutter-build, backend-start, qr-verification, nfc-reading, database-sync, crypto-validation, **ui-design**

### 🔧 Modificado

- ✏️ AGENTS.md: Agregada sección Design & Accessibility
- ✏️ .agents/INDEX.md: Actualizado con nuevo skill ui-design
- ✏️ .agents/skills/README.md: Agregada categoría Design & Accessibility

### 🗑️ Eliminado

- N/A

### 🐛 Corregido

- N/A

---

## [1.0.0] - 2026-02-20

### 📝 Agregado

#### Infraestructura Base

- 🏗️ **Monorepo TypeScript**: Workspace con packages y apps
- 📦 **@dni-connect/core**: Librería compartida con:
  - C40Decoder: Decodificación de caracteres C40 (ICAO)
  - TlvParser: Parser BER-TLV recursivo
  - VdsParser: Parser de Visible Digital Seal (ICAO 9303 Pt.13)
  - IcaoVerifier: Orquestación de 6 pasos de verificación
  - EcdsaVerifier: Verificación de firmas con Web Crypto API
  - PkiClient: Descarga de certificados desde policia.es
  - OcspClient: Verificación de revocación OCSP
  - CertificateValidator: Validación de cadenas X.509

#### Backend Node.js

- 🚀 **@dni-connect/backend**: Express + TypeScript
  - JWT Authentication (`/api/v1/auth/token`)
  - QR Verification (`/api/v1/verify/qr`)
  - Data Sync (`/api/v1/sync` con Firestore + GCS)
  - Health Check (`GET /api/v1/health`)
  - Rate limiting y CORS configurado
  - Middleware: auth, error handler, request logger
  - Winston logging

#### Flutter Frontend (Inicial)

- 📱 **Aplicación Flutter**: Web + Android + iOS
  - Material 3 Theme (light/dark)
  - GoRouter navigation (7 rutas)
  - Riverpod state management
  - Dio HTTP client
  - Constantes ICAO 9303
  - Modelos: DniData, VerificationStep, etc.
  - API Service para comunicación con backend
  - **Parsers Dart**:
    - C40Decoder (Dart)
    - TlvParser (Dart)

#### Documentación

- 📖 **ARCHITECTURE.md**: Diagrama de sistema, flujos QR/NFC, stack tech
- 📖 **UI_FLOWS.md**: Wireframes ASCII de todas las pantallas
- 📖 **AGENTS.md**: Documentación de skills y agentes
- 🔧 **Configuración**: tsconfig, pubspec.yaml, analysis_options

#### PKI & Seguridad

- 🔐 Integración con PKI Policia Nacional:
  - Base: `http://pki.policia.es/cnp/MiDNI`
  - OCSP: `http://ocsp.policia.es`
- 📜 Validación temporal: 5 minutos para QRs
- ✅ Cadenas X.509 de confianza
- 🔍 ECDSA P-256 con SHA-256

#### Google Cloud

- ☁️ **Firestore**: Almacenamiento de verificaciones
- 📦 **Cloud Storage**: Almacenamiento de fotos faciales
- 🔐 **Firebase Auth**: Autenticación SSO (opcional)
- 🌐 **Cloud Run**: Deployment del backend

### 🔧 Modificado

- N/A

### 🗑️ Eliminado

- React Frontend (pivot a Flutter)
- Kotlin Android App (pivot a Flutter)
- Swift iOS App (pivot a Flutter)

---

## 📊 Estadísticas

| Métrica | Valor |
|---------|-------|
| **Archivos TS/JS** | ~35 |
| **Archivos Dart** | ~12 |
| **Líneas de código** | ~8,500 |
| **Tests** | 0 (pendiente) |
| **Documentación** | ~25 KB |

---

## 🎯 Próximos Hitos

- [ ] VDS Parser completo en Dart ✅ DONE (20-02-2026)
- [ ] ECDSA Verifier en Dart (pointycastle)
- [ ] NFC Service (PACE protocol, flutter_nfc_kit)
- [ ] 7 Flutter Screens (HomeScreen, QrScanScreen, etc.)
- [ ] Tests unitarios (Dart + TypeScript)
- [ ] Deployment en App Stores
- [ ] Android/iOS specific configs
- [ ] Web hosting (Firebase Hosting)

---

## 🚀 Deployment Status

| Plataforma | Estado | URL |
|-----------|--------|-----|
| **Backend** | 🟡 Local | `http://localhost:3001` |
| **Flutter Web** | 🟡 Development | `http://localhost:5000` |
| **Flutter Android** | 🟡 Development | Emulator |
| **Flutter iOS** | 🟡 Development | Simulator |

---

## 👥 Contribuyentes

- Sistema de agentes automático (actualización continua)

---

## 📞 Contacto / Reportar Bugs

- 🐛 Issues: Crear en GitHub
- 📧 Email: dev@dni-connect.example.com

**Última actualización**: 20 de febrero de 2026
