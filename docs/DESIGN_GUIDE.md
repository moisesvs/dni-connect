# 🎨 Guía de Diseño - DNI-Connect Moderno

Documentación completa del nuevo sistema de diseño visual para DNI-Connect.

---

## 📋 Contenido

- [Visión General](#visión-general)
- [Paleta de Colores](#paleta-de-colores)
- [Tipografía](#tipografía)
- [Componentes](#componentes)
- [Iconografía](#iconografía)
- [Espaciados](#espaciados)
- [Ejemplos de Uso](#ejemplos-de-uso)

---

## 🎯 Visión General

El nuevo sistema de diseño de DNI-Connect está basado en **Material 3** con un enfoque en:

✨ **Modernidad** - Diseño limpio y contemporáneo
🌓 **Dark Mode** - Optimizado para vista nocturna
♿ **Accesibilidad** - Contraste y tamaños WCAG AA+
📱 **Responsividad** - Funciona en web, móvil y tablet
⚡ **Performance** - Componentes ligeros y eficientes

---

## 🎨 Paleta de Colores

### Colores Primarios

```
🔵 Azul Vibrante (Primario)
   Código: #0066FF
   Uso: Botones principales, links, destacados
   
🔵 Azul Claro
   Código: #4D94FF
   Uso: Botones secundarios, hover, fondo acento
   
🔵 Azul Oscuro
   Código: #0052CC
   Uso: Estados activos, presionado
```

### Colores Secundarios (Acentos)

```
💜 Púrpura Vibrante
   Código: #7C3AED
   Uso: Acentos, tags especiales
   
💜 Púrpura Claro
   Código: #A78BFA
   Uso: Hover en acentos, deshabilitado
   
💜 Púrpura Oscuro
   Código: #5B21B6
   Uso: Estados activos en acentos
```

### Colores de Estado

```
✅ Éxito (Verde)
   Código: #10B981
   Uso: Confirmaciones, verificaciones
   
❌ Error (Rojo)
   Código: #EF4444
   Uso: Errores, peligro, eliminación
   
⚠️ Advertencia (Amarillo)
   Código: #F59E0B
   Uso: Advertencias, campos requeridos
   
ℹ️ Información (Azul)
   Código: #3B82F6
   Uso: Información adicional, tips
```

### Colores Neutros

**Light Mode**:
- Fondo: `#FAFBFC`
- Superficie: `#FFFFFF`
- Tarjeta: `#F8FAFC`
- Texto: `#000000`
- Texto secundario: `#64748B`

**Dark Mode**:
- Fondo: `#0F172A`
- Superficie: `#1E293B`
- Tarjeta: `#334155`
- Texto: `#FFFFFF`
- Texto secundario: `#CBD5E1`

---

## 🔤 Tipografía

### Fuente Principal: Poppins

La tipografía ha cambiado de Inter a **Poppins** para:
- Mayor legibilidad
- Mejor jerarquía visual
- Más moderna y profesional

### Tamaños y Estilos

```dart
// Títulos grandes (32px, W800)
displayLarge: Poppins
  fontSize: 32
  fontWeight: 800
  letterSpacing: -0.5

// Títulos medianos (28px, W700)
displayMedium: Poppins
  fontSize: 28
  fontWeight: 700
  letterSpacing: -0.3

// Títulos pequeños (24px, W700)
displaySmall: Poppins
  fontSize: 24
  fontWeight: 700
  letterSpacing: 0

// Encabezados (20px, W700)
headlineMedium: Poppins
  fontSize: 20
  fontWeight: 700
  letterSpacing: 0.2

// Subencabezados (18px, W600)
headlineSmall: Poppins
  fontSize: 18
  fontWeight: 600
  letterSpacing: 0.1

// Etiquetas (16px, W600)
titleLarge: Poppins
  fontSize: 16
  fontWeight: 600
  letterSpacing: 0.15

// Cuerpo grande (16px, W500)
bodyLarge: Poppins
  fontSize: 16
  fontWeight: 500
  letterSpacing: 0.5

// Cuerpo normal (14px, W500)
bodyMedium: Poppins
  fontSize: 14
  fontWeight: 500
  letterSpacing: 0.25

// Cuerpo pequeño (12px, W500)
bodySmall: Poppins
  fontSize: 12
  fontWeight: 500
  letterSpacing: 0.4
```

---

## 🧩 Componentes

### 1. Botones

#### Botón Primario

```dart
AppComponents.primaryButton(
  context: context,
  text: 'Verificar DNI',
  onPressed: () { /* acción */ },
  icon: AppIcons.verification,
)
```

**Características**:
- Color: Azul vibrante (#0066FF)
- Altura: 56px
- Esquinas redondeadas: 16px
- Sombra: 8px blur
- Hover: Cambio de opacidad
- Loading: Spinner circular

#### Botón Secundario

```dart
AppComponents.secondaryButton(
  context: context,
  text: 'Cancelar',
  onPressed: () { /* acción */ },
)
```

**Características**:
- Borde: 2px azul vibrante
- Fondo: Transparente
- Similar altura y esquinas que primario

### 2. Cards

#### Card Moderna

```dart
AppComponents.modernCard(
  context: context,
  child: Text('Contenido'),
  onTap: () { /* acción */ },
)
```

**Características**:
- Esquinas: 16px redondeadas
- Sombra: 8px blur
- Borde: 1px gris claro
- Padding: 16px
- Ripple effect en tap

#### Header Card

```dart
AppComponents.headerCard(
  context: context,
  title: 'Verificación Exitosa',
  subtitle: 'Tu DNI ha sido verificado',
  icon: AppIcons.verified,
  iconColor: AppTheme.successColor,
)
```

**Características**:
- Icono en círculo con fondo tenue
- Título y subtítulo alineados
- Fondo especial (ej: azul claro)
- Ideal para información destacada

#### Info Card

```dart
AppComponents.infoCard(
  context: context,
  label: 'Documento',
  value: '12345678X',
  icon: AppIcons.id,
  statusColor: AppTheme.primaryColor,
)
```

**Características**:
- Etiqueta pequeña arriba
- Valor grande abajo
- Icono opcional
- Color de estado personalizable

### 3. Banners de Estado

```dart
AppComponents.statusBanner(
  context: context,
  message: '¡Verificación completada!',
  status: StatusType.success,
  onClose: () { /* cerrar */ },
)
```

**Estados disponibles**:
- `StatusType.success` - Verde
- `StatusType.error` - Rojo
- `StatusType.warning` - Amarillo
- `StatusType.info` - Azul

### 4. Indicadores de Carga

```dart
AppComponents.loadingIndicator(
  context: context,
  message: 'Verificando datos...',
)
```

**Características**:
- Spinner circular
- Mensaje opcional
- Centrado en pantalla

### 5. Estado Vacío

```dart
AppComponents.emptyState(
  context: context,
  icon: AppIcons.document,
  title: 'Sin documentos',
  message: 'No hay documentos verificados aún',
  actionButton: AppComponents.primaryButton(...),
)
```

**Características**:
- Icono grande con fondo coloreado
- Título y descripción
- Botón de acción opcional

### 6. List Tiles Personalizados

```dart
AppComponents.customListTile(
  context: context,
  title: 'Verificación de DNI',
  subtitle: 'Verifica tu identidad',
  leadingIcon: AppIcons.verification,
  onTap: () { /* acción */ },
)
```

**Características**:
- Icono izquierda (opcional)
- Título y subtítulo
- Flecha derecha automática
- Tap y hover effects

---

## 🎯 Iconografía

### Conjunto de Iconos Disponibles

#### Autenticación
- `AppIcons.document` - Documento
- `AppIcons.scan` - Escaneo QR
- `AppIcons.nfc` - NFC
- `AppIcons.verification` - Verificación
- `AppIcons.verified` - Verificado
- `AppIcons.shield` - Protección

#### Navegación
- `AppIcons.home` - Inicio
- `AppIcons.profile` - Perfil
- `AppIcons.settings` - Configuración
- `AppIcons.back` - Volver
- `AppIcons.forward` - Avanzar
- `AppIcons.menu` - Menú
- `AppIcons.close` - Cerrar

#### Acciones
- `AppIcons.add` - Agregar
- `AppIcons.delete` - Eliminar
- `AppIcons.edit` - Editar
- `AppIcons.copy` - Copiar
- `AppIcons.download` - Descargar
- `AppIcons.upload` - Subir
- `AppIcons.refresh` - Actualizar

#### Estados
- `AppIcons.success` - Éxito
- `AppIcons.error` - Error
- `AppIcons.warning` - Advertencia
- `AppIcons.info` - Información
- `AppIcons.pending` - Pendiente
- `AppIcons.loading` - Cargando

#### Datos
- `AppIcons.user` - Usuario
- `AppIcons.email` - Correo
- `AppIcons.phone` - Teléfono
- `AppIcons.location` - Ubicación
- `AppIcons.calendar` - Calendario
- `AppIcons.clock` - Reloj
- `AppIcons.id` - Identificación

#### Seguridad
- `AppIcons.lock` - Bloqueado
- `AppIcons.lockOpen` - Desbloqueado
- `AppIcons.fingerprint` - Huella digital
- `AppIcons.visibility` - Visible
- `AppIcons.visibilityOff` - Oculto
- `AppIcons.vpn` - VPN

### Métodos Auxiliares de Iconos

```dart
// Icono con color primario
AppIcons.primary(AppIcons.verified, size: 24)

// Icono con color secundario
AppIcons.secondary(AppIcons.edit, size: 24)

// Icono de éxito
AppIcons.success(AppIcons.verified, size: 24)

// Icono de error
AppIcons.error(AppIcons.error, size: 24)

// Icono personalizado
AppIcons.custom(AppIcons.document, Colors.blue, size: 24)

// Icono en círculo coloreado
AppIcons.inCircle(
  AppIcons.verified,
  backgroundColor: AppTheme.successColor,
  size: 48,
)

// Icono con badge
AppIcons.withBadge(
  AppIcons.notification,
  '5',
  badgeColor: Colors.red,
)
```

---

## 📏 Espaciados

```dart
// Estándar
DesignUtils.xs    // 4px
DesignUtils.sm    // 8px
DesignUtils.md    // 12px
DesignUtils.lg    // 16px  (estándar)
DesignUtils.xl    // 24px
DesignUtils.xxl   // 32px

// Ejemplo de uso
SizedBox(height: DesignUtils.lg)  // 16px de espacio vertical
SizedBox(width: DesignUtils.md)   // 12px de espacio horizontal
```

## 🔄 Border Radius

```dart
DesignUtils.radiusSm     // 8px
DesignUtils.radiusMd     // 12px
DesignUtils.radiusLg     // 16px (estándar)
DesignUtils.radiusXl     // 20px
DesignUtils.radiusCircle // 50px (para círculos)
```

## 🌑 Sombras

```dart
// Pequeña
DesignUtils.shadowSm

// Mediana
DesignUtils.shadowMd

// Grande
DesignUtils.shadowLg

// Uso
boxShadow: DesignUtils.shadowsMedium
```

---

## 📝 Ejemplos de Uso

### Ejemplo 1: Pantalla de Verificación

```dart
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_icons.dart';
import '../core/theme/app_components.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de DNI'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header informativo
            AppComponents.headerCard(
              context: context,
              title: 'Verifica tu Identidad',
              subtitle: 'Usa QR o NFC para verificar tu DNI',
              icon: AppIcons.verification,
              iconColor: AppTheme.primaryColor,
            ),
            const SizedBox(height: 24),

            // Opciones de verificación
            AppComponents.customListTile(
              context: context,
              title: 'Escanear QR',
              subtitle: 'Escanea el QR de tu DNI',
              leadingIcon: AppIcons.scan,
              onTap: _onScanQR,
            ),
            const SizedBox(height: 12),
            AppComponents.customListTile(
              context: context,
              title: 'Leer NFC',
              subtitle: 'Lee el chip NFC de tu DNIe',
              leadingIcon: AppIcons.nfc,
              onTap: _onReadNFC,
            ),
            const SizedBox(height: 32),

            // Botones de acción
            AppComponents.primaryButton(
              context: context,
              text: 'Continuar',
              onPressed: _isLoading ? null : _onContinue,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 12),
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

  void _onScanQR() {
    setState(() => _isLoading = true);
    // Simulación de carga
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Mostrar success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppComponents.statusBanner(
              context: context,
              message: 'QR escaneado exitosamente',
              status: StatusType.success,
            ),
          ),
        );
      }
    });
  }

  void _onReadNFC() {
    // Lógica de lectura NFC
  }

  void _onContinue() {
    // Lógica de continuación
  }
}
```

### Ejemplo 2: Pantalla de Resultados

```dart
class ResultsScreen extends StatelessWidget {
  final String documentNumber = '12345678X';
  final String fullName = 'Juan González Pérez';
  final bool isVerified = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Verificación'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner de éxito
          if (isVerified)
            AppComponents.statusBanner(
              context: context,
              message: '¡Verificación completada exitosamente!',
              status: StatusType.success,
            )
          else
            AppComponents.statusBanner(
              context: context,
              message: 'La verificación no se pudo completar',
              status: StatusType.error,
            ),
          const SizedBox(height: 24),

          // Card con información
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
                const SizedBox(height: 16),
                AppComponents.infoCard(
                  context: context,
                  label: 'Nombre Completo',
                  value: fullName,
                  icon: AppIcons.user,
                ),
                const SizedBox(height: 16),
                AppComponents.infoCard(
                  context: context,
                  label: 'Estado',
                  value: 'Verificado',
                  icon: AppIcons.verified,
                  statusColor: AppTheme.successColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botón de acción
          AppComponents.primaryButton(
            context: context,
            text: 'Aceptar',
            onPressed: () => Navigator.pop(context),
            icon: AppIcons.verified,
          ),
        ],
      ),
    );
  }
}
```

---

## 📱 Pantalla de Demostración

Para ver todos los componentes en acción, ejecuta:

```bash
# La app incluye una pantalla de showcase
# Accede desde el menú de desarrollo
```

---

## ✅ Checklist de Implementación

- [x] Nuevo tema Material 3 completo
- [x] Dark mode optimizado
- [x] Paleta de colores moderna
- [x] Tipografía Poppins
- [x] Componentes reutilizables
- [x] Sistema de iconos
- [x] Utilidades de diseño
- [x] Pantalla de demostración
- [x] Documentación completa

---

**Versión**: 1.0.0  
**Fecha**: 23 de Febrero de 2026  
**Estado**: ✅ Listo para usar
