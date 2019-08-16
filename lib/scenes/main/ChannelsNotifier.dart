import 'package:flutter/foundation.dart';
import 'networking/ChannelRequest.dart';
import 'networking/models/Channels.dart';

class ChannelsNotifier with ChangeNotifier {
  List<Channel> _channels = [];

  ChannelsNotifier(this._channels);

  List<Channel> getChannels() {
    return _channels;
  }

  bool test = false;

  Future<List<Channel>> fetchChannels() {
    return ChannelsRequest().getChannels().then((response) {
      test = true;
      _channels = response;
      notifyListeners();
    });
  }
}
