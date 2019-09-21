import 'package:flutter/widgets.dart';

import 'AppColors.dart';

class TextStyles {
  static TextStyle get navigationBarLightTitle => TextStyle(
      color: AppColors.primaryTextColor,
      fontFamily: "IBMPlex",
      fontWeight: FontWeight.w100,
      letterSpacing: -1,
      fontSize: 19.0);

  static TextStyle get navigationBarDarkTitle => TextStyle(
      color: AppColors.dark_primaryTextColor,
      fontFamily: "IBMPlex",
      fontWeight: FontWeight.w100,
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

  static TextStyle get commentAccent => TextStyle(
      color: AppColors.accent,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 14.0);
}
