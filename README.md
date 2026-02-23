# 🪪 DNI-Connect

**Solución multiplataforma para la verificación segura de identidad digital mediante DNIe (NFC) y QR MiDNI**

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Node.js](https://img.shields.io/badge/node-%3E%3D20.0.0-green)](https://nodejs.org/)
[![TypeScript](https://img.shields.io/badge/typescript-5.4-blue)](https://www.typescriptlang.org/)

---

## 📋 Contenido

- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Scripts Disponibles](#scripts-disponibles)
- [Arquitectura](#arquitectura)
- [Flujos de Verificación](#flujos-de-verificación)
- [Configuración](#configuración)
- [Desarrollo](#desarrollo)
- [Pruebas](#pruebas)
- [Despliegue](#despliegue)
- [Contribución](#contribución)
- [Licencia](#licencia)

---

## ✨ Características

### Métodos de Verificación

- **🔐 QR MiDNI (ICAO 9303 Pt.13)**
  - Lectura mediante cámara
  - Disponible en Web, Android e iOS
  - Validación de firma ECDSA
  - Verificación de certificados PKI

- **📱 NFC DNIe (PACE + EAC)**
  - Lectura del chip NFC del DNI
  - Disponible en Android e iOS
  - Autenticación PACE
  - Verificación de autenticidad del chip

### Plataformas Soportadas

| Plataforma | QR MiDNI | NFC DNIe | Tecnología |
|------------|----------|----------|-----------|
| **Web** | ✅ | ❌ | React/TypeScript |
| **Android** | ✅ | ✅ | Kotlin/Compose |
| **iOS** | ✅ | ✅ | Swift/SwiftUI |

### Características de Seguridad

- Validación de firma ECDSA en QR
- Verificación de estado OCSP de certificados
- Encriptación AES-256-GCM en reposo
- Sincronización segura a Google Cloud Storage
- Rate limiting y protección contra ataques
- Autenticación JWT

---

## 🔧 Requisitos Previos

- **Node.js** ≥ 20.0.0
- **npm** o **yarn**
- **TypeScript** 5.4+
- **Flutter** (para apps móviles)
- **Kotlin** (para Android)
- **Swift** (para iOS)

### Credenciales Requeridas

- Credenciales de **Google Cloud** (Firestore + Storage)
- Acceso a **PKI de la Policía Nacional** (`pki.policia.es`)
- Acceso a **OCSP** de la Policía Nacional (`ocsp.policia.es`)

---

## 📦 Instalación

### 1. Clonar el Repositorio

```bash
git clone <repository-url>
cd dni-connect
```

### 2. Instalar Dependencias

```bash
npm install
```

### 3. Configurar Variables de Entorno

Crear archivos `.env` en los directorios correspondientes:

#### Backend (`apps/web/backend/.env`)

```env
# Server
PORT=3000
NODE_ENV=development
LOG_LEVEL=info

# Google Cloud
GOOGLE_PROJECT_ID=your-project-id
GOOGLE_APPLICATION_CREDENTIALS=path/to/credentials.json

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRATION=24h

# PKI
PKI_BASE_URL=http://pki.policia.es/cnp/MiDNI
OCSP_URL=http://ocsp.policia.es

# CORS
CORS_ORIGIN=http://localhost:3001
```

#### Frontend (`apps/web/frontend/.env`)

```env
REACT_APP_API_URL=http://localhost:3000
REACT_APP_ENV=development
```

---

## 🏗️ Estructura del Proyecto

```
dni-connect/
├── apps/
│   ├── flutter/                 # App móvil (Android/iOS)
│   │   ├── lib/
│   │   │   ├── app.dart        # Configuración app
│   │   │   ├── main.dart       # Entry point
│   │   │   ├── core/
│   │   │   │   ├── constants/  # Constantes
│   │   │   │   ├── icao/       # Parseo ICAO
│   │   │   │   ├── models/     # Modelos de datos
│   │   │   │   ├── router/     # Navegación
│   │   │   │   ├── services/   # Servicios
│   │   │   │   ├── theme/      # Temas UI
│   │   │   │   └── widgets/    # Componentes
│   │   └── pubspec.yaml        # Dependencias Flutter
│   │
│   └── web/
│       ├── backend/             # API REST (Node.js/Express)
│       │   ├── src/
│       │   │   ├── server.ts    # Servidor principal
│       │   │   ├── middleware/  # Middleware
│       │   │   ├── routes/      # Rutas API
│       │   │   └── utils/       # Utilidades
│       │   ├── package.json
│       │   └── tsconfig.json
│       │
│       └── frontend/             # App Web (React)
│           ├── src/
│           ├── package.json
│           └── tsconfig.json
│
├── packages/
│   └── core/                    # Librería compartida (TypeScript)
│       ├── src/
│       │   ├── constants.ts     # Constantes globales
│       │   ├── index.ts         # Exports
│       │   ├── c40/             # Decodificación C40
│       │   ├── crypto/          # Criptografía
│       │   │   ├── certificate-validator.ts
│       │   │   ├── ecdsa-verifier.ts
│       │   │   ├── ocsp-client.ts
│       │   │   └── pki-client.ts
│       │   ├── icao/            # Estándares ICAO
│       │   │   ├── icao-verifier.ts
│       │   │   └── vds-parser.ts
│       │   ├── tlv/             # Parseo TLV
│       │   └── types/           # Tipos TypeScript
│       ├── package.json
│       └── tsconfig.json
│
├── docs/
│   ├── ARCHITECTURE.md          # Documentación de arquitectura
│   └── UI_FLOWS.md             # Flujos de interfaz usuario
│
├── package.json                 # Monorepo root
├── tsconfig.base.json          # Config TypeScript base
└── README.md                   # Este archivo
```

---

## 🚀 Scripts Disponibles

### Desarrollo

```bash
# Desarrollo web completo (backend + frontend)
npm run dev:web

# Solo backend
npm run dev:backend

# Solo frontend
npm run dev:frontend
```

### Build

```bash
# Build del paquete core
npm run build:core

# Build de todas las aplicaciones
npm run build:all

# Build específico
npm run build:frontend
npm run build:backend
```

### Testing y Linting

```bash
# Ejecutar tests
npm run test

# Lint de código
npm run lint
```

---

## 🏛️ Arquitectura

### Diagrama General

```
┌─────────────────────────────────────────────────────┐
│              CLIENTES (Web/Android/iOS)             │
│         • QR Scan  • NFC Read (móvil)              │
└──────────────┬────────────────────────────────────┘
               │ HTTPS/TLS 1.3
               ▼
┌─────────────────────────────────────────────────────┐
│           BACKEND (Node.js/Express)                 │
│  • API Gateway  • Auth JWT  • Rate Limiting        │
│  • QR Validator • NFC Handler                      │
│  • Data Sync    • Google Cloud Integration         │
└──────────────┬────────────────────────────────────┘
               │
        ┌──────┴──────┐
        ▼             ▼
   ┌────────────┐ ┌──────────────┐
   │ Google     │ │ PKI Policia  │
   │ Cloud      │ │ + OCSP       │
   │ (Firestore)│ │ (policia.es) │
   └────────────┘ └──────────────┘
```

### Capas de la Aplicación

1. **Frontend Layer** - UI responsiva (Web/Móvil)
2. **API Gateway** - Express.js con middleware de seguridad
3. **Core Business Logic** - Validación y procesamiento
4. **Crypto Layer** - ECDSA, PACE, EAC, OCSP
5. **Storage Layer** - Google Cloud (Firestore + Storage)

---

## 🔍 Flujos de Verificación

### Flujo QR MiDNI

```
1. Usuario escanea QR generado en MiDNI
   ↓
2. Backend decodifica y extrae datos
   ↓
3. Extrae referencia de certificado
   ↓
4. Descarga certificado desde PKI
   ↓
5. Verifica estado OCSP (válido/revocado)
   ↓
6. Valida firma ECDSA
   ↓
7. Verifica caducidad (< 5 minutos)
   ↓
✅ Identidad verificada → Sincroniza a Google Cloud
```

### Flujo NFC DNIe (Móvil)

```
1. Usuario introduce CAN/MRZ
   ↓
2. Acerca DNI al dispositivo
   ↓
3. Establece canal PACE (DH/ECDH)
   ↓
4. Autenticación del chip (EAC)
   ↓
5. Lee datos del chip (DG1, etc.)
   ↓
6. Valida datos y firma
   ↓
✅ Identidad verificada
```

---

## ⚙️ Configuración

### Credenciales de Google Cloud

1. Crear proyecto en [Google Cloud Console](https://console.cloud.google.com/)
2. Habilitar Firestore y Cloud Storage
3. Descargar JSON de credenciales
4. Configurar variable `GOOGLE_APPLICATION_CREDENTIALS`

### Conectar con PKI

El sistema se conecta automáticamente a:
- **PKI**: `http://pki.policia.es/cnp/MiDNI/{cert_ref}`
- **OCSP**: `http://ocsp.policia.es`

No requiere configuración adicional si el servidor tiene acceso a estas URLs.

---

## 👨‍💻 Desarrollo

### Estructura del Código

- **Backend**: TypeScript + Express.js
- **Frontend Web**: React + TypeScript
- **Apps Móviles**: Flutter + Dart/Kotlin/Swift
- **Core**: Librería compartida TypeScript

### Convenciones de Código

- **Naming**: camelCase para variables/funciones, PascalCase para clases/tipos
- **Estructura**: Separación por funcionalidad (features)
- **Testing**: Vitest para tests unitarios

### Ejemplo: Agregar Nueva Funcionalidad

1. Crear el módulo en `packages/core`
2. Implementar en el backend (`apps/web/backend/src`)
3. Integrar en frontend según plataforma
4. Escribir tests
5. Documentar cambios

---

## 🧪 Pruebas

### Ejecutar Tests

```bash
# Tests de todo el monorepo
npm run test

# Tests de un workspace específico
npm run test --workspace=packages/core
```

### Test Coverage

```bash
npm run test -- --coverage
```

---

## 🚢 Despliegue

### Backend

```bash
# Build
npm run build:backend

# Ejecutar en producción
NODE_ENV=production npm start --workspace=apps/web/backend
```

### Frontend Web

```bash
# Build
npm run build:frontend

# Servir con servidor estático
# (distribuir contenido de dist/)
```

### Apps Móviles

```bash
# Flutter build
cd apps/flutter

# iOS
flutter build ios

# Android
flutter build apk
```

---

## 📝 Documentación Adicional

- **[Arquitectura Detallada](docs/ARCHITECTURE.md)** - Información técnica profunda
- **[Flujos de UI/UX](docs/UI_FLOWS.md)** - Pantallas y experiencia de usuario

---

## 🤝 Contribución

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Guías de Contribución

- Sigue las convenciones de código del proyecto
- Escribe tests para nuevas funcionalidades
- Actualiza la documentación según sea necesario
- Asegúrate de que todos los tests pasen

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

---

## 📞 Soporte

Para reportar problemas o sugerencias:

- **Issues**: Abre un issue en el repositorio
- **Discussions**: Participa en las discusiones del proyecto

---

## 🙏 Agradecimientos

- **Policía Nacional** por infraestructura PKI y OCSP
- **ICAO** por especificaciones de documentos de viaje
- Comunidad de desarrolladores

---

**Última actualización:** Febrero 2026
