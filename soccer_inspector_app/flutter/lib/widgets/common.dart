// lib/widgets/common.dart
import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

class BallLogo extends StatelessWidget {
  final double size;
  const BallLogo({super.key, this.size = 48});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: AppPalette.primaryGradient,
        borderRadius: AppPalette.radiusLg,
        boxShadow: AppPalette.glow,
      ),
      child: Icon(Icons.sports_soccer,
          color: const Color(0xFF0A1410), size: size * 0.6),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  const GlassCard({super.key, required this.child, this.padding, this.borderColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [AppPalette.surface1, AppPalette.surface2],
        ),
        border: Border.all(color: borderColor ?? AppPalette.border),
        borderRadius: AppPalette.radiusLg,
        boxShadow: AppPalette.card,
      ),
      child: child,
    );
  }
}

class JerseyAvatar extends StatelessWidget {
  final int numero;
  final double size;
  const JerseyAvatar({super.key, required this.numero, this.size = 44});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppPalette.primaryGradient,
        borderRadius: AppPalette.radiusMd,
        boxShadow: [
          BoxShadow(color: AppPalette.primary.withValues(alpha: 0.45),
              blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Text('$numero',
          style: TextStyle(
            color: const Color(0xFF0A1410),
            fontWeight: FontWeight.w800,
            fontSize: size * 0.4,
          )),
    );
  }
}

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  const StatusPill({super.key, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.icon});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppPalette.radiusLg,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: AppPalette.primaryGradient,
          borderRadius: AppPalette.radiusLg,
          boxShadow: AppPalette.glow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF0A1410),
                    fontWeight: FontWeight.w800,
                    fontSize: 15)),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, color: const Color(0xFF0A1410), size: 18),
            ]
          ],
        ),
      ),
    );
  }
}
