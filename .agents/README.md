# 🤖 Agentes y Automatización

Configuración de agentes y skills para automatizar tareas en el desarrollo de DNI-Connect.

## 📁 Estructura

```
.agents/
├── README.md                 # Este archivo
└── skills/                   # Librería de skills
    ├── README.md             # Guía de skills
    ├── flutter-build/        # Build Flutter Web/Android/iOS
    ├── backend-start/        # Iniciar servidor backend
    ├── qr-verification/      # Verificar QRs MiDNI
    ├── nfc-reading/          # Leer DNIe con PACE
    ├── database-sync/        # Sincronizar con Firestore
    └── crypto-validation/    # Validar certificados
```

## 🎯 Propósito

Los agentes son procesos automáticos (o semi-automáticos) que ejecutan **skills** especializados para:

- 🏗️ **Construcción**: Compilar el código (Flutter, Node.js)
- ✅ **Verificación**: Tests y validaciones
- 🚀 **Deployment**: Desplegar en producción
- 🔄 **Integración**: Sincronizar datos entre servicios
- 🔐 **Seguridad**: Validar certificados y firmas

## 🚀 Quick Start

### Listar skills disponibles

```bash
./run-skill.sh --help
```

### Ejecutar un skill

```bash
# Compilar Flutter para Web (release)
./run-skill.sh flutter-build --platform web --mode release

# Iniciar servidor backend
./run-skill.sh backend-start --environment development

# Verificar QR MiDNI
./run-skill.sh qr-verification --qrData "base64data"
```

### Ver documentación de un skill

```bash
cat .agents/skills/[skill-id]/SKILL.md
cat .agents/skills/[skill-id]/config.json
```

## 📚 Documentación

- **[AGENTS.md](../AGENTS.md)** - Documentación completa de agentes
- **[skills/README.md](skills/README.md)** - Guía de skills
- **[CHANGE_LOG.md](../CHANGE_LOG.md)** - Registro de cambios

## 🔧 Skills Disponibles

### 📦 Construcción & Infraestructura

| Skill | Descripción |
|-------|-------------|
| **flutter-build** | Compilar Flutter para Web/Android/iOS |
| **backend-start** | Iniciar servidor Node.js en puerto 3001 |
| **monorepo-setup** | Setup inicial (instalación de deps) |

### ✅ Verificación & Seguridad

| Skill | Descripción |
|-------|-------------|
| **qr-verification** | Verificar QRs MiDNI (ICAO 9303 Pt.13) |
| **nfc-reading** | Leer DNIe con protocolo PACE |
| **crypto-validation** | Validar certificados X.509 y firmas ECDSA |
| **pki-integration** | Gestionar PKI de policia.es |

### 💾 Datos & Sincronización

| Skill | Descripción |
|-------|-------------|
| **database-sync** | Sincronizar con Google Cloud Firestore |
| **storage-upload** | Subir fotos a Google Cloud Storage |

### 🧪 Tests & Quality

| Skill | Descripción |
|-------|-------------|
| **flutter-test** | Ejecutar tests de Flutter |
| **backend-test** | Ejecutar tests del backend |
| **deploy-backend** | Deploy en Google Cloud Run |

## 🎯 Casos de Uso Comunes

### 1. Compilar para producción

```bash
./run-skill.sh flutter-build --platform all --mode release --clean
```

**Qué ocurre**:
- ✅ Instala dependencias con `flutter pub get`
- ✅ Ejecuta análisis estático
- ✅ Compila para Web, Android e iOS
- ✅ Genera apks/aabs

### 2. Iniciar desarrollo local

```bash
./run-skill.sh backend-start --environment development
./run-skill.sh flutter-build --platform web --mode debug
```

**Qué ocurre**:
- ✅ Backend en http://localhost:3001
- ✅ Flutter web en http://localhost:5000
- ✅ Hot-reload habilitado

### 3. Verificar un QR

```bash
./run-skill.sh qr-verification \
  --qrData "xQICAkVTQkMyMzAx..." \
  --format base64 \
  --checkRevocation true
```

**Qué ocurre**:
1. Parsea VDS (header, message, signature)
2. Decodifica datos C40/TLV
3. Valida firma ECDSA
4. Verifica timestamp (< 5 min)
5. Comprueba revocación OCSP
6. Retorna datos verificados

### 4. Sincronizar datos

```bash
./run-skill.sh database-sync \
  --userId user@example.com \
  --method qr \
  --dniData '{...}' \
  --photoBase64 "..."
```

**Qué ocurre**:
- ✅ Guarda en Firestore
- ✅ Sube foto a GCS
- ✅ Actualiza historial
- ✅ Retorna URLs

## 🔌 Integración con Agentes

Los agentes pueden ser:

1. **Automáticos**: Ejecutados por CI/CD (GitHub Actions, Cloud Build)
2. **Manuales**: Ejecutados por desarrolladores
3. **Reactivos**: Disparados por webhooks
4. **Programados**: Ejecutados según schedule (cron)

### GitHub Actions Ejemplo

```yaml
# .github/workflows/build.yml
name: Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Flutter Build
        run: ./run-skill.sh flutter-build --platform all --mode release
```

### Cloud Build Ejemplo

```yaml
# cloudbuild.yaml
steps:
  - name: 'gcr.io/cloud-builders/docker'
    args:
      - 'run'
      - '--rm'
      - '-v'
      - '$(pwd):/workspace'
      - '-w'
      - '/workspace'
      - 'ubuntu:latest'
      - 'bash'
      - '-c'
      - './run-skill.sh flutter-build --platform web --mode release'
```

## 🛠️ Configurar Variables de Entorno

Crear `.agents/.env`:

```bash
# Backend
BACKEND_PORT=3001
BACKEND_ENV=development
JWT_SECRET=tu-secret-aqui

# Firebase
FIREBASE_PROJECT_ID=dni-connect-prod
FIREBASE_PRIVATE_KEY=...
FIREBASE_CLIENT_EMAIL=...

# Google Cloud
GOOGLE_CLOUD_STORAGE_BUCKET=dni-connect-images

# PKI
PKI_BASE_URL=http://pki.policia.es/cnp/MiDNI
OCSP_URL=http://ocsp.policia.es
```

Cargar en scripts:

```bash
source .agents/.env
```

## 📊 Monitoreo de Execuciones

Los skills pueden registrar logs:

```bash
# Ver logs de un skill
tail -f .agents/logs/flutter-build.log

# Ver todos los logs
ls -lht .agents/logs/
```

## ❓ Troubleshooting

### "Skill no encontrado"

```bash
# Verificar skills disponibles
./run-skill.sh --help

# Verificar que config.json existe
ls -la .agents/skills/[skill-id]/config.json
```

### "Permission denied"

```bash
# Hacer script ejecutable
chmod +x run-skill.sh
```

### "Timeout"

```bash
# Aumentar timeout en config.json
# O ejecutar con timeout mayor:
timeout 120s ./run-skill.sh [skill] [args]
```

## 📝 Crear un Nuevo Skill

Ver: [skills/README.md](skills/README.md#-crear-un-nuevo-skill)

## 🔗 Referencias

- [AGENTS.md](../AGENTS.md) - Agentes documentación
- [ARCHITECTURE.md](../docs/ARCHITECTURE.md) - Arquitectura
- [CHANGE_LOG.md](../CHANGE_LOG.md) - Registro cambios

**Última actualización**: 20 de febrero de 2026
