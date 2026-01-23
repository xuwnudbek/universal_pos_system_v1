import 'package:flutter/material.dart';
import 'package:universal_pos_system_v1/utils/constants/app_constants.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData system = ThemeData(
    useMaterial3: true,
    brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
    useSystemColors: true,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.surface,
    useSystemColors: true,
    // Primary Colors
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      error: AppColors.error,
      onError: AppColors.onError,
      surfaceContainerHighest: AppColors.accent,
    ),

    listTileTheme: ListTileThemeData(
      iconColor: AppColors.onSurface,
      textColor: AppColors.onSurface,
      // tileColor: AppColors.onSurface.withValues(alpha: .1),
      selectedColor: AppColors.primary,
      selectedTileColor: AppColors.primary.withValues(alpha: .1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.onSurface,
      elevation: 0,
      centerTitle: false,
    ),

    // Card
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 1,
      margin: EdgeInsets.zero,
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.onSurface,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      fillColor: AppColors.surface,
      hintStyle: TextStyle(color: AppColors.onSurface.withValues(alpha: .5)),
      prefixIconColor: AppColors.onSurface.withValues(alpha: .7),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.border, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hoverColor: AppColors.primary.withValues(alpha: 0.1),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.onSurface.withValues(alpha: .1),
        disabledForegroundColor: AppColors.onSurface.withValues(alpha: .3),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.border,
      thickness: 0.5,
    ),

    // Icon Button Theme
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        disabledBackgroundColor: AppColors.onSurface.withValues(alpha: .1),
        disabledForegroundColor: AppColors.onSurface.withValues(alpha: .3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    ),

    // Choice chip theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.onSurface.withValues(alpha: .05),
      selectedColor: AppColors.primary,
      disabledColor: AppColors.onSurface.withValues(alpha: .1),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w600,
      ),
      secondaryLabelStyle: TextStyle(
        color: AppColors.onPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(style: BorderStyle.none),
      ),
    ),

    // Dropdown Menu Theme
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.border, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.surface),
        maximumSize: WidgetStatePropertyAll(Size.fromHeight(300)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    ),
  );

  // Dark Theme will be added later
}
