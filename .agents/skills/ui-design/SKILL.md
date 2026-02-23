# Skill: ui-design

Validar, generar y verificar diseños de interfaz de usuario para Flutter aplicando Material 3 y estándares de DNI-Connect.

## Descripción

Este skill automatiza tareas de diseño UI incluyendo:

1. **Validación de Material 3**: Verificar compliance con Material Design 3
2. **Generación de Temas**: Crear temas light/dark basados en color seed
3. **Validación de Contraste**: Verificar accesibilidad WCAG
4. **Testing de Responsividad**: Validar layouts en múltiples tamaños
5. **Auditoría de Componentes**: Verificar uso correcto de widgets
6. **Generación de Documentación**: Crear guía de componentes

## Inputs

```json
{
  "action": "validate|generate-theme|contrast-check|responsivity-test|audit",
  "targetFile": "lib/core/theme/app_theme.dart",
  "colorSeed": "#003366",
  "wcagLevel": "AA",
  "breakpoints": ["mobile", "tablet", "desktop"],
  "generateDocs": true
}
```

| Parámetro | Tipo | Requerido | Descripción |
|-----------|------|----------|-------------|
| `action` | string | ✅ | Acción: `validate`, `generate-theme`, `contrast-check`, `responsivity-test`, `audit` |
| `targetFile` | string | ❌ | Archivo a validar/procesar |
| `colorSeed` | string | ❌ | Color seed para generar tema (hex: #RRGGBB) |
| `wcagLevel` | string | ❌ | Nivel WCAG: `A`, `AA`, `AAA` (default: AA) |
| `breakpoints` | array | ❌ | Puntos de ruptura: mobile, tablet, desktop (default: todos) |
| `generateDocs` | boolean | ❌ | Generar documentación de componentes (default: true) |

## Outputs

```json
{
  "success": true,
  "action": "validate",
  "results": {
    "material3Compliance": {
      "valid": true,
      "issues": [],
      "warnings": [
        "ColorScheme.tertiary no utilizada",
        "Typography.displaySmall sin custom"
      ]
    },
    "contrastRatio": {
      "wcagLevel": "AA",
      "passed": true,
      "failures": [],
      "warnings": [
        {
          "element": "PrimaryButton text on surface",
          "ratio": 4.5,
          "required": 4.5,
          "status": "borderline"
        }
      ]
    },
    "responsivity": {
      "mobile": { "valid": true, "issues": [] },
      "tablet": { "valid": true, "issues": [] },
      "desktop": { "valid": true, "issues": [] }
    },
    "components": {
      "total": 45,
      "compliant": 44,
      "issues": [
        {
          "component": "CustomButton",
          "issue": "No usa Material 3 button style",
          "severity": "warning",
          "fix": "Usa ElevatedButton.styleFrom con Material 3 surface"
        }
      ]
    }
  },
  "score": 92,
  "duration": 3500,
  "generatedFiles": [
    "docs/ui-components.md",
    "docs/color-palette.md"
  ],
  "timestamp": "2026-02-23T10:30:00Z"
}
```

## Ejemplos

### Validar Material 3 Compliance

```bash
./run-skill.sh ui-design --action validate --targetFile lib/core/theme/app_theme.dart
```

Resultado:
```json
{
  "success": true,
  "action": "validate",
  "score": 92,
  "material3Compliance": {
    "valid": true,
    "issues": []
  }
}
```

### Generar tema desde color seed

```bash
./run-skill.sh ui-design --action generate-theme --colorSeed "#003366"
```

Genera automáticamente:
- ColorScheme (light/dark)
- TextTheme completo
- Componentes estilizados

### Verificar contraste WCAG

```bash
./run-skill.sh ui-design --action contrast-check --wcagLevel AA --targetFile lib/core/theme/app_theme.dart
```

### Testing de responsividad

```bash
./run-skill.sh ui-design --action responsivity-test --breakpoints mobile,tablet,desktop
```

### Auditoría completa

```bash
./run-skill.sh ui-design --action audit --generateDocs true
```

## Validaciones

- ✅ Material 3 compliance (colores, tipografía, espaciado)
- ✅ Contraste WCAG (AA/AAA)
- ✅ Respuesta en múltiples tamaños
- ✅ Uso correcto de Material Components
- ✅ Tipografía consistent
- ✅ Spacings y paddings según Material Design
- ✅ Accesibilidad (touch targets, focus states)
- ✅ Dark mode support

## Errores Comunes

| Error | Causa | Solución |
|-------|-------|----------|
| `ColorScheme incomplete` | Faltan colores en tema | Usar `ColorScheme.fromSeed()` |
| `Contrast ratio too low` | Texto con poco contraste | Aumentar diferencia de luminancia |
| `Layout broken on mobile` | Layout no responsive | Usar `MediaQuery` o `LayoutBuilder` |
| `Button target too small` | Touch target < 48dp | Aumentar altura/ancho mínimo |
| `No dark theme` | Falta modo oscuro | Implementar `useMaterial3: true` + dark colors |

## Implementación

**Ubicación**: `apps/flutter/lib/core/theme/` + `packages/ui-design/`

**Módulos involucrados**:
- `MaterialValidator`: Valida Material 3 compliance
- `ContrastChecker`: Verifica ratios WCAG
- `ResponsivityTester`: Testa layouts
- `ComponentAuditor`: Audita uso de componentes
- `ThemeGenerator`: Genera temas desde seed
- `DocGenerator`: Genera documentación

**Lenguajes**: Dart, TypeScript (CLI)

## Material 3 Estándares

| Elemento | Estándar | Verificación |
|----------|----------|--------------|
| **Colores** | ColorScheme de 20 colores | ✅ Todos presentes |
| **Tipografía** | 3 escalas (display, headline, body) | ✅ Configurado |
| **Espaciado** | Múltiplos de 4dp | ✅ Validado |
| **Elevación** | Shadow tokens | ✅ Consistente |
| **Componentes** | Usando Material 3 widgets | ✅ Auditado |

## Integración

- **Frontend**: `lib/core/theme/` incluye Material 3
- **Backend**: Skill valida desde línea de comandos
- **CI/CD**: Ejecutar en cada PR con cambios UI

## Versionado

- **v1.0.0** (2026-02-23): Creación inicial
  - Material 3 validation
  - Contrast checking (WCAG)
  - Responsivity testing
  - Component auditing
  - Theme generation
  - Documentation generation
