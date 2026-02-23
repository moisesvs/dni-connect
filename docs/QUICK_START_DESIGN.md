# 🚀 Inicio Rápido - Nuevo Sistema de Diseño

Empieza a usar el nuevo diseño en **5 minutos**.

---

## ⚡ Los 3 Pasos Esenciales

### 1️⃣ Importar en tu pantalla

```dart
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';
```

### 2️⃣ Usar componentes

```dart
AppComponents.primaryButton(
  context: context,
  text: 'Mi Botón',
  onPressed: () {},
  icon: AppIcons.verified,
)
```

### 3️⃣ Ver demostración

Navega a `/design-showcase` en tu app para ver todos los componentes en vivo.

---

## 📋 Copiar y Pegar - Componentes Principales

### Botón Principal
```dart
AppComponents.primaryButton(
  context: context,
  text: 'Aceptar',
  onPressed: () {},
  icon: AppIcons.verified,
)
```

### Botón Secundario
```dart
AppComponents.secondaryButton(
  context: context,
  text: 'Cancelar',
  onPressed: () {},
)
```

### Card Moderna
```dart
AppComponents.modernCard(
  context: context,
  child: Text('Tu contenido aquí'),
)
```

### Card Header
```dart
AppComponents.headerCard(
  context: context,
  title: 'Título',
  subtitle: 'Subtítulo',
  icon: AppIcons.verification,
  iconColor: AppTheme.primaryColor,
)
```

### Info Card
```dart
AppComponents.infoCard(
  context: context,
  label: 'Documento',
  value: '12345678X',
  icon: AppIcons.id,
)
```

### Status Banner
```dart
AppComponents.statusBanner(
  context: context,
  message: 'Éxito',
  status: StatusType.success,  // success|error|warning|info
)
```

### Loading
```dart
AppComponents.loadingIndicator(
  context: context,
  message: 'Cargando...',
)
```

### Empty State
```dart
AppComponents.emptyState(
  context: context,
  icon: AppIcons.document,
  title: 'Sin documentos',
  message: 'No hay documentos',
)
```

### List Item
```dart
AppComponents.customListTile(
  context: context,
  title: 'Título',
  subtitle: 'Subtítulo',
  leadingIcon: AppIcons.scan,
  onTap: () {},
)
```

---

## 🎨 Colores (Copiar Código)

```dart
// Primario
AppTheme.primaryColor          // #0066FF - Azul vibrante

// Secundario
AppTheme.secondaryColor        // #7C3AED - Púrpura

// Estados
AppTheme.successColor          // #10B981 - Verde
AppTheme.errorColor            // #EF4444 - Rojo
AppTheme.warningColor          // #F59E0B - Amarillo
AppTheme.infoColor             // #3B82F6 - Azul info

// Background (oscuro)
AppTheme.darkBackground        // #0F172A
AppTheme.darkSurface           // #1E293B
AppTheme.darkCardBg            // #334155

// Texto (oscuro)
AppTheme.textDark              // #FFFFFF
AppTheme.textSecondaryDark     // #CBD5E1
```

---

## 🎯 Iconos Más Usados

```dart
// Autenticación
AppIcons.verification   // Verificación
AppIcons.verified       // Verificado
AppIcons.nfc            // NFC
AppIcons.scan           // Escanear QR
AppIcons.shield         // Seguridad

// Datos
AppIcons.user           // Usuario
AppIcons.email          // Correo
AppIcons.phone          // Teléfono
AppIcons.id             // DNI
AppIcons.document       // Documento

// Acciones
AppIcons.add            // Agregar
AppIcons.delete         // Eliminar
AppIcons.edit           // Editar
AppIcons.refresh        // Actualizar

// Navegación
AppIcons.home           // Inicio
AppIcons.profile        // Perfil
AppIcons.back           // Volver
AppIcons.forward        // Avanzar

// Estados
AppIcons.success        // Éxito
AppIcons.error          // Error
AppIcons.warning        // Advertencia
AppIcons.info           // Información
```

