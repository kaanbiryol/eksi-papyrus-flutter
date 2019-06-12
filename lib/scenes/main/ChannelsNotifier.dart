import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'package:flutter/foundation.dart';

import 'networking/ChannelRequest.dart';
import 'networking/models/Channel.dart';

class ChannelsNotifier with ChangeNotifier {
  List<Channel> _channels = [];

  ChannelsNotifier(this._channels);

  List<Channel> getChannels() => _channels;

  bool test = false;

  Future<List<Channel>> fetchChannels() {
    return ChannelsRequest().getChannels().then((response) {
      test = true;
      _channels = response;
      notifyListeners();
    });
  }
}
