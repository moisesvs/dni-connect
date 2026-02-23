# 📱 Ejemplos de Pantallas Actualizadas

Ejemplos completos de pantallas de DNI-Connect usando el nuevo sistema de diseño.

---

## 📋 Contenido

- [Pantalla de Login](#pantalla-de-login)
- [Pantalla de Selección de Método](#pantalla-de-selección-de-método)
- [Pantalla de Escaneo QR](#pantalla-de-escaneo-qr)
- [Pantalla de Lectura NFC](#pantalla-de-lectura-nfc)
- [Pantalla de Resultados Exitosos](#pantalla-de-resultados-exitosos)
- [Pantalla de Error](#pantalla-de-error)
- [Pantalla de Perfil](#pantalla-de-perfil)

---

## 🔐 Pantalla de Login

```dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(DesignUtils.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo / Header
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: DesignUtils.xl,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          DesignUtils.radiusCircle,
                        ),
                      ),
                      child: Icon(
                        AppIcons.verification,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: DesignUtils.lg),
                    Text(
                      'DNI-Connect',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: DesignUtils.sm),
                    Text(
                      'Verificación segura de identidad',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: DesignUtils.xl),

              // Email field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'tu@correo.com',
                  prefixIcon: Icon(AppIcons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      DesignUtils.radiusLg,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: DesignUtils.lg,
                    horizontal: DesignUtils.lg,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: DesignUtils.lg),

              // Password field
              TextField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: '••••••••',
                  prefixIcon: Icon(AppIcons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword
                          ? AppIcons.visibility
                          : AppIcons.visibilityOff,
                    ),
                    onPressed: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      DesignUtils.radiusLg,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: DesignUtils.lg,
                    horizontal: DesignUtils.lg,
                  ),
                ),
              ),
              SizedBox(height: DesignUtils.lg),

              // Remember me
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  Text('Recuérdame'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '¿Olvidaste la contraseña?',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: DesignUtils.xl),

              // Login button
              AppComponents.primaryButton(
                context: context,
                text: 'Iniciar Sesión',
                onPressed: _isLoading ? null : _onLogin,
                isLoading: _isLoading,
                icon: AppIcons.forward,
              ),
              SizedBox(height: DesignUtils.lg),

              // Sign up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes cuenta? '),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Regístrate',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    setState(() => _isLoading = true);
    // Simulación de login
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        // Navegar a siguiente pantalla
        Navigator.pushReplacementNamed(context, '/verify');
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

## 🔄 Pantalla de Selección de Método

```dart
class VerificationMethodScreen extends StatelessWidget {
  const VerificationMethodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Método de Verificación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header informativo
            AppComponents.headerCard(
              context: context,
              title: 'Elige tu método',
              subtitle: 'Selecciona cómo deseas verificar tu identidad',
              icon: AppIcons.verification,
              iconColor: AppTheme.primaryColor,
            ),
            SizedBox(height: DesignUtils.xl),

            // Método 1: QR
            AppComponents.customListTile(
              context: context,
              title: 'Escanear Código QR',
              subtitle: 'Escanea el QR de tu MiDNI usando la cámara',
              leadingIcon: AppIcons.scan,
              onTap: () {
                Navigator.pushNamed(context, '/verify/qr');
              },
            ),
            SizedBox(height: DesignUtils.lg),

            // Método 2: NFC
            AppComponents.customListTile(
              context: context,
              title: 'Leer DNIe (NFC)',
              subtitle: 'Lee el chip NFC de tu documento',
              leadingIcon: AppIcons.nfc,
              onTap: () {
                Navigator.pushNamed(context, '/verify/nfc');
              },
            ),
            SizedBox(height: DesignUtils.xl),

            // Info sobre métodos
            AppComponents.statusBanner(
              context: context,
              message: 'Ambos métodos son seguros y verificados',
              status: StatusType.info,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 📱 Pantalla de Escaneo QR

```dart
class QRScanScreen extends StatefulWidget {
  const QRScanScreen({Key? key}) : super(key: key);

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen> {
  bool _isScanning = true;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Camera preview aquí
          Center(
            child: AppComponents.loadingIndicator(
              context: context,
              message: 'Activando cámara...',
            ),
          ),

          // Bottom sheet con instrucciones
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(DesignUtils.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isProcessing)
                      AppComponents.statusBanner(
                        context: context,
                        message: 'Procesando QR...',
                        status: StatusType.info,
                      )
                    else
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(DesignUtils.lg),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                DesignUtils.radiusLg,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  AppIcons.scan,
                                  color: AppTheme.primaryColor,
                                  size: 40,
                                ),
                                SizedBox(height: DesignUtils.md),
                                Text(
                                  'Posiciona el código QR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: DesignUtils.sm),
                                Text(
                                  'Apunta la cámara al QR de tu MiDNI',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: DesignUtils.xl),
                          AppComponents.primaryButton(
                            context: context,
                            text: 'Cancelar',
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 📲 Pantalla de Lectura NFC

```dart
class NFCReadScreen extends StatefulWidget {
  const NFCReadScreen({Key? key}) : super(key: key);

  @override
  State<NFCReadScreen> createState() => _NFCReadScreenState();
}

class _NFCReadScreenState extends State<NFCReadScreen> {
  bool _isReading = true;
  String _status = 'Acercando el dispositivo al chip NFC...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leer DNIe'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(DesignUtils.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // NFC Animation
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      AppTheme.primaryColor.withOpacity(0.1),
                ),
                child: Icon(
                  AppIcons.nfc,
                  color: AppTheme.primaryColor,
                  size: 80,
                ),
              ),
              SizedBox(height: DesignUtils.xl),

              // Status text
              Text(
                _status,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: DesignUtils.lg),

              // Instructions
              AppComponents.modernCard(
                context: context,
                child: Column(
                  children: [
                    Text(
                      'Instrucciones:',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    SizedBox(height: DesignUtils.md),
                    _buildInstructionItem(
                      '1. Coloca el documento en la parte trasera del teléfono',
                    ),
                    SizedBox(height: DesignUtils.sm),
                    _buildInstructionItem(
                      '2. Mantén el contacto durante 2-3 segundos',
                    ),
                    SizedBox(height: DesignUtils.sm),
                    _buildInstructionItem(
                      '3. Espera a que se complete la lectura',
                    ),
                  ],
                ),
              ),
              SizedBox(height: DesignUtils.xl),

              // Cancel button
              AppComponents.secondaryButton(
                context: context,
                text: 'Cancelar',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: AppTheme.successColor,
          size: 24,
        ),
        SizedBox(width: DesignUtils.md),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
```

---

## ✅ Pantalla de Resultados Exitosos

```dart
class VerificationSuccessScreen extends StatelessWidget {
  final String documentNumber;
  final String fullName;
  final String documentType;

  const VerificationSuccessScreen({
    required this.documentNumber,
    required this.fullName,
    required this.documentType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success banner
            AppComponents.statusBanner(
              context: context,
              message: '¡Verificación completada exitosamente!',
              status: StatusType.success,
            ),
            SizedBox(height: DesignUtils.xl),

            // Header card
            AppComponents.headerCard(
              context: context,
              title: fullName,
              subtitle: 'Identidad verificada',
              icon: AppIcons.verified,
              iconColor: AppTheme.successColor,
            ),
            SizedBox(height: DesignUtils.xl),

            // Details card
            AppComponents.modernCard(
              context: context,
              child: Column(
                children: [
                  AppComponents.infoCard(
                    context: context,
                    label: 'Tipo de Documento',
                    value: documentType,
                    icon: AppIcons.id,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Número',
                    value: documentNumber,
                    icon: AppIcons.document,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Estado',
                    value: 'Verificado',
                    icon: AppIcons.verified,
                    statusColor: AppTheme.successColor,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Fecha de Verificación',
                    value: DateTime.now()
                        .toString()
                        .split(' ')[0],
                    icon: AppIcons.calendar,
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // Action buttons
            AppComponents.primaryButton(
              context: context,
              text: 'Continuar',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: AppIcons.forward,
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.secondaryButton(
              context: context,
              text: 'Ver Detalles',
              onPressed: () {
                // Mostrar detalles completos
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## ❌ Pantalla de Error

```dart
class VerificationErrorScreen extends StatelessWidget {
  final String errorMessage;
  final String? errorCode;

  const VerificationErrorScreen({
    required this.errorMessage,
    this.errorCode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error de Verificación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error banner
            AppComponents.statusBanner(
              context: context,
              message: 'No se pudo completar la verificación',
              status: StatusType.error,
            ),
            SizedBox(height: DesignUtils.xl),

            // Error details
            Container(
              padding: EdgeInsets.all(DesignUtils.lg),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  DesignUtils.radiusLg,
                ),
                border: Border.all(
                  color: AppTheme.errorColor
                      .withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    AppIcons.error,
                    color: AppTheme.errorColor,
                    size: 48,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  Text(
                    'Error de Verificación',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: DesignUtils.md),
                  Text(
                    errorMessage,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (errorCode != null)
                    Padding(
                      padding: EdgeInsets.only(
                        top: DesignUtils.lg,
                      ),
                      child: Text(
                        'Código: $errorCode',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // Tips
            AppComponents.modernCard(
              context: context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sugerencias:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge,
                  ),
                  SizedBox(height: DesignUtils.md),
                  _buildTip('Verifica que el QR esté legible'),
                  _buildTip(
                    'Asegúrate de que el chip NFC esté en buen estado',
                  ),
                  _buildTip('Intenta nuevamente en un momento'),
                ],
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // Action buttons
            AppComponents.primaryButton(
              context: context,
              text: 'Intentar de Nuevo',
              onPressed: () {
                Navigator.pop(context);
              },
              icon: AppIcons.refresh,
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.secondaryButton(
              context: context,
              text: 'Volver al Inicio',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: DesignUtils.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: AppTheme.warningColor,
            size: 20,
          ),
          SizedBox(width: DesignUtils.md),
          Expanded(
            child: Text(tip),
          ),
        ],
      ),
    );
  }
}
```

---

## 👤 Pantalla de Perfil

```dart
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? AppIcons.close : AppIcons.edit),
            onPressed: () {
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DesignUtils.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Avatar
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.user,
                  color: AppTheme.primaryColor,
                  size: 50,
                ),
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // User info
            AppComponents.modernCard(
              context: context,
              child: Column(
                children: [
                  AppComponents.infoCard(
                    context: context,
                    label: 'Nombre',
                    value: 'Juan González',
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Correo',
                    value: 'juan@example.com',
                    icon: AppIcons.email,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Teléfono',
                    value: '+34 600 123 456',
                    icon: AppIcons.phone,
                  ),
                  SizedBox(height: DesignUtils.lg),
                  AppComponents.infoCard(
                    context: context,
                    label: 'Estado de Verificación',
                    value: 'Verificado',
                    icon: AppIcons.verified,
                    statusColor: AppTheme.successColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignUtils.xl),

            // Settings
            AppComponents.customListTile(
              context: context,
              title: 'Configuración de Privacidad',
              subtitle: 'Gestiona tus permisos',
              leadingIcon: AppIcons.shield,
              onTap: () {},
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.customListTile(
              context: context,
              title: 'Notificaciones',
              subtitle: 'Configura alertas',
              leadingIcon: AppIcons.notification,
              onTap: () {},
            ),
            SizedBox(height: DesignUtils.md),
            AppComponents.customListTile(
              context: context,
              title: 'Ayuda y Soporte',
              subtitle: 'Contacta con nosotros',
              leadingIcon: AppIcons.help,
              onTap: () {},
            ),
            SizedBox(height: DesignUtils.xl),

            // Logout button
            AppComponents.primaryButton(
              context: context,
              text: 'Cerrar Sesión',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: AppIcons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Notas de Implementación

1. **Imports obligatorios** en cada pantalla:
   ```dart
   import '../../../core/theme/app_theme.dart';
   import '../../../core/theme/app_icons.dart';
   import '../../../core/theme/app_components.dart';
   ```

2. **Espaciados** - Siempre usa `DesignUtils`:
   - Entre secciones: `DesignUtils.xl` (24px)
   - Dentro de secciones: `DesignUtils.lg` (16px)
   - Entre elementos pequeños: `DesignUtils.md` (12px)

3. **Colores** - Siempre usa constantes de `AppTheme`:
   - No hardcodees colores como `#0066FF`
   - Usa `AppTheme.primaryColor`, `AppTheme.successColor`, etc.

4. **Componentes** - Prefiere `AppComponents` sobre crear widgets propios:
   - `primaryButton()` para acciones principales
   - `modernCard()` para contenedores
   - `statusBanner()` para mensajes de estado
   - `customListTile()` para opciones

5. **Iconos** - Usa `AppIcons` en lugar de `Icons`:
   ```dart
   Icon(AppIcons.verification)  // ✅ Correcto
   Icon(Icons.verified)         // ❌ Incorrecto
   ```

---

**Versión**: 1.0.0  
**Última actualización**: 23 de Febrero, 2026  
**Estado**: ✅ Listo para usar
