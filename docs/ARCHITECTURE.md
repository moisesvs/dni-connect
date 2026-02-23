# DNI-Connect — Arquitectura del Sistema

## 1. Visión General

DNI-Connect es una solución multiplataforma (Web, Android, iOS) para la identificación digital
de usuarios mediante la lectura del DNIe español. Soporta dos mecanismos de identificación:

| Canal | Plataformas | Tecnología |
|-------|------------|------------|
| QR MiDNI (ICAO 9303 Pt.13) | Web, Android, iOS | Cámara + Visible Digital Seal |
| NFC DNIe (PACE + EAC) | Android, iOS | Chip NFC ISO 14443 |

---

## 2. Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CLIENTES                                     │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐               │
│  │  Web App  │    │ Android App  │    │   iOS App    │               │
│  │ React/TS  │    │  Kotlin/JC   │    │  Swift/SWUI  │               │
│  │           │    │              │    │              │               │
│  │ • QR Scan │    │ • QR Scan    │    │ • QR Scan    │               │
│  │           │    │ • NFC Read   │    │ • NFC Read   │               │
│  └─────┬─────┘    └──────┬───────┘    └──────┬───────┘               │
│        │                 │                   │                       │
│        └────────────┬────┴───────────────────┘                       │
│                     │ HTTPS / TLS 1.3                                │
└─────────────────────┼───────────────────────────────────────────────┘
                      │
┌─────────────────────┼───────────────────────────────────────────────┐
│                 BACKEND (Node.js / Express)                         │
│                     │                                               │
│  ┌──────────────────▼──────────────────────┐                        │
│  │         API Gateway / Auth              │                        │
│  │  • JWT Auth    • Rate Limiting          │                        │
│  │  • Input Validation                     │                        │
│  └──────────────────┬──────────────────────┘                        │
│                     │                                               │
│  ┌──────────────────▼──────────────────────┐                        │
│  │       Módulo de Verificación QR         │                        │
│  │  1. Decodificar VDS (ICAO 9303 Pt.13)  │                        │
│  │  2. Parsear TLV + C40                   │                        │
│  │  3. Extraer ref. certificado            │                        │
│  │  4. Descargar cert de PKI policia.es    │                        │
│  │  5. Comprobar OCSP                      │                        │
│  │  6. Verificar firma ECDSA              │                        │
│  │  7. Comprobar caducidad (5 min)         │                        │
│  └──────────────────┬──────────────────────┘                        │
│                     │                                               │
│  ┌──────────────────▼──────────────────────┐                        │
│  │      Módulo de Sincronización           │                        │
│  │  • Google Cloud Storage                 │                        │
│  │  • Firestore                            │                        │
│  │  • Encriptación AES-256-GCM en reposo   │                        │
│  └─────────────────────────────────────────┘                        │
│                                                                     │
│  Servicios Externos:                                                │
│  • PKI: http://pki.policia.es/cnp/MiDNI                            │
│  • OCSP: http://ocsp.policia.es                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 3. Flujo de Validación — QR MiDNI

```
Usuario genera QR ──▶ Escanea con cámara ──▶ Decodifica bytes ──▶
                                                                  │
  ┌───────────────────────────────────────────────────────────────┘
  │
  ▼
┌─────────────────────────────────────────────────────────┐
│ 1. DECODIFICAR: Raw bytes → Header + Message + Signature│
│    • Header: Magic, Version, Issuing Country, Cert Ref  │
│    • Message: TLV structures codificadas en C40          │
│    • Signature: bytes ECDSA                              │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 2. EXTRAER CERT REF del Header                          │
│    → Identificador del certificado firmante              │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 3. DESCARGAR CERTIFICADO desde PKI policia.es           │
│    GET http://pki.policia.es/cnp/MiDNI/{cert_ref}       │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 4. VERIFICAR ESTADO OCSP                                │
│    POST http://ocsp.policia.es                           │
│    → Certificado válido / revocado / desconocido         │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 5. VERIFICAR FIRMA ECDSA                                │
│    • Clave pública del certificado descargado            │
│    • Datos firmados = Header + Message                   │
│    • Firma = Signature del QR                            │
│    → ECDSA.verify(pubKey, data, signature)               │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 6. VERIFICAR CADUCIDAD                                   │
│    • Extraer timestamp de generación del mensaje         │
│    • Si (now - timestamp) > 5 minutos → RECHAZAR         │
│    • Si ≤ 5 minutos → ACEPTAR                            │
└───────────────────────┬─────────────────────────────────┘
                        ▼
              ✅ IDENTIDAD VERIFICADA
              → Sincronizar a Google Cloud
```

