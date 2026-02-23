import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema visual moderno de la aplicación DNI-Connect
/// Diseño Material 3 con soporte completo para dark mode
class AppTheme {
  AppTheme._();

  // ─── PALETA DE COLORES MODERNA ────────────────────────────────────

  // Colores principales - Azul profesional con variaciones
  static const Color primaryColor = Color(0xFF0066FF);      // Azul vibrante
  static const Color primaryLight = Color(0xFF4D94FF);      // Azul claro
  static const Color primaryDark = Color(0xFF0052CC);       // Azul oscuro

  // Colores secundarios - Púrpura para acentos
  static const Color secondaryColor = Color(0xFF7C3AED);    // Púrpura vibrante
  static const Color secondaryLight = Color(0xFFA78BFA);    // Púrpura claro
  static const Color secondaryDark = Color(0xFF5B21B6);     // Púrpura oscuro

  // Estados
  static const Color successColor = Color(0xFF10B981);      // Verde éxito
  static const Color dangerColor = Color(0xFFEF4444);       // Rojo error
  static const Color warningColor = Color(0xFFF59E0B);      // Amarillo advertencia
  static const Color infoColor = Color(0xFF3B82F6);         // Azul info

  // Colores neutros - Light Mode
  static const Color lightBackground = Color(0xFFFAFBFC);   // Blanco ligeramente gris
  static const Color lightSurface = Color(0xFFFFFFFF);      // Blanco puro
  static const Color lightCardBg = Color(0xFFF8FAFC);       // Fondo tarjeta claro

  // Colores neutros - Dark Mode
  static const Color darkBackground = Color(0xFF0F172A);    // Azul muy oscuro
  static const Color darkSurface = Color(0xFF1E293B);       // Azul oscuro
  static const Color darkCardBg = Color(0xFF334155);        // Azul grisáceo

  // Texto
  static const Color textLight = Color(0xFF000000);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);

  // ─── TEMA CLARO ───────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        background: lightBackground,
      ),
      scaffoldBackgroundColor: lightBackground,
      useMaterial3: true,
      
      // ─── AppBar ───
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: textLight,
        elevation: 0.5,
        centerTitle: true,
        shadowColor: Colors.grey.withOpacity(0.1),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textLight,
          letterSpacing: 0.3,
        ),
      ),

      // ─── Card ───
      cardTheme: CardThemeData(
        color: lightCardBg,
        elevation: 0,
        shadowColor: Colors.grey.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ─── Elevated Button ───
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ─── Outlined Button ───
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: primaryColor, width: 2),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ─── Text Theme ───
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textLight,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textLight,
          letterSpacing: -0.3,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textLight,
          letterSpacing: 0,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textLight,
          letterSpacing: 0.2,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textLight,
          letterSpacing: 0.1,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textLight,
          letterSpacing: 0.15,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textSecondaryLight,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondaryLight,
          letterSpacing: 0.25,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryLight,
          letterSpacing: 0.4,
        ),
      ),

      // ─── Input Decoration ───
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        prefixIconColor: primaryColor,
        suffixIconColor: textSecondaryLight,
      ),

      // ─── Floating Action Button ───
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ─── Bottom Navigation ───
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryLight,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // ─── Dialog ───
      dialogTheme: DialogThemeData(
        backgroundColor: lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
      ),

      // ─── Chip ───
      chipTheme: ChipThemeData(
        backgroundColor: lightCardBg,
        selectedColor: primaryLight,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // ─── TEMA OSCURO (Modern Dark Mode) ────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryLight,        // Más claro en dark mode
        secondary: secondaryLight,
        surface: darkSurface,
        background: darkBackground,
      ),
      scaffoldBackgroundColor: darkBackground,
      useMaterial3: true,

      // ─── AppBar ───
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: textDark,
        elevation: 0.5,
        centerTitle: true,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: 0.3,
        ),
      ),

      // ─── Card ───
      cardTheme: CardThemeData(
        color: darkCardBg,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // ─── Elevated Button ───
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ─── Outlined Button ───
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: const BorderSide(color: primaryLight, width: 2),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // ─── Text Theme ───
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.3,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: 0,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: 0.2,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.1,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.15,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
          letterSpacing: 0.25,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryDark,
          letterSpacing: 0.4,
        ),
      ),

      // ─── Input Decoration ───
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade600,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryLight, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: dangerColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        prefixIconColor: primaryLight,
        suffixIconColor: textSecondaryDark,
      ),

      // ─── Floating Action Button ───
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // ─── Bottom Navigation ───
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryLight,
        unselectedItemColor: textSecondaryDark,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // ─── Dialog ───
      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 8,
      ),

      // ─── Chip ───
      chipTheme: ChipThemeData(
        backgroundColor: darkCardBg,
        selectedColor: primaryLight,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
