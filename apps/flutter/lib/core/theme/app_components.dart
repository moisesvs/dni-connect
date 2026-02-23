import 'package:flutter/material.dart';
import 'app_icons.dart';

/// Componentes UI reutilizables con diseño moderno
class AppComponents {
  AppComponents._();

  // ─── Card personalizada ───────────────────────────────────────────
  static Widget modernCard({
    required BuildContext context,
    required Widget child,
    void Function()? onTap,
    Color? backgroundColor,
    double borderRadius = 16,
    EdgeInsets padding = const EdgeInsets.all(16),
    List<BoxShadow>? shadows,
    Border? border,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ??
                (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF334155)
                    : Colors.white),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shadows ??
                [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
            border: border,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }

  // ─── Header card ──────────────────────────────────────────────────
  static Widget headerCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return modernCard(
      context: context,
      backgroundColor: backgroundColor ??
          (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E3A5F)
              : const Color(0xFFEBF2FF)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (iconColor ?? const Color(0xFF0066FF)).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? const Color(0xFF0066FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Info card con estado ─────────────────────────────────────────
  static Widget infoCard({
    required BuildContext context,
    required String label,
    required String value,
    IconData? icon,
    Color? statusColor,
    bool isLoading = false,
  }) {
    return modernCard(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: statusColor),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading)
            const SizedBox(
              height: 20,
              child: LinearProgressIndicator(),
            )
          else
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
            ),
        ],
      ),
    );
  }

  // ─── Button primario ──────────────────────────────────────────────
  static Widget primaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    double width = double.infinity,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }

  // ─── Button secundario ────────────────────────────────────────────
  static Widget secondaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    double width = double.infinity,
  }) {
    return SizedBox(
      width: width,
      height: 56,
      child: OutlinedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF0066FF),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }

  // ─── Status banner ────────────────────────────────────────────────
  static Widget statusBanner({
    required BuildContext context,
    required String message,
    required StatusType status,
    VoidCallback? onClose,
  }) {
    final colors = _getStatusColors(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors['background'] as Color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors['border'] as Color),
      ),
      child: Row(
        children: [
          Icon(colors['icon'] as IconData, color: colors['text'] as Color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors['text'] as Color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClose,
              child: Icon(Icons.close_rounded,
                  color: colors['text'] as Color, size: 20),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Loading indicator ────────────────────────────────────────────
  static Widget loadingIndicator({
    required BuildContext context,
    String? message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  // ─── Empty state ──────────────────────────────────────────────────
  static Widget emptyState({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    Widget? actionButton,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: const Color(0xFF0066FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              const SizedBox(height: 24),
              actionButton,
            ],
          ],
        ),
      ),
    );
  }

  // ─── List tile personalizado ──────────────────────────────────────
  static Widget customListTile({
    required BuildContext context,
    required String title,
    String? subtitle,
    IconData? leadingIcon,
    Widget? trailing,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return modernCard(
      context: context,
      backgroundColor: backgroundColor,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 24),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ] else ...[
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Métodos auxiliares ───────────────────────────────────────────

  static Map<String, dynamic> _getStatusColors(StatusType status) {
    switch (status) {
      case StatusType.success:
        return {
          'background': const Color(0xFF10B981).withOpacity(0.1),
          'border': const Color(0xFF10B981),
          'text': const Color(0xFF059669),
          'icon': Icons.check_circle_rounded,
        };
      case StatusType.error:
        return {
          'background': const Color(0xFFEF4444).withOpacity(0.1),
          'border': const Color(0xFFEF4444),
          'text': const Color(0xFFDC2626),
          'icon': Icons.error_rounded,
        };
      case StatusType.warning:
        return {
          'background': const Color(0xFFF59E0B).withOpacity(0.1),
          'border': const Color(0xFFF59E0B),
          'text': const Color(0xFFD97706),
          'icon': Icons.warning_rounded,
        };
      case StatusType.info:
        return {
          'background': const Color(0xFF3B82F6).withOpacity(0.1),
          'border': const Color(0xFF3B82F6),
          'text': const Color(0xFF1D4ED8),
          'icon': Icons.info_rounded,
        };
    }
  }
}

/// Tipos de estado para banners
enum StatusType {
  success,
  error,
  warning,
  info,
}