---

## 4. Flujo de Validación — NFC DNIe

```
Usuario introduce CAN/MRZ ──▶ Acerca DNI al dispositivo ──▶
                                                             │
  ┌──────────────────────────────────────────────────────────┘
  │
  ▼
┌─────────────────────────────────────────────────────────┐
│ 1. LEER CardAccess (File 011C)                          │
│    → Determinar algoritmos PACE soportados               │
│    (PACE-ECDH-GM-AES-CBC-CMAC-128 / PACE-DH-GM-...)     │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 2. ESTABLECER CANAL PACE                                │
│    • Entrada: CAN o MRZ como password                    │
│    • Negociación DH/ECDH                                 │
│    • Derivación de claves de sesión (AES-CBC-CMAC)       │
│    • Canal seguro establecido                            │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 3. AUTENTICACIÓN DEL CHIP (EAC - Chip Authentication)   │
│    • Verificar autenticidad del chip NFC                  │
│    • Prevenir clonación                                   │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 4. LEER DATOS                                            │
│    • SOD File (hashes firmados)                          │
│    • DG1: Datos biográficos (nombre, fecha nac., etc.)   │
│    • DG2: Foto facial                                    │
│    • DG11: Domicilio                                     │
└───────────────────────┬─────────────────────────────────┘
                        ▼
┌─────────────────────────────────────────────────────────┐
│ 5. VERIFICAR INTEGRIDAD                                  │
│    • Calcular hash de cada DG leído                      │
│    • Comparar con hashes firmados en SOD                  │
│    • Verificar firma del SOD contra CSCA                  │
│    → Datos auténticos y no manipulados                   │
└───────────────────────┬─────────────────────────────────┘
                        ▼
              ✅ IDENTIDAD VERIFICADA
              → Sincronizar a Google Cloud
```

---

## 5. Stack Tecnológico

| Componente | Tecnología | Justificación |
|-----------|-----------|---------------|
| Web Frontend | React 18 + TypeScript + Vite | SPA moderna, tipado fuerte |
| Web Backend | Node.js + Express + TypeScript | Compartir lógica cripto con frontend |
| Android | Kotlin + Jetpack Compose | UI moderna, NFC nativo |
| iOS | Swift + SwiftUI | UI moderna, CoreNFC |
| Base de datos | Google Firestore | Tiempo real, serverless |
| Almacenamiento | Google Cloud Storage | Documentos y fotos |
| Auth | Firebase Authentication | SSO integrado |
| CI/CD | GitHub Actions | Automatización |

---

## 6. Seguridad

- **Transporte**: TLS 1.3 en todas las comunicaciones
- **Datos en reposo**: AES-256-GCM para datos sensibles en Firestore
- **Datos biométricos**: Nunca se almacenan en texto plano; se hashean o cifran
- **Certificados**: Validación completa de cadena PKI + OCSP
- **Sesiones**: JWT con expiración corta (15 min) + refresh tokens
- **NFC**: Canal PACE con cifrado AES de sesión
- **QR**: Ventana de validez de 5 minutos estricta

---

## 7. Estructura del Monorepo

```
dni-connect/
├── docs/                          # Documentación
│   ├── ARCHITECTURE.md
│   └── UI_FLOWS.md
├── packages/
│   └── core/                      # Lógica compartida (TypeScript)
│       ├── src/
│       │   ├── icao/              # Parser ICAO 9303 Pt.13
│       │   ├── crypto/            # ECDSA, OCSP, PKI
│       │   ├── tlv/               # Parser TLV
│       │   ├── c40/               # Decodificador C40
│       │   └── types/             # Tipos compartidos
│       ├── package.json
│       └── tsconfig.json
├── apps/
│   ├── web/                       # Aplicación Web
│   │   ├── frontend/              # React + Vite
│   │   └── backend/               # Node.js + Express
│   ├── android/                   # App Android (Kotlin)
│   └── ios/                       # App iOS (Swift)
├── package.json                   # Workspace root
└── README.md
```
