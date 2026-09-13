import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _editorial = 'serif';

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.terracotta,
      primary: AppColors.terracotta,
      secondary: AppColors.sage,
      tertiary: AppColors.amber,
      surface: AppColors.sand,
      brightness: Brightness.light,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'sans-serif',
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.sand,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.sand,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontFamily: _editorial,
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 36,
          height: 1.16,
        ),
        headlineLarge: const TextStyle(
          fontFamily: _editorial,
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          height: 1.2,
        ),
        headlineMedium: const TextStyle(
          fontFamily: _editorial,
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
          fontSize: 23,
          height: 1.25,
        ),
        titleLarge: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        bodyMedium: const TextStyle(color: AppColors.muted, height: 1.45),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFCFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.terracotta, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.terracotta,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.terracottaDark,
          minimumSize: const Size.fromHeight(50),
          side: const BorderSide(color: AppColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: AppColors.blushStrong,
        backgroundColor: AppColors.blush,
        side: const BorderSide(color: AppColors.line),
        labelStyle: const TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: AppColors.parchment,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.terracottaDark : AppColors.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.terracottaDark : AppColors.muted,
            size: 22,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.parchment,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
    );
  }
}
