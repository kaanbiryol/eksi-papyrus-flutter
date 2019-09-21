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
    primaryIconTheme: IconThemeData(color: AppColors.dark_primaryIcon),
    accentIconTheme: IconThemeData(color: AppColors.dark_accentIcon),
    textTheme: TextTheme(
        headline: TextStyles.navigationBarDarkTitle,
        title: TextStyles.darkTitle,
        body1: TextStyles.commentContent
            .copyWith(color: AppColors.dark_primaryTextColor),
        subtitle: TextStyles.commentDetails
            .copyWith(color: AppColors.dark_secondaryTextColor)),
  );

  static final light = ThemeData(
    primaryColor: AppColors.primaryColor,
    accentColor: AppColors.accent,
    backgroundColor: AppColors.background,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(color: AppColors.background),
    dividerColor: AppColors.listDivider,
    primaryIconTheme: IconThemeData(
      color: AppColors.primaryIcon,
    ),
    accentIconTheme: IconThemeData(color: AppColors.accentIcon),
    textTheme: TextTheme(
        headline: TextStyles.navigationBarLightTitle,
        title: TextStyles.lightTitle,
        body1: TextStyles.commentContent
            .copyWith(color: AppColors.primaryTextColor),
        subtitle: TextStyles.commentDetails
            .copyWith(color: AppColors.secondaryTextColor)),
  );
}
