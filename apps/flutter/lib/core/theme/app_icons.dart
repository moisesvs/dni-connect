import 'package:flutter/material.dart';

/// Iconos personalizados y utilidades de diseño para DNI-Connect
class AppIcons {
  AppIcons._();

  // ─── Iconos de Autenticación ──────────────────────────────────────
  static const IconData document = Icons.description_outlined;
  static const IconData scan = Icons.qr_code_scanner;
  static const IconData nfc = Icons.credit_card;
  static const IconData verification = Icons.verified_user;
  static const IconData verified = Icons.verified;
  static const IconData shield = Icons.shield;
  static const IconData security = Icons.security;

  // ─── Iconos de Navegación ─────────────────────────────────────────
  static const IconData home = Icons.home_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData back = Icons.arrow_back_ios_new_rounded;
  static const IconData forward = Icons.arrow_forward_ios_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData close = Icons.close_rounded;

  // ─── Iconos de Acciones ───────────────────────────────────────────
  static const IconData add = Icons.add_rounded;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData copy = Icons.content_copy_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData upload = Icons.cloud_upload_outlined;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData more = Icons.more_vert_rounded;

  // ─── Iconos de Estados ────────────────────────────────────────────
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData pending = Icons.hourglass_bottom_rounded;
  static const IconData loading = Icons.autorenew;

  // ─── Iconos de Datos ──────────────────────────────────────────────
  static const IconData user = Icons.person_outline_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData location = Icons.location_on_outlined;
  static const IconData calendar = Icons.calendar_month_outlined;
  static const IconData clock = Icons.access_time_rounded;
  static const IconData id = Icons.credit_card_outlined;

  // ─── Iconos de Seguridad ──────────────────────────────────────────
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData lockOpen = Icons.lock_open_rounded;
  static const IconData fingerprint = Icons.fingerprint_rounded;
  static const IconData visibility = Icons.visibility_rounded;
  static const IconData visibilityOff = Icons.visibility_off_rounded;
  static const IconData vpn = Icons.vpn_lock_rounded;

  // ─── Iconos de Comunicación ───────────────────────────────────────
  static const IconData notification = Icons.notifications_outlined;
  static const IconData chat = Icons.message_outlined;
  static const IconData call = Icons.call_outlined;
  static const IconData share = Icons.share_rounded;
  static const IconData send = Icons.send_rounded;

  // ─── Iconos de Utilidad ───────────────────────────────────────────
  static const IconData help = Icons.help_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.tune_rounded;
  static const IconData sort = Icons.sort_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData heart = Icons.favorite_rounded;
  static const IconData bookmark = Icons.bookmark_rounded;
  static const IconData logout = Icons.logout_rounded;

  // ─── Métodos auxiliares para renderizar iconos ─────────────────────

  /// Icono con color primario
  static Widget primary(IconData icon, {double size = 24}) {
    return Icon(icon, size: size, color: const Color(0xFF0066FF));
  }

  /// Icono con color secundario
  static Widget secondary(IconData icon, {double size = 24}) {
    return Icon(icon, size: size, color: const Color(0xFF7C3AED));
  }

  /// Icono de éxito
  static Widget success(IconData icon, {double size = 24}) {
    return Icon(icon, size: size, color: const Color(0xFF10B981));
  }

  /// Icono de error
  static Widget error(IconData icon, {double size = 24}) {
    return Icon(icon, size: size, color: const Color(0xFFEF4444));
  }

  /// Icono de advertencia
  static Widget warning(IconData icon, {double size = 24}) {
    return Icon(icon, size: size, color: const Color(0xFFF59E0B));
  }

  /// Icono con color personalizado
  static Widget custom(IconData icon, Color color, {double size = 24}) {
    return Icon(icon, size: size, color: color);
  }

  /// Icono en un círculo colorido
  static Widget inCircle(
    IconData icon, {
    required Color backgroundColor,
    Color iconColor = Colors.white,
    double size = 40,
    double iconSize = 24,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }

  /// Badge con icono
  static Widget withBadge(
    IconData icon,
    String badge, {
    Color backgroundColor = const Color(0xFF0066FF),
    Color badgeColor = const Color(0xFFEF4444),
    double size = 24,
  }) {
    return Stack(
      children: [
        Icon(icon, size: size, color: backgroundColor),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Utilidades de diseño visual
class DesignUtils {
  DesignUtils._();

  // ─── Espaciados estándar ──────────────────────────────────────────
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  // ─── Border Radius estándar ───────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusCircle = 50;

  // ─── Shadow estándar ──────────────────────────────────────────────
  static BoxShadow shadowSm = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 2,
    offset: const Offset(0, 1),
  );

  static BoxShadow shadowMd = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 4,
    offset: const Offset(0, 2),
  );

  static BoxShadow shadowLg = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );

  static List<BoxShadow> shadowsSmall = [shadowSm];
  static List<BoxShadow> shadowsMedium = [shadowMd];
  static List<BoxShadow> shadowsLarge = [shadowLg];

  // ─── Duraciones de animación ──────────────────────────────────────
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ─── Métodos auxiliares ───────────────────────────────────────────

  /// Crea un divisor estilizado
  static Widget divider({Color? color, double height = 1}) {
    return Container(
      height: height,
      color: color ?? Colors.grey.shade300,
    );
  }

  /// Crea un espaciador vertical
  static Widget verticalSpacing(double height) {
    return SizedBox(height: height);
  }

  /// Crea un espaciador horizontal
  static Widget horizontalSpacing(double width) {
    return SizedBox(width: width);
  }

  /// Crea un borde redondeado estilizado
  static BorderRadius borderRadius(double radius) {
    return BorderRadius.all(Radius.circular(radius));
  }

  /// Crea un contenedor con fondo y borde
  static BoxDecoration boxDecoration({
    Color backgroundColor = Colors.white,
    Color borderColor = Colors.transparent,
    double borderWidth = 1,
    double borderRadius = radiusLg,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      boxShadow: boxShadow,
    );
  }

  /// Crea un gradiente lineal
  static LinearGradient linearGradient({
    required Color startColor,
    required Color endColor,
    begin = Alignment.topLeft,
    end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: [startColor, endColor],
      begin: begin,
      end: end,
    );
  }

  /// Crea un chip estilizado
  static Widget chip(
    String label, {
    VoidCallback? onDelete,
    Color backgroundColor = const Color(0xFFF3F4F6),
    Color textColor = Colors.black,
    required BuildContext context,
  }) {
    return Chip(
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
      ),
      backgroundColor: backgroundColor,
      onDeleted: onDelete,
      deleteIcon: const Icon(Icons.close_rounded, size: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLg),
      ),
    );
  }

  /// Crea un badge
  static Widget badge(
    String text, {
    Color backgroundColor = const Color(0xFF0066FF),
    Color textColor = Colors.white,
    double size = 20,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: lg / 2, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radiusCircle),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
