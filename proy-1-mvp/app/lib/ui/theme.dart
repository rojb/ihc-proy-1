import 'package:flutter/material.dart';

import 'spacing.dart';

/// Paleta y tipografía.
///
/// Dirección: la app se usa de noche, en la cama o en el bus, para descartar
/// opciones rápido. Así que el color no decora — separa lo que se compara
/// (precio, fecha, vigencia) de lo que acompaña.
///
/// El verde viene de la bandera cruceña, oscurecido hasta pasar contraste AA
/// sobre el fondo. El naranja es urucú, el pigmento local: se usa solo para el
/// estado que exige atención. Ningún estado se comunica solo por color: el NFR
/// de accesibilidad lo prohíbe, así que cada color viaja con texto e ícono.
///
/// No se cargan fuentes externas a propósito. El NFR de red inestable pide que
/// la app sirva sin conexión, y una tipografía descargada en tiempo de
/// ejecución rompe eso. La personalidad la da la escala, no la familia.
abstract final class AppColors {
  static const Color ink = Color(0xFF14201C);
  static const Color inkSoft = Color(0xFF52625C);
  static const Color paper = Color(0xFFF2F5F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFDCE3DE);

  static const Color green = Color(0xFF0E5B4A);
  static const Color greenSoft = Color(0xFFE1EFE9);

  static const Color urucu = Color(0xFFB63D16);
  static const Color urucuSoft = Color(0xFFFBE7DE);

  static const Color amber = Color(0xFF8A5A00);
  static const Color amberSoft = Color(0xFFFBEFD6);
}

/// Área táctil mínima que exige el NFR de uso a una mano. Es 6 x 8: entra en
/// la escala de AppSpacing, no es un número aparte.
const double kMinTapTarget = 48;

ThemeData buildAppTheme() {
  final ColorScheme scheme = ColorScheme.fromSeed(
    seedColor: AppColors.green,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.green,
    onPrimary: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    error: AppColors.urucu,
  );

  final TextTheme text = const TextTheme(
    // El precio en la tarjeta. Es el dato de descarte, así que es lo más
    // pesado que hay en pantalla después del nombre.
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      height: 1.1,
      color: AppColors.ink,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: AppColors.ink,
    ),
    bodyMedium: TextStyle(fontSize: 15, height: 1.35, color: AppColors.ink),
    bodySmall: TextStyle(fontSize: 13, height: 1.3, color: AppColors.inkSoft),
    // Eyebrow de fecha: chico, espaciado, en mayúsculas.
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
      color: AppColors.inkSoft,
    ),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.paper,
    textTheme: text,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.paper,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(kMinTapTarget),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusS)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(kMinTapTarget),
        foregroundColor: AppColors.green,
        side: const BorderSide(color: AppColors.green, width: 1.5),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusS)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusS),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
