# 🎨 Referencia Rápida del Diseño

Cheat sheet del nuevo sistema de diseño de DNI-Connect.

---

## 📦 Imports Necesarios

```dart
import '../core/theme/app_theme.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/app_components.dart';
```

---

## 🎨 Colores Principales

| Color | Código | Uso |
|-------|--------|-----|
| **Primario** | `#0066FF` | Botones, links, destacados |
| **Secundario** | `#7C3AED` | Acentos, tags especiales |
| **Éxito** | `#10B981` | Confirmaciones, verificaciones |
| **Error** | `#EF4444` | Errores, peligro |
| **Advertencia** | `#F59E0B` | Warnings, campos requeridos |
| **Información** | `#3B82F6` | Info, tips |

**Acceso en código**:
```dart
AppTheme.primaryColor      // #0066FF
AppTheme.secondaryColor    // #7C3AED
AppTheme.successColor      // #10B981
AppTheme.errorColor        // #EF4444
AppTheme.warningColor      // #F59E0B
AppTheme.infoColor         // #3B82F6
```

---

## 🧩 Componentes (Copiar y Pegar)

### 1️⃣ Botón Primario

```dart
AppComponents.primaryButton(
  context: context,
  text: 'Aceptar',
  onPressed: () {},
  icon: AppIcons.verified,
)
```

### 2️⃣ Botón Secundario

```dart
AppComponents.secondaryButton(
  context: context,
  text: 'Cancelar',
  onPressed: () {},
)
```

### 3️⃣ Card Moderna

```dart
AppComponents.modernCard(
  context: context,
  child: Text('Contenido'),
  onTap: () {},
)
```

### 4️⃣ Header Card

```dart
AppComponents.headerCard(
  context: context,
  title: 'Título',
  subtitle: 'Subtítulo',
  icon: AppIcons.verification,
  iconColor: AppTheme.primaryColor,
)
```

### 5️⃣ Info Card

```dart
AppComponents.infoCard(
  context: context,
  label: 'Etiqueta',
  value: 'Valor',
  icon: AppIcons.id,
  statusColor: AppTheme.successColor,
)
```

### 6️⃣ Status Banner

```dart
AppComponents.statusBanner(
  context: context,
  message: 'Mensaje',
  status: StatusType.success,  // success|error|warning|info
  onClose: () {},
)
```

### 7️⃣ Loading Indicator

```dart
AppComponents.loadingIndicator(
  context: context,
  message: 'Cargando...',
)
```

### 8️⃣ Empty State

```dart
AppComponents.emptyState(
  context: context,
  icon: AppIcons.document,
  title: 'Sin documentos',
  message: 'No hay documentos',
  actionButton: AppComponents.primaryButton(
    context: context,
    text: 'Agregar',
    onPressed: () {},
  ),
)
```

### 9️⃣ Custom List Tile

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

## 🎯 Iconos (Más Usados)

```dart
AppIcons.verification    // Verificación
AppIcons.verified        // Verificado
AppIcons.nfc            // NFC
AppIcons.scan           // Escanear QR
AppIcons.shield         // Seguridad
AppIcons.user           // Usuario
AppIcons.id             // DNI/ID
AppIcons.document       // Documento
AppIcons.success        // Éxito
AppIcons.error          // Error
AppIcons.warning        // Advertencia
AppIcons.info           // Información
AppIcons.home           // Inicio
AppIcons.profile        // Perfil
AppIcons.settings       // Configuración
AppIcons.back           // Volver
AppIcons.forward        // Avanzar
AppIcons.add            // Agregar
AppIcons.delete         // Eliminar
AppIcons.edit           // Editar
AppIcons.refresh        // Actualizar
AppIcons.lock           // Bloqueado
AppIcons.visibility     // Visible
AppIcons.email          // Correo
AppIcons.phone          // Teléfono
```

**Métodos auxiliares**:
```dart
AppIcons.primary(AppIcons.verified)           // Color primario
AppIcons.secondary(AppIcons.edit)             // Color secundario
AppIcons.success(AppIcons.verified)           // Verde éxito
AppIcons.error(AppIcons.error)                // Rojo error
AppIcons.inCircle(AppIcons.verified)          // En círculo
AppIcons.withBadge(AppIcons.notification, '5') // Con badge
```

---

## 📏 Espaciados

```dart
DesignUtils.xs      // 4px
DesignUtils.sm      // 8px
DesignUtils.md      // 12px
DesignUtils.lg      // 16px  ← Estándar
DesignUtils.xl      // 24px
DesignUtils.xxl     // 32px

// Uso
SizedBox(height: DesignUtils.lg)
SizedBox(width: DesignUtils.md)
padding: EdgeInsets.all(DesignUtils.lg)
```

---

## 🔄 Border Radius

