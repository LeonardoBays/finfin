import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';

ThemeData theme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: CustomColors.azul,

    surface: const Color(0xFFFAFAFA),
    primary: CustomColors.azul,
    secondary: CustomColors.azulClaro,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,

    // textTheme: textTheme,
    scaffoldBackgroundColor: Colors.white,

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      // titleTextStyle: textTheme.titleLarge?.copyWith(
      //   color: colorScheme.onPrimary,
      //   fontSize: 20,
      // ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
    ),

    cardTheme: CardThemeData(
      elevation: 1.5,
      color: colorScheme.surface,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        // textStyle: textTheme.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        // textStyle: textTheme.labelLarge,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 8.0,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
      // selectedLabelStyle: textTheme.labelLarge?.copyWith(fontSize: 12.0),
      // unselectedLabelStyle: textTheme.labelLarge?.copyWith(
      //   fontSize: 12.0,
      //   fontWeight: FontWeight.w500,
      // ),
      type: BottomNavigationBarType.fixed,
    ),

    tabBarTheme: TabBarThemeData(
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.7),
      indicatorColor: colorScheme.primary,
      // labelStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
      // unselectedLabelStyle: textTheme.labelLarge?.copyWith(
      //   fontSize: 14,
      //   fontWeight: FontWeight.w500,
      // ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.black.withValues(alpha: 0.04),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: colorScheme.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      // hintStyle: textTheme.bodyMedium?.copyWith(
      //   color: colorScheme.onSurface.withValues(alpha: 0.5),
      // ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.tertiaryContainer,
      foregroundColor: colorScheme.onTertiaryContainer,
      elevation: 4.0,
    ),
  );
}
