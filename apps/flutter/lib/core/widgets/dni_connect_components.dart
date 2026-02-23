import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Componentes reutilizables para DNI-Connect
class DniConnectComponents {
  DniConnectComponents._();

  /// Botón primario con loading state opcional
  static Widget primaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isFullWidth = true,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  /// Card de verificación con icono y acción
  static Widget verificationCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF2563EB),
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
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
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

  /// Tarjeta de información con icono
  static Widget infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color backgroundColor = const Color(0xFFF0F9FF),
    Color iconColor = const Color(0xFF2563EB),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                Text(
                  subtitle,
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
    );
  }

  /// Input field con label y validación
  static Widget inputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    IconData? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixTap,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Tarjeta con gradiente para headers
  static Widget gradientCard({
    required String title,
    required String subtitle,
    Gradient gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  /// Setting item con icono y descripción
  static Widget settingItem({
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
              Icon(Icons.arrow_forward_ios,
                  color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Divider con texto
  static Widget dividerWithText({required String text}) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.grey[300]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.grey[300]),
        ),
      ],
    );
  }

  /// Empty state
  static Widget emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}
