import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_components.dart';

/// Pantalla de demostración del nuevo diseño
/// Diseño Dark Mode mejorado con interfaz sofisticada y moderna
class DesignShowcaseScreen extends StatefulWidget {
  const DesignShowcaseScreen({Key? key}) : super(key: key);

  @override
  State<DesignShowcaseScreen> createState() => _DesignShowcaseScreenState();
}

class _DesignShowcaseScreenState extends State<DesignShowcaseScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildCustomAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBackground,
              AppTheme.darkBackground.withGreen(
                AppTheme.darkBackground.green + 5,
              ),
            ],
          ),
        ),
        child: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _buildColorPalette(),
              _buildComponentsDemo(),
              _buildStatusDemo(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCustomBottomNav(),
    );
  }

  AppBar _buildCustomAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DNI-Connect',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
          ),
          Text(
            'Sistema de Diseño Moderno',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryDark,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
      elevation: 0,
      backgroundColor: AppTheme.darkSurface.withOpacity(0.95),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkSurface,
              AppTheme.darkSurface.withBlue(180),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkSurface,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryDark.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: AnimatedIcon(
              icon: AnimatedIcons.home_menu,
              progress: _selectedTab == 0
                  ? _animationController
                  : const AlwaysStoppedAnimation(0),
            ),
            label: 'Colores',
          ),
          BottomNavigationBarItem(
            icon: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _selectedTab == 1
                  ? _animationController
                  : const AlwaysStoppedAnimation(0),
            ),
            label: 'Componentes',
          ),
          BottomNavigationBarItem(
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_arrow,
              progress: _selectedTab == 2
                  ? _animationController
                  : const AlwaysStoppedAnimation(0),
            ),
            label: 'Estados',
          ),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    return ListView(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 100),
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.15),
                AppTheme.secondaryColor.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🎨 Paleta de Colores',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sistema de colores moderno y accesible',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryDark,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Colores Primarios
        _colorSection(
          context,
          '🔵 Colores Primarios',
          [
            ('Azul Vibrante', AppTheme.primaryColor, '#0066FF'),
            ('Azul Claro', AppTheme.primaryLight, '#4D94FF'),
            ('Azul Oscuro', AppTheme.primaryDark, '#0052CC'),
          ],
        ),
        const SizedBox(height: 28),

        // Colores Secundarios
        _colorSection(
          context,
          '💜 Colores Secundarios',
          [
            ('Púrpura', AppTheme.secondaryColor, '#7C3AED'),
            ('Púrpura Claro', AppTheme.secondaryLight, '#A78BFA'),
            ('Púrpura Oscuro', AppTheme.secondaryDark, '#5B21B6'),
          ],
        ),
        const SizedBox(height: 28),

        // Estados
        _colorSection(
          context,
          '📊 Estados',
          [
            ('Éxito', AppTheme.successColor, '#10B981'),
            ('Error', AppTheme.dangerColor, '#EF4444'),
            ('Advertencia', AppTheme.warningColor, '#F59E0B'),
            ('Información', AppTheme.infoColor, '#3B82F6'),
          ],
        ),
      ],
    );
  }

  Widget _colorSection(
    BuildContext context,
    String title,
    List<(String, Color, String)> colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 12),
        ...colors.map((color) {
          final (name, colorValue, hex) = color;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _colorCard(context, name, colorValue, hex),
          );
        }),
      ],
    );
  }

  Widget _colorCard(
    BuildContext context,
    String name,
    Color color,
    String hex,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Color preview con efecto
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Información
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hex,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryDark,
                          fontFamily: 'Courier',
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Indicador visual
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
    );
  }

  Widget _buildComponentsDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 🔘 Sección de Botones
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.15),
                AppTheme.secondaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '🔘',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Botones & Controles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppComponents.primaryButton(
                context: context,
                text: 'Botón Primario',
                onPressed: () {},
                icon: AppIcons.verified,
              ),
              const SizedBox(height: 12),
              AppComponents.secondaryButton(
                context: context,
                text: 'Botón Secundario',
                onPressed: () {},
                icon: AppIcons.edit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 💳 Sección de Cards
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryColor.withOpacity(0.15),
                AppTheme.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '💳',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Cards y Contenedores',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppComponents.headerCard(
                context: context,
                title: 'Verificación Exitosa',
                subtitle: 'Tu DNI ha sido verificado correctamente',
                icon: AppIcons.verified,
                iconColor: AppTheme.successColor,
              ),
              const SizedBox(height: 16),
              AppComponents.modernCard(
                context: context,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Información del Usuario',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textDark,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppComponents.infoCard(
                      context: context,
                      label: 'Documento',
                      value: '12345678X',
                      icon: AppIcons.id,
                    ),
                    const SizedBox(height: 12),
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
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 📋 Sección de Items de Lista
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.successColor.withOpacity(0.12),
                AppTheme.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.successColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '📋',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Items de Lista',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppComponents.customListTile(
                context: context,
                title: 'Verificación de DNI',
                subtitle: 'Verifica tu identidad con QR o NFC',
                leadingIcon: AppIcons.verification,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              AppComponents.customListTile(
                context: context,
                title: 'Configuración',
                subtitle: 'Personaliza tu experiencia',
                leadingIcon: AppIcons.settings,
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDemo() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 🎨 Sección de Estados de Mensaje
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.infoColor.withOpacity(0.15),
                AppTheme.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.infoColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '🎨',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Estados de Mensajes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppComponents.statusBanner(
                context: context,
                message: '✨ ¡Verificación completada exitosamente!',
                status: StatusType.success,
              ),
              const SizedBox(height: 12),
              AppComponents.statusBanner(
                context: context,
                message: '⚠️ Por favor, completa este campo',
                status: StatusType.warning,
              ),
              const SizedBox(height: 12),
              AppComponents.statusBanner(
                context: context,
                message: '❌ Ocurrió un error durante el proceso',
                status: StatusType.error,
                onClose: () {},
              ),
              const SizedBox(height: 12),
              AppComponents.statusBanner(
                context: context,
                message: 'ℹ️ Para continuar, necesitamos tu consentimiento',
                status: StatusType.info,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // ⏳ Sección de Estados de Carga
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.secondaryColor.withOpacity(0.15),
                AppTheme.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '⏳',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Estados de Carga',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: AppComponents.loadingIndicator(
                  context: context,
                  message: '🔍 Verificando datos...',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // 📭 Sección de Estado Vacío
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.warningColor.withOpacity(0.12),
                AppTheme.primaryColor.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.warningColor.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '📭',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Estado Vacío',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppComponents.emptyState(
                context: context,
                icon: AppIcons.document,
                title: 'Sin documentos',
                message: 'No hay documentos verificados aún',
                actionButton: AppComponents.primaryButton(
                  context: context,
                  text: 'Verificar DNI',
                  onPressed: () {},
                  width: 200,
                  icon: AppIcons.verification,
                ),
              ),
            ],
          ),
        ),
      ],
  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
