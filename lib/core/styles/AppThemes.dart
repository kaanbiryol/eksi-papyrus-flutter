import 'package:eksi_papyrus/core/styles/TextStyles.dart';
import 'package:flutter/material.dart';
import 'AppColors.dart';

enum ThemeType { LIGHT, DARK }

class AppThemes {
  static final dark = ThemeData(
    primaryColor: AppColors.dark_primaryColor,
    accentColor: AppColors.dark_accent,
    backgroundColor: AppColors.dark_background,
    scaffoldBackgroundColor: AppColors.dark_background,
    appBarTheme: AppBarTheme(color: AppColors.dark_background),
    dividerColor: AppColors.dark_listDivider,
    textTheme: TextTheme(title: TextStyles.darkTitle),
  );

  static final light = ThemeData(
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.accent,
    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(color: AppColors.background),
    dividerColor: AppColors.listDivider,
    textTheme: TextTheme(title: TextStyles.lightTitle),
  );
}
