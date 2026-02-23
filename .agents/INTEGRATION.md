# 🔗 Integración del Sistema de Agentes

Cómo funciona el sistema de documentación automática de DNI-Connect.

## 📋 Flujo Automático de Documentación

```
┌─ CAMBIO EN CÓDIGO
│  └─ Developer hace commit
│     └─ Ejecuta skill mediante ./run-skill.sh
│        └─ Skill registra ejecución
│           └─ Se actualiza automáticamente
│              ├─ CHANGE_LOG.md
│              ├─ .agents/logs/
│              └─ Metadata en config.json
│                 └─ ✅ CAMBIO DOCUMENTADO
```

## 🤖 Cómo Funciona Cada Skill

### 1. Estructura Interna del Skill

Cada skill en `.agents/skills/[skill-id]/` contiene:

```
skill-id/
├── SKILL.md          # Documentación técnica
├── config.json       # Schema y metadatos
└── implementation/   # (Opcional) Código del skill
    └── [lenguaje]/
```

### 2. Ciclo de Vida de un Skill

```
Definición
    ↓
    └─ SKILL.md: ¿Qué hace?
    └─ config.json: ¿Cómo se configura?
       ↓
   Descubrimiento
       ↓
       └─ ./run-skill.sh --help (lista el skill)
       └─ cat .agents/skills/[skill-id]/SKILL.md (ver doc)
          ↓
      Ejecución
          ↓
          └─ ./run-skill.sh [skill-id] [args]
          └─ Validación de inputs
          └─ Ejecución de lógica
          └─ Registro de outputs
             ↓
        Documentación Automática
             ↓
             └─ Logs en .agents/logs/
             └─ Entrada en CHANGE_LOG.md
             └─ Actualización de metadatos
```

## 📝 Qué se Registra Automáticamente

### Cada vez que se ejecuta un skill:

```json
{
  "timestamp": "2026-02-20T10:30:00Z",
  "skillId": "qr-verification",
  "status": "success|failure",
  "duration": 1200,
  "inputs": { /* parámetros */ },
  "outputs": { /* resultados */ },
  "errors": [],
  "warnings": []
}
```

### En CHANGE_LOG.md se agrega:

```markdown
- [2026-02-20] ✅ QR Verification ejecutado exitosamente
  - Skill: qr-verification
  - Entrada: Procesadas verificaciones de QR
  - Salida: 5 QRs verificados
```

## 🔄 Integración con Documentación Existente

```
AGENTS.md
├── Referencias a skills
├── Links a documentación detallada
└── Estado actual de cada skill

    ↓ (cuando se ejecuta)

CHANGE_LOG.md
├── Registro de cambios
├── Versión y fecha
└── Historial de ejecuciones

    ↓ (crecimiento)

.agents/logs/
├── Logs diarios
├── Estadísticas
└── Auditoría de cambios
```

## 🎯 Ejemplo: Ciclo Completo

### Paso 1: Developer decide compilar

```bash
cd /Users/e032284/Proyectos/DNI-Connect/dni-connect
./run-skill.sh flutter-build --platform web --mode release
```

### Paso 2: run-skill.sh valida

```bash
✓ Valida que skill existe
✓ Carga config.json
✓ Valida inputs contra schema
✓ Inicia ejecución
```

### Paso 3: Se ejecuta la compilación

```bash
✓ flutter pub get
✓ flutter analyze
✓ flutter build web
✓ Genera artefactos
```

### Paso 4: Se registra automáticamente

```
.agents/logs/2026-02-20/flutter-build.log
├── Inputs validados
├── Pasos ejecutados
├── Duración total
└── Status: SUCCESS

CHANGE_LOG.md (Unreleased)
├── [2026-02-20] ✅ Flutter compilado para Web
│   - Modo: release
│   - Duración: 45000ms
│   - Artefactos: build/web/
```

### Paso 5: Se actualiza índice

```
.agents/INDEX.md
└── Se recalculan estadísticas

AGENTS.md
└─ flutter-build status: ✅ (actualizado)
```

## 📊 Dashboard de Estado (Conceptual)

```
┌──────────────────────────────────────────────────────────┐
│           ESTADO DE SKILLS - 20 de Feb 2026              │
├──────────────────────────────────────────────────────────┤
│ flutter-build         ✅ Último: 2026-02-20 10:30        │
│ backend-start         ✅ Último: 2026-02-20 09:15        │
│ qr-verification       ✅ Último: 2026-02-19 16:45        │
│ nfc-reading           🟡 Dev (no ejecutado aún)          │
│ database-sync         ✅ Último: 2026-02-20 08:00        │
│ crypto-validation     ✅ Último: 2026-02-18 14:30        │
└──────────────────────────────────────────────────────────┘
```

## 🔗 Cómo Navegar la Documentación

### Para entender qué hace un skill:

```
1. Consultar tabla en AGENTS.md
   ↓
2. Abrir .agents/skills/[skill]/SKILL.md
   ↓
3. Revisar ejemplos
   ↓
4. Ver config.json para schema
```

### Para ver historial de cambios:

```
1. Revisar CHANGE_LOG.md
   ↓
2. Buscar skill específico
   ↓
3. Ver logs en .agents/logs/
```

### Para ejecutar un skill:

```
1. Ver ayuda: ./run-skill.sh --help
   ↓
2. Ver documentación: cat .agents/skills/[skill]/SKILL.md
   ↓
3. Ejecutar: ./run-skill.sh [skill] [args]
```

## 💾 Almacenamiento de Datos

```
.agents/
├── logs/                      # Logs de ejecuciones
│   └── 2026-02-20/
│       ├── flutter-build.log
│       ├── qr-verification.log
│       └── database-sync.log
│
├── cache/                     # Cache de ejecuciones
│   └── execution-cache.json
│
└── stats/                     # Estadísticas
    └── stats.json
```

## 📈 Métricas Automáticas

Se rastrean automáticamente:

- **Duración**: Tiempo de cada ejecución
- **Éxito/Fallo**: Status de cada skill
- **Frecuencia**: Cuántas veces se ejecuta
- **Tendencias**: Mejoras de rendimiento
- **Errores**: Errores más comunes

## 🔒 Garantías de Documentación

✅ **Completitud**: Cada skill debe tener SKILL.md + config.json  
✅ **Actualización**: CHANGE_LOG.md se actualiza con cada cambio  
✅ **Trazabilidad**: Logs guardan historial completo  
✅ **Accesibilidad**: Documentación en formato .md (legible)  
✅ **Validación**: Schema JSON para inputs/outputs  

## 🚀 Escalabilidad

El sistema es escalable para:

- **Más skills**: Simplemente agregar carpeta + SKILL.md + config.json
- **Más agentes**: Cada agente puede ejecutar múltiples skills
- **Más plataformas**: Skills pueden ser específicos de plataforma
- **Más equipo**: Documentación facilita onboarding

## 🔧 Mantenimiento

### Semanal
- Revisar .agents/logs/ para errores
- Limpiar logs antiguos (> 30 días)

### Mensual
- Actualizar CHANGE_LOG.md manualmente si es necesario
- Revisar estadísticas de skills más usados
- Actualizar documentación si hay cambios

### Trimestralmente
- Revisar y actualizar AGENTS.md
- Limpiar skills obsoletos
- Crear nuevos skills si es necesario

## 📞 Soporte

- 📖 Para documentación: Ver archivo .md específico
- 🐛 Para bugs: Crear issue en GitHub
- 💬 Para preguntas: Abrir Discussion

---

**Última actualización**: 20 de febrero de 2026
