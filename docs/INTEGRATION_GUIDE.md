# 📱 Guía de Integración del Nuevo Diseño

Instrucciones paso a paso para integrar los nuevos componentes en las pantallas existentes.

---

## 📋 Estructura del Código de Diseño

```
apps/flutter/lib/core/theme/
├── app_theme.dart              # 🎨 Tema Material 3 (colores, tipografía, estilos)
├── app_icons.dart              # 🎯 Iconos y utilidades de diseño
└── app_components.dart         # 🧩 Componentes reutilizables

apps/flutter/lib/features/shared/presentation/pages/
└── design_showcase_screen.dart  # ✨ Pantalla de demostración interactiva
```

---

## 🚀 Paso 1: Importar el Nuevo Diseño

En cualquier pantalla donde quieras usar el nuevo diseño, agrega estos imports:

```dart
// Siempre agrega estos imports al inicio del archivo
import '../../../core/theme/app_theme.dart';     // Colores y estilos
import '../../../core/theme/app_icons.dart';     // Iconos y utilidades
import '../../../core/theme/app_components.dart'; // Componentes
```

---

## 📊 Paso 2: Estructura Base de Pantalla

Aquí está la estructura recomendada para una pantalla moderna:

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';

class MiPantallaModerna extends StatefulWidget {
  const MiPantallaModerna({Key? key}) : super(key: key);

  @override
  State<MiPantallaModerna> createState() => _MiPantallaModernaState();
}

class _MiPantallaModernaState extends State<MiPantallaModerna> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar automáticamente tiene el nuevo estilo
      appBar: AppBar(
        title: const Text('Mi Pantalla'),
        centerTitle: true,
        elevation: 0,
      ),
      // Cuerpo con ListView para mejor scrolling
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(DesignUtils.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Agregar componentes aquí
        ],
      ),
    );
  }
}
```

---

## 🎨 Paso 3: Patrón de Cada Componente

### A. Header/Título Informativo

**Cuándo usar**: Inicio de pantalla o sección importante

```dart
// PATRÓN: Header con imagen conceptual
AppComponents.headerCard(
  context: context,
  title: 'Verifica tu DNI',
  subtitle: 'Completa tu verificación de identidad',
  icon: AppIcons.verification,
  iconColor: AppTheme.primaryColor,
)
```

### B. Opciones de Acción

**Cuándo usar**: Múltiples opciones que el usuario debe elegir

```dart
// PATRÓN: Lista de opciones con iconos
Column(
  children: [
    AppComponents.customListTile(
      context: context,
      title: 'Opción 1',
      subtitle: 'Descripción breve',
      leadingIcon: AppIcons.scan,
      onTap: () { /* acción */ },
    ),
    SizedBox(height: DesignUtils.md),
    AppComponents.customListTile(
      context: context,
      title: 'Opción 2',
      subtitle: 'Descripción breve',
      leadingIcon: AppIcons.nfc,
      onTap: () { /* acción */ },
    ),
  ],
)
```

### C. Información/Resultados

**Cuándo usar**: Mostrar datos verificados

```dart
// PATRÓN: Card con múltiples info cards
AppComponents.modernCard(
  context: context,
  child: Column(
    children: [
      AppComponents.infoCard(
        context: context,
        label: 'Documento',
        value: 'ABC123456X',
        icon: AppIcons.id,
      ),
      SizedBox(height: DesignUtils.lg),
      AppComponents.infoCard(
        context: context,
        label: 'Estado',
        value: 'Verificado',
        icon: AppIcons.verified,
        statusColor: AppTheme.successColor,
      ),
    ],
  ),
)
```

### D. Botones de Acción

**Cuándo usar**: Siempre al final de una sección/pantalla

```dart
// PATRÓN: Stack de botones
Column(
  children: [
    // Botón principal (acción primaria)
    AppComponents.primaryButton(
      context: context,
      text: 'Continuar',
      onPressed: _isLoading ? null : _onContinue,
      isLoading: _isLoading,
      icon: AppIcons.forward,
    ),
    SizedBox(height: DesignUtils.md),
    // Botón secundario (opción alternativa)
    AppComponents.secondaryButton(
      context: context,
      text: 'Cancelar',
      onPressed: _onCancel,
    ),
  ],
)
```

### E. Estados (Carga, Éxito, Error, Vacío)

**Cuando usar**: Transiciones entre estados

```dart
// PATRÓN: Estados diferentes según lógica
if (_isLoading) {
  AppComponents.loadingIndicator(
    context: context,
    message: 'Verificando...',
  )
} else if (_hasError) {
  AppComponents.statusBanner(
    context: context,
    message: 'Error en la verificación',
    status: StatusType.error,
    onClose: () { /* cerrar */ },
  )
} else if (_isEmpty) {
  AppComponents.emptyState(
    context: context,
    icon: AppIcons.document,
    title: 'Sin documentos',
    message: 'No hay documentos para mostrar',
    actionButton: AppComponents.primaryButton(
      context: context,
      text: 'Agregar documento',
      onPressed: _onAddDocument,
    ),
  )
} else {
  // Contenido normal
  _buildContent()
}
```

---

## 📐 Paso 4: Espaciado Recomendado

Usa estas constantes para mantener consistencia:

```dart
// Entre título y contenido
SizedBox(height: DesignUtils.lg)   // 16px

// Entre componentes principales
SizedBox(height: DesignUtils.xl)   // 24px

// Dentro de una tarjeta
padding: EdgeInsets.all(DesignUtils.lg)

// Entre elementos de lista
spacing: DesignUtils.md   // 12px