---

## 📏 Espaciados

```dart
// En columnas
SizedBox(height: DesignUtils.lg)    // 16px - estándar
SizedBox(height: DesignUtils.xl)    // 24px - entre secciones
SizedBox(height: DesignUtils.md)    // 12px - entre elementos pequeños

// En filas
SizedBox(width: DesignUtils.lg)
SizedBox(width: DesignUtils.md)

// En padding
padding: EdgeInsets.all(DesignUtils.lg)
padding: EdgeInsets.symmetric(
  horizontal: DesignUtils.lg,
  vertical: DesignUtils.md,
)
```

---

## 🎬 Estructura Base de Pantalla

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';

class MiPantalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Pantalla'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Agregua tus componentes aquí
            AppComponents.primaryButton(
              context: context,
              text: 'Botón',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📱 Pantalla Común - Verificación

```dart
class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            AppComponents.headerCard(
              context: context,
              title: 'Verifica tu DNI',
              subtitle: 'Elige un método',
              icon: AppIcons.verification,
              iconColor: AppTheme.primaryColor,
            ),
            SizedBox(height: DesignUtils.xl),

            // Opción 1
            AppComponents.customListTile(
              context: context,
              title: 'Escanear QR',
              subtitle: 'Escanea el código QR',
              leadingIcon: AppIcons.scan,
              onTap: () {},
            ),
            SizedBox(height: DesignUtils.md),

            // Opción 2
            AppComponents.customListTile(
              context: context,
              title: 'Leer NFC',
              subtitle: 'Lee el chip NFC',
              leadingIcon: AppIcons.nfc,
              onTap: () {},
            ),
            SizedBox(height: DesignUtils.xl),

            // Botón
            AppComponents.primaryButton(
              context: context,
              text: 'Continuar',
              onPressed: () {},
              icon: AppIcons.forward,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ✅ Checklist Rápido

- [ ] Agregué los 3 imports
- [ ] Usé `AppComponents` para botones/cards
- [ ] Usé `AppIcons` para iconos
- [ ] Usé `AppTheme` para colores
- [ ] Usé `DesignUtils` para espaciados
- [ ] La pantalla se ve bien en dark mode
- [ ] Las sombras y espacios son consistentes

---

## 🎓 Próximo Nivel

Una vez que domines lo anterior, consulta:
- 📘 [DESIGN_GUIDE.md](./docs/DESIGN_GUIDE.md) - Sistema completo
- 🚀 [INTEGRATION_GUIDE.md](./docs/INTEGRATION_GUIDE.md) - Patrones avanzados
- 📱 [SCREEN_EXAMPLES.md](./docs/SCREEN_EXAMPLES.md) - Pantallas reales

---

## 🆘 Ayuda Rápida

### "¿Dónde está el componente X?"
→ Mira la tabla en [DESIGN_QUICK_REFERENCE.md](./DESIGN_QUICK_REFERENCE.md)

### "¿Qué color uso?"
→ Consulta [DESIGN_GUIDE.md](./docs/DESIGN_GUIDE.md) - Sección Colores

### "¿Necesito un icono específico?"
→ Ve [DESIGN_QUICK_REFERENCE.md](./DESIGN_QUICK_REFERENCE.md) - Iconos

### "¿Cómo veo una pantalla similar?"
→ Busca en [SCREEN_EXAMPLES.md](./docs/SCREEN_EXAMPLES.md)

---

## 🚀 ¡Listo! Ahora sí...

```dart
// 1. Importa
import '../../../core/theme/app_components.dart';

// 2. Usa
AppComponents.primaryButton(
  context: context,
  text: 'Empezar',
  onPressed: () {},
)

// 3. ¡Listo! Tu pantalla ya se ve moderna
```

---

**Tiempo de lectura**: 5 min  
**Tiempo para primera pantalla**: 10-15 min  
**Estado**: ✅ Listo para usar

¡Bienvenido al nuevo sistema de diseño! 🎨
