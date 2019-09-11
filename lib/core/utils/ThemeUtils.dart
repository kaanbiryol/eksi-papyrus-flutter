import 'package:eksi_papyrus/core/styles/AppThemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SharedPreferencesUtils.dart';

class ThemeBloc with ChangeNotifier {
  ThemeType _themeType;
  ThemeBloc(this._themeType);

  ThemeData getTheme() {
    switch (_themeType) {
      case ThemeType.LIGHT:
        return AppThemes.light;
      case ThemeType.DARK:
        return AppThemes.dark;
      default:
        return AppThemes.light;
    }
  }

  getThemeType() => _themeType;
  isDarkTheme() => _themeType == ThemeType.DARK ? true : false;

  setTheme(ThemeType themeType) {
    _themeType = themeType;
    SharedPreferencesUtils.setCurrentTheme(themeType);
    notifyListeners();
  }
}
