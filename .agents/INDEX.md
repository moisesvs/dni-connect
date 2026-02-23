# 📑 Índice de Documentación de Agentes

Guía rápida para navegar la documentación de agentes y skills en DNI-Connect.

## 🎯 Para Empezar Rápido

1. **Soy nuevo en el proyecto**: Lee [../AGENTS.md](../AGENTS.md)
2. **Quiero ejecutar un skill**: Usa `./run-skill.sh --help`
3. **Necesito documentación de un skill específico**: Ve a [skills/](skills/)

## 📚 Documentación Principal

| Archivo | Propósito | Audiencia |
|---------|-----------|-----------|
| [../AGENTS.md](../AGENTS.md) | Overview de agentes y skills | Todos |
| [../CHANGE_LOG.md](../CHANGE_LOG.md) | Registro de cambios del proyecto | Todos |
| [README.md](README.md) | Guía de agentes y automatización | Desarrolladores |
| [skills/README.md](skills/README.md) | Guía completa de skills | Desarrolladores |
| [skills/TEMPLATE.md](skills/TEMPLATE.md) | Template para nuevos skills | Mantenedores |

## 🤖 Documentación de Skills

### Construcción & Infraestructura

- [**flutter-build**](skills/flutter-build/SKILL.md) - Compilar Flutter
- [**backend-start**](skills/backend-start/SKILL.md) - Iniciar backend
- [**dev-watch**](skills/dev-watch/SKILL.md) - Monitoreo en desarrollo

### Verificación & Seguridad

- [**qr-verification**](skills/qr-verification/SKILL.md) - Verificar QRs MiDNI
- [**nfc-reading**](skills/nfc-reading/SKILL.md) - Leer DNIe con PACE
- [**crypto-validation**](skills/crypto-validation/SKILL.md) - Validar certificados

### Datos & Sincronización

- [**database-sync**](skills/database-sync/SKILL.md) - Sincronizar con Firestore
- [**storage-upload**](skills/storage-upload/SKILL.md) - Subir a Google Cloud Storage

### Diseño & Accesibilidad

- [**ui-design**](skills/ui-design/SKILL.md) - Validar Material 3 y accesibilidad

### Tests & Deployment

- [**flutter-test**](skills/flutter-test/SKILL.md) - Tests de Flutter
- [**backend-test**](skills/backend-test/SKILL.md) - Tests del backend
- [**deploy-backend**](skills/deploy-backend/SKILL.md) - Deploy en Cloud Run

## 🔍 Buscar por Categoría

### Por Tipo de Tarea

**Necesito compilar la aplicación**
- 👉 [flutter-build](skills/flutter-build/SKILL.md)

**Necesito iniciar el backend**
- 👉 [backend-start](skills/backend-start/SKILL.md)

**Necesito verificar un QR**
- 👉 [qr-verification](skills/qr-verification/SKILL.md)

**Necesito leer un DNIe**
- 👉 [nfc-reading](skills/nfc-reading/SKILL.md)

**Necesito guardar datos**
- 👉 [database-sync](skills/database-sync/SKILL.md)

**Necesito validar certificados**
- 👉 [crypto-validation](skills/crypto-validation/SKILL.md)

**Necesito validar diseño UI**
- 👉 [ui-design](skills/ui-design/SKILL.md)

### Por Plataforma

**Flutter Web**
- [flutter-build](skills/flutter-build/SKILL.md)
- [ui-design](skills/ui-design/SKILL.md)

**Node.js Backend**
- [backend-start](skills/backend-start/SKILL.md)
- [database-sync](skills/database-sync/SKILL.md)

**Móvil (Android/iOS)**
- [nfc-reading](skills/nfc-reading/SKILL.md)
- [flutter-build](skills/flutter-build/SKILL.md)

## 🚀 Ejecutar Skills

```bash
# Ver ayuda
./run-skill.sh --help

# Compilar Flutter
./run-skill.sh flutter-build --platform web --mode release

# Iniciar backend
./run-skill.sh backend-start --environment development

# Verificar QR
./run-skill.sh qr-verification --qrData "base64data"

# Validar diseño UI
./run-skill.sh ui-design --action validate --targetFile lib/core/theme/app_theme.dart
```

## 📊 Estructura de Archivos

```
.agents/
├── INDEX.md                  # Este archivo
├── README.md                 # Guía general
├── INTEGRATION.md            # Cómo funciona el sistema
└── skills/
    ├── README.md             # Guía de skills
    ├── TEMPLATE.md           # Template
    ├── flutter-build/
    │   ├── SKILL.md
    │   └── config.json
    ├── backend-start/
    │   ├── SKILL.md
    │   └── config.json
    ├── qr-verification/
    │   ├── SKILL.md
    │   └── config.json
    ├── nfc-reading/
    │   ├── SKILL.md
    │   └── config.json
    ├── crypto-validation/
    │   ├── SKILL.md
    │   └── config.json
    ├── database-sync/
    │   ├── SKILL.md
    │   └── config.json
    ├── storage-upload/
    │   ├── SKILL.md
    │   └── config.json
    ├── ui-design/             # ✨ NUEVO
    │   ├── SKILL.md
    │   └── config.json
    └── [más skills]/
```

## ❓ FAQ Rápidas

**¿Cómo ejecuto un skill?**
```bash
./run-skill.sh [skill-id] [--param value]
```

**¿Cómo creo un nuevo skill?**
Usa [skills/TEMPLATE.md](skills/TEMPLATE.md) como referencia.

**¿Dónde está la configuración de un skill?**
En `skills/[skill-id]/config.json`

**¿Cómo veo los cambios del proyecto?**
Abre [../CHANGE_LOG.md](../CHANGE_LOG.md)

**¿Cómo valido el diseño UI?**
Usa [ui-design](skills/ui-design/SKILL.md) con `--action validate`

## 🔗 Enlaces Rápidos

- 🏠 [Raíz del proyecto](../)
- 📖 [Documentación de agentes](../AGENTS.md)
- 📝 [Registro de cambios](../CHANGE_LOG.md)
- 🏗️ [Arquitectura](../docs/ARCHITECTURE.md)
- 🎨 [UI Flows](../docs/UI_FLOWS.md)

## 🆘 Soporte

- 📖 Documentación incompleta: Revisa el archivo `.md` específico
- 🐛 Bug en un skill: Reporta en GitHub Issues
- 💬 Pregunta sobre arquitectura: Abre una Discussion

---

**Última actualización**: 23 de febrero de 2026
