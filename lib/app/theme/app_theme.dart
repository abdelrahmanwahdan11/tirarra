import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  static const Color seedColor = Color(0xFF6C5CE7);
  static const Color accentColor = Color(0xFFF06292);

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor:
          brightness == Brightness.dark ? const Color(0xFF0F111A) : Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          shadowColor: colorScheme.primary.withOpacity(0.25),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: colorScheme.primary.withOpacity(0.08),
        selectedColor: colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        secondaryLabelStyle: TextStyle(color: colorScheme.onPrimary),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface.withOpacity(0.65),
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.65),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      extensions: <ThemeExtension<dynamic>>[
        GlassTheme(
          blurSigma: 18,
          opacity: brightness == Brightness.dark ? 0.18 : 0.25,
          tintColor: brightness == Brightness.dark
              ? const Color(0xAA1B1D2A)
              : const Color(0xAAFFFFFF),
        ),
      ],
    );
  }
}

class GlassTheme extends ThemeExtension<GlassTheme> {
  const GlassTheme({
    required this.blurSigma,
    required this.opacity,
    required this.tintColor,
  });

  final double blurSigma;
  final double opacity;
  final Color tintColor;

  @override
  GlassTheme copyWith({double? blurSigma, double? opacity, Color? tintColor}) {
    return GlassTheme(
      blurSigma: blurSigma ?? this.blurSigma,
      opacity: opacity ?? this.opacity,
      tintColor: tintColor ?? this.tintColor,
    );
  }

  @override
  GlassTheme lerp(ThemeExtension<GlassTheme>? other, double t) {
    if (other is! GlassTheme) {
      return this;
    }
    return GlassTheme(
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t) ?? blurSigma,
      opacity: lerpDouble(opacity, other.opacity, t) ?? opacity,
      tintColor: Color.lerp(tintColor, other.tintColor, t) ?? tintColor,
    );
  }
}
