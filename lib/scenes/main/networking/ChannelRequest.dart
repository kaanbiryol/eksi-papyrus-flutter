import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';

import 'models/Channels.dart';

class ChannelsRequest {
  final Networking networkManager = Networking.instance;
  Future<List<Channel>> getChannels() {
    return networkManager
        .sendRequest(
      APIConstants.API_CHANNELS,
    )
        .then((dynamic response) {
      return ChannelsResponse.fromJson(json.decode(response)).channels;
    });
  }
}
