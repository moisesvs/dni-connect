# 📋 Change Log - DNI-Connect

Registro de cambios y evolución de la aplicación DNI-Connect. Cada cambio significativo se documenta aquí para mantener la trazabilidad del desarrollo.

## 🔄 Versionado

- **Formato**: CHANGELOG sigue [Keep a Changelog](https://keepachangelog.com/)
- **Actualización**: Se actualiza con cada merge a `main` o cambio significativo
- **Ramas**: Los cambios en `develop` se reportan en sección "Unreleased"

---

## [Unreleased]

### 📝 Agregado

- ✨ VDS Parser en Dart para parsing offline de QRs MiDNI
- 🤖 Sistema de Skills/Agents para ejecutar tareas especializadas
- 📚 Documentación AGENTS.md con 6 skills principales
- 📊 Estructura `.agents/skills/` con configs y documentación
- 🎯 Skills: flutter-build, backend-start, qr-verification, nfc-reading, database-sync, crypto-validation

### 🔧 Modificado

- N/A

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