// Padding horizontal de pantalla
horizontal: EdgeInsets.symmetric(horizontal: DesignUtils.lg)
```

---

## 🎯 Plantillas de Pantallas Comunes

### Plantilla 1: Pantalla de Verificación

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header informativo
            AppComponents.headerCard(
              context: context,
              title: 'Verifica tu Identidad',
              subtitle: 'Elige cómo deseas verificarte',
              icon: AppIcons.verification,
              iconColor: AppTheme.primaryColor,
            ),
            SizedBox(height: DesignUtils.xl),

            // 2. Opciones disponibles
            AppComponents.customListTile(
              context: context,
              title: 'Escanear QR',
              subtitle: 'Escanea el código QR de tu DNI',
              leadingIcon: AppIcons.scan,
              onTap: _onScanQR,
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.customListTile(
              context: context,
              title: 'Leer NFC',
              subtitle: 'Lee el chip NFC de tu DNIe',
              leadingIcon: AppIcons.nfc,
              onTap: _onReadNFC,
            ),
            SizedBox(height: DesignUtils.xl),

            // 3. Botones de acción
            AppComponents.primaryButton(
              context: context,
              text: 'Continuar',
              onPressed: _isLoading ? null : _onContinue,
              isLoading: _isLoading,
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.secondaryButton(
              context: context,
              text: 'Cancelar',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _onScanQR() { /* implementación */ }
  void _onReadNFC() { /* implementación */ }
  void _onContinue() { /* implementación */ }
}
```

### Plantilla 2: Pantalla de Resultados

```dart
class ResultsScreen extends StatelessWidget {
  final String documentNumber;
  final String fullName;
  final bool isVerified;

  const ResultsScreen({
    required this.documentNumber,
    required this.fullName,
    required this.isVerified,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Banner de estado
            AppComponents.statusBanner(
              context: context,
              message: isVerified
                  ? '¡Verificación completada!'
                  : 'La verificación falló',
              status:
                  isVerified ? StatusType.success : StatusType.error,
            ),
            SizedBox(height: DesignUtils.xl),

            // 2. Información detallada
            AppComponents.modernCard(
              context: context,
              child: Column(
                children: [
                  AppComponents.infoCard(
                    context: context,
                    label: 'Documento',
                    value: documentNumber,
                    icon: AppIcons.id,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Nombre',
                    value: fullName,
                    icon: AppIcons.user,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Estado',
                    value: isVerified ? 'Verificado' : 'No verificado',
                    icon: isVerified
                        ? AppIcons.verified
                        : AppIcons.error,
                    statusColor: isVerified
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // 3. Botón de acción
            AppComponents.primaryButton(
              context: context,
              text: 'Aceptar',
              onPressed: () => Navigator.pop(context),
              icon: AppIcons.verified,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Plantilla 3: Pantalla con Formulario

```dart
class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Título
            Text(
              'Completa el Formulario',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: DesignUtils.lg),

            // 2. Campos
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Tu Información',
                hintText: 'Ingresa tu información',
                prefixIcon: Icon(AppIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    DesignUtils.radiusLg,
                  ),
                ),
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // 3. Botón de envío
            AppComponents.primaryButton(
              context: context,
              text: 'Enviar',
              onPressed:
                  _isSubmitting ? null : _onSubmit,
              isLoading: _isSubmitting,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    // Implementación del envío
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 🔧 Paso 5: Personalización de Componentes

### Cambiar Colores Globales

Si necesitas cambiar el color principal en toda la app:

```dart
// En app_theme.dart, modifica esta línea:
static const Color primaryColor = Color(0xFF0066FF); // Cambiar aquí
```

### Crear un Icono Personalizado

```dart
// En app_icons.dart, en la clase AppIcons:
static const IconData tuIcono = Icons.tuIcono;

// Luego úsalo así:
AppIcons.primary(AppIcons.tuIcono)
```

### Crear un Componente Personalizado

Si necesitas un componente nuevo, agrega un método a `app_components.dart`:

```dart
// Ejemplo: Componente personalizado
static Widget tuComponente({
  required BuildContext context,
  required String titulo,
  required String descripcion,
  VoidCallback? onPressed,
}) {
  return AppComponents.modernCard(
    context: context,
    child: Column(
      children: [
        Text(titulo, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: DesignUtils.md),
        Text(descripcion),
        SizedBox(height: DesignUtils.lg),
        if (onPressed != null)
          AppComponents.primaryButton(
            context: context,
            text: 'Aceptar',
            onPressed: onPressed,
          ),
      ],
    ),
  );
}
```

---

## ✅ Checklist de Integración

Para cada pantalla que actualices:

- [ ] Agregué los imports necesarios
- [ ] Usé `DesignUtils` para espaciados
- [ ] Usé `AppIcons` para iconos (no Material Icons genéricos)
- [ ] Usé componentes `AppComponents` (no widgets propios)
- [ ] Los botones son `primaryButton` o `secondaryButton`
- [ ] Las tarjetas usan `modernCard` o `headerCard`
- [ ] Los colores vienen de `AppTheme` (no hardcoded)
- [ ] La pantalla se ve bien en dark mode
- [ ] El spacing es consistente con `DesignUtils`

---

## 🎬 Ver la Demostración

Para ver todos los componentes en acción:

1. Abre el archivo `design_showcase_screen.dart`
2. Navega a la pantalla desde la app
3. Explora las 3 tabs: Colores, Componentes, Estados

---

## 📞 Soporte

Si tienes preguntas sobre:
- **Colores**: Ver `DESIGN_GUIDE.md` sección "Paleta de Colores"
- **Componentes**: Ver `app_components.dart` o la demostración
- **Iconos**: Ver `app_icons.dart` o buscar en Material Icons

---

**Última actualización**: 23 de Febrero, 2026  
**Estado**: ✅ Listo para usar
