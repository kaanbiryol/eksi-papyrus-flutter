import 'package:flutter/material.dart';
import 'AppColors.dart';

enum ThemeType { LIGHT, DARK }

class AppThemes {
  static final dark = ThemeData(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accent,
      backgroundColor: AppColors.background,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(color: AppColors.background),
      dividerColor: AppColors.listDivider);

  static final light = ThemeData.light();
}
