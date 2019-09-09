import 'package:flutter/widgets.dart';

import 'AppColors.dart';

class TextStyles {
  static TextStyle get commentDetails => TextStyle(
      color: AppColors.secondaryTextColor,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 12.0);

  static TextStyle get commentContent => TextStyle(
      color: AppColors.primaryTextColor,
      fontFamily: "Noto",
      height: 0.9,
      fontWeight: FontWeight.normal,
      fontSize: 14.0);

  static TextStyle get commentAccent => TextStyle(
      color: AppColors.accent,
      fontFamily: "Noto",
      fontWeight: FontWeight.normal,
      fontSize: 14.0);
}