```dart
DesignUtils.radiusSm      // 8px
DesignUtils.radiusMd      // 12px
DesignUtils.radiusLg      // 16px  ← Estándar
DesignUtils.radiusXl      // 20px
DesignUtils.radiusCircle  // 50px
```

---

## 🎬 Pantalla de Demostración

Ver todos los componentes en acción:

```dart
// En main.dart o routing, agrega:
GoRoute(
  path: '/design-showcase',
  builder: (context, state) => const DesignShowcaseScreen(),
)

// O navega directamente:
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const DesignShowcaseScreen()),
);
```

---

## ⚡ Patrones Comunes

### Pantalla con Verificación

```dart
Column(
  children: [
    // Header
    AppComponents.headerCard(
      context: context,
      title: 'Verifica tu DNI',
      icon: AppIcons.verification,
    ),
    SizedBox(height: DesignUtils.xl),

    // Opciones
    AppComponents.customListTile(
      context: context,
      title: 'Opción 1',
      leadingIcon: AppIcons.scan,
      onTap: () {},
    ),
    SizedBox(height: DesignUtils.md),

    // Botones
    AppComponents.primaryButton(
      context: context,
      text: 'Continuar',
      onPressed: () {},
    ),
    SizedBox(height: DesignUtils.md),
    AppComponents.secondaryButton(
      context: context,
      text: 'Cancelar',
      onPressed: () {},
    ),
  ],
)
```

### Pantalla de Resultados

```dart
Column(
  children: [
    // Status banner
    AppComponents.statusBanner(
      context: context,
      message: '¡Éxito!',
      status: StatusType.success,
    ),
    SizedBox(height: DesignUtils.xl),

    // Info
    AppComponents.modernCard(
      context: context,
      child: Column(
        children: [
          AppComponents.infoCard(
            context: context,
            label: 'Documento',
            value: '12345678X',
          ),
        ],
      ),
    ),
    SizedBox(height: DesignUtils.xl),

    // Botón
    AppComponents.primaryButton(
      context: context,
      text: 'Aceptar',
      onPressed: () {},
    ),
  ],
)
```

---

## 🔍 Buscar Componentes

| Necesitas | Usa |
|-----------|-----|
| Mostrar un botón | `primaryButton()` o `secondaryButton()` |
| Mostrar información | `infoCard()` o `modernCard()` |
| Mostrar error/éxito | `statusBanner()` |
| Mostrar carga | `loadingIndicator()` |
| Mostrar sin datos | `emptyState()` |
| Mostrar opciones | `customListTile()` |
| Mostrar inicio | `headerCard()` |

---

## 🎨 Tema

El tema se aplica automáticamente a toda la app. En `MaterialApp`:

```dart
MaterialApp(
  title: 'DNI-Connect',
  theme: AppTheme.lightTheme(),
  darkTheme: AppTheme.darkTheme(),
  themeMode: ThemeMode.dark,  // Fuerza dark mode
)
```

---

## ✨ Tips Profesionales

1. **Siempre usa `DesignUtils`** para espaciados - no hardcodees `16` o `24`
2. **Siempre usa `AppTheme`** para colores - no hardcodees `#0066FF`
3. **Siempre usa `AppIcons`** para iconos - no uses Material Icons genéricos
4. **Siempre usa componentes** - no crees tus propios Cards si existe `modernCard()`
5. **Mantén consistencia** - usa el mismo patrón en todas las pantallas
6. **Prueba en dark mode** - todos los componentes están optimizados

---

## 📱 Responsive Design

Para pantallas grandes (tablet/web):

```dart
// Ancho máximo
Container(
  constraints: BoxConstraints(maxWidth: 600),
  child: Padding(
    padding: EdgeInsets.symmetric(
      horizontal: DesignUtils.xl,
      vertical: DesignUtils.lg,
    ),
    child: Column(...),
  ),
)
```

---

## 🆘 Problemas Comunes

| Problema | Solución |
|----------|----------|
| "Widget no se ve" | Verifica que esté dentro de `Scaffold` |
| "Colores no cambian" | Reinicia la app (hot reload no siempre funciona) |
| "Icono no aparece" | Verifica que uses `AppIcons.` no `Icons.` |
| "Botón deshabilitado" | Asegúrate de que `onPressed` no sea null |
| "Spacing inconsistente" | Usa `DesignUtils` no números hardcodeados |

---

## 📚 Documentación Completa

- **Colores y Tipografía**: [DESIGN_GUIDE.md](./DESIGN_GUIDE.md)
- **Cómo integrar**: [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md)
- **Este cheat sheet**: [DESIGN_QUICK_REFERENCE.md](./DESIGN_QUICK_REFERENCE.md)

---

**Versión**: 1.0.0  
**Última actualización**: 23 de Febrero, 2026
