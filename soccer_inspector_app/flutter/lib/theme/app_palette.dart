// lib/theme/app_palette.dart
//
// SOCCER INSPECTOR — Paleta de cores trocável.
// Para mudar a vibe do app, basta substituir os valores hex abaixo.
// Todos os widgets consomem cores via AppPalette.current — não use
// Colors.green, etc. diretamente nos componentes.
//
// Paletas alternativas prontas (descomente uma para trocar):
//
// === Verde neon esportivo (default) ===
//   primary #04E762  glow #80ED99  accent #38A3A5  deep #22577A
//
// === Azul tático ===
//   primary #57CC99  glow #C7F9CC  accent #38A3A5  deep #22577A
//
// === Multicolor vibrante ===
//   primary #DC0073  glow #F5B700  accent #008BF8  deep #FFFFFF
//
// === Tech roxo + ciano ===
//   primary #7014F2  glow #00F59B  accent #21B0FE  deep #1C9EDA

import 'package:flutter/material.dart';

class AppPalette {
  // === ALTERE AQUI PARA TROCAR DE PALETA ===
  static const Color primary       = Color(0xFF04E762);
  static const Color primaryGlow   = Color(0xFF80ED99);
  static const Color accent        = Color(0xFF38A3A5);
  static const Color deep          = Color(0xFF22577A);
  static const Color warning       = Color(0xFFF5B700);
  static const Color danger        = Color(0xFFDC0073);

  // Superfícies (geradas do dark-mode esportivo)
  static const Color surface0      = Color(0xFF0E1A14);
  static const Color surface1      = Color(0xFF142219);
  static const Color surface2      = Color(0xFF1B2C22);
  static const Color surface3      = Color(0xFF253A2C);

  static const Color foreground    = Color(0xFFF1FFF5);
  static const Color mutedFg       = Color(0xFF8FA89A);
  static const Color border        = Color(0x1AFFFFFF);

  static const Color success       = primary;
  static const Color info          = accent;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryGlow],
  );

  static const LinearGradient pitchGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface0, Color(0xFF0A140F)],
  );

  static List<BoxShadow> glow = [
    BoxShadow(color: primary.withValues(alpha: 0.35), blurRadius: 32, offset: const Offset(0, 12)),
  ];

  static List<BoxShadow> card = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 24, offset: const Offset(0, 8)),
  ];

  static BorderRadius radiusLg = BorderRadius.circular(20);
  static BorderRadius radiusMd = BorderRadius.circular(14);
  static BorderRadius radiusSm = BorderRadius.circular(10);
}

class AppTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppPalette.surface0,
      colorScheme: const ColorScheme.dark(
        primary: AppPalette.primary,
        onPrimary: Color(0xFF0A1410),
        secondary: AppPalette.accent,
        surface: AppPalette.surface1,
        onSurface: AppPalette.foreground,
        error: AppPalette.danger,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppPalette.foreground,
        displayColor: AppPalette.foreground,
      ),
      cardTheme: CardThemeData(
        color: AppPalette.surface1,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppPalette.radiusLg),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.surface2,
        hintStyle: const TextStyle(color: AppPalette.mutedFg),
        border: OutlineInputBorder(
          borderRadius: AppPalette.radiusMd,
          borderSide: const BorderSide(color: AppPalette.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppPalette.radiusMd,
          borderSide: const BorderSide(color: AppPalette.primary, width: 2),
        ),
      ),
    );
  }
}
