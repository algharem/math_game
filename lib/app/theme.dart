import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const sky = Color(0xFF4EA8DE);
  static const skyDeep = Color(0xFF2F86BF);
  static const skySoft = Color(0xFFE3F2FB);
  static const leaf = Color(0xFF38B000);
  static const leafDeep = Color(0xFF2A8600);
  static const leafSoft = Color(0xFFE6F6DC);
  static const coral = Color(0xFFFF7043);
  static const coralDeep = Color(0xFFD9532A);
  static const coralSoft = Color(0xFFFFE9E1);
  static const sun = Color(0xFFFFD166);
  static const sunDeep = Color(0xFFE8AD2C);
  static const sunSoft = Color(0xFFFFF5DB);
  static const ink = Color(0xFF1D3557);
  static const background = Color(0xFFF9F9F6);
  static const card = Color(0xFFFFFFFF);
  static const muted = Color(0xFFEFEFE9);
  static const mutedForeground = Color(0xFF5B6B7E);
  static const border = Color(0xFFE4E4DC);
  static const purple = Color(0xFF7B61FF);
  static const purpleSoft = Color(0xFFF0ECFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData build({
    required bool highContrast,
    required bool largeText,
  }) {
    final ink = highContrast ? const Color(0xFF07182D) : AppColors.ink;
    final background =
        highContrast ? const Color(0xFFFFFFFF) : AppColors.background;
    final border = highContrast ? const Color(0xFF728197) : AppColors.border;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.sky,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.sky,
      onPrimary: Colors.white,
      primaryContainer: AppColors.skySoft,
      onPrimaryContainer: AppColors.skyDeep,
      secondary: AppColors.sun,
      onSecondary: ink,
      secondaryContainer: AppColors.sunSoft,
      onSecondaryContainer: ink,
      tertiary: AppColors.leaf,
      onTertiary: Colors.white,
      error: AppColors.coral,
      onError: Colors.white,
      surface: background,
      onSurface: ink,
      outline: border,
      surfaceContainerHighest: AppColors.muted,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Tajawal',
      visualDensity: VisualDensity.comfortable,
    );

    var textTheme = base.textTheme
        .apply(
          fontFamily: 'Tajawal',
          bodyColor: ink,
          displayColor: ink,
        )
        .copyWith(
          displayLarge: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w800,
            fontSize: 44,
            color: ink,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w800,
            fontSize: 36,
            color: ink,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: ink,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w800,
            fontSize: 26,
            color: ink,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: ink,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: ink,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            fontSize: 17,
            color: ink,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w400,
            fontSize: 17,
            height: 1.55,
            color: ink,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            height: 1.5,
            color: ink,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: ink,
          ),
        );

    if (largeText) {
      textTheme = textTheme.apply(fontSizeFactor: 1.12);
    }

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: ink),
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardTheme(
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.sky, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sky,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: Colors.white),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.skyDeep,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: AppColors.skySoft,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        labelStyle: textTheme.labelLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
    );
  }
}
