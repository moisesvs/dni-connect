import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({Key? key}) : super(key: key);

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'DNI-Connect',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.grey[900],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF2563EB),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return _buildHome();
    } else if (_selectedIndex == 1) {
      return _buildHistory();
    } else {
      return _buildSettings();
    }
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome card
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF1E40AF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Bienvenido de vuelta!',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Verifica tu identidad de forma segura',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Verification methods
            Text(
              'Métodos de verificación',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 16),
            _buildVerificationCard(
              icon: Icons.qr_code_2,
              title: 'Escanear QR',
              subtitle: 'Lee el QR de tu DNI',
              onTap: () => context.pushNamed('qr_scan'),
              color: const Color(0xFF2563EB),
            ),
            const SizedBox(height: 12),
            _buildVerificationCard(
              icon: Icons.nfc,
              title: 'Leer NFC',
              subtitle: 'Lee el chip de tu DNI',
              onTap: () => context.pushNamed('nfc_input'),
              color: const Color(0xFF10B981),
            ),
            const SizedBox(height: 32),
            // Security info
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF2563EB).withOpacity(0.2),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xFF2563EB),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verificación segura',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        Text(
                          'Tus datos están encriptados',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Historial vacío',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí aparecerán tus verificaciones',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSettingItem(
              icon: Icons.person_outline,
              title: 'Perfil',
              subtitle: 'Edita tu información',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.security_outlined,
              title: 'Seguridad',
              subtitle: 'Gestiona tu contraseña',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Configura tus preferencias',
              onTap: () {},
            ),
            _buildSettingItem(
              icon: Icons.info_outlined,
              title: 'Acerca de',
              subtitle: 'Versión 1.0.0',
              onTap: () {},
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () {
                // Handle logout
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cerrar sesión',
                style: GoogleFonts.inter(
                  color: const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!),
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
