import 'dart:convert';

import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _kUserChannels = "userChannels";

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
}
