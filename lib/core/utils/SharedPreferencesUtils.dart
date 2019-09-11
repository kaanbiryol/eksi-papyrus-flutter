import 'dart:convert';

import 'package:eksi_papyrus/core/styles/AppThemes.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static const String _kUserChannels = "userChannels";
  static const String _kTheme = "theme";

  static Future<List<Channel>> getUserChannels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userChannels = prefs.getString(_kUserChannels);
    if (userChannels != null && userChannels.isNotEmpty) {
      var list = json.decode(userChannels) as List;
      List<Channel> channelList = list.map((i) => Channel.fromJson(i)).toList();
      return channelList;
    }
    return List<Channel>();
  }

  static Future<bool> setUserChannels(List<Channel> userChannels) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String channels = json.encode(userChannels);
    return prefs.setString(_kUserChannels, channels);
  }

  static Future<ThemeType> getCurrentTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeType themeType = ThemeType.values.firstWhere(
        (value) => value.toString() == prefs.getString(_kTheme),
        orElse: () => ThemeType.LIGHT);
    return themeType;
  }

  static Future<bool> setCurrentTheme(ThemeType themeType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_kTheme, themeType.toString());
  }
}
