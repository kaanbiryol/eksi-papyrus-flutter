import 'package:flutter/widgets.dart';

import 'AppColors.dart';

class TextStyles {
  static TextStyle get navigationBarLightTitle => TextStyle(
      color: AppColors.primaryTextColor,
      fontWeight: FontWeight.w400,
      letterSpacing: -1,
      fontSize: 19.0);

  static TextStyle get navigationBarDarkTitle => TextStyle(
      color: AppColors.dark_primaryTextColor,
      fontWeight: FontWeight.w400,
      letterSpacing: -1,
      fontSize: 19.0);

  static TextStyle get darkTitle => TextStyle(
      color: AppColors.dark_primaryTextColor,
      fontWeight: FontWeight.normal,
      fontSize: 15.0);

  static TextStyle get lightTitle => TextStyle(
      color: AppColors.primaryTextColor,
      fontWeight: FontWeight.normal,
      fontSize: 15.0);

  static TextStyle get topicTitle => TextStyle(
      color: AppColors.primaryTextColor,
      fontWeight: FontWeight.normal,
      fontSize: 16.0);

  static TextStyle get commentDetails => TextStyle(
      color: AppColors.secondaryTextColor,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 12.0);

  static TextStyle get commentContent => TextStyle(
      color: AppColors.primaryTextColor,
      fontFamily: "Noto",
      height: 1.2,
      fontWeight: FontWeight.normal,
      fontSize: 14.0);

  static TextStyle get darkCommentAccent => TextStyle(
      color: AppColors.dark_secondaryAccent,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 14.0);

  static TextStyle get lightCommentAccent => TextStyle(
      color: AppColors.secondaryAccent,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 14.0);

  static TextStyle get darkSettingsTitle => TextStyle(
      color: AppColors.dark_accent,
      fontWeight: FontWeight.bold,
      fontSize: 13.0);
}
